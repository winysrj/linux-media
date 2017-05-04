Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49254 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752721AbdEDPAe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 11:00:34 -0400
Date: Thu, 4 May 2017 18:00:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v4 20/27] rcar-vin: register a media pad if running in
 media controller mode
Message-ID: <20170504150031.GA7456@valkosipuli.retiisi.org.uk>
References: <20170427224203.14611-1-niklas.soderlund+renesas@ragnatech.se>
 <20170427224203.14611-21-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170427224203.14611-21-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 28, 2017 at 12:41:56AM +0200, Niklas Söderlund wrote:
> When running in media controller mode a media pad is needed, register
> one.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 9 +++++++++
>  drivers/media/platform/rcar-vin/rcar-vin.h  | 4 ++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 7aaa01dee014d64b..f560d27449b84882 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -267,7 +267,16 @@ static int rvin_group_init(struct rvin_dev *vin)
>  	if (ret)
>  		return ret;
>  
> +	vin->pad.flags = MEDIA_PAD_FL_SINK;
> +	ret = media_entity_pads_init(&vin->vdev->entity, 1, &vin->pad);
> +	if (ret)
> +		goto error_v4l2;
> +
>  	return 0;

This would benefit from an extra newline.

> +error_v4l2:
> +	rvin_v4l2_mc_remove(vin);
> +
> +	return ret;
>  }
>  
>  /* -----------------------------------------------------------------------------
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> index 6f2b1e28381678a9..06934313950253f4 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -103,6 +103,8 @@ struct rvin_info {
>   * @notifier:		V4L2 asynchronous subdevs notifier
>   * @digital:		entity in the DT for local digital subdevice
>   *
> + * @pad:		pad for media controller
> + *
>   * @lock:		protects @queue
>   * @queue:		vb2 buffers queue
>   *
> @@ -132,6 +134,8 @@ struct rvin_dev {
>  	struct v4l2_async_notifier notifier;
>  	struct rvin_graph_entity digital;
>  
> +	struct media_pad pad;
> +
>  	struct mutex lock;
>  	struct vb2_queue queue;
>  

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
