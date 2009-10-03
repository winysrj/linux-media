Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33964 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752747AbZJCWcK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Oct 2009 18:32:10 -0400
Date: Sun, 4 Oct 2009 00:31:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Antonio Ospite <ospite@studenti.unina.it>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: pxa_camera + mt9m1111:  Failed to configure for format 50323234
In-Reply-To: <20091003161328.36419315.ospite@studenti.unina.it>
Message-ID: <Pine.LNX.4.64.0910040024070.5857@axis700.grange>
References: <20091002213530.104a5009.ospite@studenti.unina.it>
 <Pine.LNX.4.64.0910030116270.12093@axis700.grange>
 <20091003161328.36419315.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 3 Oct 2009, Antonio Ospite wrote:

> On Sat, 3 Oct 2009 01:27:04 +0200 (CEST)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > On Fri, 2 Oct 2009, Antonio Ospite wrote:
> > 
> > > Hi,
> > > 
> > > after updating to 2.6.32-rc2 I can't capture anymore with the setup in the
> > > subject.
> > 
> > Indeed:-( Please, verify, that this patch fixes your problem (completely 
> > untested), if it does, I'll push it for 2.6.32:
> > 
> > pxa_camera: fix camera pixel format configuration
> > 
> > A typo prevents correct picel format negotiation with client drivers.
> >
> 
> typo in the log message too :) s/picel/pixel/

Thanks:-)

> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> > index 6952e96..aa831d5 100644
> > --- a/drivers/media/video/pxa_camera.c
> > +++ b/drivers/media/video/pxa_camera.c
> > @@ -1432,7 +1432,9 @@ static int pxa_camera_set_fmt(struct soc_camera_device *icd,
> >  		icd->sense = &sense;
> >  
> >  	cam_f.fmt.pix.pixelformat = cam_fmt->fourcc;
> > -	ret = v4l2_subdev_call(sd, video, s_fmt, f);
> > +	ret = v4l2_subdev_call(sd, video, s_fmt, &cam_f);
> > +	cam_f.fmt.pix.pixelformat = pix->pixelformat;
> > +	*pix = cam_f.fmt.pix;
> >  
> >  	icd->sense = NULL;
> 
> Ok, I can capture again even by only fixing the typo: s/f/&cam_f/
> but I don't know if this is complete.

No, that's not.

> Anyways your patch works, but the picture is now shifted, see:
> http://people.openezx.org/ao2/a780-pxa-camera-mt9m111-shifted.jpg
> 
> Is this because of the new cropping code?

Hm, it shouldn't be. Does it look always like this - reproducible? What 
program are you using? What about other geometry configurations? Have you 
ever seen this with previous kernel versions? New cropping - neither 
mplayer nor gstreamer use cropping normally. This seems more like a HSYNC 
problem to me. Double-check platform data? Is it mioa701 or some custom 
board?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
