--[[
	Utilities1 
	
	by iamnotultra3 a.k.a Elite
	
	MIT license, you're free to use it : D
	you can credit me if you want tho
	
	This module provides a collection of utilities
	for Roblox game development,
	including a custom Signal class for event handling,
	functions for formatting time and numbers,
	a Random utility for various randomization tasks,
	and an EliteDataStoreService for managing DataStore operations with rate limit awareness.
	
	1. Requiring module 
		make any script and write down:
		
		-----
		
		local Utilities_Module = require(path.to.Utilities1)
		
		-----
		
		Note: inside the brackets, type in an actual path,
		
		example:
		
		-----
		
		local Utilities_Module = require(game.ServerScriptService.Utilities1)
		
		-----
	2. Accessing module Utilities
		now as you have required the module, you just have to
		type:
		
		-----
		
		local SomeUtility = Utilities_Module.SomeUtility
		
		-----
		
		note: instead of SomeUtility, use an actual utility name,
		
		example:
		
		-----
		
		local Random = Utilities_Module.Random
		
		
		-----
		
		and now you can access the utilities!
		
	3. Utilities use info
	
		`Signal`
			The Signal class is a custom event handling system,
			allowing you to create and manage events 
			with features like parallel execution and one-time listeners.
			
		Access Signal class:
			local Signal = Utilities_Module.Signal


		Creating a Signal:
			local My_Signal = Signal.new()


		Signal methods:
			Connect(fn: function): Connection
                Description: 
                    Connects a function to the signal,
                    which will be called every time the signal is fired.
		        Parameters:
			        fn: The function to connect.
                Returns: 
                    A Connection object that can be used to disconnect the listener.
                Notes:
                     Asserts that fn is a function; otherwise, it errors with a type mismatch message.


            ConnectParallel(fn: function): Connection
                Description: 
                   Similar to Connect, but the function runs in parallel using task.desynchronize.
                Parameters:
                    fn: The function to connect.
                
                Returns:
                    A Connection object.
                Warnings: 
                    Be cautious with parallel execution as it may lead to race conditions
                    or thread safety issues if shared state is modified.


            Once(fn: function): Connection
                Description:
                    Connects a function that will only be called once, after the signal is fired,
                    the function will be called and the connection will be instantly disconnected
                Parameters:
                    fn: The function to connect (must be a function).
                Returns: 
                    A Connection object.


            Wait(): ...any
                Description: 
                    Pauses the current thread until the signal is fired, 
                    then resumes and returns the arguments passed to Fire.
                Returns:
                    The arguments passed to Fire.
                Notes:
                    Uses coroutines; must be called from a context that can yield.
                Warnings:
                    Will block the thread until the signal fires, so avoid in non-yielding contexts to prevent hangs.


            Fire(...: any): ()
                Description:
                    Triggers the signal, calling all connected functions with the provided arguments.
                Parameters:
                    Variable arguments to pass to listeners.
                Notes:
                    Clones the listeners table to avoid issues if listeners disconnect during firing,
                    which may impact performance with many listeners.


            Destroy(): ()
                Description:
                    Cleans up the signal by clearing all listeners and preventing further use.
                Notes:
                    Sets the metatable to nil, effectively disabling the signal.


        `Connection` use:
            Disconnect(): ()
                Description:
                    Removes the listener from the signal.



        Notes for `Signal`
            The Signal class is designed to be robust, cloning the listeners table during Fire to prevent runtime modifications from breaking iteration.
            Performance may degrade with a large number of listeners due to table cloning in Fire.

        Useful Trick:
        	In order to improve IDE support, you can type in the data that will be sent within signal,
            example script:
            ____
            
	            local Utils_Module = require(game.ServerScriptService)
	            
	            local Signal = Utils_Module.Signal
	            
	            local Types = Utils_Module.Types
	            

	            local My_Signal = Signal.new(Types.number, Types.boolean, Types.table)
	            
	            My_Signal:Connect(function(num, bool, tbl)-- when you are inside the brackets, the IDE support will show all the types you provided inside the Signal.new() brackets
	            	...
	            end)
	            
	            ____
            
			This is not necessary and made for conveniency only,
			Nothing will happen if you mismatch types you fired
			compared to what was in Signal.new() brackets,
			It will be only visually available, not when using it



        `FormatUtils` section
            This section includes utility functions for formatting numbers and time into human-readable strings.


            Functions:
                        
                FormatTime(format_num: number, format_mode: string?, format_params: TimeFormatParams?): string
                    Description: 
                        Converts a number into a human-readable time string (e.g. "1h30m")
                    Parameters:
                        format_num: The number to format (must be a number).
                        format_mode: The unit of the input number ("s", "m", "h", "d", "mon", "y"). Defaults to "s".
                        format_params: Optional table with settings:
                            div: Separator between units (default: "").
                            include_if_0: Whether to include units with zero value (default: false).
                            Custom labels: seconds, minutes, hours, days, months, years (e.g., seconds = "sec").
                    Returns:
                        A formatted time string.
                    Notes:
                        Rounds the input to the nearest whole second.
                        Processes units from years to seconds, including only non-zero values unless include_if_0 is true.
                    Warnings:
                        If format_mode is invalid, it warns and returns an empty string.


                FormatNumber(num: number, config: NumberFormatParams?): string
                    Description:
                        Formats large numbers with suffixes (e.g., 1000 -> "1k", 1000000 -> "1M")
                    Parameters:
                        num: The number to format (must be a number)
                        config: Optional table with settings:
                        precision: Number of decimal places (default: 1)
                        suffixes: Custom labels for suffixes (e.g., {K = "Kilo"})
                    Returns:
                        The formatted string.
                    Notes:
                        Supports suffixes from "K" (thousand) to "Un" (undecillion)
                        For numbers less then 1000, it formats with the specified precision without a suffix.
                    Warnings:
                        Asserts that num is a number; otherwise, it errors.


        `Random` utility
            The Random utility provides functions for random selection and generation,
            using a single Random instance for consistency.
        Methods:
            Choice(tbl: table): any
                Description: 
                    Selects a random element from a table.
                Parameters:
                    tbl: The table to choose from (must be a table).
                Returns: 
                    The chosen value; if the table has string or Instance keys, also returns the key.
                Warnings: 
                    Errors if tbl isn’t a table; warns and returns nil if the table is empty.


            GenerateRandomInteger(x: number, y: number, blacklist: {number}?): number
                Description: 
                    Generates a random integer between x and y, inclusive,
                    optionally avoiding blacklisted numbers.
                Parameters:
                    x: Minimum value.
                    y: Maximum value.
                    blacklist: Optional array of numbers to avoid.
                Returns:
                    A random integer.
                Notes: 
                    Retries up to 120 times if the result is blacklisted.
                Warnings:
                    Errors if x or y aren’t numbers, if x > y, or if retries exceed 120.


            WeightedChoice(tbl: {{any}}, weightKey: string?): any
                Description: 
                    Selects a random item from a table based on weights.
                Parameters:
                    tbl: Table of items with weight fields.
                    weightKey: Field name for weights (default: "weight").
                Returns: 
                    The selected item.
                Warnings: 
                    Errors if tbl isn’t a table, is empty, or if any item lacks a numeric weight.


            ChooseMultiple(tbl: table, n: number, allowDuplicates: boolean?): {any}
                Description: 
                    Selects `n` random items from a table, with or without duplicates.
                Parameters:
                    tbl: The table to choose from.
                    n: Number of items to select.
                    allowDuplicates: Whether duplicates are allowed (default: false).
                Returns: 
                    A table of selected items.
                Notes: 
                    Uses table cloning, which may be inefficient for large tables.
                Warnings: 
                    Errors if tbl isn’t a table, n isn’t a positive integer,
                    or if n exceeds table size without duplicates.


            RandomFloat(min: number, max: number): number
                Description:
                    Generates a random float between min and max.
                Parameters:
                    min: Minimum value.
                    max: Maximum value.
                Returns: 
                    A random float.
                Warnings:  
                    Errors if min or max aren’t numbers or if min > max.


            WeightedRandomFloat(min: number, max: number, mode: number?): number
                Description: 
                    Generates a random float between min and max with a bias towards mode (triangular distribution).
                Parameters:
                    min: Minimum value.
                    max: Maximum value.
                    mode: Bias point (default: midpoint of min and max).
                Returns: 
                    A random float.
                Warnings: 
                    Errors if min or max aren’t numbers, or if mode is outside the range.


        EliteDataStoreService
            This service wraps Roblox’s DataStoreService to manage request budgets and queue requests,
            preventing rate limit issues.
        Methods
            GetDataStore(DataStoreName: string, Scope: string?, DataStoreOptions: DataStoreOptions?): EliteDataStore
                Description: 
                    Returns an EliteDataStore object for the specified DataStore.
                Parameters: 
                    Standard DataStore parameters.


            GetOrderedDataStore(DataStoreName: string, Scope: string?): EliteOrderedDataStore
                Description: 
                    Returns an EliteOrderedDataStore object.
                Parameters: 
                    Standard OrderedDataStore parameters.


            ListDataStoresAsync(prefix: string?, pageSize: number?, cursor: string?): DataStoreListingPages
                Description: Lists DataStores matching the prefix.

        EliteDataStore Methods
            GetAsync(key: string, options: DataStoreOptions?): any?
            SetAsync(key: string, value: any, userIds: {any?}?, options: DataStoreOptions?): boolean
            UpdateAsync(key: string, transform: (oldValue: any?) -> any): boolean
            IncrementAsync(key: string, delta: number, userIds: {any?}?, options: DataStoreOptions?): boolean
            RemoveAsync(key: string): boolean
            ListKeysAsync(prefix: string?, pageSize: number?, cursor: string?, excludeDeleted: boolean?): DataStoreKeyPages
            ListVersionsAsync(key: string, sortDirection: Enum.SortDirection?, minDate: number?, maxDate: number?, pageSize: number?): DataStoreVersionPages
            GetVersionAsync(key: string, version: string): any?
            RemoveVersionAsync(key: string, version: string): boolean
            GetVersionAtTimeAsync(key: string, timestamp: number): any?
        Notes: 
            All methods queue requests and return results based on budget availability.
        Warnings: 
            Asserts parameter types; errors on invalid input.


        EliteOrderedDataStore Methods
            GetSortedAsync(ascending: boolean, pageSize: number, minValue: number?, maxValue: number?, returnRawPages: boolean?): { [string]: number } | DataStorePages
                Description: 
                    Retrieves sorted data, optionally returning raw pages.
            It includes all other write and read methods like in a basic DataStore,
            excluding versioning and key listing
        
    Notes
        Requests are processed every 0.5 seconds via a Heartbeat loop, which is not configurable.
        No automatic retry logic for failed requests; users must handle errors.
        Uses a Signal (RequestFinished) to notify request completion.
    Type Annotations
        The module includes detailed Luau type annotations for all exported types,
        enhancing compatibility with type-checking tools.
]]


