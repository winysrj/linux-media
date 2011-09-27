Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33089 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab1I0LRJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 07:17:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 2/4] v4l: add documentation for selection API
Date: Tue, 27 Sep 2011 13:17:07 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl, sakari.ailus@iki.fi
References: <1314793703-32345-1-git-send-email-t.stanislaws@samsung.com> <201109231513.22342.laurent.pinchart@ideasonboard.com> <4E7CA433.1000402@samsung.com>
In-Reply-To: <4E7CA433.1000402@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109271317.07571.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Friday 23 September 2011 17:22:27 Tomasz Stanislawski wrote:
> On 09/23/2011 03:13 PM, Laurent Pinchart wrote:

[snip]

> >>>> +<para>The composing targets refer to a memory buffer. The limits of
> >>>> composing +coordinates are obtained using<constant>
> >>>> V4L2_SEL_COMPOSE_BOUNDS</constant>. +All coordinates are expressed in
> >>>> pixels. The top/left corner is always point +<constant>
> >>>> {0,0}</constant>. The width and height is equal to the image size
> >>>> +specified using<constant>   VIDIOC_S_FMT</constant>.</para>
> >>> 
> >>> We support sub-pixel cropping, but not sub-pixel composition. Can you
> >>> remind me of the rationale for that ?
> >> 
> >> Do you mean that OMAP3 ISP supports cropping with sub-pixel resolution?
> > 
> > No, sorry. By "we" I meant the selection API.
> > 
> >> I thought that pixels are natural units for images stored in memory
> >> buffers. But I would not be surprised if there was some weird
> >> fractal-like format providing images with infinite resolution. Do you
> >> think that the sentence "All coordinates are expressed in pixel" should
> >> be dropped from spec?
> > 
> > I don't know to be honest. What bothers me is that the spec allows
> > sub-pixel resolution for cropping but not for composing. I'm not sure if
> > there's any hardware supported by our current drivers that could make
> > use of sub-pixel selections, but I don't see a reason to allow sub-pixel
> > cropping and not sub- pixel composing. The solution might be to disallow
> > sub-pixel cropping for now though. If we do that, can we later extend it
> > in a clean way ?
> 
> Video Processor (VP) chip that is part of s5p-tv hardware is capable of
> subpixel cropping using polyphase filters. So the hardware is already
> present.
> 
> I have to ideas to add subpixels to selection API.
> 
> 1. Introduce struct v4l2_frect similar to struct v4l2_rect. All its
> fields' type would be struct v4l2_fract.
> 2. Add field denominator to v4l2_selection as one of reserved fields.
> All selection coordinates would be divided by this number.
> 
> The 2nd proposal could added in the future update to selection API.

The second solution seems the simplest. Drivers will likely not support 
arbitrary denominators, so we also need a way to report the acceptable 
value(s) to userspace.

[snip]

> >>>> +<para>The part of a buffer that is modified by the hardware is given
> >>>> by +<constant>   V4L2_SEL_COMPOSE_PADDED</constant>. It contains all
> >>>> pixels defined +using<constant>   V4L2_SEL_COMPOSE_ACTIVE</constant> 
> >>>>  plus all padding data +modified by hardware during insertion
> >>>> process. All pixel outside this rectangle
> >>> 
> >>> s/All pixel/All pixels/
> >>> 
> >>>> +<emphasis>must not</emphasis>   be changed by the hardware. The
> >>>> content of pixels +that lie inside the padded area but outside active
> >>>> area is undefined. The +application can use the padded and active
> >>>> rectangles to detect where the +rubbish pixels are located and remove
> >>>> them if needed.</para>
> >>> 
> >>> How would an application remove them ?
> >> 
> >> The application may use memset if it recognizes fourcc. The idea of
> >> padding target was to provide information about artifacts introduced the
> >> hardware. If the image is decoded directly to framebuffer then the
> >> application could remove artifacts. We could introduce some V4L2
> >> control to inform if the padding are is filled with zeros to avoid
> >> redundant memset.
> >> What do you think?
> > 
> > OK, I understand this better now. I'm still not sure how applications
> > will be able to cope with that. memset'ing the garbage area won't look
> > good on the screen.
> 
> The memset is just a simple and usually fast solution. The application
> could fill the padding area with any pattern or background color.
> 
> > Does your hardware have different compose and padding rectangles ?
> 
> I assume that you mean active and padded targets for composing, right?
> The answer is yes. The MFC inserts data to the image that dimensions are
> multiples of 128x32. The movie inside could be any size that fits to the
> buffer. The area that contains the movie frame is the active rectangle.
> The padded is filled with zeros. For MFC the bounds and padded rectangle
> are the same.
> 
> Hmm...
> 
> Does it violate 'no margin requirement', doesn't it?

