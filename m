Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:43742 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab3LOLq7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Dec 2013 06:46:59 -0500
Message-ID: <52AD96AE.4090205@gmail.com>
Date: Sun, 15 Dec 2013 12:46:54 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>, mark.rutland@arm.com
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, s.nawrocki@samsung.com,
	shaik.ameer@samsung.com, arunkk.samsung@gmail.com
Subject: Re: [PATCH v10 1/2] [media] exynos5-is: Adds DT binding documentation
References: <1386911563-26236-1-git-send-email-arun.kk@samsung.com> <1386911563-26236-2-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1386911563-26236-2-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/13/2013 06:12 AM, Arun Kumar K wrote:
> From: Shaik Ameer Basha<shaik.ameer@samsung.com>
>
> The patch adds the DT binding doc for exynos5 SoC camera
> subsystem.
>
> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> ---
>   .../bindings/media/exynos5250-camera.txt           |  136 ++++++++++++++++++++
>   1 file changed, 136 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/media/exynos5250-camera.txt
>
> diff --git a/Documentation/devicetree/bindings/media/exynos5250-camera.txt b/Documentation/devicetree/bindings/media/exynos5250-camera.txt
> new file mode 100644
> index 0000000..0c36bc4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/exynos5250-camera.txt
> @@ -0,0 +1,136 @@
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
> +- clocks		: list of phandles and clock specifiers, corresponding
> +			  to entries in the clock-names property
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
> +Required properties:
> +
> +For describing the input type in the child nodes, the following properties
> +have to be present in the parallel-ports node:
> +- #address-cells: Must be 1
> +- #size-cells: Must be 0
> +
> +Image sensor nodes
> +------------------
> +
> +The sensor device nodes should be added to their control bus controller (e.g.
> +I2C0) nodes and linked to a port node in the csis or the parallel-ports node,
> +using the common video interfaces bindings, defined in video-interfaces.txt.

Hi Mark,

Could you have a look again at this binding ? Perhaps we could
get your Ack now so it can be merged through the media tree ?

Thanks,
Sylwester

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
> +			#address-cells =<1>;
> +			#size-cells =<0>;
> +
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
