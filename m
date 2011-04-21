Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34521 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab1DUITi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2011 04:19:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 0/2] V4L: Extended crop/compose API, ver2
Date: Thu, 21 Apr 2011 10:19:29 +0200
References: <1302079459-4018-1-git-send-email-t.stanislaws@samsung.com> <201104131507.55171.laurent.pinchart@ideasonboard.com> <4DADB1FF.3090506@samsung.com>
In-Reply-To: <4DADB1FF.3090506@samsung.com>
MIME-Version: 1.0
Message-Id: <201104211019.31714.laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Tomasz,

On Tuesday 19 April 2011 18:02:07 Tomasz Stanislawski wrote:
> Hi Laurent,
> 
> > I wish it would be that simple. Let me show you an example, taken from
> > the OMAP3 ISP resizer driver. The following equation comes from the
> > OMAP3 ISP documentation and describes the relationship between the
> > resizer input width (after cropping) and output width.
> 
> I analyzed your comments. It looks that selection of cropping parameters
> using hints is an example of integer linear programming. This problem is
> NP-hard in general. Therefore I think we should allow driver to
> completely ignore hints.

If we allow drivers to ignore hints, many of them will, and applications won't 
be able to rely on the hints being correctly handled. Won't that be an issue ?

> > iw = (32 * sph + (ow - 1) * hrsz + 16) >> 8 + 7
> > 
> > iw is the input width, ow the output width, hrsz the horizontal scaling
> > factor, and sph a constant. All variables are integers.
> > 
> > The equation must be verified perfectly, otherwise the hardware will
> > fail. The driver needs to compute the hrsz value based on the iw and ow
> > values provided by the user. As the equation doesn't accept a solution
> > for all (iw, ow) tuples, iw (the crop rectangle width) needs to be
> > adjusted. This is where hints would come into play.
> > 
> > The following equation is equivalent to the first one
> > 
> > iw - 7 = (32 * sph + (ow - 1) * hrsz + 16) >> 8
> > 
> > but this one isn't
> > 
> > (iw - 7) << 8 = 32 * sph + (ow - 1) * hrsz + 16
> > 
> > as the >> 8 operator looses the 8 least significant bits of it's left
> > operand, so you can't revert the operation.
> > 
> > Try to reverse the equation to compute the hrsz and adjusted iw values
> > for different hint flags and you will feel my pain. I'm pretty sure some
> > hardware (will) have even more complex requirements.
> 
> I think that the problem of ISP configuration could be solved in
> following way:
> 
> iw - 7 = (32 * sph + (ow - 1) * hrsz + 16) >> 8
> 
> is equivalent to:
>     256 * (iw - 7) <=32 * sph + (ow - 1) * hrsz + 16 <= 256 * (iw - 7) +
> 255 what can be reduced to:
>     256 * iw + A <= (ow - 1) * hrsz <= 256 * iw + B
> where
>     A = -1808 - 32 * sph
>     B = -1553 - 32 * sph
> What can written as:
>     L(iw) <= hrsz <= U(iw)
>     L(iw) = ceil( (256 * iw + A) / (ow - 1) )
>     U(iw) = floor((256 * iw + B) / (ow - 1) )
> 
> The solution can be computed by linear search assuming that pixel format
> is fixed and ow cannot change.
> The hints are used here.
> 
> If V4L2_SEL_WIDTH_GE is set
>     iw = v4l2_selection::r::width
>     l = L(iw); // lower bound on hrsz
>     u = U(iw); //upper bound on hrsz
>     while (iw <= iwmax && l <= hrszmax) {
>        if (l <= u && l >= hrszmin)
>           return l; //found solution
>        ++iw;
>        l = L(iw);
>        u = U(iw);
>     }
> 
> If V4L2_SEL_WIDTH_LE is set
>     iw = v4l2_selection::r::width
>     l = L(iw); // lower bound on hrsz
>     u = U(iw); //upper bound on hrsz
>     while (iw >= iwmin && u >= hrszmin) {
>        if (l <= u && u <= hrszmax)
>           return u; //found solution
>        --iw;
>        l = L(iw);
>        u = U(iw);
>     }
> 
> If both flags are set then try to compute correct hrsz directly.
> Code above could be optimized a bit by using higher of increase of iw
> after every loop.
> The search procedure is relatively slow but it finishes after at most
> few thousands iterations.
> If set crop operation is rare then this solution may be acceptable.
> What is your opinion?

I've thought about using an iterative approach, but I don't really like it.

As you correctly found out, reverting the equation leads to an inequality.

