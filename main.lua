function fifteens(j,total,ranks)
  local i
  local sub
  local a
  while j<6 do
  sub = total+ranks[j]
  if sub==15 then
   score = score + 2
  elseif sub<15 then
    fifteens(j+1,sub,ranks)
    end
  j = j+1
  end
end
function augment(t1,t2)

    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end
function runs(n)
  n = augment(n,{0,0})
  score = 0
  for i=1,11 do
    if n[i]>0 and n[i+1]>0 and n[i+2]>0 then
      if n[i+3]>0 then
        if n[i+4]>0 then
          n[i+4] = 0
          score = score+5
        else
          sm = n[i]+n[i+1]+n[i+2]+n[i+3]
          if sm == 4 then
            score = score+4
          end
          if sm == 5 then
            score = score+8
          end
        end
        n[i+3] = 0
      else
        sm = n[i]+n[i+1]+n[i+2]
        if sm==3 then
          score = score+3
        end
        if sm==4 then
          score = score+6
        end
        if sm==5 then
          if n[i]==3 or n[i+1]==3 or n[i+2]==3 then
            score = score+9
          else
            score = score+12
          end
        end
      end
      n[i] = 0 
      n[i+1] = 0
      n[i+2] = 0
    end
  end
  return score
end
function printTable(table)
  print('[')
  for i = 1, #table do
   print(table[i])
  end
  print(']')
  print(#table)
end
function decode(m)
  local l = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnop"
  local r = {}
  local x
  for x = 1, 5 do
    local i,j = string.find(l,m:sub(x,x))
    r = augment(r,{i})
  end
  return r
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
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
local function main()
  print("App loaded!")
  print("Loading Hand Table...")
  local allHands,err = table.load( "hand.lua" )
  assert( err == nil )
  print(#allHands)
  print("Loaded Hand Table!")
  print("Loading Score Table...")
  local scoreSaves,err = table.load( "scores.lua" )
  assert( err == nil )
  --local scoreSaves = {}
  print("Loaded Score Table!")
  print("Starting loop:")
  
  local deck = {"As","2s","3s","4s","5s","6s","7s","8s","9s","Ts","Js","Qs","Ks","Ah","2h","3h","4h","5h","6h","7h","8h","9h","Th","Jh","Qh","Kh","Ad","2d","3d","4d","5d","6d","7d","8d","9d","Td","Jd","Qd","Kd","Ac","2c","3c","4c","5c","6c","7c","8c","9c","Tc","Jc","Qc","Kc"}
  ::loop::
  --print("Picking new hand...")
  local counter = #scoreSaves + 1
  local hand = allHands[counter]
  --print("Hand picked! Decoding...")
  hand = decode(hand)
  --print("Decoded! Converting to cards...")
  local hand_n = hand
  hand = {}
  for x=1,5 do
    hand = augment(hand,{deck[hand_n[x]]})
  end
  --print("Converted to cards!")
  --print("Scoring...")
  ::again::
  print('Hand ' .. tostring(counter) .. ':',hand[1],hand[2],hand[3],hand[4],hand[5])
  ranks = {}
  suits = {}
  rnum = {}
  a = {"A","2","3","4","5","6","7","8","9","T","J","Q","K"}
  for x=1,5 do
    y = hand[x]:sub(1,1)
     for xz = 1,13 do
      if a[xz] == y then
        z = xz
       break
      end
     end
  
     zz = z
     if z > 10 then
       z = 10
     end
     rnum = augment(rnum, {z})
     ranks = augment(ranks,{zz})
     suits = augment(suits,{hand[x]:sub(#hand[x],#hand[x])})
     end
     num = {}
     for i=1,13 do
      num[i] = 0
     end
     for i=1,5 do
      num[ranks[i]] = num[ranks[i]] + 1
     end
     --Time to score!
     score = 0
     --Pairs:
     for i=1,13 do
       score = num[i] * (num[i]-1) + score
     end
     score = score + runs(num)
     fifteens(1,0,rnum)
     if suits[1]==suits[2] and suits[2]==suits[3] and suits[3]==suits[4] then
      if suits[1]==suits[5] then
        score = score+5
      else
        score = score+4
      end
     end
    for i=1,4 do
      if ranks[i]==11 and suits[i]==suits[5] then
        score = score+1
      end
    end
    print('Score:',score)
    scoreSaves = augment(scoreSaves,{score})
    --assert( table.save( scoreSaves, "scores.lua" ) == nil )
    if counter==1000000 or counter == 2000000 or counter>12994792 then
      assert( table.save( scoreSaves, "scores.lua" ) == nil )
    end
    goto loop
end
main()
