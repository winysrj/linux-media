Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:55172 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934239AbdIYJqM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 05:46:12 -0400
Subject: Re: [PATCH v6 05/25] rcar-vin: change name of video device
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
 <20170822232640.26147-6-niklas.soderlund+renesas@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <201fba0d-5cea-e1a6-bc7b-b19850e92a1d@xs4all.nl>
Date: Mon, 25 Sep 2017 11:46:09 +0200
MIME-Version: 1.0
In-Reply-To: <20170822232640.26147-6-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23/08/17 01:26, Niklas Söderlund wrote:
> The rcar-vin driver needs to be part of a media controller to support
> Gen3. Give each VIN instance a unique name so it can be referenced from
> userspace.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index 3c4dd08261a0d3f5..ba88774bd5379a98 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -878,7 +878,8 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
>  	vdev->fops = &rvin_fops;
>  	vdev->v4l2_dev = &vin->v4l2_dev;
>  	vdev->queue = &vin->queue;
> -	strlcpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
> +	snprintf(vdev->name, sizeof(vdev->name), "%s %s", KBUILD_MODNAME,
> +		 dev_name(vin->dev));
>  	vdev->release = video_device_release_empty;
>  	vdev->ioctl_ops = &rvin_ioctl_ops;
>  	vdev->lock = &vin->lock;
> 
