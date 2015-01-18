Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:51923 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbbARWKK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2015 17:10:10 -0500
Date: Sun, 18 Jan 2015 23:10:01 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] soc_camera: avoid potential null-dereference
In-Reply-To: <Pine.LNX.4.64.1501072043490.16637@axis700.grange>
Message-ID: <Pine.LNX.4.64.1501182308200.23540@axis700.grange>
References: <1420597628-317-1-git-send-email-andy.shevchenko@gmail.com>
 <Pine.LNX.4.64.1501072043490.16637@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 7 Jan 2015, Guennadi Liakhovetski wrote:

> Hi Andy,
> 
> Thanks for the patch. Will queue for the next pull request.

Actually no, I won't. I don't think there's currently a but there. the 
pointer isn't dereferenced before being checked. Only an address of a 
field in a struct, it's pointing to is calculated. So, if it's NULL just a 
small offset will be calculated, but no dereferencing will take place.

Thanks
Guennadi

> Regards
> Guennadi
> 
> On Wed, 7 Jan 2015, Andy Shevchenko wrote:
> 
> > We have to check the pointer before dereferencing it.
> > 
> > Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> > ---
> >  drivers/media/platform/soc_camera/soc_camera.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> > index b3db51c..8c665c4 100644
> > --- a/drivers/media/platform/soc_camera/soc_camera.c
> > +++ b/drivers/media/platform/soc_camera/soc_camera.c
> > @@ -2166,7 +2166,7 @@ static int soc_camera_video_start(struct soc_camera_device *icd)
> >  static int soc_camera_pdrv_probe(struct platform_device *pdev)
> >  {
> >  	struct soc_camera_desc *sdesc = pdev->dev.platform_data;
> > -	struct soc_camera_subdev_desc *ssdd = &sdesc->subdev_desc;
> > +	struct soc_camera_subdev_desc *ssdd;
> >  	struct soc_camera_device *icd;
> >  	int ret;
> >  
> > @@ -2177,6 +2177,8 @@ static int soc_camera_pdrv_probe(struct platform_device *pdev)
> >  	if (!icd)
> >  		return -ENOMEM;
> >  
> > +	ssdd = &sdesc->subdev_desc;
> > +
> >  	/*
> >  	 * In the asynchronous case ssdd->num_regulators == 0 yet, so, the below
> >  	 * regulator allocation is a dummy. They are actually requested by the
> > -- 
> > 1.8.3.101.g727a46b
> > 
> 
