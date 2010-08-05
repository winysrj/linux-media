Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35494 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab0HEUyq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Aug 2010 16:54:46 -0400
Date: Thu, 5 Aug 2010 22:54:45 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	baruch@tkos.co.il, Sascha Hauer <s.hauer@pengutronix.de>,
	Teresa Gamez <T.Gamez@phytec.de>
Subject: Re: [PATCH 5/5] mx2_camera: add informative camera clock frequency
	printout
Message-ID: <20100805205445.GG23884@pengutronix.de>
References: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de> <1280828276-483-6-git-send-email-m.grzeschik@pengutronix.de> <Pine.LNX.4.64.1008052228280.26127@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008052228280.26127@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 05, 2010 at 10:30:39PM +0200, Guennadi Liakhovetski wrote:
> On Tue, 3 Aug 2010, Michael Grzeschik wrote:
> 
> > ported mx27_camera to 2.6.33.2
> 
> Sorry, do not understand what this description has to do with the contents 
The Description is of topic from a previous patchseries from Teresa
Gamez and has nothin to do with the content, right!

> - adding a printk to a driver? I don't think this is something critical 
> enough to be handled urgently now for 2.6.36, right?
Yes you are right, this one isn't urgent.

Michael

> 
> Thanks
> Guennadi
> 
> > Signed-off-by: Teresa Gamez <T.Gamez@phytec.de>
> > Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > ---
> >  drivers/media/video/mx2_camera.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> > index 7f27492..fb1b1cb 100644
> > --- a/drivers/media/video/mx2_camera.c
> > +++ b/drivers/media/video/mx2_camera.c
> > @@ -1360,6 +1360,9 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
> >  			goto exit_dma_free;
> >  	}
> >  
> > +	dev_info(&pdev->dev, "Camera clock frequency: %ld\n",
> > +			clk_get_rate(pcdev->clk_csi));
> > +
> >  	INIT_LIST_HEAD(&pcdev->capture);
> >  	INIT_LIST_HEAD(&pcdev->active_bufs);
> >  	spin_lock_init(&pcdev->lock);
> > -- 
> > 1.7.1
> > 
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
