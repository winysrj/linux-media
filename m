Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:43076 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934072Ab3GPVXq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jul 2013 17:23:46 -0400
Message-ID: <51E5B9DD.7090203@gmail.com>
Date: Tue, 16 Jul 2013 23:23:41 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arunkk.samsung@gmail.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [RFC v2 01/10] exynos5-fimc-is: Add Exynos5 FIMC-IS device tree
 bindings documentation
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com> <1370005408-10853-2-git-send-email-arun.kk@samsung.com> <51C385F0.6000402@gmail.com> <CALt3h7-jRSNZNsrxkeuGTgjTv1iRMb00ZAqcFUvcj_R-dsYiRw@mail.gmail.com>
In-Reply-To: <CALt3h7-jRSNZNsrxkeuGTgjTv1iRMb00ZAqcFUvcj_R-dsYiRw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 07/09/2013 01:08 PM, Arun Kumar K wrote:
> On Fri, Jun 21, 2013 at 4:15 AM, Sylwester Nawrocki
> <sylvester.nawrocki@gmail.com>  wrote:
>> On 05/31/2013 03:03 PM, Arun Kumar K wrote:
[...]
>>> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
>>> ---
>>>    .../devicetree/bindings/media/exynos5-fimc-is.txt  |   41
>>> ++++++++++++++++++++
>>>    1 file changed, 41 insertions(+)
>>>    create mode 100644
>>> Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>>> b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>>> new file mode 100644
>>> index 0000000..9fd4646
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>>> @@ -0,0 +1,41 @@
[...]
>>> +-----------------------------------
>>> +
>>> +The camera subsystem on Samsung Exynos5 SoC has some changes relative
>>> +to previous SoC versions. Exynos5 has almost similar MIPI-CSIS and
>>> +FIMC-LITE IPs but has a much improved version of FIMC-IS which can
>>> +handle sensor controls and camera post-processing operations. The
>>> +Exynos5 FIMC-IS has a dedicated ARM Cortex A5 processor, many
>>> +post-processing blocks (ISP, DRC, FD, ODC, DIS, 3DNR) and two
>>> +dedicated scalers (SCC and SCP).
>>> +
>>> +fimc-is node
>>> +------------
>>> +
>>> +Required properties:
>>> +
>>> +- compatible        : must be "samsung,exynos5250-fimc-is"
>>> +- reg               : physical base address and size of the memory mapped
>>> +                      registers
>>> +- interrupt-parent  : Parent interrupt controller
>>> +- interrupts        : fimc-is interrupt to the parent combiner
>>> +- clocks            : list of clock specifiers, corresponding to entries
>>> in
>>> +                      clock-names property;
>>> +- clock-names       : must contain "isp", "mcu_isp", "isp_div0",
>>> "isp_div1",
>>> +                      "isp_divmpwm", "mcu_isp_div0", "mcu_isp_div1"
>>> entries,
>>> +                      matching entries in the clocks property.
>>> +
>>> +
>>> +Board specific properties:
>>> +
>>> +- pinctrl-names    : pinctrl names for camera port pinmux control, at
>>> least
>>> +                    "default" needs to be specified.
>>> +- pinctrl-0...N           : pinctrl properties corresponding to
>>> pinctrl-names
>>
>>
>> What pins exactly are supposed to be covered by these properties ? For what
>> devices ? Aren't the camera port pins supposed to be specified at the common
>> 'camera' node ? I believe the camera ports are not specific to the FIMC-IS.
>
> These are for the sensor controls (especially clock lines).
> I think I should move these to the sensor node.

This doesn't sound right either. These pins are not a property of an 
external
image sensor device, they are specific to the AP SoC. So IMO these pinctrl
properties belong to some SoC's internal device node.

I think we could add a clock provider for the sclk_cam clocks and then the
pinmux of those clock outputs could be configurable from with the clock 
ops.
E.g. we set the pinumx into CAM_?_CLKOUT function only when a clock is 
enabled.
Disabling a clock would put CLKOUT pin pinmux e.g. into input with pull 
down
state. This would ensure proper CLKOUT pin configuration when image 
sensor is
suspended or entirely powered off. I'm working on something like this for
exynos4.

>>> +pmu subnode
>>> +-----------
>>> +
>>> +Required properties:
>>> + - reg : should contain PMU physical base address and size of the memory
>>> +         mapped registers.
>>
>>
>> What about other devices, like ISP I2C, SPI ? Don't you want to list at
>> least
>> the ones currently used (I2C bus controllers) ?
>>
>
> The present driver doesnt make use of the SPI bus as its used only
> for sensor calibration which is not yet added.

Is it only going to be used by the Cortex-A5 firmware, similarly to the
I2C bus ? If so then it is likely not needed to specify it here right now.
But I believe for complete H/W description we should reserve a possibility
to add those various peripheral device nodes here.

> I2C bus is used by the sensor which has its own node. May be I should
> explain one of the sensor nodes over here?

I would describe at least I2C bus controller node and add a note that image
sensor nodes can be specified there.

Also, it would be good to start adding separate sensor drivers for each
sensor, like s5k6a3, s5k4e3, etc. Ideally we should not have duplicated
fimc-is-sensor.[ch] that would handle various sensors, i.e. same set of
sensors to drivers/media/platform/exynos4-is and drivers/media/platform/
exynos5-is.

After you post the next iteration of this series I could have a look how
it could be done.

--
Thanks,
Sylwester
