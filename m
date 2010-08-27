Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:59077 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754907Ab0H0JqA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Aug 2010 05:46:00 -0400
Date: Fri, 27 Aug 2010 11:46:04 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Grzeschik <mgr@pengutronix.de>
cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	baruch@tkos.co.il, Sascha Hauer <s.hauer@pengutronix.de>,
	Teresa Gamez <T.Gamez@phytec.de>
Subject: Re: [PATCH 5/5] mx2_camera: add informative camera clock frequency
 printout
In-Reply-To: <20100805205445.GG23884@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1008271140300.28043@axis700.grange>
References: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de>
 <1280828276-483-6-git-send-email-m.grzeschik@pengutronix.de>
 <Pine.LNX.4.64.1008052228280.26127@axis700.grange> <20100805205445.GG23884@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Thu, 5 Aug 2010, Michael Grzeschik wrote:

> On Thu, Aug 05, 2010 at 10:30:39PM +0200, Guennadi Liakhovetski wrote:
> > On Tue, 3 Aug 2010, Michael Grzeschik wrote:
> > 
> > > ported mx27_camera to 2.6.33.2
> > 
> > Sorry, do not understand what this description has to do with the contents 
> The Description is of topic from a previous patchseries from Teresa
> Gamez and has nothin to do with the content, right!
> 
> > - adding a printk to a driver? I don't think this is something critical 
> > enough to be handled urgently now for 2.6.36, right?
> Yes you are right, this one isn't urgent.
> 
> Michael
> 
> > 
> > Thanks
> > Guennadi
> > 
> > > Signed-off-by: Teresa Gamez <T.Gamez@phytec.de>
> > > Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > > ---
> > >  drivers/media/video/mx2_camera.c |    3 +++
> > >  1 files changed, 3 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> > > index 7f27492..fb1b1cb 100644
> > > --- a/drivers/media/video/mx2_camera.c
> > > +++ b/drivers/media/video/mx2_camera.c
> > > @@ -1360,6 +1360,9 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
> > >  			goto exit_dma_free;
> > >  	}
> > >  
> > > +	dev_info(&pdev->dev, "Camera clock frequency: %ld\n",
> > > +			clk_get_rate(pcdev->clk_csi));
> > > +
> > >  	INIT_LIST_HEAD(&pcdev->capture);
> > >  	INIT_LIST_HEAD(&pcdev->active_bufs);
> > >  	spin_lock_init(&pcdev->lock);

Well, in mx2_camera_remove() we have a message

	dev_info(&pdev->dev, "MX2 Camera driver unloaded\n");

and currently no counterpart in probe. I don't think this "unloaded" 
message is particularly valuable, but we've already got it. So, we can 
either remove it or add one more in probe. If you prefer the latter - 
fine, but (1) I'd put it later - just before "return 0;" where we already 
know probe will not fail, and (2) make it even more informative like

"MX2 Camera (CSI) driver probed, clock frequency %ld\n"

if you really _do_ think the user is interested to know that;) Otherwise, 
make this and the "unloaded" dev_dbg().

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
