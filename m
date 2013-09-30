Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2574 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab3I3LxJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 07:53:09 -0400
Message-ID: <5249660A.6080706@xs4all.nl>
Date: Mon, 30 Sep 2013 13:52:42 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: Re: [PATCH 10/10] [media] coda: v4l2-compliance fix: zero pixel format
 priv field
References: <1379582036-4840-1-git-send-email-p.zabel@pengutronix.de> <1379582036-4840-11-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1379582036-4840-11-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/19/2013 11:13 AM, Philipp Zabel wrote:
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index d15238a..6dec34d 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -556,6 +556,7 @@ static int coda_vidioc_g_fmt(struct file *file, void *priv,
>  
>  	f->fmt.pix.sizeimage	= q_data->sizeimage;
>  	f->fmt.pix.colorspace	= ctx->colorspace;
> +	f->fmt.pix.priv		= 0;

This is cleared by the core code, so this isn't necessary.

>  
>  	return 0;
>  }
> @@ -613,6 +614,8 @@ static int coda_vidioc_try_fmt(struct coda_ctx *ctx, struct coda_codec *codec,
>  		BUG();
>  	}
>  
> +	f->fmt.pix.priv = 0;
> +

This is the only one that needs to be cleared manually, so this is fine.

Regards,

	Hans

>  	return 0;
>  }
>  
> 

