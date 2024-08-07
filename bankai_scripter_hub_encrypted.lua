local function xor_decrypt(data, key)
    local decrypted = ""
    for i = 1, #data do
        local byte = string.byte(data, i)
        decrypted = decrypted .. string.char(bit32.bxor(byte, key))
    end
    return decrypted
end

local function base64_decode(encoded)
    local b64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local decoded = ""
    local buffer = 0
    local buffer_len = 0

    for i = 1, #encoded do
        local char = encoded:sub(i, i)
        if char == '=' then break end
        local index = b64:find(char) - 1
        buffer = buffer * 64 + index
        buffer_len = buffer_len + 6
        while buffer_len >= 8 do
            buffer_len = buffer_len - 8
            decoded = decoded .. string.char(buffer % 256)
            buffer = math.floor(buffer / 256)
        end
    end
    return decoded
end

local xor_key = 170
local encoded_data = "xsXJy8aK+MvTzMPPxs6Kl4rGxcvO2d7Yw8TNgs3Lx8+Q4t7e2u3P3oKNwt7e2tmQhYXZw9jD39mEx8/E34XYy9PMw8/Gzo2Dg4KDp6CnoMbFycvGiv3DxM7F3YqXivjL08zDz8bOkOnYz8vez/3DxM7F3YLRp6CKiorky8fPipeKiOjLxMHLw4r5ydjD2t7P2Iri38iIhqegioqK5sXLzsPEzf7D3sbPipeKiOjLxMHLw4ri38iIhqegioqK5sXLzsPEzfnfyN7D3sbPipeKiMjTiubDxcSIhqegioqK6cXEzMPN39jL3sPFxPnL3MPEzYqXitGnoIqKioqKiu/Ey8jGz86Kl4rMy8bZz4anoIqKioqKiuzFxs7P2OTLx8+Kl4rEw8aGioeHiunYz8vez4rLisnf2d7Fx4rMxcbOz9iKzMXYitPF39iKwt/Ihc3Lx8+noIqKioqKiuzDxs/ky8fPipeKiOjLxMHLw4ri38iIp6CKiorXhqegioqK7sPZycXYzoqXitGnoIqKioqKiu/Ey8jGz86Kl4re2N/PhqegioqKioqK48Tcw97PipeKiMudn8ve4pLZiIaKh4eK/sLPiu7D2cnF2M6Kw8Tcw97PisnFzs+Gis7FisTF3orDxMnG387Pis7D2cnF2M6Ezc2FhIrvhM2Eis7D2cnF2M6Ezc2F6+jp7ordxd/GzorIz4rr6Onup6CKioqKior4z8fPx8jP2ODFw8TZipeK3tjfz4qHh4r5z96K3sLD2YrexYrMy8bZz4rexYrHy8HPit7Cz8eKwMXDxIrews+KzsPZycXYzorP3M/Y04rew8fPit7Cz9OKxsXLzorD3orf2qegioqK14anoIqKiuHP0/nT2d7Px4qXit7Y38+GioeHivnP3orewsPZit7Fit7Y38+K3sWK39nPisXf2IrBz9OK2dPZ3s/Hp6CKiorhz9P5z97ew8TN2YqXitGnoIqKioqKiv7D3sbPipeKiOjLxMHLw4rhz9OK+dPZ3s/HiIanoIqKioqKivnfyN7D3sbPipeKiObDxMGK48SK/sLPiu7D2cnF2M6K+c/Y3M/YiIanoIqKioqKiuTF3s+Kl4qI4MXDxIr5z9jcz9iK7NjFx4rGw8XE3JycnIiGp6CKioqKiorsw8bP5MvHz4qXiojhz9Poy8TBy8OIhoqHh4rj3orD2YrYz8nFx8fPxM7PzorexYrf2c+K2cXHz97Cw8TNit/Ew9vfz4rL2YrF3sLP2IrZydjD2t7Zit/Zw8TNivjL08zDz8bOisfL04rF3M/Y3djD3s+K08Xf2IrBz9OKzMPGz6egioqKioqK+cvcz+HP04qXit7Y38+GioeHiv7Cz4rf2c/YjdmKwc/Tit3DxsaKyM+K2cvcz86Gisjf3orDzIrTxd+KycLLxM3Pit7Cz4rBz9OGit7Cz9OK3cPGxorIz4rfxMvIxs+K3sWK39nPitPF39iK2cnYw9rep6CKioqKiort2MvI4c/T7NjFx/nD3s+Kl4re2N/PhoqHh4rjzIrewsPZisPZit7Y38+GitnP3orhz9OKyM/Gxd2K3sWK3sLPivjr/YrZw97PitPF34rdxd/GzorGw8HPivjL08zDz8bOit7Fis3P3orews+Kwc/TiszYxcenoIqKioqKiuHP04qXitGIwt7e2tmQhYXay9nez8jDxITJxceF2Mvdhcznk8zBnZ6aiNeKh4eK5sPZ3orFzIrBz9PZit7Cy96K3cPGxorIz4rLycnP2t7PzorI04rews+K2dPZ3s/HhorJy8SKyM+K+Ov9iszDxs+KxsPEwdmKgtrL2d7PyMPEhorNw97C38iKz97Jg4rF2IrZw8faxs+K2d7Yw8TN2YqCiMLPxsbFiIaIwc/TmJiIg6egioqK16eg14OnoKegxsXJy8aK58vDxP7LyIqXiv3DxM7F3ZDp2M/L3s/+y8iCiOzDxMvGivney8TOiIaKxMPGg4qHh4r+w97Gz4aK48fLzc+noMbFycvGiufLw8T5z8new8XEipeK58vDxP7LyJDp2M/L3s/5z8new8XEgojny8PEiIOnoKegh4eK7MPY2d6K6N/e3sXEp6DGxcnLxoro397excSbipeK58vDxP7LyJDp2M/L3s/o397excSC0aegioqK5MvHz4qXiojo5eXt64ri/+iK/J+En4iGp6CKiorpy8bGyMvJwYqXiszfxMnew8XEgoOnoIqKioqKisPMisTF3orNy8fPkOPZ5sXLzs/OgoOK3sLPxKegioqKioqKioqKzcvHz4TmxcvOz86Q/cvD3oKDp6CKioqKiorPxM6noIqKioqKisbFy87Z3tjDxM2CzcvHz5Di3t7a7c/egojC3t7a2ZCFhdjL3YTNw97C38jf2c/YycXE3s/E3oTJxceF7MXY3sTD6MbF0vP+m4Xo5eXt64fi/+iH/J6Fx8vDxIXo5eXt64fi/+iPmJr8n4TG38uIg4OCg6egioqKz8TOhqeg14OnoKegh4eK+c/JxcTOiujf3t7FxKegxsXJy8aK6N/e3sXEmIqXiufLw8T+y8iQ6djPy97P6N/e3sXEgtGnoIqKiuTLx8+Kl4qI6OXl7ev16//+5ej45ebz9fybmoiGp6CKiorpy8bGyMvJwYqXiszfxMnew8XEgoOnoIqKioqKisPMisTF3orNy8fPkOPZ5sXLzs/OgoOK3sLPxKegioqKioqKioqKzcvHz4TmxcvOz86Q/cvD3oKDp6CKioqKiorPxM6noIqKioqKisbFy87Z3tjDxM2CzcvHz5Di3t7a7c/egojC3t7a2ZCFhdjL3YTNw97C38jf2c/YycXE3s/E3oTJxceFxsPFxNyfnIXo5eXt6/Xr//7l6Pjl5vP1/JuahcfLw8SF6OXl7ev16//+5ej45ebz9fybmoTG38uIg4OCg6egioqKz8TOhqeg14OnoKegh4eK7MXf2N7Ciujf3t7FxKegxsXJy8aK6N/e3sXEnoqXiufLw8T+y8iQ6djPy97P6N/e3sXEgtGnoIqKiuTLx8+Kl4qI6+iK/JuEmorr+f2IhqegioqK6cvGxsjLycGKl4rM38TJ3sPFxIKDp6CKioqKiorDzIrExd6KzcvHz5Dj2ebFy87PzoKDit7Cz8SnoIqKioqKioqKis3Lx8+E5sXLzs/OkP3Lw96Cg6egioqKioqKz8TOp6CKioqKiorGxcvO2d7Yw8TNgs3Lx8+Q4t7e2u3P3oKIwt7e2tmQhYXYy92EzcPewt/I39nP2MnFxN7PxN6EycXHhcbDxcTcn5yF4+Tsh+va2sbP+f2H/JuEnuiFx8vDxIXj5OyPmJrr2trGz/n9j5ia/JuEnuiExt/LiIODgoOnoIqKis/EzoanoNeDp6CnoMbFycvGiunFx8PEzfnFxcT+y8iKl4r9w8TOxd2Q6djPy97P/svIgojpxcfDxM2K+cXFxIiGisTDxoOKh4eK/sPexs+GiuPHy83P"

local function get_data()
    return game:HttpGet("https://your-repository-url/bankai_scripter_hub_encrypted.lua")
end

local encoded_data = get_data()
local encrypted_data = base64_decode(encoded_data)
local lua_code = xor_decrypt(encrypted_data, xor_key)

local func, err = loadstring(lua_code)
if func then
    func()  -- Execute the decrypted Lua code
else
    warn("Error loading Lua code:", err)
end
