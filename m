Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:61071 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab3HEWhj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Aug 2013 18:37:39 -0400
Message-ID: <5200292E.1000505@gmail.com>
Date: Tue, 06 Aug 2013 00:37:34 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Arun Kumar K <arun.kk@samsung.com>, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	s.nawrocki@samsung.com, hverkuil@xs4all.nl, a.hajda@samsung.com,
	sachin.kamat@linaro.org, shaik.ameer@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com,
	Rob Herring <rob.herring@calxeda.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [RFC v3 02/13] [media] exynos5-fimc-is: Add Exynos5 FIMC-IS device
 tree bindings documentation
References: <1375455762-22071-1-git-send-email-arun.kk@samsung.com> <1375455762-22071-3-git-send-email-arun.kk@samsung.com> <51FD7925.2010604@gmail.com> <51FFD892.5000708@wwwdotorg.org>
In-Reply-To: <51FFD892.5000708@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/05/2013 06:53 PM, Stephen Warren wrote:
> On 08/03/2013 03:41 PM, Sylwester Nawrocki wrote:
>> On 08/02/2013 05:02 PM, Arun Kumar K wrote:
>>> The patch adds the DT binding documentation for Samsung
>>> Exynos5 SoC series imaging subsystem (FIMC-IS).
>
>>> diff --git
>>> a/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>>> b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>>> new file mode 100644
>>> index 0000000..49a373a
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>>> @@ -0,0 +1,52 @@
>>> +Samsung EXYNOS5 SoC series Imaging Subsystem (FIMC-IS)
>>> +------------------------------------------------------
>>> +
>>> +The camera subsystem on Samsung Exynos5 SoC has some changes relative
>>> +to previous SoC versions. Exynos5 has almost similar MIPI-CSIS and
>>> +FIMC-LITE IPs but has a much improved version of FIMC-IS which can
>>> +handle sensor controls and camera post-processing operations. The
>>> +Exynos5 FIMC-IS has a dedicated ARM Cortex A5 processor, many
>>> +post-processing blocks (ISP, DRC, FD, ODC, DIS, 3DNR) and two
>>> +dedicated scalers (SCC and SCP).
>
> So there are a lot of blocks mentioned there, yet the binding doesn't
> seem to describe most of it. Is the binding complete?

Thanks for the review Stephen.

No, the binding certainly isn't complete, it doesn't describe the all
available IP blocks. There are separate MMIO address regions for each
block for the main CPUs and for the Cortex-A5 which is supposed to run
firmware that controls the whole subsystem. So in theory all those IP
blocks should be listed as device tree nodes, with at least their
compatible, reg and interrupts properties. However due to most of the
sub-devices being controlled by the firmware the current Linux driver
for this whole FIMC-IS subsystem doesn't need to now exact details
of each internal data processing block. The is a mailbox interface
used for communication between host CPU and the FIMC-IS CPU.

So while we could list all the devices, we decided not to do so.
Because it is not needed by the current software and we may miss some
details for case where the whole subsystem is controlled by the host
CPU (however such scenario is extremely unlikely AFAICT) which then
would be impossible or hard to change.

I guess we should list all available devices, similarly as it's done
in Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt.

And then should they just be disabled through the status property
if they are not needed in the Linux driver ? I guess it is more
sensible than marking them as optional and then not listing them
in dts at all ?

>>> +pmu subnode
>>> +-----------
>>> +
>>> +Required properties:
>>> + - reg : should contain PMU physical base address and size of the memory
>>> +         mapped registers.
>
> I think you need a compatible value for this. How else is the node
> identified? The node name probably should not be used for identification.

Of course the node name is currently used for identification. There is no
compatible property because this pmu node is used to get hold of only part
of the Power Management Unit registers, specific to the FIMC-IS.
The PMU has more registers that also other drivers would be interested in,
e.g. clocks or USB.

I have been considering exposing the PMU registers through a syscon-like
interface and having a phandle pointing to it in the relevant device nodes.

Adding compatible property might not be a good approach. It would have
been hard to map this to a separate device described in the SoC's
datasheet. Registers specific to the FIMC-IS are not contiguous in the
PMU MMIO region.

>>> +
>>> +i2c-isp (ISP I2C bus controller) nodes
>>> +------------------------------------------
>>> +
>>> +Required properties:
>>> +
>>> +- compatible    : should be "samsung,exynos4212-i2c-isp" for Exynos4212,
>>> +          Exynos4412 and Exynos5250 SoCs;
>>> +- reg        : physical base address and length of the registers set;
>>> +- clocks    : must contain gate clock specifier for this controller;
>>> +- clock-names    : must contain "i2c_isp" entry.
>>> +
>>> +For the above nodes it is required to specify a pinctrl state named "default",
>
> Is "above nodes" both pmu, i2c-isp? It might make sense to be more
> explicit re: which nodes this comment applies to.

Yeah, certainly there is room for improvement here. "above nodes" was 
supposed
to refer to the i2c-isp nodes only, it should be said more precisely.

>>> +according to the pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt.
