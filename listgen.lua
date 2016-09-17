function listgen(hs,ds)
s ="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnop"
hand = {}
c = 0
for x=1,ds-hs+1 do
 hand1 = s:sub(x,x)
 for y=x+1,ds-hs+2 do
  hand2 = hand1 .. s:sub(y,y)
   for z=y+1,ds-hs+3 do
   hand3 = hand2 .. s:sub(z,z)
    for t = z+1,ds-hs+4 do
     hand4 = hand3 .. s:sub(t,t)
     for a = t+1,ds do
      hand5 = hand4 .. s:sub(a,a)
      --for x=1,5 do
        hand = augment(hand,{hand5})
        --hand5 = wrap(hand5,1)
        print(c)
        c = c+1
      --end
     end
    end
   end
  end
 end
 --printTable(hand)
 print("Saving table!")
 t1 = os.clock()
 assert( table.save( hand, "hand_shortened.lua" ) == nil )
 print("Done Saving in: "..os.difftime(os.clock(), t1))
 
end
function augment(t1,t2)

    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end
function printTable(table)
  print('[')
  for i = 1, #table do
   print(table[i])
  end
  print(']')
  print(#table)
end
function wrap( t, l )
    -- change i=0 to move left and i=1 to right
    for i = 1, l do
        t = t:sub(#t,#t) .. t:sub(1,#t-1)
    end
    return t
end
do
   -- declare local variables
   --// exportstring( string )
   --// returns a "Lua" portable version of the string
   local function exportstring( s )
      return string.format("%q", s)
   end

   --// The Save Function
   function table.save(  tbl,filename )
      local charS,charE = "   ","\n"
      local file,err = io.open( filename, "wb" )
      if err then return err end

      -- initiate variables for save procedure
      local tables,lookup = { tbl },{ [tbl] = 1 }
      file:write( "return {"..charE )

      for idx,t in ipairs( tables ) do
         file:write( "-- Table: {"..idx.."}"..charE )
         file:write( "{"..charE )
         local thandled = {}

         for i,v in ipairs( t ) do
            thandled[i] = true
            local stype = type( v )
            -- only handle value
            if stype == "table" then
               if not lookup[v] then
                  table.insert( tables, v )
                  lookup[v] = #tables
               end
               file:write( charS.."{"..lookup[v].."},"..charE )
            elseif stype == "string" then
               file:write(  charS..exportstring( v )..","..charE )
            elseif stype == "number" then
               file:write(  charS..tostring( v )..","..charE )
            end
         end

         for i,v in pairs( t ) do
            -- escape handled values
            if (not thandled[i]) then
            
               local str = ""
               local stype = type( i )
               -- handle index
               if stype == "table" then
                  if not lookup[i] then
                     table.insert( tables,i )
                     lookup[i] = #tables
                  end
                  str = charS.."[{"..lookup[i].."}]="
               elseif stype == "string" then
                  str = charS.."["..exportstring( i ).."]="
               elseif stype == "number" then
                  str = charS.."["..tostring( i ).."]="
               end
            
               if str ~= "" then
                  stype = type( v )
                  -- handle value
                  if stype == "table" then
                     if not lookup[v] then
                        table.insert( tables,v )
                        lookup[v] = #tables
                     end
                     file:write( str.."{"..lookup[v].."},"..charE )
                  elseif stype == "string" then
                     file:write( str..exportstring( v )..","..charE )
                  elseif stype == "number" then
                     file:write( str..tostring( v )..","..charE )
                  end
               end
            end
         end
         file:write( "},"..charE )
      end
      file:write( "}" )
      file:close()
   end
   
   --// The Load Function
   function table.load( sfile )
      local ftables,err = loadfile( sfile )
      if err then return _,err end
      local tables = ftables()
      for idx = 1,#tables do
         local tolinki = {}
         for i,v in pairs( tables[idx] ) do
            if type( v ) == "table" then
               tables[idx][i] = tables[v[1]]
            end
            if type( i ) == "table" and tables[i[1]] then
               table.insert( tolinki,{ i,tables[i[1]] } )
            end
         end
         -- link indices
         for _,v in ipairs( tolinki ) do
            tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
         end
      end
      return tables[1]
   end
-- close do
end

-- ChillCode
listgen(5,52)