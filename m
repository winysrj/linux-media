Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28632 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab3HTL7u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 07:59:50 -0400
Message-id: <52135A32.70305@samsung.com>
Date: Tue, 20 Aug 2013 13:59:46 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, hverkuil@xs4all.nl,
	swarren@wwwdotorg.org, mark.rutland@arm.com, a.hajda@samsung.com,
	sachin.kamat@linaro.org, shaik.ameer@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com,
	Pawel Moll <Pawel.Moll@arm.com>,
	Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v6 02/13] [media] exynos5-fimc-is: Add Exynos5 FIMC-IS
 device tree bindings documentation
References: <1376644845-10422-1-git-send-email-arun.kk@samsung.com>
 <1376644845-10422-3-git-send-email-arun.kk@samsung.com>
In-reply-to: <1376644845-10422-3-git-send-email-arun.kk@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Pawel, Kumar

On 08/16/2013 11:20 AM, Arun Kumar K wrote:
> The patch adds the DT binding documentation for Samsung
> Exynos5 SoC series imaging subsystem (FIMC-IS).
> 
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>  .../devicetree/bindings/media/exynos5-fimc-is.txt  |   47 ++++++++++++++++++++
>  1 file changed, 47 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
> new file mode 100644
> index 0000000..bc279b4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
> @@ -0,0 +1,47 @@
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
> +                      clock-names property;
> +- clock-names       : must contain "isp", "mcu_isp", "isp_div0", "isp_div1",
> +                      "isp_divmpwm", "mcu_isp_div0", "mcu_isp_div1" entries,
> +                      matching entries in the clocks property.
> +- samsung,pmu       : phandle to the fimc-is pmu node describing the register
> +                      base and size for FIMC-IS PMU.

As this is a phandle to the whole SoC Power Management Unit I would amend
this to something like:

- samsung,pmu       : phandle to the Power Management Unit (PMU) node.

> +
> +i2c-isp (ISP I2C bus controller) nodes
> +------------------------------------------
> +
> +Required properties:
> +
> +- compatible	: should be "samsung,exynos4212-i2c-isp" for Exynos4212,
> +		  Exynos4412 and Exynos5250 SoCs;
> +- reg		: physical base address and length of the registers set;
> +- clocks	: must contain gate clock specifier for this controller;
> +- clock-names	: must contain "i2c_isp" entry.
> +
> +For the i2c-isp node, it is required to specify a pinctrl state named "default",
> +according to the pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt.
> +
> +Device tree nodes of the image sensors controlled directly by the FIMC-IS
> +firmware must be child nodes of their corresponding ISP I2C bus controller node.
> +The data link of these image sensors must be specified using the common video
> +interfaces bindings, defined in video-interfaces.txt.

Thanks,
Sylwester
