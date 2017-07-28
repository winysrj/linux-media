Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:37893 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751631AbdG1L2i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 07:28:38 -0400
Subject: Re: [PATCH] v4l: rcar-vin: Simplify rvin_group_notify_{bound,unbind}
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        niklas.soderlund@ragnatech.se
Cc: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, kieran.bingham@ideasonboard.com
References: <1500630950-29870-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bc3e6468-867c-6372-f488-5e37e77215e2@xs4all.nl>
Date: Fri, 28 Jul 2017 13:28:32 +0200
MIME-Version: 1.0
In-Reply-To: <1500630950-29870-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/21/2017 11:55 AM, Kieran Bingham wrote:
> Use a container_of macro to obtain the graph entity object from the ASD
> This removes the error conditions, and reduces the lock contention.
> 
> (The locking may even be potentially removed)

I've set the status in patchwork to 'Not Applicable' since the patch isn't
against the mainline code. I leave it to Niklas to decide what to do with this.

Regards,

	Hans

> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
> 
> Hi Niklas,
> 
> While working through the Multi camera setup, we came across this improvement.
> 
> If this code isn't yet upstream, feel free to squash this change into your
> existing branch if you wish.
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
> 
