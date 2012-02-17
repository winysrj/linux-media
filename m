Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:58983 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2BQJsn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 04:48:43 -0500
Date: Fri, 17 Feb 2012 10:48:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: linux-media@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
	javier.martin@vista-silicon.com, baruch@tkos.co.il
Subject: Re: [PATCH 1/2] media/video mx2_camera: make using emma mandatory
 for i.MX27
In-Reply-To: <20120217093018.GS3852@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1202171043530.22632@axis700.grange>
References: <1329469749-18099-1-git-send-email-s.hauer@pengutronix.de>
 <1329469749-18099-2-git-send-email-s.hauer@pengutronix.de>
 <Pine.LNX.4.64.1202171022050.22632@axis700.grange> <20120217093018.GS3852@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 17 Feb 2012, Sascha Hauer wrote:

> On Fri, Feb 17, 2012 at 10:24:13AM +0100, Guennadi Liakhovetski wrote:
> > Hi Sascha
> > 
> > Thanks for the patch. Just one question:
> > 
> > On Fri, 17 Feb 2012, Sascha Hauer wrote:
> > 
> > > The i.MX27 dma support was introduced with the initial commit of
> > > this driver and originally created by me. However, I never got
> > > this stable due to the racy dma engine and used the EMMA engine
> > > instead. As the DMA support is most probably unused and broken in
> > > its current state, remove it. This also helps us to get rid of
> > > another user of the legacy i.MX DMA support,
> > > Also, remove the dependency on ARCH_MX* macros as these are scheduled
> > > for removal.
> > > 
> > > This patch only removes the use_emma variable and assumes it's
> > > hardcoded '1'. The resulting dead code is removed in the next patch.
> > > 
> > > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > > ---
> > >  drivers/media/video/mx2_camera.c |   21 ++++++++-------------
> > >  1 files changed, 8 insertions(+), 13 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> > > index 04aab0c..65709e4 100644
> > > --- a/drivers/media/video/mx2_camera.c
> > > +++ b/drivers/media/video/mx2_camera.c
> > 
> > [snip]
> > 
> > > @@ -1620,7 +1616,6 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
> > >  
> > >  		if (res_emma && irq_emma >= 0) {
> > >  			dev_info(&pdev->dev, "Using EMMA\n");
> > > -			pcdev->use_emma = 1;
> > >  			pcdev->res_emma = res_emma;
> > >  			pcdev->irq_emma = irq_emma;
> > >  			if (mx27_camera_emma_init(pcdev))
> > 
> > If emma is becoming the only way to use this driver on i.MX27, shouldn't 
> > the EMMA memory and IRQ resources become compulsory? I.e., if any of them 
> > is missing we should error out?
> 
> Yes, done in 2/2.

Yes, I saw that - after hitting send:-) But it does mean, that between 
patches 1 and 2 the functionality will be incorrect in that specific error 
case. Anyway, that's "just" a bisect breakage in a very small window and 
only on one platform, so, if that's acceptable to you as that platform 
maintainer, I won't argue either;-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
