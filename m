Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:40312 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030657AbeCANCe (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2018 08:02:34 -0500
Subject: Re: [PATCH] vimc: fix control event handling
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <5fa05ebf-0bb4-3fac-ed5e-a5283889c67c@xs4all.nl>
From: Helen Koike <helen.koike@collabora.com>
Message-ID: <29522655-b969-f204-9f0c-3caf8d35dd07@collabora.com>
Date: Thu, 1 Mar 2018 10:02:27 -0300
MIME-Version: 1.0
In-Reply-To: <5fa05ebf-0bb4-3fac-ed5e-a5283889c67c@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch

On 02/02/2018 11:00 AM, Hans Verkuil wrote:
> The sensor subdev didn't handle control events. Add support for this.
> Found with v4l2-compliance.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Helen Koike <helen.koike@collabora.com>

> ---
> diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
> index 9d63c84a9876..617415c224fe 100644
> --- a/drivers/media/platform/vimc/vimc-common.c
> +++ b/drivers/media/platform/vimc/vimc-common.c
> @@ -434,7 +434,9 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
>   	v4l2_set_subdevdata(sd, ved);
> 
>   	/* Expose this subdev to user space */
> -	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	if (sd->ctrl_handler)
> +		sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS;
> 
>   	/* Initialize the media entity */
>   	ret = media_entity_pads_init(&sd->entity, num_pads, ved->pads);
> diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
> index 457e211514c6..54184cd9e0ff 100644
> --- a/drivers/media/platform/vimc/vimc-sensor.c
> +++ b/drivers/media/platform/vimc/vimc-sensor.c
> @@ -23,6 +23,7 @@
>   #include <linux/v4l2-mediabus.h>
>   #include <linux/vmalloc.h>
>   #include <media/v4l2-ctrls.h>
> +#include <media/v4l2-event.h>
>   #include <media/v4l2-subdev.h>
>   #include <media/tpg/v4l2-tpg.h>
> 
> @@ -284,11 +285,18 @@ static int vimc_sen_s_stream(struct v4l2_subdev *sd, int enable)
>   	return 0;
>   }
> 
> +static struct v4l2_subdev_core_ops vimc_sen_core_ops = {
> +	.log_status = v4l2_ctrl_subdev_log_status,
> +	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
> +	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
> +};
> +
>   static const struct v4l2_subdev_video_ops vimc_sen_video_ops = {
>   	.s_stream = vimc_sen_s_stream,
>   };
> 
>   static const struct v4l2_subdev_ops vimc_sen_ops = {
> +	.core = &vimc_sen_core_ops,
>   	.pad = &vimc_sen_pad_ops,
>   	.video = &vimc_sen_video_ops,
>   };
> 