local RunService = game:GetService("RunService")
local DataStoreService = game:GetService("DataStoreService")


-----------------------------------------------------------

------`Signal`--------

--`Connection` class
local signal_connection = {}
signal_connection.__index = signal_connection

function signal_connection.new(signal_class, fn, run_once, run_parallel)
	local self = setmetatable({}, signal_connection)

	self.signal = signal_class
	self.fn = fn
	self.run_once = run_once or false
	self.run_parallel = run_parallel or false

	return self
end


function signal_connection:Disconnect()
	local i = table.find(self.signal._listeners, self)
	if i then
		table.remove(self.signal._listeners, i)
	end
end

--end of `Connection` class

--`Signal` class
local Signal = {}
Signal.__index = Signal

function Signal.new()
	local self = setmetatable({}, Signal)
	self._listeners = {}

	return self
end

function Signal:Connect(fn)
	assert(type(fn) == "function", `Invalid Argument #1, function expected, got {typeof(fn)}`)

	local connection = signal_connection.new(self, fn)

	table.insert(self._listeners, connection)

	return connection
end

function Signal:Fire(...)
	local res = table.pack(...)
	for _, connection in ipairs(table.clone(self._listeners)) do
		task.spawn(function()
			if connection.run_parallel then task.desynchronize() end

			connection.fn(table.unpack(res))

			if connection.run_parallel then task.synchronize() end
			if connection.run_once then
				connection:Disconnect()
			end
		end)
	end
