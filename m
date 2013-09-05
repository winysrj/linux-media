Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:33599 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab3IETk3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Sep 2013 15:40:29 -0400
Message-ID: <5228DE28.4030503@gmail.com>
Date: Thu, 05 Sep 2013 21:40:24 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: devicetree@vger.kernel.org
CC: Arun Kumar K <arun.kk@samsung.com>, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, swarren@wwwdotorg.org, mark.rutland@arm.com,
	Pawel.Moll@arm.com, galak@codeaurora.org, a.hajda@samsung.com,
	sachin.kamat@linaro.org, shaik.ameer@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: Re: [PATCH v7 02/13] [media] exynos5-fimc-is: Add Exynos5 FIMC-IS
 device tree bindings documentation
References: <1377066881-5423-1-git-send-email-arun.kk@samsung.com> <1377066881-5423-3-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1377066881-5423-3-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2013 08:34 AM, Arun Kumar K wrote:
> The patch adds the DT binding documentation for Samsung
> Exynos5 SoC series imaging subsystem (FIMC-IS).
>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> Reviewed-by: Sylwester Nawrocki<s.nawrocki@samsung.com>

Can I have a DT binding maintainer Ack for this binding ?
I'd like to queue this patch for 3.13 once the merge window has closed.

> ---
>   .../devicetree/bindings/media/exynos5-fimc-is.txt  |   46 ++++++++++++++++++++
>   1 file changed, 46 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>
> diff --git a/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
> new file mode 100644
> index 0000000..5611401
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
> @@ -0,0 +1,46 @@
> +Samsung EXYNOS5 SoC series Imaging Subsystem (FIMC-IS)
> +------------------------------------------------------
> +
> +The camera subsystem on Samsung Exynos5 SoC has some changes relative
> +to previous SoC versions. Exynos5 has almost similar MIPI-CSIS and
> +FIMC-LITE IPs but has a much improved version of FIMC-IS which can
> +handle sensor controls and camera post-processing operations. The
> +Exynos5 FIMC-IS has a dedicated ARM Cortex A5 processor, many
> +post-processing blocks (ISP, DRC, FD, ODC, DIS, 3DNR) and two
> +dedicated scalers (SCC and SCP).
> +
> +fimc-is node
> +------------
> +
> +Required properties:
> +
> +- compatible        : must be "samsung,exynos5250-fimc-is"
> +- reg               : physical base address and size of the memory mapped
> +                      registers
> +- interrupt-parent  : parent interrupt controller
> +- interrupts        : fimc-is interrupt to the parent interrupt controller
> +- clocks            : list of clock specifiers, corresponding to entries in
> +                      clock-names property
> +- clock-names       : must contain "isp", "mcu_isp", "isp_div0", "isp_div1",
> +                      "isp_divmpwm", "mcu_isp_div0", "mcu_isp_div1" entries,
> +                      matching entries in the clocks property
> +- samsung,pmu       : phandle to the Power Management Unit (PMU) node
> +
> +i2c-isp (ISP I2C bus controller) nodes
> +------------------------------------------
> +
> +Required properties:
> +
> +- compatible	: should be "samsung,exynos4212-i2c-isp" for Exynos4212,
> +		  Exynos4412 and Exynos5250 SoCs
> +- reg		: physical base address and length of the registers set
> +- clocks	: must contain gate clock specifier for this controller
> +- clock-names	: must contain "i2c_isp" entry
> +
> +For the i2c-isp node, it is required to specify a pinctrl state named "default",
> +according to the pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt.
> +
> +Device tree nodes of the image sensors controlled directly by the FIMC-IS
> +firmware must be child nodes of their corresponding ISP I2C bus controller node.
> +The data link of these image sensors must be specified using the common video
> +interfaces bindings, defined in video-interfaces.txt.

--
Thanks,
Sylwester
