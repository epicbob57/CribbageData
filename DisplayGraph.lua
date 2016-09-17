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
function augment(t1,t2)

    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end
function printTable(table)
  --print('[')
  for i = 1, #table do
   print(table[i])
  end
  --print(']')
  --print(#table)
end
function max(a)
  local values = {}

  for k,v in pairs(a) do
    values[#values+1] = v
  end
  table.sort(values) -- automatically sorts lowest to highest

  return values[#values]
end
function printBar(n)
  local l = {'','|','||','|||','||||','|||||','||||||','|||||||'} 
  if n > 133 then
    print('Overflow!')
    return
  end
  n2 = n
  local x = {}
  for i=1,19 do
    x[i] = ''
  end
  x2 = x
  for i=1,19 do
    if n < 7 then
      x[i] = l[n+1]
      break
    end
    n = n - 7
    x[i] = l[8]
  end
  if x[1] == '' and n2>0 then
    x[1] = l[2]
  end
  print(x[1],x[2],x[3],x[4],x[5],x[6],x[7],x[8],x[9],x[10],x[11],x[12],x[13],x[14],x[15],x[16],x[17],x[18],x[19])
end
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
function main()
  print("Loading Score Table...")
  local scores,err = table.load( "scores.lua" )
  assert( err == nil )
  print("Loaded Score Table!")
  print(#scores)
  bars = {}
  for i=1,30 do
    bars[i] = 0
  end
  n = #scores
  mean1 = 0
  for i=1,n do
    bars[scores[i]+1] = bars[scores[i]+1] + 1
    mean1 = mean1 + scores[i]
  end
  bars2 = {}
  for i=1, 30 do
    bars2[i] = round(bars[i]*133/max(bars),0)
    printBar(bars2[i])
  end
  printTable(bars)
  mean = 0
  for i=1, 30 do
    mean = bars[i] + mean 
  end
  print('')
  print(mean/30)
  mean1 = 0
  for i=1, #scores do
    mean1 = mean1 + scores[i]
  end
  print(mean1/#scores)
end
main()