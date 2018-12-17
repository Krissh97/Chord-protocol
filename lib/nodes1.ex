defmodule Nodes do 
  use GenServer
  def init(state) do
    successor=state.suc
    predecessor=state.pre
    list=state.node_list
    p=state.node
   yo=state.whole_list
    #IO.inspect(yo)
    successor=Use.find_successor(list,p) 
    predecessor=Use.find_predecessor(list,p)
    c=0
    z=0
    u= Use.find_m(state.n,c)
    avg_hops=state.avg_hops
    fig=[]
    f=[]
    f=state.finger_table
    fig=Use.create_fingertable(list,p,f,z,u)
    IO.inspect(state.id) 
    IO.inspect(fig)  
    {:ok,send_map({yo,fig,successor,predecessor,avg_hops,state.message_count,state.id})}
  end 
  def handle_cast(:yolo,state) do
    IO.inspect("After evtnh :#{state.avg_hops}")
    {:noreply,state}
  end
  
 # def handle_cast(:yo, state) do
   #IO.inspect("ko")
  #  IO.inspect(state.finger_table)
   # {:noreply, state}
  #end
 # def handle_cast(:getcount,state) do
 #   IO.inspect(state.message_count)
  #  {:noreply,state}
  #end
 def handle_cast(:update,state) do
    #IO.inspect("hops are #{hops}")
    {:noreply,send_map({state.whole_list,state.finger_table,state.suc,state.pre, state.avg_hops+1, state.message_count,state.id})}
  end
  def handle_cast({:gotoit,node,r},state) do
    tab=state.finger_table
    up_node=state.id
    if Enum.member?(tab,r)==true do
      GenServer.cast(String.to_atom(Use.sha_1(node)),:update)
    else
      Use.findfingertable(node,up_node,r,tab,state.whole_list)
    end
    {:noreply,state}
  end
  def nodeHops(nodeele) do
    GenServer.call(nodeele, :forhop)
  end

  def handle_call(:forhop, _from, state) do
    hop=state.avg_hops
    {:reply, hop, state}
  end
  def handle_call(:doit,_from, state) do
    node=state.id
    yo=state.whole_list
    fing=[]
   hops=state.avg_hops
   IO.inspect("retrieved hops:#{hops}")
    fing=state.finger_table
    IO.inspect(fing)
    #:timer.sleep(1000)
    rand=Enum.random(1..yo)
    #if rand!=node do
      IO.inspect("rand is #{rand} for #{state.id}")
      if rand==state.id do
        #IO.inspect("haha")
        GenServer.cast(String.to_atom(Use.sha_1(node)),:update)
      else
       if(Enum.member?(fing,rand)==true) do
          IO.inspect("true")
      
     # IO.inspect(hops)
         GenServer.cast(String.to_atom(Use.sha_1(node)),:update)
        else 
          Use.findfingertable(node,node,rand,fing,yo)
#-------------------------------
          GenServer.cast(String.to_atom(Use.sha_1(node)),:update)
      #  Use.dothis(fing,rand,node)

         IO.inspect("false")
        end
      #send_map(,,,,hops,,)#
      end
    
      {:reply,state,state}
  end
  def send_map({yo,finger_table, suc, pre, avg_hops, message_count, id }), do: %{whole_list: yo,finger_table: finger_table, suc: suc, pre: pre, avg_hops: avg_hops, message_count: message_count, id: id}
end
 

 
