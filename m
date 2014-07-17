Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2390 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933607AbaGQQTo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 12:19:44 -0400
Message-ID: <53C7F782.7000509@xs4all.nl>
Date: Thu, 17 Jul 2014 18:19:14 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH 07/11] [media] coda: lock capture frame size to output
 frame size when streaming
References: <1405613112-22442-1-git-send-email-p.zabel@pengutronix.de> <1405613112-22442-8-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405613112-22442-8-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/17/2014 06:05 PM, Philipp Zabel wrote:
> As soon as the output queue is streaming, let try_fmt on the capture side
> only allow the frame size that was set on the output side.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/coda.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 3d57986..6b659c8 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -721,6 +721,9 @@ static int coda_try_fmt_vid_cap(struct file *file, void *priv,
>  					f->fmt.pix.pixelformat);
>  		if (!codec)
>  			return -EINVAL;
> +
> +		f->fmt.pix.width = q_data_src->width;
> +		f->fmt.pix.height = q_data_src->height;
>  	} else {
>  		/* Otherwise determine codec by encoded format, if possible */
>  		codec = coda_find_codec(ctx->dev, V4L2_PIX_FMT_YUV420,
> 

