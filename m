Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51342 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbZDCIyE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2009 04:54:04 -0400
Date: Fri, 3 Apr 2009 10:54:01 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <lg@denx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] mx3-camera: fix to match the new clock naming
Message-ID: <20090403085401.GO23731@pengutronix.de>
References: <Pine.LNX.4.64.0904021145040.5263@axis700.grange> <20090403082844.GM23731@pengutronix.de> <Pine.LNX.4.64.0904031047040.4729@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904031047040.4729@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 03, 2009 at 10:49:32AM +0200, Guennadi Liakhovetski wrote:
> On Fri, 3 Apr 2009, Sascha Hauer wrote:
> 
> > On Thu, Apr 02, 2009 at 11:49:55AM +0200, Guennadi Liakhovetski wrote:
> > > With the i.MX31 transition to clkdev clock names have changed, fix the 
> > > driver to use the new name.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> > > ---
> > > diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
> > > index 70629e1..7e6b51d 100644
> > > --- a/drivers/media/video/mx3_camera.c
> > > +++ b/drivers/media/video/mx3_camera.c
> > > @@ -1100,7 +1100,7 @@ static int mx3_camera_probe(struct platform_device *pdev)
> > >  	}
> > >  	memset(mx3_cam, 0, sizeof(*mx3_cam));
> > >  
> > > -	mx3_cam->clk = clk_get(&pdev->dev, "csi_clk");
> > > +	mx3_cam->clk = clk_get(&pdev->dev, "csi");
> > 
> > clk_get(&pdev->dev, NULL) please. The name is only for distinguishing
> > the clocks when there is more than one clock per device which isn't the
> > case here.
> > 
> > I just see that it's
> > 
> > _REGISTER_CLOCK("mx3-camera.0", "csi", csi_clk)
> > 
> > Should be
> > 
> > _REGISTER_CLOCK("mx3-camera.0", NULL, csi_clk)
> > 
> > instead.
> 
> Right, that's why. What should we do now?
> 
> 1. We leave this patch as is, and remove the connection ID later
> 2. I make a single patch that changes both, you ack it, and I pull it via 
> V4L.
> 3. I make two patches, you ack the ARM part and I pull them via V$L.
> 4. We do not want to pull two patches via different trees

2) is ok for me.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
