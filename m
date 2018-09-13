Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:10441 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727413AbeIMTcY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 15:32:24 -0400
Date: Thu, 13 Sep 2018 17:22:36 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        slongerbeam@gmail.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 3/3] media: renesas-ceu: Use default mbus settings
Message-ID: <20180913142236.4g2eo3exn7rjwlpk@kekkonen.localdomain>
References: <1536847191-17175-1-git-send-email-jacopo+renesas@jmondi.org>
 <1536847191-17175-4-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1536847191-17175-4-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Thu, Sep 13, 2018 at 03:59:51PM +0200, Jacopo Mondi wrote:
> As the v4l2-fwnode now allows drivers to set defaults, and eventually
> override them by specifying properties in DTS, use defaults for the CEU
> driver.
> 
> Also remove endpoint properties from the gr-peach-audiocamerashield as
> they match the defaults now specified in the driver code.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  arch/arm/boot/dts/gr-peach-audiocamerashield.dtsi |  4 ----
>  drivers/media/platform/renesas-ceu.c              | 20 +++++++++++---------
>  2 files changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/gr-peach-audiocamerashield.dtsi b/arch/arm/boot/dts/gr-peach-audiocamerashield.dtsi
> index e31a9e3..8d77579 100644
> --- a/arch/arm/boot/dts/gr-peach-audiocamerashield.dtsi
> +++ b/arch/arm/boot/dts/gr-peach-audiocamerashield.dtsi
> @@ -69,10 +69,6 @@
> 
>  	port {
>  		ceu_in: endpoint {
> -			hsync-active = <1>;
> -			vsync-active = <1>;
> -			bus-width = <8>;
> -			pclk-sample = <1>;

Do I understand correctly that pclk-sample was never relevant for the
hardware, and is removed because of that? You could mention that in the
commit message. That's perhaps a minor detail.

The set seems good to me.

>  			remote-endpoint = <&mt9v111_out>;
>  		};
>  	};
> diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
> index 035f1d3..150196f 100644
> --- a/drivers/media/platform/renesas-ceu.c
> +++ b/drivers/media/platform/renesas-ceu.c
> @@ -1551,7 +1551,16 @@ static int ceu_parse_dt(struct ceu_device *ceudev)
>  		return ret;
> 
>  	for (i = 0; i < num_ep; i++) {
> -		struct v4l2_fwnode_endpoint fw_ep = { .bus_type = 0 };
> +		struct v4l2_fwnode_endpoint fw_ep = {
> +			.bus_type = V4L2_MBUS_PARALLEL,
> +			.bus = {
> +				.parallel = {
> +					.flags = V4L2_MBUS_HSYNC_ACTIVE_HIGH |
> +						 V4L2_MBUS_VSYNC_ACTIVE_HIGH,
> +					.bus_width = 8,
> +				},
> +			},
> +		};
> 
>  		ep = of_graph_get_endpoint_by_regs(of, 0, i);
>  		if (!ep) {
> @@ -1564,14 +1573,7 @@ static int ceu_parse_dt(struct ceu_device *ceudev)
>  		ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &fw_ep);
>  		if (ret) {
>  			dev_err(ceudev->dev,
> -				"Unable to parse endpoint #%u.\n", i);
> -			goto error_cleanup;
> -		}
> -
> -		if (fw_ep.bus_type != V4L2_MBUS_PARALLEL) {
> -			dev_err(ceudev->dev,
> -				"Only parallel input supported.\n");
> -			ret = -EINVAL;
> +				"Unable to parse endpoint #%u: %d.\n", i, ret);
>  			goto error_cleanup;
>  		}
> 

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