end

function Signal:Once(fn)
	assert(type(fn) == "function", `Invalid Argument #1, function expected, got {typeof(fn)}`)


	local connection = signal_connection.new(self, fn, true)

	table.insert(self._listeners, connection)

	return connection
end

function Signal:Wait()
	local cor = coroutine.running()

	local conn = nil
	conn = self:Connect(function(...)
		conn:Disconnect()
		task.spawn(cor, ...)
	end)

	return coroutine.yield()
end


function Signal:ConnectParallel(fn)
	assert(type(fn) == "function", `Invalid Argument #1, function expected, got {typeof(fn)}`)

	local connection = signal_connection.new(self, fn, nil, true)

	table.insert(self._listeners, connection)

	return connection
end

function Signal:Destroy()
	table.clear(self._listeners)
	self._listeners = nil

	setmetatable(self, nil)
end

--end of `Signal` class

---------------------------------------------------------------

-----Format Functions------

local format_multi = {
	s = 1,
	m = 60,
	h = 3600,
	d = 86400,
	mon = 2592000,
	y = 31104000
}

local default_format_params = {
	div = "", -- no separator by default
	include_if_0 = false, -- skip units with 0
	seconds = "s",
	minutes = "m",
	hours = "h",
	days = "d",
	months = "mon",
	years = "y"
}

local units_in_order = {
	{ key = "years",   seconds = format_multi.y },
	{ key = "months",  seconds = format_multi.mon },
	{ key = "days",    seconds = format_multi.d },
	{ key = "hours",   seconds = format_multi.h },
	{ key = "minutes", seconds = format_multi.m },
	{ key = "seconds", seconds = format_multi.s },
}

local function FormatTime(format_num, format_mode, format_params)
	assert(type(format_num) == "number", `Invalid argument #1, number expected, got {typeof(format_num)}`)
	format_mode = format_mode or "s"
	format_params = format_params or default_format_params

	--Validate the format params
	for key, value in pairs(default_format_params) do
		if format_params[key] == nil then
			format_params[key] = value
		end
	end

	if not format_multi[format_mode] then
		warn(`Invalid format mode: {format_mode}. Expected one of: s, m, h, d, mon, y`)
		return ""
	end

	-- Convert to total seconds
	local total_seconds = math.round(format_num * format_multi[format_mode])

	local parts = {}

	for _, unit in ipairs(units_in_order) do
		local unit_key = unit.key
		local unit_seconds = unit.seconds
		local value = math.floor(total_seconds / unit_seconds)
		total_seconds %= unit_seconds

		if value > 0 or format_params.include_if_0 then
			local label = format_params[unit_key] or unit_key
			table.insert(parts, tostring(value) .. label)
		end
	end

	return table.concat(parts, format_params.div or "")
end


