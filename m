Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49273 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775AbbAGTon (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Jan 2015 14:44:43 -0500
Date: Wed, 7 Jan 2015 20:44:26 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] soc_camera: avoid potential null-dereference
In-Reply-To: <1420597628-317-1-git-send-email-andy.shevchenko@gmail.com>
Message-ID: <Pine.LNX.4.64.1501072043490.16637@axis700.grange>
References: <1420597628-317-1-git-send-email-andy.shevchenko@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Thanks for the patch. Will queue for the next pull request.

Regards
Guennadi

On Wed, 7 Jan 2015, Andy Shevchenko wrote:

> We have to check the pointer before dereferencing it.
> 
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> ---
>  drivers/media/platform/soc_camera/soc_camera.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index b3db51c..8c665c4 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -2166,7 +2166,7 @@ static int soc_camera_video_start(struct soc_camera_device *icd)
>  static int soc_camera_pdrv_probe(struct platform_device *pdev)
>  {
>  	struct soc_camera_desc *sdesc = pdev->dev.platform_data;
> -	struct soc_camera_subdev_desc *ssdd = &sdesc->subdev_desc;
> +	struct soc_camera_subdev_desc *ssdd;
>  	struct soc_camera_device *icd;
>  	int ret;
>  
> @@ -2177,6 +2177,8 @@ static int soc_camera_pdrv_probe(struct platform_device *pdev)
>  	if (!icd)
>  		return -ENOMEM;
>  
> +	ssdd = &sdesc->subdev_desc;
> +
>  	/*
>  	 * In the asynchronous case ssdd->num_regulators == 0 yet, so, the below
>  	 * regulator allocation is a dummy. They are actually requested by the
> -- 
> 1.8.3.101.g727a46b
> 
