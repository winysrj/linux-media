Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56012 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbbKPUV1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 15:21:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Lad Prabhakar <prabhakar.csengg@gmail.com>,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] [media] i2c: constify v4l2_ctrl_ops structures
Date: Mon, 16 Nov 2015 22:21:34 +0200
Message-ID: <1528138.k1hTttqLyu@avalon>
In-Reply-To: <1447452318-19028-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1447452318-19028-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Julia,

Thank you for the patch.

On Friday 13 November 2015 23:05:17 Julia Lawall wrote:
> These v4l2_ctrl_ops structures are never modified, like all the other
> v4l2_ctrl_ops structures, so declare them as const.
> 
> Done with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree. I've prefixed the subject line with "v4l: i2c" instead 
of just "i2c".

> ---
>  drivers/media/i2c/mt9m032.c |    2 +-
>  drivers/media/i2c/mt9p031.c |    2 +-
>  drivers/media/i2c/mt9t001.c |    2 +-
>  drivers/media/i2c/mt9v011.c |    2 +-
>  drivers/media/i2c/mt9v032.c |    2 +-
>  drivers/media/i2c/ov2659.c  |    2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/i2c/mt9t001.c b/drivers/media/i2c/mt9t001.c
> index 8ae99f7..3486bc8 100644
> --- a/drivers/media/i2c/mt9t001.c
> +++ b/drivers/media/i2c/mt9t001.c
> @@ -626,7 +626,7 @@ static int mt9t001_s_ctrl(struct v4l2_ctrl *ctrl)
>  	return 0;
>  }
> 
> -static struct v4l2_ctrl_ops mt9t001_ctrl_ops = {
> +static const struct v4l2_ctrl_ops mt9t001_ctrl_ops = {
>  	.s_ctrl = mt9t001_s_ctrl,
>  };
> 
> diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
> index a68ce94..b8e80c0 100644
> --- a/drivers/media/i2c/mt9v032.c
> +++ b/drivers/media/i2c/mt9v032.c
> @@ -703,7 +703,7 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
>  	return 0;
>  }
> 
> -static struct v4l2_ctrl_ops mt9v032_ctrl_ops = {
> +static const struct v4l2_ctrl_ops mt9v032_ctrl_ops = {
>  	.s_ctrl = mt9v032_s_ctrl,
>  };
> 
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index 0db15f5..1e78aa2 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -817,7 +817,7 @@ static int mt9p031_s_ctrl(struct v4l2_ctrl *ctrl)
>  	return 0;
>  }
> 
> -static struct v4l2_ctrl_ops mt9p031_ctrl_ops = {
> +static const struct v4l2_ctrl_ops mt9p031_ctrl_ops = {
>  	.s_ctrl = mt9p031_s_ctrl,
>  };
> 
> diff --git a/drivers/media/i2c/mt9v011.c b/drivers/media/i2c/mt9v011.c
> index a4a5c39..c681b3b 100644
> --- a/drivers/media/i2c/mt9v011.c
> +++ b/drivers/media/i2c/mt9v011.c
> @@ -454,7 +454,7 @@ static int mt9v011_s_ctrl(struct v4l2_ctrl *ctrl)
>  	return 0;
>  }
> 
> -static struct v4l2_ctrl_ops mt9v011_ctrl_ops = {
> +static const struct v4l2_ctrl_ops mt9v011_ctrl_ops = {
>  	.s_ctrl = mt9v011_s_ctrl,
>  };
> 
> diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
> index 49109f4..b952e7d 100644
> --- a/drivers/media/i2c/ov2659.c
> +++ b/drivers/media/i2c/ov2659.c
> @@ -1249,7 +1249,7 @@ static int ov2659_s_ctrl(struct v4l2_ctrl *ctrl)
>  	return 0;
>  }
> 
> -static struct v4l2_ctrl_ops ov2659_ctrl_ops = {
> +static const struct v4l2_ctrl_ops ov2659_ctrl_ops = {
>  	.s_ctrl = ov2659_s_ctrl,
>  };
> 
> diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
> index c7747bd..eec064e 100644
> --- a/drivers/media/i2c/mt9m032.c
> +++ b/drivers/media/i2c/mt9m032.c
> @@ -671,7 +671,7 @@ static int mt9m032_set_ctrl(struct v4l2_ctrl *ctrl)
>  	return 0;
>  }
> 
> -static struct v4l2_ctrl_ops mt9m032_ctrl_ops = {
> +static const struct v4l2_ctrl_ops mt9m032_ctrl_ops = {
>  	.s_ctrl = mt9m032_set_ctrl,
>  	.try_ctrl = mt9m032_try_ctrl,
>  };

-- 
Regards,

Laurent Pinchart

