Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49183 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932488AbcKVVj0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 16:39:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Thaissa Falbo <thaissa.falbo@gmail.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Leo Sperling <leosperling97@gmail.com>,
        sayli karnik <karniksayli1995@gmail.com>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] Staging: media: davinci_vpfe: unlock on error in vpfe_reqbufs()
Date: Tue, 22 Nov 2016 23:39:44 +0200
Message-ID: <1552231.W5T0VxdTBZ@avalon>
In-Reply-To: <20161118113024.GA3150@mwanda>
References: <20161118113024.GA3150@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

Thank you for the patch.

On Friday 18 Nov 2016 14:30:24 Dan Carpenter wrote:
> We should unlock before returning this error code in vpfe_reqbufs().
> 
> Fixes: 622897da67b3 ("[media] davinci: vpfe: add v4l2 video driver support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree. I will send a pull request for v4.11.

> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> b/drivers/staging/media/davinci_vpfe/vpfe_video.c index c34bf46..353f3a8
> 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -1362,7 +1362,7 @@ static int vpfe_reqbufs(struct file *file, void *priv,
> ret = vb2_queue_init(q);
>  	if (ret) {
>  		v4l2_err(&vpfe_dev->v4l2_dev, "vb2_queue_init() failed\n");
> -		return ret;
> +		goto unlock_out;
>  	}
> 
>  	fh->io_allowed = 1;

-- 
Regards,

Laurent Pinchart

