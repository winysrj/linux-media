Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:41475 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbaICUyi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:54:38 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBC00AQPFF0YA80@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Sep 2014 16:54:36 -0400 (EDT)
Date: Wed, 03 Sep 2014 17:54:32 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 03/46] [media] soc_camera: use kmemdup()
Message-id: <20140903175432.25ea4797.m.chehab@samsung.com>
In-reply-to: <Pine.LNX.4.64.1409032240390.10547@axis700.grange>
References: <cover.1409775488.git.m.chehab@samsung.com>
 <b7688fe7abdac43a645e7a69748a561cf9960009.1409775488.git.m.chehab@samsung.com>
 <Pine.LNX.4.64.1409032240390.10547@axis700.grange>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 3 Sep 2014 22:44:02 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:

> Hi Mauro,
> 
> On Wed, 3 Sep 2014, Mauro Carvalho Chehab wrote:
> 
> > Instead of calling kzalloc and then copying, use kmemdup(). That
> > avoids zeroing the data structure before copying.
> > 
> > Found by coccinelle.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > 
> > diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> > index f4308fed5431..ee8cdc95a9f9 100644
> > --- a/drivers/media/platform/soc_camera/soc_camera.c
> > +++ b/drivers/media/platform/soc_camera/soc_camera.c
> > @@ -1347,13 +1347,11 @@ static int soc_camera_i2c_init(struct soc_camera_device *icd,
> >  		return -ENODEV;
> >  	}
> >  
> > -	ssdd = kzalloc(sizeof(*ssdd), GFP_KERNEL);
> > +	ssdd = kmemdup(&sdesc->subdev_desc, sizeof(*ssdd), GFP_KERNEL);
> >  	if (!ssdd) {
> >  		ret = -ENOMEM;
> >  		goto ealloc;
> >  	}
> > -
> > -	memcpy(ssdd, &sdesc->subdev_desc, sizeof(*ssdd));
> 
> Hm, wow... that seems  to be a particularly silly one... Even if not 
> memdup, why did I use kZalloc() to immediately overwrite it completely?.. 

Maybe this pattern happened due to some incremental change.

> Thanks for catching! This and the other two (so far) patches - would you 
> like me to pull-push them or just use my
> 
> Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> for all 3 of them?

Just the acked-by is enough.

Thanks!
Mauro

> 
> Thanks
> Guennadi
> 
> >  	/*
> >  	 * In synchronous case we request regulators ourselves in
> >  	 * soc_camera_pdrv_probe(), make sure the subdevice driver doesn't try
> > -- 
> > 1.9.3
> > 
