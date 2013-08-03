Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36674 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3HCVmD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Aug 2013 17:42:03 -0400
Message-ID: <51FD7925.2010604@gmail.com>
Date: Sat, 03 Aug 2013 23:41:57 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, a.hajda@samsung.com, sachin.kamat@linaro.org,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com, Stephen Warren <swarren@wwwdotorg.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [RFC v3 02/13] [media] exynos5-fimc-is: Add Exynos5 FIMC-IS device
 tree bindings documentation
References: <1375455762-22071-1-git-send-email-arun.kk@samsung.com> <1375455762-22071-3-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1375455762-22071-3-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/02/2013 05:02 PM, Arun Kumar K wrote:
> The patch adds the DT binding documentation for Samsung
> Exynos5 SoC series imaging subsystem (FIMC-IS).
>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> ---
>   .../devicetree/bindings/media/exynos5-fimc-is.txt  |   52 ++++++++++++++++++++
>   1 file changed, 52 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>
> diff --git a/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
> new file mode 100644
> index 0000000..49a373a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
> @@ -0,0 +1,52 @@
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
> +- interrupt-parent  : Parent interrupt controller

s/Parent/parent ?

> +- interrupts        : fimc-is interrupt to the parent combiner
> +- clocks            : list of clock specifiers, corresponding to entries in
> +                      clock-names property;
> +- clock-names       : must contain "isp", "mcu_isp", "isp_div0", "isp_div1",
> +                      "isp_divmpwm", "mcu_isp_div0", "mcu_isp_div1" entries,
> +                      matching entries in the clocks property.
> +
> +pmu subnode
> +-----------
> +
> +Required properties:
> + - reg : should contain PMU physical base address and size of the memory
> +         mapped registers.
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
> +For the above nodes it is required to specify a pinctrl state named "default",
> +according to the pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt.
> +
> +Device tree nodes of the image sensors' controlled directly by the FIMC-IS
> +firmware must be child nodes of their corresponding ISP I2C bus controller node.
> +The data link of these image sensors must be specified using the common video
> +interfaces bindings, defined in video-interfaces.txt.

This one looks good to me. Feel free to add

  Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

I'm adding the Device Tree maintainers at Cc so we can possibly get 
their Ack.

--
Thanks,
Sylwester
