Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54001 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692AbaCKQTA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 12:19:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	robh+dt@kernel.org, mark.rutland@arm.com, galak@codeaurora.org,
	kyungmin.park@samsung.com
Subject: Re: [PATCH v7 3/10] Documentation: devicetree: Update Samsung FIMC DT binding
Date: Tue, 11 Mar 2014 17:20:35 +0100
Message-ID: <1823087.0J3KNi6X3C@avalon>
In-Reply-To: <1394553635-12134-1-git-send-email-s.nawrocki@samsung.com>
References: <24917002.Y0kBkkQHhZ@avalon> <1394553635-12134-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thank you for the patch.

On Tuesday 11 March 2014 17:00:35 Sylwester Nawrocki wrote:
> This patch documents following updates of the Exynos4 SoC camera subsystem
> devicetree binding:
> 
>  - addition of #clock-cells and clock-output-names properties to 'camera'
>    node - these are now needed so the image sensor sub-devices can reference
> clocks provided by the camera host interface,
>  - dropped a note about required clock-frequency properties at the
>    image sensor nodes; the sensor devices can now control their clock
>    explicitly through the clk API and there is no need to require this
>    property in the camera host interface binding.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
> Resending only single patch which changed.
> 
> Changes since v6:
>  - #clock-cells, clock-output-names documented as mandatory properties;
>  - renamed "cam_mclk_{a,b}" to "cam_{a,b}_clkout in the example dts,
>    this now matches changes in exynos4.dtsi further in the patch series;
>  - marked "samsung,camclk-out" property as deprecated.
> 
> Changes since v5:
>  - none.
> 
> Changes since v4:
>  - dropped a requirement of specific order of values in clocks/
>    clock-names properties (Mark) and reference to clock-names in
>    clock-output-names property description (Mark).
> ---
>  .../devicetree/bindings/media/samsung-fimc.txt     |   46
> +++++++++++++------- 1 file changed, 31 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt
> b/Documentation/devicetree/bindings/media/samsung-fimc.txt index
> 96312f6..1908a5f 100644
> --- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
> +++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt

[snip]

>  Image sensor nodes
>  ------------------
> @@ -97,8 +108,8 @@ Image sensor nodes
>  The sensor device nodes should be added to their control bus controller
> (e.g. I2C0) nodes and linked to a port node in the csis or the
> parallel-ports node, using the common video interfaces bindings, defined in
> video-interfaces.txt.
> -The implementation of this bindings requires clock-frequency property to be
> -present in the sensor device nodes.
> +An optional clock-frequency property needs to be present in the sensor
> device
> +nodes. Default value when this property is not present is 24 MHz.

I think you forgot to drop that sentence.

-- 
Regards,

Laurent Pinchart

