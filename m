Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:39185 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3KEFab (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 00:30:31 -0500
MIME-Version: 1.0
In-Reply-To: <20131028233205.GC4763@kartoffel>
References: <1382074659-31130-1-git-send-email-arun.kk@samsung.com>
	<1382074659-31130-2-git-send-email-arun.kk@samsung.com>
	<20131028233205.GC4763@kartoffel>
Date: Tue, 5 Nov 2013 11:00:30 +0530
Message-ID: <CALt3h78pyyKU35k7A=JZkvf2K4-3tSb2n2o2LZKnPef9zqWuNQ@mail.gmail.com>
Subject: Re: [PATCH v10 01/12] exynos5-fimc-is: Add Exynos5 FIMC-IS device
 tree bindings documentation
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"s.nawrocki@samsung.com" <s.nawrocki@samsung.com>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
	Pawel Moll <Pawel.Moll@arm.com>,
	"galak@codeaurora.org" <galak@codeaurora.org>,
	"a.hajda@samsung.com" <a.hajda@samsung.com>,
	"sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
	"shaik.ameer@samsung.com" <shaik.ameer@samsung.com>,
	"kilyeon.im@samsung.com" <kilyeon.im@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mark,

Thank you for the review.
Will address your comments.

Regards
Arun

On Tue, Oct 29, 2013 at 5:02 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi,
>
> Apologies for the late reply. I have a few comments, but nothing major.
>
> On Fri, Oct 18, 2013 at 06:37:28AM +0100, Arun Kumar K wrote:
>> The patch adds the DT binding documentation for Samsung
>> Exynos5 SoC series imaging subsystem (FIMC-IS).
>>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
>>  .../devicetree/bindings/media/exynos5-fimc-is.txt  |   84 ++++++++++++++++++++
>>  1 file changed, 84 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>> new file mode 100644
>> index 0000000..0525417
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>> @@ -0,0 +1,84 @@
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
>
> s/must be/should contain/
>
>> +- reg               : physical base address and size of the memory mapped
>> +                      registers
>> +- interrupt-parent  : parent interrupt controller
>
> I don't think this is actually required in all cases. It's a standard property
> that people can add if it happens to be required in a particular instance.
>
>> +- interrupts        : fimc-is interrupt to the parent interrupt controller
>
> Is this the only interrupt the device generates? If so:
>
> - interrupts: interrupt-specifier for the fimc-is interrupt.
>
>> +- clocks            : list of clock specifiers, corresponding to entries in
>> +                      clock-names property
>> +- clock-names       : must contain "isp", "mcu_isp", "isp_div0", "isp_div1",
>> +                      "isp_divmpwm", "mcu_isp_div0", "mcu_isp_div1" entries,
>> +                      matching entries in the clocks property
>> +- samsung,pmu       : phandle to the Power Management Unit (PMU) node
>> +
>> +i2c-isp (ISP I2C bus controller) nodes
>> +--------------------------------------
>> +The i2c-isp node is defined as the child node of fimc-is.
>
> There are multiple of these, so how about the following instead:
>
> The i2c-isp nodes should be children of the fimc-is node.
>
> It might be worth pointing out that ranges, #address-cells, and #size-cells
> should be present as appropriate.
>
>> +
>> +Required properties:
>> +
>> +- compatible : should be "samsung,exynos4212-i2c-isp" for Exynos4212,
>> +               Exynos4412 and Exynos5250 SoCs
>
> Similarly, s/should be/must contain/
>
>> +- reg                : physical base address and length of the registers set
>> +- clocks     : must contain gate clock specifier for this controller
>> +- clock-names        : must contain "i2c_isp" entry
>
> I'd prefer clocks to be described as for the simc-is, with clock names being
> something like:
>
> - clock-names: should contain "i2c_isp" for the gate clock.
>
>> +
>> +For the i2c-isp node, it is required to specify a pinctrl state named "default",
>> +according to the pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt.
>
> I'd prefer a mention of pinctrl-0 and pinctrl-names, as that's what most other
> bindings do.
>
> Also, as this is described as required it should be in the example.
>
>> +
>> +Device tree nodes of the image sensors controlled directly by the FIMC-IS
>> +firmware must be child nodes of their corresponding ISP I2C bus controller node.
>> +The data link of these image sensors must be specified using the common video
>> +interfaces bindings, defined in video-interfaces.txt.
>
> These don't seem to be in the example and probably should be.
>
> Otherwise, this looks fine. With those points fixed up:
>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
>
> Thanks,
> Mark.