256 * (iw - 7) <= 32 * sph + (ow - 1) * hrsz + 16 <= 256 * (iw - 7) + 255

We found out that using

32 * sph + (ow - 1) * hrsz + 16 = 256 * (iw - 7) + 255

and thus

hrsz = floor(((iw - 7) * 256 + 255 - 16 - 32 * sph) / (ow - 1))

gives the hrsz value that produces the highest iw value lower or equal to the 
requested one. This corresponds to the LE hint. We decided to stop there, as 
we found no easy way to implement the GE hint.

[snip]

> >>>>>> 5. Possible improvements and extensions.
> >>>>>> - combine composing and cropping ioctl into a single ioctl
> >>>>> 
> >>>>> I think this could be very interesting. By doing this in a single
> >>>>> ioctl you should have all the information needed to setup a scaler.
> >>>>> And with the hints you can tell the driver how the input/output
> >>>>> rectangles need to be adjusted.
> >>> 
> >>> You would still need S_FMT to define the size of the captured (output)
> >>> image for capture (output) devices.
> >> 
> >> Frankly, I think that there is a general flaw in a purpose of S_FMT.
> >> In V4l2, there are following entities and associated ioctl used for
> >> configuration:
> >> analog TV input/output - VIDIOC_S_STD
> >> digital TV input/output - VIDIOC_S_DV_PRESET
> >> audio  input - VIDIOC_S_AUDIO
> >> memory buffer - VIDIOC_S_FMT
> >> 
> >> Now I ask:
> >> Why S_CROP can change a format in memory buffer (width and size) but it
> >> is not allowed to change DV preset?
> >> Why symmetry is broken between these entities?
> >> 
> >> In my opinion, a format should stay fixed after successful VIDIOC_S_FMT.
> >> It would mean that width and height of an image must not be changed by
> >> CROP/COMPOSE setup.
> >> For input devices, if an image is too large for desired cropping
> >> rectangle then a buffer's composing rectangle is adjusted. So data from
> >> a sensor are blit on a part of an image. If HW did not support buffer
> >> composing then it would return EINVAL or increase cropping rectangle if
> >> hints allow this.
> >> 
> >> Using this treat CROP/COMPOSE ioctls could be merged. Driver could
> >> adjust crop/compose rectangle simultaneously  according to its scaling
> >> capabilities. No adjustment of resolution of input data, output data.
> >> Moreover no memory management would be involved because a buffer size
> >> would not change. I think it may greatly simply driver's code.
> >> 
> >> BTW: I think that sensors need some dedicated ioctl for configuration
> >> similar to ioctls available for other entities (like S_DV_PRESET or more
> >> general S_DV_TIMINGS).
> > 
> > What you're proposing is essentially dropping the existing crop/fmt
> > ioctls, and creating new well-thought ones.
> > 
> > Let's keep in mind that we have two classes of hardware. Most consumer
> > devices can be controlled through a single V4L2 device node. The format
> > and crop ioctls are used to perform cropping and scalling. If we want a
> > consistent API for that kind of devices, we need to consider the device
> > as implementing a simple pre-defined pipeline (similar to input ->
> > scaler -> devnode), and map the device node ioctls to that pipeline.
> > Users will then be able to understand what the ioctls do and how they
> > interact with eachother.
> 
> Current definition of configuration of cropping and scaling is difficult
> to understand.
> New API for buffer allocation (VIDIOC_CREATEBUF, ...) is comming.
> Therefore I think it would a good idea to separate memory management from
> cropping control.
> Maybe S_FMT should only introduce bounds for composing functionality in
> case of capture devices?
> Do you know how many application makes use of CROP ioctls?

I don't know. Probably not many, but still a handful.

> > The second class of devices include all other devices, which don't
> > conform to that simple virtual pipeline. They should be managed with the
> > media controller API. I don't think we will ever be able to define a
> > consistent API at the V4L2 device node level for any kind of arbitrary
> > device.
> 
> In media controller there is still need to configure both compose and
> crop at the same time.

That's correct, but they will be configured at the subdev level, with subdev 
ioctls. We still need to define proper crop and compose ioctls there. My point 
was that the V4L2 devnode crop and compose ioctls don't need to solve all 
problems, they just need to be able to handle the simple input -> scaler -> 
devnode pipeline.

> Maybe passing table of v4l2_selection, every one with different targets?

That could work. We would also need a pad number field in the table entries 
for the subdev crop/compose ioctls.

-- 
Regards,

Laurent Pinchart
