Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:51557 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752716Ab2FDPer convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jun 2012 11:34:47 -0400
From: Albert Wang <twang13@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 4 Jun 2012 08:33:47 -0700
Subject: RE: [PATCH] [media] soc-camera: Correct icl platform data assignment
Message-ID: <477F20668A386D41ADCC57781B1F7043083A727354@SC-VEXCH1.marvell.com>
References: <1338803000-26019-1-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1206041425010.22611@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1206041425010.22611@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Guennadi

Yes, maybe you are right.
I checked some i2c client drivers, they all changed it to:

struct soc_camera_link *icl = soc_camera_i2c_to_link(client);

We also can update our client driver, but could you please explain why do you change it?
Thank you very much!


Thanks
Albert Wang
86-21-61092656

-----Original Message-----
From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de] 
Sent: Monday, 04 June, 2012 20:29
To: Albert Wang
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] soc-camera: Correct icl platform data assignment

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

No, I don't think this is right. If it were right, all soc-camera systems would be broken for a couple of kernel versions. I think, you have to update your drivers...

Thanks
Guennadi

> 
> Change-Id: Ia40a5ce96adbc5a1c3f3a90028e87a6fdbabc881
> Signed-off-by: Albert Wang <twang13@marvell.com>
> ---
>  drivers/media/video/soc_camera.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/soc_camera.c 
> b/drivers/media/video/soc_camera.c
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
