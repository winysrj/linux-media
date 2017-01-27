Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58352 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754513AbdA0Jc2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jan 2017 04:32:28 -0500
Date: Fri, 27 Jan 2017 11:31:09 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] v4l: of: check for unique lanes in data-lanes and
 clock-lanes
Message-ID: <20170127093108.GI7139@valkosipuli.retiisi.org.uk>
References: <20170126131259.5621-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170126131259.5621-1-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On Thu, Jan 26, 2017 at 02:12:59PM +0100, Niklas Söderlund wrote:
> All lines in data-lanes and clock-lanes properties must be unique.
> Instead of drivers checking for this add it to the generic parser.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/v4l2-core/v4l2-of.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
> index 93b33681776c..1042db6bb996 100644
> --- a/drivers/media/v4l2-core/v4l2-of.c
> +++ b/drivers/media/v4l2-core/v4l2-of.c
> @@ -32,12 +32,19 @@ static int v4l2_of_parse_csi_bus(const struct device_node *node,
>  	prop = of_find_property(node, "data-lanes", NULL);
>  	if (prop) {
>  		const __be32 *lane = NULL;
> -		unsigned int i;
> +		unsigned int i, n;
>  
>  		for (i = 0; i < ARRAY_SIZE(bus->data_lanes); i++) {
>  			lane = of_prop_next_u32(prop, lane, &v);
>  			if (!lane)
>  				break;
> +			for (n = 0; n < i; n++) {
> +				if (bus->data_lanes[n] == v) {
> +					pr_warn("%s: duplicated lane %u in data-lanes\n",
> +						node->full_name, v);
> +					return -EINVAL;
> +				}
> +			}

In some cases it's just the number of lanes that matter, not their order, as
the hardware cannot reorder them. I might still just print a warning but not
return an error. Same below.

Although then hardware that actually can reorder the lanes might have issues
if such a bug exists in DTB. Presumably the DTB would have been tested at
some point though.

>  			bus->data_lanes[i] = v;
>  		}
>  		bus->num_data_lanes = i;
> @@ -63,6 +70,15 @@ static int v4l2_of_parse_csi_bus(const struct device_node *node,
>  	}
>  
>  	if (!of_property_read_u32(node, "clock-lanes", &v)) {
> +		unsigned int n;
> +
> +		for (n = 0; n < bus->num_data_lanes; n++) {
> +			if (bus->data_lanes[n] == v) {
> +				pr_warn("%s: duplicated lane %u in clock-lanes\n",
> +					node->full_name, v);
> +				return -EINVAL;
> +			}
> +		}
>  		bus->clock_lane = v;
>  		have_clk_lane = true;
>  	}

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
