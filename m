Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48921 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaCGASI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Mar 2014 19:18:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, marbugge@cisco.com
Subject: Re: [RFCv1 PATCH 0/4] add G/S_EDID support for video nodes
Date: Fri, 07 Mar 2014 01:19:38 +0100
Message-ID: <2019495.ODacH4EFDT@avalon>
In-Reply-To: <5318710C.1070204@xs4all.nl>
References: <1393932659-13817-1-git-send-email-hverkuil@xs4all.nl> <2719510.vO5HGhFCIt@avalon> <5318710C.1070204@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 06 March 2014 13:58:52 Hans Verkuil wrote:
> On 03/06/14 11:37, Laurent Pinchart wrote:
> > On Thursday 06 March 2014 08:35:07 Hans Verkuil wrote:
> >> On 03/06/2014 02:45 AM, Laurent Pinchart wrote:
> >>> On Tuesday 04 March 2014 12:30:55 Hans Verkuil wrote:
> >>>> Currently the VIDIOC_SUBDEV_G/S_EDID and struct v4l2_subdev_edid are
> >>>> subdev APIs. However, that's in reality quite annoying since for simple
> >>>> video pipelines there is no need to create v4l-subdev device nodes for
> >>>> anything else except for setting or getting EDIDs.
> >>>> 
> >>>> What happens in practice is that v4l2 bridge drivers add explicit
> >>>> support for VIDIOC_SUBDEV_G/S_EDID themselves, just to avoid having to
> >>>> create subdev device nodes just for this.
> >>>> 
> >>>> So this patch series makes the ioctls available as regular ioctls as
> >>>> well. In that case the pad field should be set to 0 and the bridge
> >>>> driver will fill in the right pad value internally depending on the
> >>>> current input or output and pass it along to the actual subdev driver.
> >>> 
> >>> Would it make sense to allow usage of the pad field on video nodes as
> >>> well ?
> >> 
> >> No, really not. The video node driver has full control over which
> >> inputs/outputs map to which pads. None of that is (or should be) visible
> >> from userspace.
> > 
> > What about using the pad field as an input number in that case ? That
> > would allow getting and setting EDID for the different inputs without
> > requiring to change the active input, just like we can do with the subdev
> > API.
> 
> That's a good idea. How should I do that with the v4l2_edid struct: just
> expect userspace to fill in the pad but interpret it differently, or change
> it to a union:
> 
> 	union {
> 		__u32 pad;
> 		__u32 input;
> 		__u32 output;
> 	};

I think I woul djust document the pad field as being used as an input or 
output number in that case, to keep the code simpler, but I'm fine with a 
union if you find it cleaner.

-- 
Regards,

Laurent Pinchart

