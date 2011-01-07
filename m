Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53973 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab1AGOP7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 09:15:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [RFC] Cropping and scaling with subdev pad-level operations
Date: Fri, 7 Jan 2011 15:16:42 +0100
Cc: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <201101061633.30029.laurent.pinchart@ideasonboard.com> <1294338536.5589.77.camel@morgan.silverblock.net>
In-Reply-To: <1294338536.5589.77.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101071516.42933.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Andy,

On Thursday 06 January 2011 19:28:56 Andy Walls wrote:
> On Thu, 2011-01-06 at 16:33 +0100, Laurent Pinchart wrote:
> > Hi everybody,
> > 
> > I ran into an issue when implementing cropping and scaling on the OMAP3
> > ISP resizer sub-device using the pad-level operations. As nobody seems
> > to be happy with the V4L2 crop ioctls, I thought I would ask for
> > comments about the subdev pad-level API to avoid repeating the same
> > mistakes.
> > 
> > A little background information first. The OMAP3 ISP resizer has an input
> > and an output pad. It receives images on its input pad, performs
> > cropping to a user-configurable rectange and then scales that rectangle
> > up or down to a user-configurable output size. The resulting image is
> > output on the output pad.
> > 
> > The hardware sets various restrictions on the crop rectangle and on the
> > output size, or more precisely on the relationship between them.
> > Horizontal and vertical scaling ratios are independent (at least
> > independent enough for the purpose of this discussion), so I'll will not
> > comment on one of them in particular.
> > 
> > The minimum and maximum scaling ratios are roughly 1/4 and x4. A complex
> > equation describes the relationship between the ratio, the cropped size
> > and the output size. It involves integer arithmetics and must be
> > fullfilled exactly, so not all combination of crop rectangle and output
> > size can be achieved.
> > 
> > The driver expects the user to set the input size first. It propagates
> > the input format to the output pad, resetting the crop rectangle. That
> > behaviour is common to all the OMAP3 ISP modules, and I don't think much
> > discussion is needed there.
> 
> I'll note here that the driver is allowing the application to make *two*
> assumptions here:
> 
> 	output size == input size
> and
> 	output pixel resolution == input pixel resolution
> 
> If I'm taking a picture of a building, at a distance from the building
> such that the input image has a resolution of 1 pixel per 5 cm in the
> plane of the building, then the output image also has a pixel resolution
> of 1 pixel per 5 cm in the plane of the building.

I'm not sure to follow you here. If the resizer upscales the image by 2, you 
will have 2 pixels per 5 cm at the output.

> > The user can then configure the crop rectangle and the output size
> > independently. As not all combinations are possible, configuring one of
> > them can modify the other one as a side effect.
> 
> What enforces the modification, the hardware or the driver?

The hardware requires several conditions to be fulfilled, and the driver 
enforces that.

> IMO, a crop should be a crop with no scaling or interpolation side
> effects.  If I have 1 pixel per 5 cm on the input, I should get 1 pixel
> per 5 cm on the output.

Correct, but I'm not talking about crop only. The OMAP3 ISP resizer first 
crops the input image, and then scales the cropped image to output a cropped 
and resized image.

> Changing the output size when setting a new crop window is IMO the
> correct thing to do since:
> 
> a. it maintains the pixel resolution (e.g. 1 pixel per 5 cm).
> 
> b. it is a predictable result that people and applications can rely upon
> 
> c. It fail due to any implicit zoom constraint violation
> 
> d. The application also knows what the new output size will be, since it
> just set the crop window to that same size
> 
> >  This is where problems come from.
> > 
> > Let's assume that the input size, the crop rectangle and the output size
> > are all set to 4000x4000. The user then wants to crop a 500x500
> > rectangle and scale it up to 750x750.
> > 
> > If the user first sets the crop rectangle to 500x500,  the 4000x4000
> > output size would result in a x8 scaling factor, not supported by the
> > resizer. The driver must then either modify the requested crop rectangle
> > or the output size to fullfill the hardware requirements.
> 
> My suggestion is to have the driver modify the output size as a side
> effect.  Changing the output size already happens as a side effect when
> the application sets the input size.

That's what we're currently doing, but it introduces an issue, see below.

> > If the user first sets the output size to 750x750 we end up with a
> > similar problem, and the driver needs to modify one of crop rectangle or
> > output size as well.
> > 
> > When the stream is on, the output size can't be modified as it would
> > change the captured frame size.
> 
> Hmm.
> 
> >  The crop rectangle and scaling ratios, on the other
> > 
> > hand, can be modified to implement digital zoom. For that reason, the
> > resizer driver doesn't modify the output size when the crop rectangle is
> > set while a stream is running, but restricts the crop rectangle size.
> > With the above example as a starting point, requesting a 500x500 crop
> > rectangle, which would result in an unsupported x8 zoom, will return a
> > 1000x1000 crop rectangle.
> 
> But in this situation - fixed input size, fixed output size - you know
> exactly what scaling levels are supported, 1/4x to 4x, right?

