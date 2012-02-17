Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35813 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2BQJaW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Feb 2012 04:30:22 -0500
Date: Fri, 17 Feb 2012 10:30:18 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
	javier.martin@vista-silicon.com, baruch@tkos.co.il
Subject: Re: [PATCH 1/2] media/video mx2_camera: make using emma mandatory
 for i.MX27
Message-ID: <20120217093018.GS3852@pengutronix.de>
References: <1329469749-18099-1-git-send-email-s.hauer@pengutronix.de>
 <1329469749-18099-2-git-send-email-s.hauer@pengutronix.de>
 <Pine.LNX.4.64.1202171022050.22632@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1202171022050.22632@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 17, 2012 at 10:24:13AM +0100, Guennadi Liakhovetski wrote:
> Hi Sascha
> 
> Thanks for the patch. Just one question:
> 
> On Fri, 17 Feb 2012, Sascha Hauer wrote:
> 
> > The i.MX27 dma support was introduced with the initial commit of
> > this driver and originally created by me. However, I never got
> > this stable due to the racy dma engine and used the EMMA engine
> > instead. As the DMA support is most probably unused and broken in
> > its current state, remove it. This also helps us to get rid of
> > another user of the legacy i.MX DMA support,
> > Also, remove the dependency on ARCH_MX* macros as these are scheduled
> > for removal.
> > 
> > This patch only removes the use_emma variable and assumes it's
> > hardcoded '1'. The resulting dead code is removed in the next patch.
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > ---
> >  drivers/media/video/mx2_camera.c |   21 ++++++++-------------
> >  1 files changed, 8 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> > index 04aab0c..65709e4 100644
> > --- a/drivers/media/video/mx2_camera.c
> > +++ b/drivers/media/video/mx2_camera.c
> 
> [snip]
> 
> > @@ -1620,7 +1616,6 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
> >  
> >  		if (res_emma && irq_emma >= 0) {
> >  			dev_info(&pdev->dev, "Using EMMA\n");
> > -			pcdev->use_emma = 1;
> >  			pcdev->res_emma = res_emma;
> >  			pcdev->irq_emma = irq_emma;
> >  			if (mx27_camera_emma_init(pcdev))
> 
> If emma is becoming the only way to use this driver on i.MX27, shouldn't 
> the EMMA memory and IRQ resources become compulsory? I.e., if any of them 
> is missing we should error out?

Yes, done in 2/2.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
