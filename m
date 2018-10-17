Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:56412 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbeJQQv6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Oct 2018 12:51:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFP] Which V4L2 ioctls could be replaced by better versions?
Date: Wed, 17 Oct 2018 11:57:24 +0300
Message-ID: <1711632.PTPtFUq1Nv@avalon>
In-Reply-To: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
References: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday, 20 September 2018 17:42:15 EEST Hans Verkuil wrote:
> Some parts of the V4L2 API are awkward to use and I think it would be
> a good idea to look at possible candidates for that.
> 
> Examples are the ioctls that use struct v4l2_buffer: the multiplanar support
> is really horrible, and writing code to support both single and multiplanar
> is hard. We are also running out of fields and the timeval isn't y2038
> compliant.
> 
> A proof-of-concept is here:
> 
> https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=v4l2-buffer&id=a95
> 549df06d9900f3559afdbb9da06bd4b22d1f3
> 
> It's a bit old, but it gives a good impression of what I have in mind.
> 
> Another candidate is
> VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL/VIDIOC_ENUM_FRAMEINTERVALS: expressing
> frame intervals as a fraction is really awkward and so is the fact that the
> subdev and 'normal' ioctls are not the same.
> 
> Would using nanoseconds or something along those lines for intervals be
> better?
> 
> I have similar concerns with VIDIOC_SUBDEV_ENUM_FRAME_SIZE where there is no
> stepwise option, making it different from VIDIOC_ENUM_FRAMESIZES. But it
> should be possible to extend VIDIOC_SUBDEV_ENUM_FRAME_SIZE with stepwise
> support, I think.

If we refresh the enumeration ioctls, I propose moving away from the one 
syscall per value model, and returning everything in one (userspace-allocated) 
buffer. The same could apply to all enumerations (such as controls for 
instance), even if we don't address them all in one go.

> Do we have more ioctls that could use a refresh? S/G/TRY_FMT perhaps, again
> in order to improve single vs multiplanar handling.

If we refresh the G/S/TRY format ioctls (and I think we should), I would 
propose moving to a G/S model with ACTIVE and TRY formats, as for subdevs. 
This should make it easier to construct full device states internally, in 
order to implement proper request API support for formats. We should then also 
document much better how formats and selection rectangles interact.

> It is not the intention to come to a full design, it's more to test the
> waters so to speak.

Another item that we're missing is a way to delete buffers (the counterpart of 
VIDIOC_CREATE_BUFS). As this will introduce holes in the buffer indices, we 
might also need to revamp VIDIOC_CREATE_BUFS (which would give us a chance to 
move away from the format structure passed to that ioctl).

-- 
Regards,

Laurent Pinchart
