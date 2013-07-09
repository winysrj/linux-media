Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f51.google.com ([209.85.212.51]:46738 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3GILIp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jul 2013 07:08:45 -0400
MIME-Version: 1.0
In-Reply-To: <51C385F0.6000402@gmail.com>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
	<1370005408-10853-2-git-send-email-arun.kk@samsung.com>
	<51C385F0.6000402@gmail.com>
Date: Tue, 9 Jul 2013 16:38:44 +0530
Message-ID: <CALt3h7-jRSNZNsrxkeuGTgjTv1iRMb00ZAqcFUvcj_R-dsYiRw@mail.gmail.com>
Subject: Re: [RFC v2 01/10] exynos5-fimc-is: Add Exynos5 FIMC-IS device tree
 bindings documentation
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thank you for the review and sorry for the delayed response.

On Fri, Jun 21, 2013 at 4:15 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Arun,
>
> On 05/31/2013 03:03 PM, Arun Kumar K wrote:
>
> Please add at least one sentence here. All in all this patch
> adds DT binding documentation for a fairly complex subsystem.
>
> And please Cc devicetree-discuss@lists.ozlabs.org next time.
>

Ok will do that.

>
>> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
>> ---
>>   .../devicetree/bindings/media/exynos5-fimc-is.txt  |   41
>> ++++++++++++++++++++
>>   1 file changed, 41 insertions(+)
>>   create mode 100644
>> Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>> b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>> new file mode 100644
>> index 0000000..9fd4646
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>> @@ -0,0 +1,41 @@
>> +Samsung EXYNOS SoC Camera Subsystem
>
>
> Shouldn't it be, e.g.:
>
> Samsung EXYNOS5 SoC series Imaging Subsystem (FIMC-IS)
>
> Or do you intend this file to be describing also the other sub-devices,
> like GScaler ?
>

Probably not. WIll change it to Imaging subsystem.

>
>> +-----------------------------------
>> +
>> +The camera subsystem on Samsung Exynos5 SoC has some changes relative
>> +to previous SoC versions. Exynos5 has almost similar MIPI-CSIS and
>> +FIMC-LITE IPs but has a much improved version of FIMC-IS which can
>> +handle sensor controls and camera post-processing operations. The
>> +Exynos5 FIMC-IS has a dedicated ARM Cortex A5 processor, many
>> +post-processing blocks (ISP, DRC, FD, ODC, DIS, 3DNR) and two
>> +dedicated scalers (SCC and SCP).
>> +
>> +fimc-is node
>> +------------
>> +
>> +Required properties:
>> +
>> +- compatible        : must be "samsung,exynos5250-fimc-is"
>> +- reg               : physical base address and size of the memory mapped
>> +                      registers
>> +- interrupt-parent  : Parent interrupt controller
>> +- interrupts        : fimc-is interrupt to the parent combiner
>> +- clocks            : list of clock specifiers, corresponding to entries
>> in
>> +                      clock-names property;
>> +- clock-names       : must contain "isp", "mcu_isp", "isp_div0",
>> "isp_div1",
>> +                      "isp_divmpwm", "mcu_isp_div0", "mcu_isp_div1"
>> entries,
>> +                      matching entries in the clocks property.
>> +
>> +
>> +Board specific properties:
>> +
>> +- pinctrl-names    : pinctrl names for camera port pinmux control, at
>> least
>> +                    "default" needs to be specified.
>> +- pinctrl-0...N           : pinctrl properties corresponding to
>> pinctrl-names
>
>
> What pins exactly are supposed to be covered by these properties ? For what
> devices ? Aren't the camera port pins supposed to be specified at the common
> 'camera' node ? I believe the camera ports are not specific to the FIMC-IS.
>

These are for the sensor controls (especially clock lines).
I think I should move these to the sensor node.

>
>> +pmu subnode
>> +-----------
>> +
>> +Required properties:
>> + - reg : should contain PMU physical base address and size of the memory
>> +         mapped registers.
>
>
> What about other devices, like ISP I2C, SPI ? Don't you want to list at
> least
> the ones currently used (I2C bus controllers) ?
>

The present driver doesnt make use of the SPI bus as its used only
for sensor calibration which is not yet added.
I2C bus is used by the sensor which has its own node. May be I should
explain one of the sensor nodes over here?

Regards
Arun
