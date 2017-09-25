Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:40324 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932107AbdIYK03 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 06:26:29 -0400
Subject: Re: [PATCH v6 20/25] rcar-vin: add chsel information to rvin_info
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
 <20170822232640.26147-21-niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5892e834-e154-74d6-bdb2-1e6f2b083418@xs4all.nl>
Date: Mon, 25 Sep 2017 12:26:26 +0200
MIME-Version: 1.0
In-Reply-To: <20170822232640.26147-21-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/08/17 01:26, Niklas Söderlund wrote:
> Each Gen3 SoC has a limited set of predefined routing possibilities for
> which CSI-2 device and virtual channel can be routed to which VIN
> instance. Prepare to store this information in the struct rvin_info.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

I think I know what you are doing here, but the comments for struct
rvin_group_chsel need more work, they are confusing.

> ---
>  drivers/media/platform/rcar-vin/rcar-vin.h | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> index 88683aaee3b6acd5..617f254b52fe106d 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -35,6 +35,9 @@
>  /* Max number on VIN instances that can be in a system */
>  #define RCAR_VIN_NUM 8
>  
> +/* Max number of CHSEL values for any Gen3 SoC */
> +#define RCAR_CHSEL_MAX 6
> +
>  enum chip_id {
>  	RCAR_H1,
>  	RCAR_M1,
> @@ -91,6 +94,19 @@ struct rvin_graph_entity {
>  
>  struct rvin_group;
>  
> +
> +/** struct rvin_group_chsel - Map a CSI2 device and channel for a CHSEL value
> + * @csi:		VIN internal number for CSI2 device
> + * @chan:		CSI-2 channel number on remote. Note that channel

remote? I don't know what you mean here.

> + *			is not the same as VC. The CSI-2 hardware have 4

have -> has

> + *			channels it can output on but which VC is outputted

output to what?

> + *			on which channel is configurable inside the CSI-2.
> + */
> +struct rvin_group_chsel {
> +	enum rvin_csi_id csi;
> +	unsigned int chan;
> +};
> +
>  /**
>   * struct rvin_info - Information about the particular VIN implementation
>   * @chip:		type of VIN chip
> @@ -98,6 +114,9 @@ struct rvin_group;
>   *
>   * max_width:		max input width the VIN supports
>   * max_height:		max input height the VIN supports
> + *
> + * num_chsels:		number of possible chsel values for this VIN
> + * chsels:		routing table VIN <-> CSI-2 for the chsel values
>   */
>  struct rvin_info {
>  	enum chip_id chip;
> @@ -105,6 +124,9 @@ struct rvin_info {
>  
>  	unsigned int max_width;
>  	unsigned int max_height;
> +
> +	unsigned int num_chsels;
> +	struct rvin_group_chsel chsels[RCAR_VIN_NUM][RCAR_CHSEL_MAX];
>  };
>  
>  /**
> 

Regards,

	Hans
