Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:34166 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3IPVxw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Sep 2013 17:53:52 -0400
Message-ID: <52377DE5.3070808@gmail.com>
Date: Mon, 16 Sep 2013 23:53:41 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, s.nawrocki@samsung.com,
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

Hi,

On 08/21/2013 08:34 AM, Arun Kumar K wrote:
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
> +- clock-names	: must contain "sclk_bayer" entry
> +- samsung,csis	: list of phandles to the mipi-csis device nodes
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
[...]
> +	/* MIPI CSI-2 bus IF sensor */
> +	s5c73m3: sensor@1a {
		...
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

I'd like to propose a little re-design of this binding. The reason is that
I've noticed issues related to the power domain and FIMC-LITE, FIMC-IS 
clocks
handling sequences. This lead to a failure to disable the ISP power domain
and to complete the system suspend/resume cycle. Not sure if this happens on
Exynos5 SoCs, nevertheless IMHO it would be more reasonable to make 
FIMC-LITE
device nodes child nodes of FIMC-IS. FIMC-LITE seems to be an integral part
of the FIMC-IS subsystem.

Then fimc-is node would be placed at root level, with fimc-lite nodes as its
subnodes:

fimc-is {
	compatible = "exynos5250-fimc-is";
	reg = <...>;
	...
	#address-cells = <1>;
	#size-cells = <1>;
	ranges;
	
	fimc_lite_0: fimc-lite@12390000 {
		compatible = "samsung,exynos4212-fimc-lite";
		...
	};

	fimc_lite_1: fimc-lite@123A0000 {
		compatible = "samsung,exynos4212-fimc-lite";
		...
	};

	fimc_lite_2: fimc-lite@123B0000 {
		compatible = "samsung,exynos4212-fimc-lite";
		...
	};

	i2c0_isp: i2c-isp@12130000 {
		...
	};

	...
};

Once FIMC-IS driver has probed it would call of_platform_populate() and
would instantiate all FIMC-IS subsystem sub-devices, including FIMC-LITEs.

I think it's more correct from the hardware structure point of view and it
would allow us to have the required control on the initialization and power/
clock sequences. Especially that you might not be able to control the order
of registration of the exynos5250-fimc-is and fimc-is-i2c drivers, once the
I2C bus controller is outside of the exynos5-fimc-is module.

Besides, I would propose to make mipi-csis nodes subnodes of the camera
node. Then the top level camera driver would call of_platform_populate()
to instantiate MIPI-CSIS devices. That feels better than using samsung,csis
property pointing to mipi-csis nodes.

Sorry about somewhat going in circles with that, hopefully this is the
last change before this driver can be queued upstream.

--
Thanks,
Sylwester
