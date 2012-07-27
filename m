Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57916 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab2G0JfS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jul 2012 05:35:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC] omap3-isp G_FMT & ENUM_FMT
Date: Fri, 27 Jul 2012 11:35:21 +0200
Message-ID: <1772349.addfYp7k4f@avalon>
In-Reply-To: <50125A66.80104@matrix-vision.de>
References: <1343303996-16025-1-git-send-email-michael.jones@matrix-vision.de> <7135672.xS20ZCiE6C@avalon> <50125A66.80104@matrix-vision.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 27 July 2012 11:07:50 Michael Jones wrote:
> Hi Laurent,
> 
> On 07/27/2012 01:32 AM, Laurent Pinchart wrote:
> > Hi Michael,
> > 
> > On Thursday 26 July 2012 16:22:17 Michael Jones wrote:
> >> On 07/26/2012 04:05 PM, Laurent Pinchart wrote:
> >>> On Thursday 26 July 2012 13:59:54 Michael Jones wrote:
> >>>> Hello,
> >>>> 
> >>>> I would like to (re)submit a couple of patches to support V4L2 behavior
> >>>> at the V4L2 device nodes of the omap3-isp driver, but I'm guessing they
> >>>> require some discussion first.
> >>> 
> >>> Indeed.
> >>> 
> >>> The main reason why the OMAP3 ISP driver implements G_FMT/S_FMT as it
> >>> does today is to hack around a restriction in the V4L2 API. We needed a
> >>> way to preallocate and possibly prequeue buffers for snapshot, which
> >>> wasn't possible in a standard-compliant way back then.
> >>> 
> >>> The situation has since changed, and we now have the VIDIOC_CREATE_BUFS
> >>> and VIDIOC_PREPARE_BUF ioctls. My plan is to
> >>> 
> >>> - port the OMAP3 ISP driver to videobuf2
> >>> - implement support for CREATE_BUFS and PREPARE_BUF
> >>> - fix the G_FMT/S_FMT/ENUM_FMT behaviour
> >> 
> >> What will the G_FMT/S_FMT/ENUM_FMT behavior be then?  Can you contrast
> >> it with the behavior of my patches?  If the behavior will be the same
> >> for user space, and your proposed changes won't be in very soon, can we
> >> use my patches until you make your changes?
> > 
> > At the moment the driver accepts any format you give it in a S_FMT call,
> > regardless of the format of the connected pad. The reason for that is to
> > allow VIDIOC_REQBUFS to allocate buffers for an arbitrary size.
> > 
> > With CREATE_BUFS and PREPARE_BUFS support, G_FMT, S_FMT and ENUM_FMT
> > should return the format of the connected pad.
> 
> OK, so this sounds like the same behavior I'd like to add before
> CREATE_BUFS and PREPARE_BUFS support is in.  My other question was if
> this is the case, can we use my approach until your planned changes are in?

We can't, as it would break the use case of preallocating buffers without 
providing any alternative solution. That's why I haven't fixed the 
G_FMT/S_FMT/ENUM_FMT issue yet.

-- 
Regards,

Laurent Pinchart

