Return-path: <linux-media-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42304 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932188AbaBUPu4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Feb 2014 10:50:56 -0500
Date: Fri, 21 Feb 2014 15:50:23 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"galak@codeaurora.org" <galak@codeaurora.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"kgene.kim@samsung.com" <kgene.kim@samsung.com>,
	"a.hajda@samsung.com" <a.hajda@samsung.com>
Subject: Re: [PATCH v4 03/10] Documentation: devicetree: Update Samsung
 FIMC DT binding
Message-ID: <20140221155023.GF20449@e106331-lin.cambridge.arm.com>
References: <1392925237-31394-1-git-send-email-s.nawrocki@samsung.com>
 <1392925237-31394-5-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392925237-31394-5-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 20, 2014 at 07:40:30PM +0000, Sylwester Nawrocki wrote:
> This patch documents following updates of the Exynos4 SoC camera subsystem
> devicetree binding:
>  - addition of #clock-cells property to 'camera' node - the #clock-cells
>    property is needed when the sensor sub-devices use clock provided by
>    the camera host interface;
>  - addition of an optional clock-output-names property;
>  - change of the clock-frequency at image sensor node from mandatory to
>    an optional property - there should be no need to require this property
>    by the camera host device binding, a default frequency value can ofen
>    be used;
>  - addition of a requirement of specific order of values in clocks/
>    clock-names properties, so the first two entry in the clock-names
>    property can be used as parent clock names for the camera master
>    clock provider.  It happens all in-kernel dts files list the clock
>    in such order, thus there should be no regression as far as in-kernel
>    dts files are concerned.

I'm not sure I follow the reasoning here. Why does this matter? Why can
child nodes not get these by name if they have to?

> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../devicetree/bindings/media/samsung-fimc.txt     |   36 +++++++++++++++-----
>  1 file changed, 28 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
> index 96312f6..1a5820d 100644
> --- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
> +++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
> @@ -20,6 +20,7 @@ Required properties:
>  		  the clock-names property;
>  - clock-names	: must contain "sclk_cam0", "sclk_cam1", "pxl_async0",
>  		  "pxl_async1" entries, matching entries in the clocks property.
> +		  First two entries must be "sclk_cam0", "sclk_cam1".

I don't think this is a good idea.

>  
>  The pinctrl bindings defined in ../pinctrl/pinctrl-bindings.txt must be used
>  to define a required pinctrl state named "default" and optional pinctrl states:
> @@ -32,6 +33,22 @@ way around.
>  
>  The 'camera' node must include at least one 'fimc' child node.
>  
> +Optional properties (*:

Is that a smiley face?

> +
> +- #clock-cells: from the common clock bindings (../clock/clock-bindings.txt),
> +  must be 1. A clock provider is associated with the 'camera' node and it should
> +  be referenced by external sensors that use clocks provided by the SoC on
> +  CAM_*_CLKOUT pins. The clock specifier cell stores an index of a clock.
> +  The indices are 0, 1 for CAM_A_CLKOUT, CAM_B_CLKOUT clocks respectively.
> +
> +- clock-output-names: from the common clock bindings, should contain names of
> +  clocks registered by the camera subsystem corresponding to CAM_A_CLKOUT,
> +  CAM_B_CLKOUT output clocks, in this order. Parent clock of these clocks are
> +  specified be first two entries of the clock-names property.

Do you need this?

That's not how clock-names is supposed to work. The clock-names property
is for the names of the _input_ clock lines on the device, not the
output names on whichever parent clock they came from.

Any clock-names property description should define absolutely the set of
names. As this does not, NAK.

> +
> +(* #clock-cells and clock-output-names are mandatory properties if external
> +image sensor devices reference 'camera' device node as a clock provider.

s/(*/Note:/

> +
>  'fimc' device nodes
>  -------------------
>  
> @@ -97,8 +114,8 @@ Image sensor nodes
>  The sensor device nodes should be added to their control bus controller (e.g.
>  I2C0) nodes and linked to a port node in the csis or the parallel-ports node,
>  using the common video interfaces bindings, defined in video-interfaces.txt.
> -The implementation of this bindings requires clock-frequency property to be
> -present in the sensor device nodes.
> +An optional clock-frequency property needs to be present in the sensor device
> +nodes. Default value when this property is not present is 24 MHz.

s/needs to/should/ ?

What is this the frequency of?

Thanks,
Mark.
