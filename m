Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40377 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab1IWNN0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 09:13:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 2/4] v4l: add documentation for selection API
Date: Fri, 23 Sep 2011 15:13:18 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl, sakari.ailus@iki.fi
References: <1314793703-32345-1-git-send-email-t.stanislaws@samsung.com> <201109230041.27712.laurent.pinchart@ideasonboard.com> <4E7C7D63.7070504@samsung.com>
In-Reply-To: <4E7C7D63.7070504@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109231513.22342.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Friday 23 September 2011 14:36:51 Tomasz Stanislawski wrote:
> On 09/23/2011 12:41 AM, Laurent Pinchart wrote:
> 
> Hi Laurent,
> Thank you for the review.

Your welcome. Sorry once again for the delay.

> It looks that spelling highlighting is not enough :).

That's what review is for :-)

> I discussed some of your comments. There are still some open issues.
> 
> > On Wednesday 31 August 2011 14:28:21 Tomasz Stanislawski wrote:

[snip]

> >> +<section>
> >> +
> >> +<title>Configuration of video capture</title>
> >> +
> >> +<para>See the figure<xref linkend="sel-targets-capture" />  for
> >> examples of the
> > 
> > s/the figure/figure/
> > 
> >> +selection targets available for a video capture device. The targets
> >> should be +configured according to the pipeline configuration rules for
> >> a capture device.
> > 
> > Do we have such rules written somewhere ?
> 
> The pipeline configuration rules are not a part of V4L2 doc yet. It was
> discussed at IRC meeting.
> Do you think that the RFC should be posted in separate patch to V4L2 doc?

As this document refers to them, I think that would be useful. We're talking 
about pipeline configuration using the video nodes API, right ?

[snip]

> >> +<para>The composing targets refer to a memory buffer. The limits of
> >> composing +coordinates are obtained using<constant> 
> >> V4L2_SEL_COMPOSE_BOUNDS</constant>. +All coordinates are expressed in
> >> pixels. The top/left corner is always point +<constant> 
> >> {0,0}</constant>. The width and height is equal to the image size
> >> +specified using<constant>  VIDIOC_S_FMT</constant>.</para>
> > 
> > We support sub-pixel cropping, but not sub-pixel composition. Can you
> > remind me of the rationale for that ?
> 
> Do you mean that OMAP3 ISP supports cropping with sub-pixel resolution?

No, sorry. By "we" I meant the selection API.

> I thought that pixels are natural units for images stored in memory
> buffers. But I would not be surprised if there was some weird fractal-like
> format providing images with infinite resolution. Do you think that the
> sentence "All coordinates are expressed in pixel" should be dropped from
> spec?

I don't know to be honest. What bothers me is that the spec allows sub-pixel 
resolution for cropping but not for composing. I'm not sure if there's any 
hardware supported by our current drivers that could make use of sub-pixel 
selections, but I don't see a reason to allow sub-pixel cropping and not sub-
pixel composing. The solution might be to disallow sub-pixel cropping for now 
though. If we do that, can we later extend it in a clean way ?

[snip]

> >> +<para>For capture devices the default composing rectangle is queried
> >> using +<constant>  V4L2_SEL_COMPOSE_DEFAULT</constant>  and it is
> >> always equal to +bounding rectangle.</para>
> > 
> > If they're always equal, why do we have two different targets ? :-) Maybe
> > "is usually identical to" or "is most of the time identical to" would be
> > better ?
> 
> Good question. I remember that once Hans has said that there should be
> no margins in an image if no selection ioctl was used. Therefore I decided
> that default and bounds rectangles should be equal for video capture.
> I am interested what is Hans' opinion about proposal of softening this
> requirement.

I think it's a good requirement for now, but we might find use cases later 
that would conflict with the requirement. If we just say that the rectangles 
must be identical, applications might use the BOUNDS target instead of the 
DEFAULT target to retrieve the default rectangle (if they're identical, why 
should they bother ?). I'd like to reword the spec to make it clear that that 
drivers must (at least for now) have identical defaults and bounds, and that 
application must use the DEFAULT target to retrieve the default rectangle in 
case the driver-side requirement gets lifted later.

