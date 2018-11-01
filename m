Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56366 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728085AbeKAUwk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 1 Nov 2018 16:52:40 -0400
Subject: Re: [PATCH 2/2] media: vimc: constify structures stored in fields of
 v4l2_subdev_ops structure
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1540644545-26184-1-git-send-email-Julia.Lawall@lip6.fr>
 <1540644545-26184-3-git-send-email-Julia.Lawall@lip6.fr>
From: Helen Koike <helen.koike@collabora.com>
Message-ID: <317df861-530f-7700-7098-3a91855363a9@collabora.com>
Date: Thu, 1 Nov 2018 08:49:50 -0300
MIME-Version: 1.0
In-Reply-To: <1540644545-26184-3-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Julia,

Thanks, I had missed that one.

On 10/27/18 10:49 AM, Julia Lawall wrote:
> The fields of a v4l2_subdev_ops structure are all const, so the
> structures that are stored there and are not used elsewhere can be
> const as well.
> 
> Done with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Acked-by: Helen Koike <helen.koike@collabora.com>

> 
> ---
>  drivers/media/platform/vimc/vimc-sensor.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
> index edf4c85ae63d..32ca9c6172b1 100644
> --- a/drivers/media/platform/vimc/vimc-sensor.c
> +++ b/drivers/media/platform/vimc/vimc-sensor.c
> @@ -286,7 +286,7 @@ static int vimc_sen_s_stream(struct v4l2_subdev *sd, int enable)
>  	return 0;
>  }
>  
> -static struct v4l2_subdev_core_ops vimc_sen_core_ops = {
> +static const struct v4l2_subdev_core_ops vimc_sen_core_ops = {
>  	.log_status = v4l2_ctrl_subdev_log_status,
>  	.subscribe_event = v4l2_ctrl_subdev_subscribe_event,
>  	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
> 
