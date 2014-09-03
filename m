Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64072 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755756AbaICUoJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Sep 2014 16:44:09 -0400
Date: Wed, 3 Sep 2014 22:44:02 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 03/46] [media] soc_camera: use kmemdup()
In-Reply-To: <b7688fe7abdac43a645e7a69748a561cf9960009.1409775488.git.m.chehab@samsung.com>
Message-ID: <Pine.LNX.4.64.1409032240390.10547@axis700.grange>
References: <cover.1409775488.git.m.chehab@samsung.com>
 <b7688fe7abdac43a645e7a69748a561cf9960009.1409775488.git.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, 3 Sep 2014, Mauro Carvalho Chehab wrote:

> Instead of calling kzalloc and then copying, use kmemdup(). That
> avoids zeroing the data structure before copying.
> 
> Found by coccinelle.
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index f4308fed5431..ee8cdc95a9f9 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -1347,13 +1347,11 @@ static int soc_camera_i2c_init(struct soc_camera_device *icd,
>  		return -ENODEV;
>  	}
>  
> -	ssdd = kzalloc(sizeof(*ssdd), GFP_KERNEL);
> +	ssdd = kmemdup(&sdesc->subdev_desc, sizeof(*ssdd), GFP_KERNEL);
>  	if (!ssdd) {
>  		ret = -ENOMEM;
>  		goto ealloc;
>  	}
> -
> -	memcpy(ssdd, &sdesc->subdev_desc, sizeof(*ssdd));

Hm, wow... that seems  to be a particularly silly one... Even if not 
memdup, why did I use kZalloc() to immediately overwrite it completely?.. 
Thanks for catching! This and the other two (so far) patches - would you 
like me to pull-push them or just use my

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

for all 3 of them?

Thanks
Guennadi

>  	/*
>  	 * In synchronous case we request regulators ourselves in
>  	 * soc_camera_pdrv_probe(), make sure the subdevice driver doesn't try
> -- 
> 1.9.3
> 
