Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40439 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab2GZXb5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 19:31:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC] omap3-isp G_FMT & ENUM_FMT
Date: Fri, 27 Jul 2012 01:32:03 +0200
Message-ID: <7135672.xS20ZCiE6C@avalon>
In-Reply-To: <50115299.6000201@matrix-vision.de>
References: <1343303996-16025-1-git-send-email-michael.jones@matrix-vision.de> <4048543.KhXI4ynbrF@avalon> <50115299.6000201@matrix-vision.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Thursday 26 July 2012 16:22:17 Michael Jones wrote:
> On 07/26/2012 04:05 PM, Laurent Pinchart wrote:
> > On Thursday 26 July 2012 13:59:54 Michael Jones wrote:
> >> Hello,
> >> 
> >> I would like to (re)submit a couple of patches to support V4L2 behavior
> >> at the V4L2 device nodes of the omap3-isp driver, but I'm guessing they
> >> require some discussion first.
> > 
> > Indeed.
> > 
> > The main reason why the OMAP3 ISP driver implements G_FMT/S_FMT as it does
> > today is to hack around a restriction in the V4L2 API. We needed a way to
> > preallocate and possibly prequeue buffers for snapshot, which wasn't
> > possible in a standard-compliant way back then.
> > 
> > The situation has since changed, and we now have the VIDIOC_CREATE_BUFS
> > and VIDIOC_PREPARE_BUF ioctls. My plan is to
> > 
> > - port the OMAP3 ISP driver to videobuf2
> > - implement support for CREATE_BUFS and PREPARE_BUF
> > - fix the G_FMT/S_FMT/ENUM_FMT behaviour
> 
> What will the G_FMT/S_FMT/ENUM_FMT behavior be then?  Can you contrast
> it with the behavior of my patches?  If the behavior will be the same
> for user space, and your proposed changes won't be in very soon, can we
> use my patches until you make your changes?

At the moment the driver accepts any format you give it in a S_FMT call, 
regardless of the format of the connected pad. The reason for that is to allow 
VIDIOC_REQBUFS to allocate buffers for an arbitrary size.

With CREATE_BUFS and PREPARE_BUFS support, G_FMT, S_FMT and ENUM_FMT should 
return the format of the connected pad. 

-- 
Regards,

Laurent Pinchart

