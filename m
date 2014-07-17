Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4563 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbaGQQJZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 12:09:25 -0400
Message-ID: <53C7F516.3080005@xs4all.nl>
Date: Thu, 17 Jul 2014 18:08:54 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH 03/11] [media] coda: remove CAPTURE and OUTPUT caps
References: <1405613112-22442-1-git-send-email-p.zabel@pengutronix.de> <1405613112-22442-4-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405613112-22442-4-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/17/2014 06:05 PM, Philipp Zabel wrote:
> This is a mem2mem driver, pure capture or output modes are not
> supported.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/coda.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 10f9278..f52d17c 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -536,13 +536,7 @@ static int coda_querycap(struct file *file, void *priv,
>  	strlcpy(cap->card, coda_product_name(ctx->dev->devtype->product),
>  		sizeof(cap->card));
>  	strlcpy(cap->bus_info, "platform:" CODA_NAME, sizeof(cap->bus_info));
> -	/*
> -	 * This is only a mem-to-mem video device. The capture and output
> -	 * device capability flags are left only for backward compatibility
> -	 * and are scheduled for removal.
> -	 */
> -	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT |
> -			   V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
> +	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
>  	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>  
>  	return 0;
> 

