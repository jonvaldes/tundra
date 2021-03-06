-- Copyright 2010 Andreas Fredriksson
--
-- This file is part of Tundra.
--
-- Tundra is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- Tundra is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with Tundra.  If not, see <http://www.gnu.org/licenses/>.

module(..., package.seeall)

unit_test('scalar interpolation', function (t)
	local e = require 'tundra.environment'
	local e1, e2, e3
	e1 = e.create(nil, { Foo="Foo", Baz="Strut" })
	e2 = e1:clone({ Foo="Bar" })
	e3 = e1:clone({ Baz="c++" })

	t:check_equal(e1:get("Foo"), "Foo")
	t:check_equal(e1:get("Baz"), "Strut")
	t:check_equal(e2:get("Foo"), "Bar")
	t:check_equal(e2:get("Baz"), "Strut")
	t:check_equal(e3:get("Fransos", "Ost"), "Ost")

	e1:set("Foo", "Foo")
	t:check_equal(e1:interpolate("$(Foo)"), "Foo")
	t:check_equal(e1:interpolate("$(Foo:u)"), "FOO")
	t:check_equal(e1:interpolate("$(Foo:l)"), "foo")

	t:check_equal(e1:interpolate("$(Foo) $(Baz)"), "Foo Strut")
	t:check_equal(e2:interpolate("$(Foo) $(Baz)"), "Bar Strut")
	t:check_equal(e3:interpolate("$(Foo) $(Baz)"), "Foo c++")
	t:check_equal(e1:interpolate("a $(>)", { ['>'] = "foo" }), "a foo")

	e1:set("FILE", "foo/bar.txt")
	t:check_equal(e1:interpolate("$(FILE:B)"), "foo/bar")
	t:check_equal(e1:interpolate("$(FILE:B:a.res)"), "foo/bar.res")
end)

unit_test('list interpolation', function (t)
	local e = require 'tundra.environment'
	local e1 = e.create()

	e1:set("Foo", { "Foo" })
	t:check_equal(e1:interpolate("$(Foo)"), "Foo")

	e1:set("Foo", { "Foo", "Bar" } )
	t:check_equal(e1:interpolate("$(Foo)") , "Foo Bar")
	t:check_equal(e1:interpolate("$(Foo:j,)"), "Foo,Bar")
	t:check_equal(e1:interpolate("$(Foo:p!)") , "!Foo !Bar")
	t:check_equal(e1:interpolate("$(Foo:a!)") , "Foo! Bar!")
	t:check_equal(e1:interpolate("$(Foo:p-I:j__)") , "-IFoo__-IBar")
	t:check_equal(e1:interpolate("$(Foo:j\\:)"), "Foo:Bar")
	t:check_equal(e1:interpolate("$(Foo:u)"), "FOO BAR")
	t:check_equal(e1:interpolate("$(Foo:[2])"), "Bar")
	t:check_equal(e1:interpolate("$(Foo:Aoo)"), "Foo Baroo")
	t:check_equal(e1:interpolate("$(Foo:PF)"), "Foo FBar")
end)
