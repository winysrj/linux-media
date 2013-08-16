Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:59153 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab3HPIJW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Aug 2013 04:09:22 -0400
MIME-Version: 1.0
In-Reply-To: <520CEF1A.90306@gmail.com>
References: <1376455574-15560-1-git-send-email-arun.kk@samsung.com>
	<1376455574-15560-3-git-send-email-arun.kk@samsung.com>
	<520CEF1A.90306@gmail.com>
Date: Fri, 16 Aug 2013 13:39:20 +0530
Message-ID: <CALt3h78hTfrVot5RMVdCJ1pPRY_D2C-Dwb-+YoPYyhCqHr+Mpg@mail.gmail.com>
Subject: Re: [PATCH v5 02/13] [media] exynos5-fimc-is: Add Exynos5 FIMC-IS
 device tree bindings documentation
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	kilyeon.im@samsung.com, Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thu, Aug 15, 2013 at 8:39 PM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> W dniu 2013-08-14 06:46, Arun Kumar K pisze:
>
>> The patch adds the DT binding documentation for Samsung
>> Exynos5 SoC series imaging subsystem (FIMC-IS).
>>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
>>   .../devicetree/bindings/media/exynos5-fimc-is.txt  |   47
>> ++++++++++++++++++++
>>   1 file changed, 47 insertions(+)
>>   create mode 100644
>> Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>> b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>> new file mode 100644
>> index 0000000..bfd36df
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>> @@ -0,0 +1,47 @@
>> +Samsung EXYNOS5 SoC series Imaging Subsystem (FIMC-IS)
>> +------------------------------------------------------
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
>> +- interrupt-parent  : parent interrupt controller
>> +- interrupts        : fimc-is interrupt to the parent combiner
>
>
> Is it really only one interrupt or two as in case of Exynos4x12 ?
> Also it's probably more appropriate to say "interrupt controller"
> instead of "combiner", not including details of the the FIMC-IS external
> interrupt controller in this binding.
>

It needs only one interrupt and that is the one from A5 to main ARM processor.
Will change it to controller.

>
>> +- clocks            : list of clock specifiers, corresponding to entries
>> in
>> +                      clock-names property;
>> +- clock-names       : must contain "isp", "mcu_isp", "isp_div0",
>> "isp_div1",
>> +                      "isp_divmpwm", "mcu_isp_div0", "mcu_isp_div1"
>> entries,
>> +                      matching entries in the clocks property.
>> +- pmu               : phandle to the fimc-is pmu node describing the
>> register
>> +                      base and size for FIMC-IS PMU.
>
>
> This property needs to be prefixed with "samsung,".
>

Ok

Regards
Arun