> >> +<para>The part of a buffer that is modified by the hardware is given by
> >> +<constant>  V4L2_SEL_COMPOSE_PADDED</constant>. It contains all pixels
> >> defined +using<constant>  V4L2_SEL_COMPOSE_ACTIVE</constant>  plus all
> >> padding data +modified by hardware during insertion process. All pixel
> >> outside this rectangle
> > 
> > s/All pixel/All pixels/
> > 
> >> +<emphasis>must not</emphasis>  be changed by the hardware. The content
> >> of pixels +that lie inside the padded area but outside active area is
> >> undefined. The +application can use the padded and active rectangles to
> >> detect where the +rubbish pixels are located and remove them if
> >> needed.</para>
> > 
> > How would an application remove them ?
> 
> The application may use memset if it recognizes fourcc. The idea of
> padding target was to provide information about artifacts introduced the
> hardware. If the image is decoded directly to framebuffer then the
> application could remove artifacts. We could introduce some V4L2
> control to inform if the padding are is filled with zeros to avoid
> redundant memset.
> What do you think?

OK, I understand this better now. I'm still not sure how applications will be 
able to cope with that. memset'ing the garbage area won't look good on the 
screen.

Does your hardware have different compose and padding rectangles ?

[snip]

> >> +<para>  The driver may have to adjusts the requested dimensions against
> >> hardware +limits and other parts as the pipeline, i.e. the bounds given
> >> by the +capture/output window or TV display.  If constraints flags have
> >> to be violated +at any stage then ERANGE is returned.
> > 
> > You know that I still think that hints should be hints, and that ERANGE
> > should not be returned, right ? :-)
> 
> Yes.. :). There are pros and cons for hints, too.
> (+) hint can be ignored therefore is easier to implement them in drivers.
> It may speed up adoption of the selection api.
> (-) It is not possible to prevent hardware from applying the configuration
> that is not acceptable by the application. Such an unfortunate operation
> could mess up the whole pipeline.

Interesting point, I hadn't thought about it.

> I found two ways to solve the cons. The new ioctl TRY_SELECTION should be
> introduced now or in the future version of selection api. Second, the
> pipeline configuration rules may help in this case. An application should
> configure pipeline according to the rules. The setup of stages before the
> current stage is guaranteed to not modified. Therefore the unfortunate
> selection call could only mess up the stages lower in the pipeline.
> 
> The constraints idea was OK, until I found that the content of ioctl
> parameters is not copied to the userspace when the ioctl fails. Therefore
> the application receives no feedback other than ERANGE. Moreover I found out
> that is not easy to calculate the best-hit rectangle that could be returned.
> A lot of code must be added to driver to support it.
> 
> There is still one more problem with the hints. Examine following scenario.
> One tries to setup 20x20 rectangle using SEL_SIZE_LE hint. The ioctl
> succeeds but the driver returns 32x32. Does it mean?
> 
> (A) it is not possible to set a rectangle smaller than 20x20
> (B) it is not possible to set a rectangle smaller than 32x32
> (C) driver failed to configuration consistent with 20x20 (or smaller)
> rectangle.
>        It is not known if such a configuration exists.
>        Should the application continue the negotiations?
>        Size 16x16 might be good, if the driver did not implement hint
> [ignored them]
>        and rounded 20x20 to 32x32.
> 
> The solution using constraints was consistent. The ERANGE is returned and
> case (A) is valid. If constraints were transformed to hints then we should
> allow to violate hints only if there is no configuration that satisfy the
> hints.

I agree with that, drivers must not violate hints if they can be satisfied, 
otherwise they're completely pointless.

> What is your opinion about it?

I won't fight too much against a constraint-based approach :-) Not that you 
convinced me that constraints are better, but I can live with them.

-- 
Regards,

Laurent Pinchart
