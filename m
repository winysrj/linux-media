Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52930 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbbIPPIS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2015 11:08:18 -0400
Date: Wed, 16 Sep 2015 17:08:06 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Wang YanQing <udknight@gmail.com>
cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] soc_camera: soc_camera_pdrv_probe: fix potential
 NULL pointer dereference
In-Reply-To: <20150916150003.GA2195@udknight>
Message-ID: <Pine.LNX.4.64.1509161707381.1783@axis700.grange>
References: <20150916150003.GA2195@udknight>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 16 Sep 2015, Wang YanQing wrote:

> Move dereference of sdesc after NULL pointer checker.
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  drivers/media/platform/soc_camera/soc_camera.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index 9087fed..53b153d 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -2187,13 +2187,14 @@ static int soc_camera_video_start(struct soc_camera_device *icd)
>  static int soc_camera_pdrv_probe(struct platform_device *pdev)
>  {
>  	struct soc_camera_desc *sdesc = pdev->dev.platform_data;
> -	struct soc_camera_subdev_desc *ssdd = &sdesc->subdev_desc;
> +	struct soc_camera_subdev_desc *ssdd;

NAK. This isn't a dereference. This is just an address calculation.

Thanks
Guennadi

>  	struct soc_camera_device *icd;
>  	int ret;
>  
>  	if (!sdesc)
>  		return -EINVAL;
>  
> +	ssdd = &sdesc->subdev_desc;
>  	icd = devm_kzalloc(&pdev->dev, sizeof(*icd), GFP_KERNEL);
>  	if (!icd)
>  		return -ENOMEM;
> -- 
> 1.8.5.6.2.g3d8a54e.dirty
> 
