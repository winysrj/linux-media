Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:46971 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab3CWNOs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Mar 2013 09:14:48 -0400
Message-ID: <514DAAC3.4050202@gmail.com>
Date: Sat, 23 Mar 2013 14:14:43 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org, s.nawrocki@samsung.com,
	kgene.kim@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: Re: [RFC 01/12] exynos-fimc-is: Adding device tree nodes
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com> <1362754765-2651-2-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1362754765-2651-2-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/08/2013 03:59 PM, Arun Kumar K wrote:
> Add the fimc-is node and the required pinctrl nodes for
> fimc-is driver for Exynos5. Also adds the DT binding documentation
> for the new fimc-is node.
>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> Signed-off-by: Kilyeon Im<kilyeon.im@samsung.com>
> ---
>   .../devicetree/bindings/media/soc/exynos5-is.txt   |   81 ++++++++++++++++++++
>   arch/arm/boot/dts/exynos5250-pinctrl.dtsi          |   60 +++++++++++++++
>   arch/arm/boot/dts/exynos5250-smdk5250.dts          |   54 ++++++++++++-
>   arch/arm/boot/dts/exynos5250.dtsi                  |    8 ++
>   4 files changed, 201 insertions(+), 2 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/media/soc/exynos5-is.txt
>   mode change 100644 =>  100755 arch/arm/boot/dts/exynos5250-smdk5250.dts
>   mode change 100644 =>  100755 arch/arm/boot/dts/exynos5250.dtsi

I suspect this mode change wasn't intentional.

> diff --git a/Documentation/devicetree/bindings/media/soc/exynos5-is.txt b/Documentation/devicetree/bindings/media/soc/exynos5-is.txt
> new file mode 100644
> index 0000000..e0fdf02
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/soc/exynos5-is.txt
> @@ -0,0 +1,81 @@
> +Samsung EXYNOS SoC Camera Subsystem
> +-----------------------------------
> +
> +The camera subsystem on Samsung Exynos5 SoC has some changes relative
> +to previous SoC versions. Exynos5 has almost similar MIPI-CSIS and
> +FIMC-LITE IPs but removed the FIMC-CAPTURE. Instead it has an improved

s/FIMC-CAPTURE/FIMC IPs (IP blocks) ?

> +FIMC-IS which can provide imate data DMA output.

s/imate/image

Not sure if this is true. FIMC (camera host interface and video 
post-processor)
IPs have been removed, but I think they were replaced with GSCALER. 
There is
FIMC-IS on both Exynos4 and Exynos5 series.

> +
> +The device tree binding remain similar to the Exynos4 bindings which can
> +be seen at samsung-fimc.txt with the addition of fimc-is sub-node which will
> +be explained here.
> +
> +fimc-is subnode of camera node
> +------------------------------
> +
> +Required properties:
> +
> +- compatible		: must be "samsung,exynos5250-fimc-is"
> +- reg			: physical base address and size of the memory mapped
> +			  registers
> +- interrupt-parent	: Parent interrupt controller
> +- interrupts		: fimc-is interrupt to the parent combiner
> +
> +Board specific properties:
> +
> +- pinctrl-names    : pinctrl names for camera port pinmux control, at least
> +		     "default" needs to be specified.
> +- pinctrl-0...N	   : pinctrl properties corresponding to pinctrl-names
> +
> +Sensor sub-nodes:
> +
> +FIMC-IS IP supports custom built sensors to be controlled exclusively by
> +the FIMC-IS firmware. These sensor properties are to be defined here.

What this means is that the software architecture defines how we describe
the hardware. I have serious doubts about this approach. I do recall this
concept was used in an early version of code I shared with you. But then
I decided to describe the I2C bus controllers (other bus controllers could
be probably added later when required) in usual way, as fimc-is node child
nodes or standalone, at root level.

The reason is that all these peripheral bus controllers are accessible in
same way by the FIMC-IS and the host CPU. Their interrupts are routed to
both, and registers regions are visible to both CPUs as well. AFAIK ISP I2C
bus controllers are directly compatible with s3c2440, so on some systems
that do not use the IS these I2C controllers should in theory work without
problems with current i2c-s3c2410 I2C bus driver.

Defining image sensor nodes in a standard way as ISP I2C bus controller
nodes has an disadvantage that we need dummy I2C bus controller driver,
at least this is how I have written the driver for Exynos4x12. In some
version of it I had sensor nodes put in a isp-i2c fimc-is sub-node, but
then there was an issue that this was not a fully specified I2C bus
controller node.

You can refer to my exynos4 fimc-is patch series for details on how this
is now implemented.

Handling the image sensor in a standard way, as regular I2C client devices
has an advantage that we can put pinctrl properties in relevant device 
nodes,
where available, which more closely describes the hardware structure.

I'm not really sure in 100% if all this complication is required. It would
allow to use same DT blob for different Imaging Subsystem SW architecture.
For example some parts of functionality handled currently by FIMC-IS (ARM
Cortex-A5) could be moved to host CPU, without any change in the device
tree structure. The kernel could decide e.g. if it uses image sensor driver
implemented in the ISP firmware, or a driver run on the host CPU.

What do you think ?

Thanks,
Sylwester
