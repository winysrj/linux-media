Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36047 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754517AbZCZRqw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 13:46:52 -0400
Date: Thu, 26 Mar 2009 18:47:03 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Questinons regarding soc_camera / pxa_camera
In-Reply-To: <49CBB13F.7090609@hni.uni-paderborn.de>
Message-ID: <Pine.LNX.4.64.0903261831430.5438@axis700.grange>
References: <49CBB13F.7090609@hni.uni-paderborn.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(moving to the new v4l list)

On Thu, 26 Mar 2009, Stefan Herbrechtsmeier wrote:

> --- a/linux/drivers/media/video/soc_camera.c    Sun Mar 22 08:53:36 2009 -0300
> +++ b/linux/drivers/media/video/soc_camera.c    Thu Mar 26 15:35:43 2009 +0100
> @@ -238,7 +238,7 @@ static int soc_camera_init_user_formats(
>     icd->num_user_formats = fmts;
>     fmts = 0;
> 
> -    dev_dbg(&icd->dev, "Found %d supported formats.\n", fmts);
> +    dev_dbg(&icd->dev, "Found %d supported formats.\n",
> icd->num_user_formats);
> 
>     /* Second pass - actually fill data formats */
>     for (i = 0; i < icd->num_formats; i++)
> 
> I thing this was wrong or ' fmts = 0;' must be under the output.

Right, I'd prefer the latter though - to move the "fmts = 0;" assignment 
down.

> 
> @@ -675,8 +675,8 @@ static int soc_camera_cropcap(struct fil
>     a->bounds.height        = icd->height_max;
>     a->defrect.left            = icd->x_min;
>     a->defrect.top            = icd->y_min;
> -    a->defrect.width        = DEFAULT_WIDTH;
> -    a->defrect.height        = DEFAULT_HEIGHT;
> +    a->defrect.width        = icd->width_max;
> +    a->defrect.height        = icd->height_max;
>     a->pixelaspect.numerator    = 1;
>     a->pixelaspect.denominator    = 1;
> 
> What was the reason to use fix values? Because of the current implementation
> of crop,
> the default value can get bigger than the max value.

Yes, you're right again, taking scaling into account. Although, setting 
default to maximum doesn't seem a very good idea to me either. Maybe we'd 
have to add an extra parameter to struct soc_camera_device, but I'm 
somewhat reluctant to change this now, because all those fields from the 
struct will have to disappear anyway with the v4l2-subdev transition, at 
which point, I think, all these requests will have to be passed down to 
drivers.

> Is there some ongoing work regarding the crop implementation on soc_camera?
> If I understand the documentation [1] right, the crop vales should represent
> the area
> of the capture device before scaling. What was the reason for the current
> implementation
> combing crop and fmt values?

See this discussion: 
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/68 
besides, my idea was, that the user cannot be bothered with all scalings / 
croppings that take place in host and client devices (on camera 
controllers and / or sensors). My understanding was: the user uses S_FMT 
to request a window of a certain size, say 640x480, the drivers shall try 
to fit as much into it as possible using scaling. How many hardware pixels 
are now used to build this VGA window the user has no idea about. Then you 
can use S_CROP to select sub-windows from _that_ area. If you want a 
different resolution, you use S_FMT again (after stopping the running 
capture), etc. Any other solution seemed too complicated and impractical 
to me.

Thanks
Guennadi
---
Guennadi Liakhovetski
