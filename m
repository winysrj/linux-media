Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35626 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbbETVV2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 17:21:28 -0400
Received: by wicmx19 with SMTP id mx19so169146071wic.0
        for <linux-media@vger.kernel.org>; Wed, 20 May 2015 14:21:27 -0700 (PDT)
Message-ID: <555CECEE.90100@cogentembedded.com>
Date: Wed, 20 May 2015 23:22:06 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
CC: g.liakhovetski@gmx.de, hverkuil@xs4all.nl,
	rob.taylor@codethink.co.uk
Subject: Re: [PATCH 08/20] media: soc_camera pad-aware driver initialisation
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk> <1432139980-12619-9-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-9-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 05/20/2015 07:39 PM, William Towle wrote:

> Add detection of source pad number for drivers aware of the media
> controller API, so that soc_camera/rcar_vin can create device nodes
> to support a driver such as adv7604.c (for HDMI on Lager) underneath.

> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
> ---
>   drivers/media/platform/soc_camera/rcar_vin.c   |    4 ++++
>   drivers/media/platform/soc_camera/soc_camera.c |   27 +++++++++++++++++++++++-
>   include/media/soc_camera.h                     |    1 +
>   3 files changed, 31 insertions(+), 1 deletion(-)

> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 0f67646..b4e9b43 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
[...]
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index d708df4..126d645 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
[...]
> @@ -1311,7 +1312,25 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
>   	}
>
>   	/* At this point client .probe() should have run already */
> -	ret = soc_camera_init_user_formats(icd);
> +	ret = media_entity_init(&icd->vdev->entity, 1, &icd->pad, 0);
> +	if (!ret) {
> +		for (src_pad_idx = 0; src_pad_idx < sd->entity.num_pads;
> +				src_pad_idx++)
> +			if (sd->entity.pads[src_pad_idx].flags
> +						== MEDIA_PAD_FL_SOURCE)
> +				break;
> +
> +		if (src_pad_idx < sd->entity.num_pads) {
> +			if (!media_entity_create_link(
> +				&icd->vdev->entity, 0,
> +				&sd->entity, src_pad_idx,
> +				MEDIA_LNK_FL_IMMUTABLE |
> +				MEDIA_LNK_FL_ENABLED)) {

    Please either start the continuation lines under ! on the first line or 
indent them more to the right, so that's easier on the eyes.

> +				ret = soc_camera_init_user_formats(icd);
> +			}
> +		}
> +	}
> +
>   	if (ret < 0)
>   		goto eusrfmt;
>
> @@ -1322,6 +1341,7 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
>   		goto evidstart;
>
>   	/* Try to improve our guess of a reasonable window format */
> +	fmt.pad = src_pad_idx;
>   	if (!v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt)) {
>   		icd->user_width		= mf->width;
>   		icd->user_height	= mf->height;
> @@ -1335,6 +1355,7 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
>   evidstart:
>   	soc_camera_free_user_formats(icd);
>   eusrfmt:
> +	media_entity_cleanup(&icd->vdev->entity);
>   	soc_camera_remove_device(icd);
>
>   	return ret;
> @@ -1856,6 +1877,10 @@ static int soc_camera_remove(struct soc_camera_device *icd)
>   	if (icd->num_user_formats)
>   		soc_camera_free_user_formats(icd);
>
> +	if (icd->vdev->entity.num_pads) {
> +		media_entity_cleanup(&icd->vdev->entity);
> +	}
> +

    Brackets not needed here, and checkpatch.pl should have complained about that.

WBR, Sergei