-- Ordered suffix list (from largest to smallest)
local default_suffixes = {
	{ key = "Un", name = "Ud", value = 1e36 },
	{ key = "Dd", name = "Dd", value = 1e33 },
	{ key = "No", name = "No", value = 1e30 },
	{ key = "Oc", name = "Oc", value = 1e27 },
	{ key = "Sp", name = "Sp", value = 1e24 },
	{ key = "Sx", name = "Sx", value = 1e21 },
	{ key = "Qi", name = "Qi", value = 1e18 },
	{ key = "Qa", name = "Qa", value = 1e15 },
	{ key = "T",  name = "T",  value = 1e12 },
	{ key = "B",  name = "B",  value = 1e9  },
	{ key = "M",  name = "M",  value = 1e6  },
	{ key = "K",  name = "k",  value = 1e3  },
}

local function FormatNumber(num, config)
	assert(typeof(num) == "number", `Invalid argument #1: expected number, got {typeof(num)}`)

	config = config or {}

	local precision = typeof(config.precision) == "number" and config.precision or 1
	local customLabels = config.suffixes or {}

	local absNum = math.abs(num)

	for _, suffixData in ipairs(default_suffixes) do
		if absNum >= suffixData.value then
			local value = num / suffixData.value
			local formatted = string.format(`%.{precision}f`, value)

			-- Use custom label if provided for this suffix key
			local label = customLabels[suffixData.key] or suffixData.name

			return formatted .. label
		end
	end

	-- Fallback for small numbers
	if precision == 0 then
		return tostring(math.floor(num))
	else
		return string.format(`%.{precision}f`, num)
	end
end

---------------------------------------------------------------


-----Random------
local rng = Random.new() -- Single Random instance for consistent randomization

local Random = {}


