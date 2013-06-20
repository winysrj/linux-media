Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:38309 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161077Ab3FTWpQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 18:45:16 -0400
Message-ID: <51C385F0.6000402@gmail.com>
Date: Fri, 21 Jun 2013 00:45:04 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com,
	arunkk.samsung@gmail.com,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [RFC v2 01/10] exynos5-fimc-is: Add Exynos5 FIMC-IS device tree
 bindings documentation
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com> <1370005408-10853-2-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1370005408-10853-2-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 05/31/2013 03:03 PM, Arun Kumar K wrote:

Please add at least one sentence here. All in all this patch
adds DT binding documentation for a fairly complex subsystem.

And please Cc devicetree-discuss@lists.ozlabs.org next time.

> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> ---
>   .../devicetree/bindings/media/exynos5-fimc-is.txt  |   41 ++++++++++++++++++++
>   1 file changed, 41 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
>
> diff --git a/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
> new file mode 100644
> index 0000000..9fd4646
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/exynos5-fimc-is.txt
> @@ -0,0 +1,41 @@
> +Samsung EXYNOS SoC Camera Subsystem

Shouldn't it be, e.g.:

Samsung EXYNOS5 SoC series Imaging Subsystem (FIMC-IS)

Or do you intend this file to be describing also the other sub-devices,
like GScaler ?

> +-----------------------------------
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
> +- interrupts        : fimc-is interrupt to the parent combiner
> +- clocks            : list of clock specifiers, corresponding to entries in
> +                      clock-names property;
> +- clock-names       : must contain "isp", "mcu_isp", "isp_div0", "isp_div1",
> +                      "isp_divmpwm", "mcu_isp_div0", "mcu_isp_div1" entries,
> +                      matching entries in the clocks property.
> +
> +
> +Board specific properties:
> +
> +- pinctrl-names    : pinctrl names for camera port pinmux control, at least
> +		     "default" needs to be specified.
> +- pinctrl-0...N	   : pinctrl properties corresponding to pinctrl-names

What pins exactly are supposed to be covered by these properties ? For what
devices ? Aren't the camera port pins supposed to be specified at the common
'camera' node ? I believe the camera ports are not specific to the FIMC-IS.

> +pmu subnode
> +-----------
> +
> +Required properties:
> + - reg : should contain PMU physical base address and size of the memory
> +         mapped registers.

What about other devices, like ISP I2C, SPI ? Don't you want to list at 
least
the ones currently used (I2C bus controllers) ?

Regards,
Sylwester
