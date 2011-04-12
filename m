Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:55704 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab1DLG2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 02:28:43 -0400
Date: Tue, 12 Apr 2011 08:28:41 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kassey Lee <kassey1216@gmail.com>
cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2.6.39] soc_camera: OMAP1: fix missing bytesperline and
 sizeimage initialization
In-Reply-To: <BANLkTimut-G1YXFU+4gqiCij-RLu-Vn4-Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1104120820020.23770@axis700.grange>
References: <201104090158.04827.jkrzyszt@tis.icnet.pl>
 <Pine.LNX.4.64.1104101751380.12697@axis700.grange>
 <BANLkTimut-G1YXFU+4gqiCij-RLu-Vn4-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi

On Tue, 12 Apr 2011, Kassey Lee wrote:

> hi, Guennadi:
>     a lot of sensors support JPEG output.
>     1) bytesperline is defined by sensor timing.
>     2) and sizeimage is unknow for jpeg.
> 
>   how about for JPEG
>    1) host driver gets bytesperline from sensor driver.
>    2) sizeimage refilled by host driver after dma transfer done( a
> frame is received)
>   thanks.

How is this done currently on other V4L2 drivers? To transfer a frame you 
usually first do at least one of S_FMT and G_FMT, at which time you 
already have to report sizeimage to the user - before any transfer has 
taken place. Currently with soc-camera it is already possible to override 
sizeimage and bytesperline from the host driver. Just set them to whatever 
you need in your try_fmt and they will be kept. Not sure how you want to 
do that, if you need to first read in a frame - do you want to perform 
some dummy frame transfer? You might not even have any buffers queued yet, 
so, it has to be a read without writing to RAM. Don't such compressed 
formats just put a value in sizeimage, that is a calculated maximum size?

Thanks
Guennadi

> 2011/4/11 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> > Hi Janusz
> >
> > On Sat, 9 Apr 2011, Janusz Krzysztofik wrote:
> >
> >> Since commit 0e4c180d3e2cc11e248f29d4c604b6194739d05a, bytesperline and
> >> sizeimage memebers of v4l2_pix_format structure have no longer been
> >> calculated inside soc_camera_g_fmt_vid_cap(), but rather passed via
> >> soc_camera_device structure from a host driver callback invoked by
> >> soc_camera_set_fmt().
> >>
> >> OMAP1 camera host driver has never been providing these parameters, so
> >> it no longer works correctly. Fix it by adding suitable assignments to
> >> omap1_cam_set_fmt().
> >
> > Thanks for the patch, but now it looks like many soc-camera host drivers
> > are re-implementing this very same calculation in different parts of their
> > code - in try_fmt, set_fmt, get_fmt. Why don't we unify them all,
> > implement this centrally in soc_camera.c and remove all those
> > calculations? Could you cook up a patch or maybe several patches - for
> > soc_camera.c and all drivers?
> >
> > Thanks
> > Guennadi
> >
> >>
> >> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> >> ---
> >>  drivers/media/video/omap1_camera.c |    6 ++++++
> >>  1 file changed, 6 insertions(+)
> >>
> >> --- linux-2.6.39-rc2/drivers/media/video/omap1_camera.c.orig  2011-04-06 14:30:37.000000000 +0200
> >> +++ linux-2.6.39-rc2/drivers/media/video/omap1_camera.c       2011-04-09 00:16:36.000000000 +0200
> >> @@ -1292,6 +1292,12 @@ static int omap1_cam_set_fmt(struct soc_
> >>       pix->colorspace  = mf.colorspace;
> >>       icd->current_fmt = xlate;
> >>
> >> +     pix->bytesperline = soc_mbus_bytes_per_line(pix->width,
> >> +                                                 xlate->host_fmt);
> >> +     if (pix->bytesperline < 0)
> >> +             return pix->bytesperline;
> >> +     pix->sizeimage = pix->height * pix->bytesperline;
> >> +
> >>       return 0;
> >>  }
> >>
> >>
> >
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
