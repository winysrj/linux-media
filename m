Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56195 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752402AbdCEMvw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Mar 2017 07:51:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2 2/3] v4l: Clearly document interactions between formats, controls and buffers
Date: Sun, 05 Mar 2017 14:52:25 +0200
Message-ID: <1655091.gPI0LlWvRn@avalon>
In-Reply-To: <20170304134854.GW3220@valkosipuli.retiisi.org.uk>
References: <20170228150320.10104-1-laurent.pinchart+renesas@ideasonboard.com> <5f3e6c07-e07f-6ce2-0158-3f5ec750637f@xs4all.nl> <20170304134854.GW3220@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Saturday 04 Mar 2017 15:48:54 Sakari Ailus wrote:
> On Sat, Mar 04, 2017 at 11:57:32AM +0100, Hans Verkuil wrote:
> ...
> 
> >>> +To simplify their implementation, drivers may also require buffers to
> >>> be +reallocated in order to change formats or controls that influence
> >>> the buffer +size. In that case, to perform such changes, userspace
> >>> applications shall +first stop the video stream with the
> >>> :c:func:`VIDIOC_STREAMOFF` ioctl if it +is running and free all buffers
> >>> with the :c:func:`VIDIOC_REQBUFS` ioctl if +they are allocated. The
> >>> format or controls can then be modified, and buffers +shall then be
> >>> reallocated and the stream restarted. A typical ioctl sequence +is
> >>> +
> >>> + #. VIDIOC_STREAMOFF
> >>> + #. VIDIOC_REQBUFS(0)
> >>> + #. VIDIOC_S_FMT
> >>> + #. VIDIOC_S_EXT_CTRLS
> >>
> >> Same here.
> >>
> >> Would it be safe to say that controls are changed first? I wonder if
> >> there could be special cases where this wouldn't apply though. It could
> >> ultimately come down to hardware features: rotation might be only
> >> available for certain formats so you'd need to change the format first
> >> to enable rotation.
> >>
> >> What you're documenting above is a typical sequence so it doesn't have to
> >> be applicable to all potential hardware. I might mention there could be
> >> such dependencies. I wonder if one exists at the moment. No?
> > 
> > The way V4L2 works is that the last ioctl called gets 'preference'. So the
> > driver should attempt to satisfy the ioctl, even if that means undoing
> > previous ioctls. In other words, V4L2 allows any order, but the
> > end-result might be different depending on the hardware capabilities.
> 
> Indeed. But the above sequence suggests that formats are set before
> controls. I suggested to clarify that part.

I agree with both of you. I'll clarify that this is just an example and that 
formats and controls can be set in a different order (or even interleaved).

-- 
Regards,

Laurent Pinchart
