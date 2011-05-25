Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53246 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab1EYNnv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 09:43:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 0/2] V4L: Extended crop/compose API
Date: Wed, 25 May 2011 15:43:58 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	sakari.ailus@maxwell.research.nokia.com
References: <1304588396-7557-1-git-send-email-t.stanislaws@samsung.com> <201105232329.24524.laurent.pinchart@ideasonboard.com> <4DDBA481.70605@samsung.com>
In-Reply-To: <4DDBA481.70605@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105251543.59679.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Tomasz,

On Tuesday 24 May 2011 14:28:49 Tomasz Stanislawski wrote:
> Laurent Pinchart wrote:
> > On Wednesday 18 May 2011 18:55:51 Tomasz Stanislawski wrote:
> >> Laurent Pinchart wrote:
> >>> On Saturday 14 May 2011 12:50:32 Hans Verkuil wrote:
> >>>> On Friday, May 13, 2011 14:43:08 Laurent Pinchart wrote:
> >>>>> On Saturday 07 May 2011 13:52:25 Hans Verkuil wrote:
> >>>>>> On Thursday, May 05, 2011 11:39:54 Tomasz Stanislawski wrote:

[snip]

> >> Solution I (more restrictive):
> >> 0 - driver is free to adjust size, it is recommended to choose the
> >> crop/compose rectangle as close as possible to desired one
> >> 
> >> SEL_SIZE_GE - drive is not allowed to shrink the rectangle. If no such a
> >> rectangle exists ERANGE is returned (EINVAL is used for
> >> not-understandable configuration)
> >> 
> >> SEL_SIZE_LE - drive is not allowed to grow the rectangle. If no such a
> >> rectangle exists ERANGE is returned (EINVAL is used for
> >> not-understandable configuration)
> >> 
> >> SEL_SIZE_EQ = SEL_SIZE_GE | SEL_SIZE_LE - choose size exactly the same
> >> as in desired rectangle. Return ERANGE if such a configuration is not
> >> possible.
> > 
> > So SEL_SIZE_EQ would be identical to 0, except that ERANGE would be
> > returned if the resulting configuration is not equal to the requested
> > configuration.
> > 
> >> -----------------------------------------
> >> 
> >> Solution II (less restrictive). Proposed in this RFC.
> >> 
> >> 0 - apply rectangle as close as possible to desired one like the default
> >> behavior of  VIDIOC_S_CROP.
> >> 
> >> SEL_SIZE_GE - suggestion to increase or keep size of both coordinates
> >> 
> >> SEL_SIZE_LE - suggestion to decrease or keep size of both coordinates
> >> 
> >> SEL_SIZE_GE | SEL_SIZE_LE - technically suggestion to "increase or keep
> >> or decrease" sizes. Basically, it means that driver is completely free
> >> to choose coordinates. It works like saying "give me a crop similar to
> >> this one" to the driver. I agree that it is not "a very useful"
> >> combination of flags.
> > 
> > I don't see any difference between that and 0. Drivers will implement
> > both the same way.
> > 
> >> In both solutions, the driver is recommended to keep the center of the
> >> rectangle in the same place.
> >> 
> >> Personally, I prefer 'solution I' because it is more logical one.
> >> One day, the SEL_SIZE_GE could be expanded to LEFT_LE | RIGHT_GE |
> >> TOP_LE | BOTTOM_GE flags if drivers could support it.
> > 
> > But why return ERANGE ? That's one extra check in the driver that could
> > easily be done in userspace. And it won't be very useful to
> > applications, knowing that the driver doesn't support one exact
> > configuration won't help the application finding out how to use the
> > hardware. Applications will likely use 0 instead of SEL_SIZE_EQ. If we
> > got for solution I, I think we should disallow SEL_SIZE_LE |
> > SEL_SIZE_GE. It's just not useful.
> 
> Hi Laurent,
> You are right that the check could be done in the userspace.
> However I think it is better to do it in driver or V4L2 framework
> because of following reasons:
> 
> 1. Checking by an application is a redundant work:
> - application specifies constraint flags
> - application checks if returned coordinates suit to the flags,
>    so demands are implemented twice by passing flags and making checks,
>    it may lead to error prone code and difficult to detect bugs.
> - the code for checking of coordinates would be duplicated in every
> application that would use SELECTION
> 
> 2. Coordinate checking could be done by v4l2 framework. I mean adding a
> function like one below:
> int v4l2_selection_check_rect(const struct v4l2_rect *adjusted, const
> struct v4l2_rect *desired, int flags)
> 
> The function whould be called by driver after initial adjustments.
> The function returns -ERANGE if coordinates of adjusted rectangle do not
> suit to desired one basing on constraint flags.
> 
> 3. It is easier to add new flags if checking is controlled by
> driver/v4l2 framework (including libv4l2).
> 
> 4. Successful S_SELECTION may change format set by S_FMT
> - if adjusted rectangle does not suit to application's demands then
> falling back to other crop resolution requires to reconfigure the
> pipeline (calling S_FMT again).
> - therefore S_SELECTION should fail if it not possible to satisfy
> applications constraints and leave the hardware configuration intact

We need to define how S_SELECTION and S_FMT will interact before I can answer 
this :-) The LE | GE behaviour is a detail though, so I think we can postpone 
the decision and work on S_SELECTION/S_FMT/S_WHATEVER interaction first.

> 5. Some application may want to have a fixed crop resolution, others may
> allow adjustment. I think that API should let applications explicitly
> decide which treatment they prefer and using SIZE_EQ is an intuitive way
> to force fixed coordinates. If the application if forced to use a fixed
> crop resolution. Without SIZE_EQ the application has to to a lot of
> checks only to detect that the resolution is not applicable.
> The application that use SIZE_* flags knows failure may happen.

(In response to 1-3 and 5) Our current policy with most format-related ioctls 
is that the driver has to respond to a user request in a "best effort" way. 
This means the driver tries to honor the request as much as possible, and 
returns what it can achieve. It's then up to the application to use that 
information to implement application-specific policies. I think that a hint 
that would require the driver to return an error would not be consistent with 
the API, and that inconsistency wouldn't bring any added value.

-- 
Regards,

Laurent Pinchart
