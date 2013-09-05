Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:46841 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab3IETpA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Sep 2013 15:45:00 -0400
Message-ID: <5228DF32.4000909@gmail.com>
Date: Thu, 05 Sep 2013 21:44:50 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: devicetree@vger.kernel.org
CC: Arun Kumar K <arun.kk@samsung.com>, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, swarren@wwwdotorg.org, mark.rutland@arm.com,
	Pawel.Moll@arm.com, galak@codeaurora.org, a.hajda@samsung.com,
	sachin.kamat@linaro.org, shaik.ameer@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: Re: [PATCH v7 01/13] [media] exynos5-is: Adding media device driver
 for exynos5
References: <1377066881-5423-1-git-send-email-arun.kk@samsung.com> <1377066881-5423-2-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1377066881-5423-2-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2013 08:34 AM, Arun Kumar K wrote:
> From: Shaik Ameer Basha<shaik.ameer@samsung.com>
>
> This patch adds support for media device for EXYNOS5 SoCs.
> The current media device supports the following ips to connect
> through the media controller framework.
>
> * MIPI-CSIS
>    Support interconnection(subdev interface) between devices
>
> * FIMC-LITE
>    Support capture interface from device(Sensor, MIPI-CSIS) to memory
>    Support interconnection(subdev interface) between devices
>
> * FIMC-IS
>    Camera post-processing IP having multiple sub-nodes.
>
> G-Scaler will be added later to the current media device.
>
> The media device creates two kinds of pipelines for connecting
> the above mentioned IPs.
> The pipeline0 is uses Sensor, MIPI-CSIS and FIMC-LITE which captures
> image data and dumps to memory.
> Pipeline1 uses FIMC-IS components for doing post-processing
> operations on the captured image and give scaled YUV output.
>
> Pipeline0
>    +--------+     +-----------+     +-----------+     +--------+
>    | Sensor | -->  | MIPI-CSIS | -->  | FIMC-LITE | -->  | Memory |
>    +--------+     +-----------+     +-----------+     +--------+
>
> Pipeline1
>   +--------+      +--------+     +-----------+     +-----------+
>   | Memory | -->   |  ISP   | -->  |    SCC    | -->  |    SCP    |
>   +--------+      +--------+     +-----------+     +-----------+
>
> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> ---
>   .../bindings/media/exynos5250-camera.txt           |  126 ++
>   drivers/media/platform/exynos5-is/exynos5-mdev.c   | 1210 ++++++++++++++++++++
>   drivers/media/platform/exynos5-is/exynos5-mdev.h   |  126 ++
>   3 files changed, 1462 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/media/exynos5250-camera.txt
>   create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.c
>   create mode 100644 drivers/media/platform/exynos5-is/exynos5-mdev.h
>
> diff --git a/Documentation/devicetree/bindings/media/exynos5250-camera.txt b/Documentation/devicetree/bindings/media/exynos5250-camera.txt
> new file mode 100644
> index 0000000..09420ba
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/exynos5250-camera.txt
> @@ -0,0 +1,126 @@
> +Samsung EXYNOS5 SoC Camera Subsystem
> +------------------------------------
> +
> +The Exynos5 SoC Camera subsystem comprises of multiple sub-devices
> +represented by separate device tree nodes. Currently this includes: FIMC-LITE,
> +MIPI CSIS and FIMC-IS.
> +
> +The sub-device nodes are referenced using phandles in the common 'camera' node
> +which also includes common properties of the whole subsystem not really
> +specific to any single sub-device, like common camera port pins or the common
> +camera bus clocks.
> +
> +Common 'camera' node
> +--------------------
> +
> +Required properties:
> +
> +- compatible		: must be "samsung,exynos5250-fimc"
> +- clocks		: list of clock specifiers, corresponding to entries in
> +                          the clock-names property
> +- clock-names		: must contain "sclk_bayer" entry
> +- samsung,csis		: list of phandles to the mipi-csis device nodes
> +- samsung,fimc-lite	: list of phandles to the fimc-lite device nodes
> +- samsung,fimc-is	: phandle to the fimc-is device node
> +
> +The pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt must be used
> +to define a required pinctrl state named "default".
> +
> +'parallel-ports' node
> +---------------------
> +
> +This node should contain child 'port' nodes specifying active parallel video
> +input ports. It includes camera A, camera B and RGB bay inputs.
> +'reg' property in the port nodes specifies the input type:
> + 1 - parallel camport A
> + 2 - parallel camport B
> + 5 - RGB camera bay
> +
> +3, 4 are for MIPI CSI-2 bus and are already described in samsung-mipi-csis.txt
> +
> +Image sensor nodes
> +------------------
> +
> +The sensor device nodes should be added to their control bus controller (e.g.
> +I2C0) nodes and linked to a port node in the csis or the parallel-ports node,
> +using the common video interfaces bindings, defined in video-interfaces.txt.
> +
> +Example:
> +
> +	aliases {
> +		fimc-lite0 =&fimc_lite_0
> +	};
> +
> +	/* Parallel bus IF sensor */
> +	i2c_0: i2c@13860000 {
> +		s5k6aa: sensor@3c {
> +			compatible = "samsung,s5k6aafx";
> +			reg =<0x3c>;
> +			vddio-supply =<...>;
> +
> +			clock-frequency =<24000000>;
> +			clocks =<...>;
> +			clock-names = "mclk";
> +
> +			port {
> +				s5k6aa_ep: endpoint {
> +					remote-endpoint =<&fimc0_ep>;
> +					bus-width =<8>;
> +					hsync-active =<0>;
> +					vsync-active =<1>;
> +					pclk-sample =<1>;
> +				};
> +			};
> +		};
> +	};
> +
> +	/* MIPI CSI-2 bus IF sensor */
> +	s5c73m3: sensor@1a {
> +		compatible = "samsung,s5c73m3";
> +		reg =<0x1a>;
> +		vddio-supply =<...>;
> +
> +		clock-frequency =<24000000>;
> +		clocks =<...>;
> +		clock-names = "mclk";
> +
> +		port {
> +			s5c73m3_1: endpoint {
> +				data-lanes =<1 2 3 4>;
> +				remote-endpoint =<&csis0_ep>;
> +			};
> +		};
> +	};
> +
> +	camera {
> +		compatible = "samsung,exynos5250-fimc";
> +		#address-cells =<1>;
> +		#size-cells =<1>;
> +		status = "okay";
> +
> +		pinctrl-names = "default";
> +		pinctrl-0 =<&cam_port_a_clk_active>;
> +
> +		samsung,csis =<&csis_0>,<&csis_1>;
> +		samsung,fimc-lite =<&fimc_lite_0>,<&fimc_lite_1>,<&fimc_lite_2>;
> +		samsung,fimc-is =<&fimc_is>;
> +
> +		/* parallel camera ports */
> +		parallel-ports {
> +			/* camera A input */
> +			port@1 {
> +				reg =<1>;
> +				camport_a_ep: endpoint {
> +					remote-endpoint =<&s5k6aa_ep>;
> +					bus-width =<8>;
> +					hsync-active =<0>;
> +					vsync-active =<1>;
> +					pclk-sample =<1>;
> +				};
> +			};
> +		};
> +	};
> +
> +MIPI-CSIS device binding is defined in samsung-mipi-csis.txt, FIMC-LITE
> +device binding is defined in exynos-fimc-lite.txt and FIMC-IS binding
> +is defined in exynos5-fimc-is.txt.

Does this binding look OK, can I have a DT maintainer Ack for that ?

--
Thanks,
Sylwester
