Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51387 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756762AbZDAQ7O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Apr 2009 12:59:14 -0400
Date: Wed, 1 Apr 2009 18:59:21 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Questinons regarding soc_camera / pxa_camera
In-Reply-To: <49D32B16.2070101@hni.uni-paderborn.de>
Message-ID: <Pine.LNX.4.64.0904011831340.5389@axis700.grange>
References: <49CBB13F.7090609@hni.uni-paderborn.de>
 <Pine.LNX.4.64.0903261831430.5438@axis700.grange> <49D32B16.2070101@hni.uni-paderborn.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 1 Apr 2009, Stefan Herbrechtsmeier wrote:

> Guennadi Liakhovetski schrieb:
> > (moving to the new v4l list)
> > 
> > On Thu, 26 Mar 2009, Stefan Herbrechtsmeier wrote:
> > 
> >   
> > > --- a/linux/drivers/media/video/soc_camera.c    Sun Mar 22 08:53:36 2009
> > > -0300
> > > +++ b/linux/drivers/media/video/soc_camera.c    Thu Mar 26 15:35:43 2009
> > > +0100
> > > @@ -238,7 +238,7 @@ static int soc_camera_init_user_formats(
> > >     icd->num_user_formats = fmts;
> > >     fmts = 0;
> > > 
> > > -    dev_dbg(&icd->dev, "Found %d supported formats.\n", fmts);
> > > +    dev_dbg(&icd->dev, "Found %d supported formats.\n",
> > > icd->num_user_formats);
> > > 
> > >     /* Second pass - actually fill data formats */
> > >     for (i = 0; i < icd->num_formats; i++)
> > > 
> > > I thing this was wrong or ' fmts = 0;' must be under the output.
> > >     
> > 
> > Right, I'd prefer the latter though - to move the "fmts = 0;" assignment
> > down.
> > 
> >   
> Should I generate a PATCH or will you change it by our own?

Up to you. Patch is welcome. If you don't make one, I'll make it some time 
later with "Reported-by: <you>."

> > > @@ -675,8 +675,8 @@ static int soc_camera_cropcap(struct fil
> > >     a->bounds.height        = icd->height_max;
> > >     a->defrect.left            = icd->x_min;
> > >     a->defrect.top            = icd->y_min;
> > > -    a->defrect.width        = DEFAULT_WIDTH;
> > > -    a->defrect.height        = DEFAULT_HEIGHT;
> > > +    a->defrect.width        = icd->width_max;
> > > +    a->defrect.height        = icd->height_max;
> > >     a->pixelaspect.numerator    = 1;
> > >     a->pixelaspect.denominator    = 1;
> > > 
> > > What was the reason to use fix values? Because of the current
> > > implementation
> > > of crop,
> > > the default value can get bigger than the max value.
> > >     
> > 
> > Yes, you're right again, taking scaling into account. Although, setting
> > default to maximum doesn't seem a very good idea to me either. Maybe we'd
> > have to add an extra parameter to struct soc_camera_device, but I'm somewhat
> > reluctant to change this now, because all those fields from the struct will
> > have to disappear anyway with the v4l2-subdev transition, at which point, I
> > think, all these requests will have to be passed down to drivers.
> >   
> OK, what is the timetable / plan for the soc_camera to v4l2-subdev transition?

There's none. I have (almost) converted all currently in mainline drivers 
to the "soc-camera as a platform device" scheme, which is the first step 
of the conversion. I'll publish it then, so developers of other platforms 
and drivers could test it. Then I'll start the second step. Besides I'm 
constantly interrupted by other tasks, including the currently running 
merge window. So, on the one hand this work profits from me currently not 
having any paid job, on the other hand it suffers from me having to spend 
time looking for paid jobs:-)

> > > Is there some ongoing work regarding the crop implementation on
> > > soc_camera?
> > > If I understand the documentation [1] right, the crop vales should
> > > represent
> > > the area
> > > of the capture device before scaling. What was the reason for the current
> > > implementation
> > > combing crop and fmt values?
> > >     
> > 
> > See this discussion:
> > http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/68
> > besides, my idea was, that the user cannot be bothered with all scalings /
> > croppings that take place in host and client devices (on camera controllers
> > and / or sensors). My understanding was: the user uses S_FMT to request a
> > window of a certain size, say 640x480, the drivers shall try to fit as much
> > into it as possible using scaling. How many hardware pixels are now used to
> > build this VGA window the user has no idea about.
> If we use the real pixels for CROP, the user can calculate the scale.
> (see 1.11.3 Examples for "Image Cropping, Insertion and Scaling" in the
> documentation)

In the thread that I pointed you at there's a reply from Mauro, which, as 
far as we understood each other:-), confirms my understanding of format 
and cropping functionality. And to me it seems easier for the user to only 
work in one scale. But we can revisit this later, sure.

> > Then you can use S_CROP to select sub-windows from _that_ area. If you want
> > a different resolution, you use S_FMT again (after stopping the running
> > capture), etc. 
> Do you mean you can use S_CROP during a running capture?
> What happen if you change the width or height of the sub-windows. This will
> change the resolution
> / size of the image.
> 
> I only know the camera driver side of this functions and don't know how it is
> used,  but I would used
> S_FMT do set the output format and S_CROP to select the real sensor size and
> position.
> For example S_FMT with 320x240 set the sensor area to 1280x960 (max).

Ok, you mean the user retrieves CROP capabilities, sees 1280x960 as max, 
selects scale 4 and hence an output window of 320x240:

User request		Sensor window		Scale	User window
S_FMT(320x240)		1280x960		4:1	320x240

> S_CROP with 600x400 set
> the sensor area to 640x480, because this is the next supported scale (1,2,4,8)
> for the fix output format.
> If I understand the documentation right, S_CROP would use the old scale (4)
> and change the format to 200x100 to get the requested sensor area.

(wouldn't the user window be 160x120?) Here the user wants a window of 
150x100, so she uses the previously remembered scale of 4 to request 
600x400:

S_CROP(600x400)		640x480			4:1	160x120

> I think for now I take over your implementation of S_FMT and S_CROP.
> After the v4l2-subdev transition we can update the implementations.

With my implementation to achieve 160x120 at scale 4:1 you do just

S_FMT(320x240)		1280x960		4:1	320x240
S_CROP(160x120)		640x480			4:1	160x120

i.e., the user doesn't have to remember the scale. Which, IMHO, is easier 
for the user. Think about a visual "agent": if you change the window size, 
you work in terms of your output window size, i.e., you tell the X-server 
to put a window of 160x120 pixels. With the former approach you have to 
use different sizes for X and for the camera, with the latter one you only 
use one unit for both. That's my naive interpretation anyway:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
