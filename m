Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:60960 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2FDM3A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2012 08:29:00 -0400
Date: Mon, 4 Jun 2012 14:28:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] soc-camera: Correct icl platform data assignment
In-Reply-To: <1338803000-26019-1-git-send-email-twang13@marvell.com>
Message-ID: <Pine.LNX.4.64.1206041425010.22611@axis700.grange>
References: <1338803000-26019-1-git-send-email-twang13@marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Albert

On Mon, 4 Jun 2012, Albert Wang wrote:

> This patch corrects icl platform data assignment
> 
>     from:
>         icl->board_info->platform_data = icl;
>     to:
>         icl->board_info->platform_data = icd;
> 
> during init i2c device board info

No, I don't think this is right. If it were right, all soc-camera systems 
would be broken for a couple of kernel versions. I think, you have to 
update your drivers...

Thanks
Guennadi

> 
> Change-Id: Ia40a5ce96adbc5a1c3f3a90028e87a6fdbabc881
> Signed-off-by: Albert Wang <twang13@marvell.com>
> ---
>  drivers/media/video/soc_camera.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index 0421bf9..cb8b8c7 100755
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -991,7 +991,7 @@ static int soc_camera_init_i2c(struct soc_camera_device *icd,
>  		goto ei2cga;
>  	}
>  
> -	icl->board_info->platform_data = icl;
> +	icl->board_info->platform_data = icd;
>  
>  	subdev = v4l2_i2c_new_subdev_board(&ici->v4l2_dev, adap,
>  				icl->board_info, NULL);
> -- 
> 1.7.0.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
