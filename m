Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37100 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755589AbdD1J2T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 05:28:19 -0400
Subject: Re: [PATCH v4 07/27] rcar-vin: change name of video device
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <20170427224203.14611-1-niklas.soderlund+renesas@ragnatech.se>
 <20170427224203.14611-8-niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <f030af6f-5244-ccef-4ac6-9805ab8c015d@ideasonboard.com>
Date: Fri, 28 Apr 2017 10:28:15 +0100
MIME-Version: 1.0
In-Reply-To: <20170427224203.14611-8-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27/04/17 23:41, Niklas Söderlund wrote:
> The rcar-vin driver needs to be part of a media controller to support
> Gen3. Give each VIN instance a unique name so it can be referenced from
> userspace.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Functional and tested.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index 1b364f359ff4b5ed..709ee828f2ac2173 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -915,7 +915,8 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
>  	vdev->fops = &rvin_fops;
>  	vdev->v4l2_dev = &vin->v4l2_dev;
>  	vdev->queue = &vin->queue;
> -	strlcpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
> +	snprintf(vdev->name, sizeof(vdev->name), "%s %s", KBUILD_MODNAME,
> +		 dev_name(vin->dev));
>  	vdev->release = video_device_release;
>  	vdev->ioctl_ops = &rvin_ioctl_ops;
>  	vdev->lock = &vin->lock;
> 