function Random.Choice(tbl): any
	if type(tbl) ~= "table" then
		error("[Random] incorrect argument #1, table expected, got " .. typeof(tbl))
	end
	if next(tbl) == nil then
		warn("[Random] empty table provided, not processing request")
		return nil
	end

	local ch = {}
	for k, v in pairs(tbl) do
		table.insert(ch, {k, v})
	end
	local result = ch[rng:NextInteger(1, #ch)]
	if result then
		if type(result[1]) == "string" or typeof(result[1]) == "Instance" then
			return result[2], result[1]
		end
		return result[2]
	end
end

function Random.GenerateRandomInteger(x: number, y: number, blacklist: {number}?, attempt: number?): number
	if type(x) ~= "number" or type(y) ~= "number" then
		error("[Random] incorrect x or y arguments")
	end
	if x > y then
		error("[Random] x must be lower than y")
	end
	attempt = attempt or 1
	local result = rng:NextInteger(x, y)
	if type(blacklist) == "table" then
		if table.find(blacklist, result) then
			if attempt > 120 then
				error("[Random] exceeded Random number generation attempts, please try to minimize the blacklist")
			end
			result = Random.GenerateRandomInteger(x, y, blacklist, attempt + 1)
		end
	end
	return result
end

function Random.WeightedChoice(tbl: {any}, weightKey: string?): any
	if type(tbl) ~= "table" then
		error("[Random] Expected a table, got " .. typeof(tbl))
	end
	if next(tbl) == nil then
		error("[Random] Table is empty")
	end
	weightKey = weightKey or "weight"

	local totalWeight = 0
	for _, item in pairs(tbl) do
		if type(item[weightKey]) ~= "number" then
			error("[Random] Invalid weight for item: " .. tostring(item))
		end
		totalWeight = totalWeight + item[weightKey]
	end

	local randomValue = rng:NextNumber() * totalWeight
	local currentWeight = 0
	for _, item in pairs(tbl) do
		currentWeight = currentWeight + item[weightKey]
		if randomValue <= currentWeight then
			return item
		end
	end
	return tbl[#tbl] -- Fallback for floating-point precision
end

function Random.ChooseMultiple(tbl: {any} | {[any]: any}, n: number, allowDuplicates: boolean?): {any}
	if type(tbl) ~= "table" then
		error("[Random] Expected a table, got " .. typeof(tbl))
	end
	if type(n) ~= "number" or n < 1 or math.floor(n) ~= n then
		error("[Random] n must be a positive integer")
	end
	local isArray = #tbl > 0
	local count = isArray and #tbl or table.maxn(tbl)
	if not allowDuplicates and n > count then
		error("[Random] Cannot select " .. n .. " unique items from a table with " .. count .. " items")
	end

	local result = {}
	local available = table.clone(tbl)
	for i = 1, n do
		if next(available) == nil then
			if allowDuplicates then
				available = table.clone(tbl)
			else
				error("[Random] Ran out of unique items")
			end
		end
		local item, key = Random.Choice(available)
		table.insert(result, item)
		if not allowDuplicates then
			if isArray then
				table.remove(available, key)
			else
				available[key] = nil
			end
		end
	end
	return result
end

function Random.RandomFloat(min: number, max: number): number
	if type(min) ~= "number" or type(max) ~= "number" then
		error("[Random] min and max must be numbers")
	end
	if min > max then
		error("[Random] min cannot be greater than max_ASYNC")
	end
	return min + (max - min) * rng:NextNumber()
end

function Random.WeightedRandomFloat(min: number, max: number, mode: number?): number
	if type(min) ~= "number" or type(max) ~= "number" then
		error("[Random] min and max must be numbers")
	end
	mode = mode or (min + max) / 2
	if mode < min or mode > max then
		error("[Random] mode must be between min and max")
	end
	local u = rng:NextNumber()
	local c = (mode - min) / (max - min)
	if u <= c then
		return min + math.sqrt(u * (max - min) * (mode - min))
	else
		return max - math.sqrt((1 - u) * (max - min) * (max - mode))
	end
end
----------------------------------------------------------------

----Powered DataStoreService Class----

local total_ds_requests = 0

local elite_data_store_service = {}
elite_data_store_service.__index = elite_data_store_service

local data_store_processor = {
	incoming_requests = {
		SetAsync = {},
		GetAsync = {},
		UpdateAsync = {},
		IncrementAsync = {},
		RemoveAsync = {},
		ListKeysAsync = {},
		GetVersionAsync = {},
		ListVersionsAsync = {},
		RemoveVersionAsync = {},
		GetVersionAtTimeAsync = {},
		GetSortedAsync = {}
	},
	IsRunning = false
}

local RequestFinished = Signal.new()

local RunService = game:GetService("RunService")
local DataStoreService = game:GetService("DataStoreService")

local function run_processor()
	if data_store_processor.IsRunning then
		return
	end
	data_store_processor.IsRunning = true

	local heartbeatConn
	local elapsed = 0

	heartbeatConn = RunService.Heartbeat:Connect(function(delta)
		elapsed += delta
		if elapsed < 0.5 then return end
		elapsed = 0

		local allEmpty = true

		for req_name, req_queue in pairs(data_store_processor.incoming_requests) do
			if #req_queue > 0 then
				allEmpty = false

				for _, request_info in ipairs(req_queue) do
					if request_info.processing then
						continue
					end

					local budget = DataStoreService:GetRequestBudgetForRequestType(request_info.rt)
					if budget <= 0 then
						continue
					end

					request_info.processing = true

					task.spawn(function()
						local key = request_info.tk
						local ds = request_info.ds
						local opts = request_info.dso
						local xtra = request_info.xtra

						local result = {
							success = false,
							errmsg = nil,
							value = nil
						}

						local ok, err = pcall(function()
							if req_name == "GetAsync" then
								result.value = ds:GetAsync(key, opts)
							elseif req_name == "SetAsync" then
								ds:SetAsync(key, xtra.set_value, opts)
								result.success = true
								return
							elseif req_name == "UpdateAsync" then
								ds:UpdateAsync(key, xtra.transform_func)
								result.success = true
								return
							elseif req_name == "IncrementAsync" then
								ds:IncrementAsync(key, xtra.increment, opts)
								result.success = true
								return
							elseif req_name == "RemoveAsync" then
								ds:RemoveAsync(key, opts)
								result.success = true
								return
							elseif req_name == "ListKeysAsync" then
								result.value = ds:ListKeysAsync(xtra.prefix, xtra.page_size, xtra.cursor, xtra.exclude_deleted)
							elseif req_name == "GetVersionAsync" then
								result.value = ds:GetVersionAsync(xtra.key, xtra.version)
							elseif req_name == "ListVersionsAsync" then
								result.value = ds:ListVersionsAsync(xtra.key, xtra.sort_direction, xtra.min_date, xtra.max_date, xtra.page_size)
							elseif req_name == "RemoveVersionAsync" then
								result.value = ds:RemoveVersionAsync(xtra.key, xtra.version)
							elseif req_name == "GetVersionAtTimeAsync" then
								result.value = ds:GetVersionAtTimeAsync(xtra.key, xtra.timestamp)
							elseif req_name == "GetSortedAsync" then
								local ascending = xtra.ascending
								local pageSize = xtra.pageSize
								local minValue = xtra.minValue
								local maxValue = xtra.maxValue

								local pages = ds:GetSortedAsync(ascending, pageSize, minValue, maxValue)

								-- Return full pages object or just the current page, based on xtra
								if xtra.returnRawPages then
									result.value = pages
								else
									result.value = pages:GetCurrentPage()
								end

								result.success = true
							else
								warn(`[DataStoreProcessor] Unknown request type: {req_name}`)
							end
						end) 

						result.success = ok and (result.success or result.value ~= nil)
						if not ok then
							result.errmsg = err
							warn(`[DataStoreProcessor] Error with "{req_name}" on {key}: {err}`)
						end

						RequestFinished:Fire(request_info.rid, result)

						-- Remove this request from the queue
						local index = table.find(req_queue, request_info)
						if index then
							table.remove(req_queue, index)
						end
					end)
				end
			end
		end

		if allEmpty then
			-- No more queued requests – stop it
			data_store_processor.IsRunning = false
			heartbeatConn:Disconnect()
		end
	end)
end


local function generate_request_id()
	total_ds_requests += 1
	return "R_"..total_ds_requests
end

local function process_request(request_name: string, data_store: DataStore, request_type: Enum.DataStoreRequestType, target_key: string, extradata: {[any]: any}, data_store_options: DataStoreOptions?)

	--start the processor once a request is made
	run_processor()

	local rval = nil
	local process_finished = false

	if data_store_processor.incoming_requests[request_name] then
		local request_id = generate_request_id()
		local conn = nil
		conn = RequestFinished:Connect(function(r_id, return_val)
			if request_id == r_id then
				rval = return_val
				process_finished = true
				conn:Disconnect()
			end
		end)

		table.insert(data_store_processor.incoming_requests[request_name], {
			ds = data_store,
			rt = request_type,
			tk = target_key,
			dso = data_store_options,
			rid = request_id,
			processing = false,
			xtra = extradata
		})
	else
		warn(`No {request_name} request found`)
		process_finished = true
	end

	repeat
		task.wait()
	until process_finished

	return rval
end
function elite_data_store_service:GetDataStore(data_store_name: string, data_store_scope: string?, data_store_options: DataStoreOptions?)
	assert(type(data_store_name) == "string", "Invalid argument #1, string expected, got "..typeof(data_store_name))

	local self = setmetatable({}, elite_data_store_service)
	self._ds = DataStoreService:GetDataStore(data_store_name, data_store_scope, data_store_options)

	return self
end

function elite_data_store_service:ListDataStoresAsync(prefix, pagesize, cursor)
	return DataStoreService:ListDataStoresAsync(prefix, pagesize, cursor)
end

function elite_data_store_service:GetOrderedDataStore(data_store_name: string, data_store_scope: string?)
	assert(type(data_store_name) == "string", "Invalid argument #1, string expected, got "..typeof(data_store_name))

	local self = setmetatable(elite_data_store_service, {})
	self._ds = DataStoreService:GetOrderedDataStore(data_store_name, data_store_scope)

	return self
end

function elite_data_store_service:GetAsync(data_store_key, data_store_options)
	assert(type(data_store_key) == "string", `Invalid argument #1, string expected, got {typeof(data_store_key)}`)

	local request_result = process_request("GetAsync", self._ds, Enum.DataStoreRequestType.GetAsync, data_store_key, nil, data_store_options)

	return request_result.value
end

function elite_data_store_service:RemoveAsync(data_store_key)
	assert(type(data_store_key) == "string", `Invalid argument #1, string expected, got {typeof(data_store_key)}`)

	local request_result = process_request("RemoveAsync", self._ds, Enum.DataStoreRequestType.SetIncrementAsync, data_store_key)

	return request_result.value
end

function elite_data_store_service:SetAsync(data_store_key, save_value, user_ids: {any?}, data_store_options)
	assert(type(data_store_key) == "string", `Invalid argument #1, string expected, got {typeof(data_store_key)}`)


	local request_result = process_request("SetAsync", self._ds, Enum.DataStoreRequestType.SetIncrementAsync, data_store_key, {set_value = save_value, user_ids = user_ids}, data_store_options)

	return request_result.success
end

function elite_data_store_service:UpdateAsync(data_store_key, transform_function)
	assert(type(data_store_key) == "string", `Invalid argument #1, string expected, got {typeof(data_store_key)}`)
	assert(type(transform_function) == "function", `Invalid argument #2, function expected, got {typeof(transform_function)}`)

	local request_result = process_request("UpdateAsync", self._ds, Enum.DataStoreRequestType.SetIncrementAsync, data_store_key, {transform_func = transform_function})

	return request_result.success
end

function elite_data_store_service:IncrementAsync(data_store_key, increment_value, user_ids: {any?}, data_store_options)
	assert(type(data_store_key) == "string", `Invalid argument #1, string expected, got {typeof(data_store_key)}`)
	assert(type(increment_value) == "number", `Invalid argument #2, number expected, got {typeof(increment_value)}`)

	local request_result = process_request("IncrementAsync", self._ds, Enum.DataStoreRequestType.SetIncrementAsync, data_store_key, {set_value = increment_value, user_ids = user_ids}, data_store_options)

	return request_result.success
end

function elite_data_store_service:ListKeysAsync(prefix, page_size, cursor, exclude_deleted)
	local request_result = process_request("ListKeysAsync", self._ds, Enum.DataStoreRequestType.ListAsync, nil, {prefix = prefix, page_size = page_size, cursor = cursor, exclude_deleted = exclude_deleted})

	return request_result.value
end

function elite_data_store_service:ListVersionsAsync(key, sort_direction, min_date, max_date, page_size)
	assert(type(key) == "string", `Invalid argument #1, string expected, got {typeof(key)}`)


	local request_result = process_request("ListVersionsAsync", self._ds, Enum.DataStoreRequestType.ListAsync, nil, {key = key, sort_direction = sort_direction, min_date = min_date, max_date = max_date, page_size = page_size})

	return request_result.value
end

function elite_data_store_service:GetVersionAsync(key, version)
	assert(type(key) == "string", `Invalid argument #1, string expected, got {typeof(key)}`)


	local request_result = process_request("GetVersionAsync", self._ds, Enum.DataStoreRequestType.GetVersionAsync, nil, {key = key, version = version})

	return request_result.value
end

function elite_data_store_service:RemoveVersionAsync(key, version)
	assert(type(key) == "string", `Invalid argument #1, string expected, got {typeof(key)}`)


	local request_result = process_request("RemoveVersionAsync", self._ds, Enum.DataStoreRequestType.RemoveVersionAsync, nil, {key = key, version = version})

	return request_result.value
end

function elite_data_store_service:GetVersionAtTimeAsync(key, timestamp)
	assert(type(key) == "string", `Invalid argument #1, string expected, got {typeof(key)}`)
	assert(type(timestamp) == "number", `Invalid argument #2, number expected, got {typeof(timestamp)}`)



	local request_result = process_request("GetVersionAtTimeAsync", self._ds, Enum.DataStoreRequestType.GetVersionAsync, nil, {key = key, timestamp = timestamp})

	return request_result.value
end

function elite_data_store_service:GetSortedAsync(ascending: boolean, page_size: number, min_value: number?, max_value: number?, return_raw_pages: boolean?)
	assert(type(ascending) == "boolean", `Invalid argument #1, boolean expected, got {typeof(ascending)}`)
	assert(type(page_size) == "number", `Invalid argument #2, number expected, got {typeof(page_size)}`)
	if min_value ~= nil then
		assert(type(min_value) == "number", `Invalid argument #3, number or nil expected, got {typeof(min_value)}`)
	end
	if max_value ~= nil then
		assert(type(max_value) == "number", `Invalid argument #4, number or nil expected, got {typeof(max_value)}`)
	end
	if return_raw_pages ~= nil then
		assert(type(return_raw_pages) == "boolean", `Invalid argument #5, boolean or nil expected, got {typeof(return_raw_pages)}`)
	end

	local request_result = process_request(
		"GetSortedAsync",
		self._ds,
		Enum.DataStoreRequestType.GetSortedAsync,
		nil,
		{
			ascending = ascending,
			pageSize = page_size,
			minValue = min_value,
			maxValue = max_value,
			returnRawPages = return_raw_pages
		}
	)

	return request_result.value
end



-----Type annotations----

export type Connection = {
	Disconnect: (self: Connection) -> ()
}

export type Signal<T...> = {

	Connect: (self: Signal<T...>, func: (T...) -> ()) -> Connection,

	ConnectParallel: (self: Signal<T...>, func: (T...) -> ()) -> Connection,

	Once: (self: Signal<T...>, func: (T...) -> ()) -> Connection,

	Wait: (self: Signal<T...>) -> T...,

	Fire: (self: Signal<T...>, T...) -> ()

}
export type TimeFormatParams = {
	div: string?,
	include_if_0: boolean?,
	seconds: string?,
	minutes: string?,
	hours: string?,
	days: string?,
	months: string?,
	years: string?
}

export type NumberFormatParams = {
	precision: number,
	suffixes: {
		K: string,
		M: string,
		B: string,
		T: string,
		Qd: string,
		Qi: string,
		Sx: string,
		Sp: string,
		Oc: string,
		No: string,
		Dd: string,
		Un: string
	}
}

export type Signal_Lib = {
	new: <T...>(T...) -> Signal<T...>
}

export type Random = {
	-- Return a random value from the table
	Choice: (tbl: {any} | {[any]: any}) -> any,

	-- Generate a random number from x(minimum number) to y(maximum number)
	GenerateRandomInteger: (
		x: number, -- Minimum number
		y: number, -- Maximum number
		blacklist: {number}? -- Array of numbers to skip
	) -> number,

	-- Select a random item from a table based on weights
	WeightedChoice: (tbl: {{any}}, weightKey: string?) -> any,

	-- Select n unique items from a table
	ChooseMultiple: (tbl: {any} | {[any]: any}, n: number, allowDuplicates: boolean?) -> {any},

	-- Generate a random float between min and max
	RandomFloat: (min: number, max: number) -> number,

	-- Generate a random float with a bias (triangular distribution)
	WeightedRandomFloat: (min: number, max: number, mode: number?) -> number
}

export type EliteDataStore = {
	GetAsync: (self: EliteDataStore, key: string, options: DataStoreOptions?) -> any?,
	SetAsync: (self: EliteDataStore, key: string, value: any, userIds: {any?}?, options: DataStoreOptions?) -> boolean,
	UpdateAsync: (self: EliteDataStore, key: string, transform: (oldValue: any?) -> any) -> boolean,
	IncrementAsync: (self: EliteDataStore, key: string, delta: number, userIds: {any?}?, options: DataStoreOptions?) -> boolean,
	RemoveAsync: (self: EliteDataStore, key: string) -> boolean,

	ListVersionsAsync: (
		self: EliteDataStore,
		key: string,
		sortDirection: Enum.SortDirection?,
		minDate: number?,
		maxDate: number?,
		pageSize: number?
	) -> DataStoreVersionPages,

	GetVersionAsync: (
		self: EliteDataStore,
		key: string,
		version: string
	) -> any?,

	GetVersionAtTimeAsync: (
		self: EliteDataStore,
		key: string,
		timestamp: number
	) -> any?,

	RemoveVersionAsync: (
		self: EliteDataStore,
		key: string,
		version: string
	) -> boolean,

	ListKeysAsync: (
		self: EliteDataStore,
		prefix: string?,
		pageSize: number?,
		cursor: string?,
		excludeDeleted: boolean?
	) -> DataStoreKeyPages
}

export type EliteOrderedDataStore = {
	GetSortedAsync: (
		self: EliteOrderedDataStore,
		ascending: boolean,
		pageSize: number,
		minValue: number?,
		maxValue: number?,
		returnRawPages: boolean?
	) -> { [string]: number } | DataStorePages,

	GetAsync: (self: EliteOrderedDataStore, key: string, options: DataStoreOptions?) -> any?,
	SetAsync: (self: EliteOrderedDataStore, key: string, value: any, userIds: {any?}?, options: DataStoreOptions?) -> boolean,
	UpdateAsync: (self: EliteOrderedDataStore, key: string, transform: (oldValue: any?) -> any) -> boolean,
	IncrementAsync: (self: EliteOrderedDataStore, key: string, delta: number, userIds: {any?}?, options: DataStoreOptions?) -> boolean,
	RemoveAsync: (self: EliteOrderedDataStore, key: string) -> boolean,
}
export type EliteDataStoreService = {
	GetDataStore: (
		self: EliteDataStoreService,
		DataStoreName: string,
		Scope: string?,
		DataStoreOptions: DataStoreOptions?
	) -> EliteDataStore,

	GetOrderedDataStore: (
		self: EliteDataStoreService,
		DataStoreName: string,
		Scope: string?,
		DataStoreOptions: DataStoreOptions?
	) -> EliteOrderedDataStore,

	ListDataStoresAsync: (
		self: EliteDataStoreService,
		prefix: string?,
		pageSize: number?,
		cursor: string?
	) -> DataStoreListingPages,
}

local Types : {
	boolean: boolean,
	number: number,
	string: string,
	table: {[any]: any},
	func: (...any) -> ...any ,
	thread: thread,
	any: any,

	-- Roblox datatypes
	Axes: Axes,
	BrickColor: BrickColor,
	CFrame: CFrame,
	Color3: Color3,
	ColorSequence: ColorSequence,
	ColorSequenceKeypoint: ColorSequenceKeypoint,
	DateTime: DateTime,
	DockWidgetPluginGuiInfo: DockWidgetPluginGuiInfo,
	Enum: Enum,
	EnumItem: EnumItem,
	Faces: Faces,
	NumberRange: NumberRange,
	NumberSequence: NumberSequence,
	NumberSequenceKeypoint: NumberSequenceKeypoint,
	PathWaypoint: PathWaypoint,
	PhysicalProperties: PhysicalProperties,
	Ray: Ray,
	RaycastParams: RaycastParams,
	RaycastResult: RaycastResult,
	Rect: Rect,
	Region3: Region3,
	Region3int16: Region3int16,
	TweenInfo: TweenInfo,
	UDim: UDim,
	UDim2: UDim2,
	Vector2: Vector2,
	Vector2int16: Vector2int16,
	Vector3: Vector3,
	Vector3int16: Vector3int16,
	OverlapParams: OverlapParams,
	Instance: Instance,
	Model: Model,
	BindableEvent: BindableEvent,
	BindableFunction: BindableFunction,
	Folder: Folder,
	Part: Part,
	MeshPart: MeshPart,
	UnionOperation: UnionOperation,
	WedgePart: WedgePart,
	CornerWedgePart: CornerWedgePart,
	TrussPart: TrussPart,
	BasePart: BasePart,
	Player: Player,
	Players: Players,
	Workspace: Workspace,
	Sound: Sound,
	Animation: Animation,
	AnimationTrack: AnimationTrack,
	Humanoid: Humanoid,
	Tool: Tool,
	Accessory: Accessory,
	BillboardGui: BillboardGui,
	SurfaceGui: SurfaceGui,
	ScreenGui: ScreenGui,
	TextLabel: TextLabel,
	TextButton: TextButton,
	ImageLabel: ImageLabel,
	ImageButton: ImageButton,
	Frame: Frame,
	VideoFrame: VideoFrame,
	ViewportFrame: ViewportFrame,
	Camera: Camera,
	Decal: Decal,
	Texture: Texture,
	Light: Light,
	PointLight: PointLight,
	SpotLight: SpotLight,
	SurfaceLight: SurfaceLight,
	ParticleEmitter: ParticleEmitter,
	Beam: Beam,
	Trail: Trail,
	Attachment: Attachment,
	AlignPosition: AlignPosition,
	AlignOrientation: AlignOrientation,
	BodyPosition: BodyPosition,
	BodyGyro: BodyGyro,
	BodyVelocity: BodyVelocity,
	LinearVelocity: LinearVelocity,
	VectorForce: VectorForce,
	AngularVelocity: AngularVelocity,

	-- Roblox special types
	SecurityCapabilities: SecurityCapabilities,
	SharedTable: SharedTable,
	
	
	
	--Module types
	Signal: Signal,
	Signal_Lib: Signal_Lib,
	Random: Random,
	EliteDataStoreService: EliteDataStoreService,
	EliteDataStore: EliteDataStore,
	EliteOrderedDataStore: EliteOrderedDataStore
} = nil


return {
	Signal = Signal :: Signal_Lib,
	FormatUtils = {
		FormatTime = FormatTime :: (FormatNumber: number, FormatNumberMode: string?, FormatParams: TimeFormatParams?) -> string,
		FormatNumber = FormatNumber :: (FormatNumber: number, Params: NumberFormatParams?) -> string,
	},
	Random = Random :: Random,

	EliteDataStoreService = elite_data_store_service :: EliteDataStoreService,
	
	Types = Types
}