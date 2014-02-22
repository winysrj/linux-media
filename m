Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:59047 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaBVW0s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Feb 2014 17:26:48 -0500
Message-ID: <5309241B.5000702@gmail.com>
Date: Sat, 22 Feb 2014 23:26:35 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"galak@codeaurora.org" <galak@codeaurora.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"kgene.kim@samsung.com" <kgene.kim@samsung.com>,
	"a.hajda@samsung.com" <a.hajda@samsung.com>,
	Mike Turquette <mturquette@linaro.org>,
	Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v4 03/10] Documentation: devicetree: Update Samsung FIMC
 DT binding
References: <1392925237-31394-1-git-send-email-s.nawrocki@samsung.com> <1392925237-31394-5-git-send-email-s.nawrocki@samsung.com> <20140221155023.GF20449@e106331-lin.cambridge.arm.com> <53091E72.3090107@gmail.com>
In-Reply-To: <53091E72.3090107@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[Ccing Mike]

On 22.02.2014 23:02, Sylwester Nawrocki wrote:
> On 02/21/2014 04:50 PM, Mark Rutland wrote:
>> On Thu, Feb 20, 2014 at 07:40:30PM +0000, Sylwester Nawrocki wrote:
>>> +- #clock-cells: from the common clock bindings
>>> (../clock/clock-bindings.txt),
>>> +  must be 1. A clock provider is associated with the 'camera' node
>>> and it should
>>> +  be referenced by external sensors that use clocks provided by the
>>> SoC on
>>> +  CAM_*_CLKOUT pins. The clock specifier cell stores an index of a
>>> clock.
>>> +  The indices are 0, 1 for CAM_A_CLKOUT, CAM_B_CLKOUT clocks
>>> respectively.
>>> +
>>> +- clock-output-names: from the common clock bindings, should contain
>>> names of
>>> +  clocks registered by the camera subsystem corresponding to
>>> CAM_A_CLKOUT,
>>> +  CAM_B_CLKOUT output clocks, in this order. Parent clock of these
>>> clocks are
>>> +  specified be first two entries of the clock-names property.
>>
>> Do you need this?
>
> All right, that might have been a bad idea, it mixes names of clocks
> registered
> by the main clock controller with names of clock input lines at the device.
> It's a mistake I have been usually sensitive to and now made it myself. :/
>
> My intention was to maintain the clock tree, since the camera block doesn't
> generate the clock itself, it merely passes through the clocks from the
> SoC main
> clock controller (CMU). So clk parents need to be properly set and since
> there
> is no clock-output-names property at the CMU DT node,
> of_clk_get_parent_name()
> cannot be used.
>
> So presumably the DT binding would be only specifying that the sclk_cam0,
> sclk_cam1 clock input entries are associated with output clocks named as
> in clock-output-names property.
>
> And the driver could either:
>   1) hard code those (well defined) CMU clock (clk parent) names,

I don't think this would be a good idea, as those CMU clock names may 
vary between SoCs.

>   2) clk_get() its input clock, retrieve name with __clk_get_name() and
> pass
>     it as parent name to clk_register() - it sounds a bit hacky though.

This looks fine, at least until proper interface is added to CCF. Exynos 
audio subsystem clock driver does exactly the same.

However, the right thing would be to make it possible to use pointers to 
struct clk instead of strings to list parent(s). This could be done by 
adding .parents field (struct clk **) to clk_init_data struct and make 
clk_register() use it if available.

>
> The output clock names could be also well defined by the binding per the
> IP's
> compatible. Nevertheless using clock-output-names seems cleaner to me than
> defining character strings in the driver.
>
> What do you think ?

<RANT>

Personally, I don't like clock-output-names at all. The idea of having a 
global namespace for all clock providers looks flawed to me. This 
property only tries to work around the not-quite-right design by giving 
device tree the right to force CCF to use particular internal clock 
identifiers and avoid collisions if two providers happen to have the 
same internal clock names.

I believe there should be completely no need for clock-output-names, 
(other than a textual label for debugging purposes, analogically to 
regulator-name). If one clock provider needs a clock from another, then 
you should list it using clock bindings in node of the former, not rely 
on some static name assignments.

Then, after eliminating the need to use static names anymore, the 
namespace could be split into per-provider namespaces and we would have 
no collision issue anymore.

Of course it's probably to late already for such changes, as there are 
already systems relying on clock-output-names (i.e. without inter-IP 
clock dependencies listed using clock bindings) and we would have to 
keep backwards compatibility anyway...

</RANT>

Best regards,
Tomasz