Seems so :-)

> >>>> +<para>   The driver may have to adjusts the requested dimensions
> >>>> against hardware +limits and other parts as the pipeline, i.e. the
> >>>> bounds given by the +capture/output window or TV display.  If
> >>>> constraints flags have to be violated +at any stage then ERANGE is
> >>>> returned.
> >>> 
> >>> You know that I still think that hints should be hints, and that ERANGE
> >>> should not be returned, right ? :-)
> >> 
> >> Yes.. :). There are pros and cons for hints, too.
> >> (+) hint can be ignored therefore is easier to implement them in
> >> drivers. It may speed up adoption of the selection api.
> >> (-) It is not possible to prevent hardware from applying the
> >> configuration that is not acceptable by the application. Such an
> >> unfortunate operation could mess up the whole pipeline.
> > 
> > Interesting point, I hadn't thought about it.
> > 
> >> I found two ways to solve the cons. The new ioctl TRY_SELECTION should
> >> be introduced now or in the future version of selection api. Second,
> >> the pipeline configuration rules may help in this case. An application
> >> should configure pipeline according to the rules. The setup of stages
> >> before the current stage is guaranteed to not modified. Therefore the
> >> unfortunate selection call could only mess up the stages lower in the
> >> pipeline.
> >> 
> >> The constraints idea was OK, until I found that the content of ioctl
> >> parameters is not copied to the userspace when the ioctl fails.
> >> Therefore the application receives no feedback other than ERANGE.
> >> Moreover I found out that is not easy to calculate the best-hit
> >> rectangle that could be returned. A lot of code must be added to driver
> >> to support it.
> >> 
> >> There is still one more problem with the hints. Examine following
> >> scenario. One tries to setup 20x20 rectangle using SEL_SIZE_LE hint.
> >> The ioctl succeeds but the driver returns 32x32. Does it mean?
> >> 
> >> (A) it is not possible to set a rectangle smaller than 20x20
> >> (B) it is not possible to set a rectangle smaller than 32x32
> >> (C) driver failed to configuration consistent with 20x20 (or smaller)
> >> rectangle.
> >> 
> >>         It is not known if such a configuration exists.
> >>         Should the application continue the negotiations?
> >>         Size 16x16 might be good, if the driver did not implement hint
> >> 
> >> [ignored them]
> >> 
> >>         and rounded 20x20 to 32x32.
> >> 
> >> The solution using constraints was consistent. The ERANGE is returned
> >> and case (A) is valid. If constraints were transformed to hints then we
> >> should allow to violate hints only if there is no configuration that
> >> satisfy the hints.
> > 
> > I agree with that, drivers must not violate hints if they can be
> > satisfied, otherwise they're completely pointless.
> 
> So the practical difference between hints and constraints is that
> with hints it is possible to apply configuration that is not accepted by
> application. Moreover, after calling {S/TRY}_SELECTION the driver must
> always return the best-hit rectangle, which may be difficult to compute,
> even if it will not be accepted by the application.
> 
> Surprisingly, it may be easier for the constraints to be implemented
> correctly than to implement the hint.

I think the driver should always return the best-hit rectangle, regardless of 
whether we use hints or not.

-- 
Regards,

Laurent Pinchart