The driver know what scaling factors are supported, but applications don't.

> It sounds like this can be hidden from userpace with different behavior
> inside the driver for the crop and scale API calls when streaming.
> 
> 1.  When streaming, a single crop or scale API request from userspace
> would cause the driver to command all the required underlying crop and
> scale operations for the resizer.
> 
> 2. When streaming stops, either
> a. require the applications to query the state of the crop window and
> output size, or
> b. require drivers to revert to the original crop and scale settings
> that were in place before streaming started
> 
> Bad idea?

I don't like 2.b., there's no real reason to revert the settings. As for 1., 
what do you mean about a "single crop or scale API request" ? Scaling is 
currently requested by modifying the input and/or output sizes (the input size 
being the cropped rectangle in this case). While streaming, digital zoom is 
thus performed by modifying the crop rectangle, without touching the output 
size.

> > When the stream is off, we have two options:
> > 
> > - Handle crop rectangle modifications the same way as when the stream is
> > on. This is cleaner, but bring one drawback. The user can't set the crop
> > rectangle to 500x500 and output size to 750x750 directly. No matter
> > whether the crop rectangle or output size is set first, the intermediate
> > 500x5000/4000x4000 or 4000x4000/750x750 combination are invalid. An
> > extra step will be needed: the crop rectangle will first be set to
> > 1000x1000, the output size will then be set to 750x750, and the crop
> > rectangle will finally be set to 500x500. That won't make life easy for
> > userspace applications.
> 
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> There's a reason why you shouldn't choose this option.
> 
> Are the constraints between crop and output size going to be the same
> for every resizer hardware variant or every driver?

I don't know, I don't have enough experience with similar hardware.

> > - Modify the output size when the crop rectangle is set. With this
> > option, the output size is automatically set to the crop rectangle size
> > when the crop rectangle is changed. With the above example, setting the
> > crop rectangle to 500x500 will automatically set the output size to
> > 500x500, and the user will then just have to set the output size to
> > 750x750.
> 
> I like this one.  The result of the side effect is easily understood and
> should be easy to implement for different hardware using the same API.

I agree, and that's what the resizer driver currently implements. The issue 
with this is described in my previous e-mail: applications can't query the 
maximum zoom factor (or rather the minimum input crop rectangle size).

> > The second option has a major drawback as well, as there's no way for
> > applications to query the minimum/maximum zoom factor. With the first
> > option an application can set the desired output size, and then set a
> > very small crop rectangle to retrieve the minimum allowed crop rectangle
> > (and thus the maximum zoom factor). With the second option the output
> > size will be changed when the crop rectangle is set, so this isn't
> > possible anymore.
> > 
> > Retrieving the maximum zoom factor in the stream off state is an
> > application requirement to be able to display the zoom level on a GUI
> > (with a slider for instance).
> 
> The application trying to make indirect behavior measurements to
> determine maximum/minimum zoom seems odd.  Why can't the driver just
> report those directly via some control or query?  The driver should know
> the answer.

Setting the crop rectangle is such a query :-) What else would you use ?

> > The OMAP3 ISP resizer currently implements the second option, and I'll
> > modify it to implement the first option. The drawback is that some
> > crop/output combinations will require an extra step to be achieved. I'd
> > like your opinion on this issue.
> 
> I'll opine for option 2.
> 
> > Is the behaviour described in option one acceptable ?
> 
> Is it possible to implement consistent behavior across all resizer
> drivers, or will applications need apriori knowledge of the constraints
> of underlying hardware device just to crop and scale an image?

I don't know what constraints similar resizer hardware have, so I can't answer 
this.

> > Should the API be extended/modified to make it simpler for applications to
> > configure the various sizes in the image pipeline ?
> > 
> >  Are we all doomed and will we have to use a crop/scale API that nobody
> >  will ever understand ? :-)
> 
> I don't know.  It would be an interesting exercise to
> 
> 1. collect the assumptions people and applications currently make for a
> "crop" function and a "scale" function

Hence this RFC :-)

> 2. look at what behavior and assumptions our current API and drivers
> make for "crop" and "scale" functions
> 
> 3. determine what assumptions or behaviors can be supported across
> different hardware/software resizer units, not just the OMAP.

Thank you for your answer.

-- 
Regards,

Laurent Pinchart
