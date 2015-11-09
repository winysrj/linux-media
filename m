Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44709 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbbKIOeJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 09:34:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] mt9t001: constify v4l2_subdev_internal_ops structure
Date: Mon, 09 Nov 2015 16:34:19 +0200
Message-ID: <1969703.gAPgeEIYEi@avalon>
In-Reply-To: <1444564633-19861-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1444564633-19861-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Julia,

Thank you for the patch.

On Sunday 11 October 2015 13:57:13 Julia Lawall wrote:
> This v4l2_subdev_internal_ops structure is never modified.  All other
> v4l2_subdev_internal_ops structures are declared as const.
> 
> Done with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

> ---
>  drivers/media/i2c/mt9t001.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/mt9t001.c b/drivers/media/i2c/mt9t001.c
> index 8ae99f7..4383a5d 100644
> --- a/drivers/media/i2c/mt9t001.c
> +++ b/drivers/media/i2c/mt9t001.c
> @@ -834,7 +834,7 @@ static struct v4l2_subdev_ops mt9t001_subdev_ops = {
>  	.pad = &mt9t001_subdev_pad_ops,
>  };
> 
> -static struct v4l2_subdev_internal_ops mt9t001_subdev_internal_ops = {
> +static const struct v4l2_subdev_internal_ops mt9t001_subdev_internal_ops =
> { .registered = mt9t001_registered,
>  	.open = mt9t001_open,
>  	.close = mt9t001_close,

-- 
Regards,

Laurent Pinchart

