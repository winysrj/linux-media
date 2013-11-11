Return-path: <linux-media-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44289 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753173Ab3KKQMW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Nov 2013 11:12:22 -0500
Date: Mon, 11 Nov 2013 16:12:13 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Arun Kumar K <arun.kk@samsung.com>
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
	"kilyeon.im@samsung.com" <kilyeon.im@samsung.com>,
	"arunkk.samsung@gmail.com" <arunkk.samsung@gmail.com>
Subject: Re: [PATCH v9 01/13] [media] exynos5-is: Adding media device
 driver for exynos5
Message-ID: <20131111161213.GK21201@e106331-lin.cambridge.arm.com>
References: <1380279558-21651-1-git-send-email-arun.kk@samsung.com>
 <1380279558-21651-2-git-send-email-arun.kk@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380279558-21651-2-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 27, 2013 at 11:59:06AM +0100, Arun Kumar K wrote:
> From: Shaik Ameer Basha <shaik.ameer@samsung.com>
> 
> This patch adds support for media device for EXYNOS5 SoCs.
> The current media device supports the following ips to connect
> through the media controller framework.
 
[...]

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
> +- compatible           : must be "samsung,exynos5250-fimc"
> +- clocks               : list of clock specifiers, corresponding to entries in
> +                          the clock-names property

Minor nit: clocks are references by phandle + clock-specifier pairs, as
the clock-specifier is separate from the phandle to the clock. 

> +- clock-names          : must contain "sclk_bayer" entry
> +- samsung,csis         : list of phandles to the mipi-csis device nodes
> +- samsung,fimc-lite    : list of phandles to the fimc-lite device nodes
> +- samsung,fimc-is      : phandle to the fimc-is device node
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

I believe the parallel ports node must have #address-cells and
#size-cells defined for the child nodes' reg properties to be
meaningful. Judging by the examples and code, it seems you expect
#address-cells = <1> and #size-cells = <0>. It would be nice to have
that described.

Cheers,
Mark.
