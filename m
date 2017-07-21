Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:34414 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754052AbdGUKP2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 06:15:28 -0400
Received: by mail-lf0-f48.google.com with SMTP id g25so17815291lfh.1
        for <linux-media@vger.kernel.org>; Fri, 21 Jul 2017 03:15:27 -0700 (PDT)
Date: Fri, 21 Jul 2017 12:15:25 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, kieran.bingham@ideasonboard.com
Subject: Re: [PATCH] v4l: rcar-vin: Simplify rvin_group_notify_{bound,unbind}
Message-ID: <20170721101525.GD20077@bigcity.dyn.berto.se>
References: <1500630950-29870-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1500630950-29870-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thanks for your patch.

On 2017-07-21 10:55:50 +0100, Kieran Bingham wrote:
> Use a container_of macro to obtain the graph entity object from the ASD
> This removes the error conditions, and reduces the lock contention.
> 
> (The locking may even be potentially removed)
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
> 
> Hi Niklas,
> 
> While working through the Multi camera setup, we came across this improvement.

Nice :-)

> 
> If this code isn't yet upstream, feel free to squash this change into your
> existing branch if you wish.

Patch is not yet upstream and I'm pending to post the next version of 
the series so will squash this in, thanks for allowing me to do so!

> 
> Regards
> 
> Kieran
> 
>  drivers/media/platform/rcar-vin/rcar-core.c | 28 ++++++----------------------
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  3 +++
>  2 files changed, 9 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 8393a1598660..b4fc7b56c8a1 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -688,20 +688,11 @@ static void rvin_group_notify_unbind(struct v4l2_async_notifier *notifier,
>  				     struct v4l2_async_subdev *asd)
>  {
>  	struct rvin_dev *vin = notifier_to_vin(notifier);
> -	unsigned int i;
> +	struct rvin_graph_entity *csi = to_rvin_graph_entity(asd);
>  
>  	mutex_lock(&vin->group->lock);
> -	for (i = 0; i < RVIN_CSI_MAX; i++) {
> -		if (&vin->group->csi[i].asd == asd) {
> -			vin_dbg(vin, "Unbind CSI-2 %s\n", subdev->name);
> -			vin->group->csi[i].subdev = NULL;
> -			mutex_unlock(&vin->group->lock);
> -			return;
> -		}
> -	}
> +	csi->subdev = NULL;
>  	mutex_unlock(&vin->group->lock);
> -
> -	vin_err(vin, "No entity for subdev %s to unbind\n", subdev->name);
>  }
>  
>  static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
> @@ -709,23 +700,16 @@ static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
>  				   struct v4l2_async_subdev *asd)
>  {
>  	struct rvin_dev *vin = notifier_to_vin(notifier);
> -	unsigned int i;
> +	struct rvin_graph_entity *csi = to_rvin_graph_entity(asd);
>  
>  	v4l2_set_subdev_hostdata(subdev, vin);
>  
>  	mutex_lock(&vin->group->lock);
> -	for (i = 0; i < RVIN_CSI_MAX; i++) {
> -		if (&vin->group->csi[i].asd == asd) {
> -			vin_dbg(vin, "Bound CSI-2 %s\n", subdev->name);
> -			vin->group->csi[i].subdev = subdev;
> -			mutex_unlock(&vin->group->lock);
> -			return 0;
> -		}
> -	}
> +	vin_dbg(vin, "Bound CSI-2 %s\n", subdev->name);
> +	csi->subdev = subdev;
>  	mutex_unlock(&vin->group->lock);
>  
> -	vin_err(vin, "No entity for subdev %s to bind\n", subdev->name);
> -	return -EINVAL;
> +	return 0;
>  }
>  
>  static struct device_node *rvin_group_get_csi(struct rvin_dev *vin,
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> index e7e600fdf566..900c473c3d15 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -92,6 +92,9 @@ struct rvin_graph_entity {
>  	unsigned int sink_pad;
>  };
>  
> +#define to_rvin_graph_entity(asd) \
> +	container_of(asd, struct rvin_graph_entity, asd)
> +
>  struct rvin_group;
>  
>  
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
