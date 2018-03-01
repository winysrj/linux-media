Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:40414 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030517AbeCANKp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2018 08:10:45 -0500
Subject: Re: [PATCH] vimc: use correct subdev functions
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <202e6c79-de41-f429-e6a4-79790aa9e34d@xs4all.nl>
From: Helen Koike <helen.koike@collabora.com>
Message-ID: <bee0fa7a-1b13-f7c9-7177-22c5976786aa@collabora.com>
Date: Thu, 1 Mar 2018 10:10:36 -0300
MIME-Version: 1.0
In-Reply-To: <202e6c79-de41-f429-e6a4-79790aa9e34d@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 02/07/2018 03:06 PM, Hans Verkuil wrote:
> Instead of calling everything a MEDIA_ENT_F_ATV_DECODER, pick the
> correct functions for these blocks.

Nice, thanks for the patch

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>


Acked-by: Helen Koike <helen.koike@collabora.com>

> ---
> diff --git a/drivers/media/platform/vimc/vimc-debayer.c b/drivers/media/platform/vimc/vimc-debayer.c
> index 4d663e89d33f..6e10b63ba9ec 100644
> --- a/drivers/media/platform/vimc/vimc-debayer.c
> +++ b/drivers/media/platform/vimc/vimc-debayer.c
> @@ -533,7 +533,7 @@ static int vimc_deb_comp_bind(struct device *comp, struct device *master,
>   	/* Initialize ved and sd */
>   	ret = vimc_ent_sd_register(&vdeb->ved, &vdeb->sd, v4l2_dev,
>   				   pdata->entity_name,
> -				   MEDIA_ENT_F_ATV_DECODER, 2,
> +				   MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV, 2,
>   				   (const unsigned long[2]) {MEDIA_PAD_FL_SINK,
>   				   MEDIA_PAD_FL_SOURCE},
>   				   &vimc_deb_ops);
> diff --git a/drivers/media/platform/vimc/vimc-scaler.c b/drivers/media/platform/vimc/vimc-scaler.c
> index e1602e0bc230..e583ec7a91da 100644
> --- a/drivers/media/platform/vimc/vimc-scaler.c
> +++ b/drivers/media/platform/vimc/vimc-scaler.c
> @@ -395,7 +395,7 @@ static int vimc_sca_comp_bind(struct device *comp, struct device *master,
>   	/* Initialize ved and sd */
>   	ret = vimc_ent_sd_register(&vsca->ved, &vsca->sd, v4l2_dev,
>   				   pdata->entity_name,
> -				   MEDIA_ENT_F_ATV_DECODER, 2,
> +				   MEDIA_ENT_F_PROC_VIDEO_SCALER, 2,
>   				   (const unsigned long[2]) {MEDIA_PAD_FL_SINK,
>   				   MEDIA_PAD_FL_SOURCE},
>   				   &vimc_sca_ops);
> diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
> index 457e211514c6..7d9fa9ccdb0e 100644
> --- a/drivers/media/platform/vimc/vimc-sensor.c
> +++ b/drivers/media/platform/vimc/vimc-sensor.c
> @@ -378,7 +378,7 @@ static int vimc_sen_comp_bind(struct device *comp, struct device *master,
>   	/* Initialize ved and sd */
>   	ret = vimc_ent_sd_register(&vsen->ved, &vsen->sd, v4l2_dev,
>   				   pdata->entity_name,
> -				   MEDIA_ENT_F_ATV_DECODER, 1,
> +				   MEDIA_ENT_F_CAM_SENSOR, 1,
>   				   (const unsigned long[1]) {MEDIA_PAD_FL_SOURCE},
>   				   &vimc_sen_ops);
>   	if (ret)
> 
