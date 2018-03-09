Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:39616 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751096AbeCIPnZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 10:43:25 -0500
Subject: Re: [PATCH v12 26/33] rcar-vin: change name of video device
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
References: <20180307220511.9826-1-niklas.soderlund+renesas@ragnatech.se>
 <20180307220511.9826-27-niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5f4b2cd2-2c7f-56f0-9f50-abdd07f9cc88@xs4all.nl>
Date: Fri, 9 Mar 2018 16:43:23 +0100
MIME-Version: 1.0
In-Reply-To: <20180307220511.9826-27-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/03/18 23:05, Niklas Söderlund wrote:
> The rcar-vin driver needs to be part of a media controller to support
> Gen3. Give each VIN instance a unique name so it can be referenced from
> userspace.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index ea0759a645e49490..7c10557d965ea6ed 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -993,7 +993,7 @@ int rvin_v4l2_register(struct rvin_dev *vin)
>  	/* video node */
>  	vdev->v4l2_dev = &vin->v4l2_dev;
>  	vdev->queue = &vin->queue;
> -	strlcpy(vdev->name, KBUILD_MODNAME, sizeof(vdev->name));
> +	snprintf(vdev->name, sizeof(vdev->name), "VIN%u output", vin->id);
>  	vdev->release = video_device_release_empty;
>  	vdev->lock = &vin->lock;
>  	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
> 
