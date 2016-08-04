Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41158 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933629AbcHDOqK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2016 10:46:10 -0400
Date: Thu, 4 Aug 2016 17:38:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCHv2] v4l2-common: add s_selection helper function
Message-ID: <20160804143813.GL3243@valkosipuli.retiisi.org.uk>
References: <c6379bf1-4fdf-7deb-4312-86d26d0ee106@xs4all.nl>
 <20160804140313.GI3243@valkosipuli.retiisi.org.uk>
 <aa119982-53c6-37bf-d019-b6ccd27b5c8a@xs4all.nl>
 <20160804141734.GK3243@valkosipuli.retiisi.org.uk>
 <b343ec5f-0c03-ae92-ef92-a051b23060ca@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b343ec5f-0c03-ae92-ef92-a051b23060ca@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Aug 04, 2016 at 04:27:27PM +0200, Hans Verkuil wrote:
> 
> 
> On 08/04/2016 04:17 PM, Sakari Ailus wrote:
> > On Thu, Aug 04, 2016 at 04:11:55PM +0200, Hans Verkuil wrote:
> >>
> >>
> >> On 08/04/2016 04:03 PM, Sakari Ailus wrote:
> >>> Hi Hans,
> >>>
> >>> On Mon, Aug 01, 2016 at 12:33:39PM +0200, Hans Verkuil wrote:
> >>>> Checking the selection constraint flags is often forgotten by drivers, especially
> >>>> if the selection code just clamps the rectangle to the minimum and maximum allowed
> >>>> rectangles.
> >>>>
> >>>> This patch adds a simple helper function that checks the adjusted rectangle against
> >>>> the constraint flags and either returns -ERANGE if it doesn't fit, or fills in the
> >>>> new rectangle and returns 0.
> >>>>
> >>>> It also adds a small helper function to v4l2-rect.h to check if one rectangle fits
> >>>> inside another.
> >>>
> >>> I could have misunderstood the purpose of the patch but... these flags are
> >>> used by drivers in guidance in adjusting the rectangle in case there are
> >>> hardware limitations, to make it larger or smaller than requested if the
> >>> request can't be fulfillsed as such. The intent is *not* to return an error
> >>> back to the user. In this respect it works quite like e.g. S_FMT does in
> >>> cases an exact requested format can't be supported.
> >>>
> >>> <URL:https://www.linuxtv.org/downloads/v4l-dvb-apis/apb.html#v4l2-selection-flags>
> >>>
> >>> What can be done is rather driver specific.
> >>>
> >>
> >> That's not what the spec says:
> >>
> >> https://hverkuil.home.xs4all.nl/spec/uapi/v4l/vidioc-g-selection.html
> >>
> >> ERANGE
> >> It is not possible to adjust struct v4l2_rect r rectangle to satisfy all constraints given in the flags argument.
> >>
> >> It's rather unambiguous, I think.
> >>
> >> If you don't want an error, then just leave 'flags' to 0. That makes sense.
> > 
> > Does it? I can't imagine a use case for that.
> 
> That's just the standard behavior: "I'd like this selection rectangle, but adjust
> however you like it to something that works."

That's not how this patch works though: it returns an error instead.

> 
> > The common section still defines these flags differently, and that's the
> > behaviour on V4L2 sub-device interface. Do we have a driver that implements
> > support for these flags as you described?
> > 
> 
> A quick check: fimc-capture, gsc-m2m, am437, vivid, fimc-lite, bdisp.
> 
> Note that VIDIOC_SUBDEV_S_SELECTION doesn't specify an ERANGE error, but I don't know
> if that is intentional or an oversight. At least smiapp-core.c doesn't return an error.

Please read the description of the flags in common documentation. The smiapp
driver implements them as described in the common and V4L2 sub-device
documentation:

<URL:https://www.linuxtv.org/downloads/v4l-dvb-apis/subdev.html#v4l2-subdev-selections>
<URL:https://www.linuxtv.org/downloads/v4l-dvb-apis/apb.html#v4l2-selection-flags>

I.e. they affect rounding in the case where an exact match can't be found,
hardware limitations taken into account. The V4L2 behaviour can be
implemented using the common / sub-device flag definitions but not the other
way around, so we don't necessary have a problem here. It's just that
returning an error in such a case doesn't really make much sense.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
