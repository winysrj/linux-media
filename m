Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56678 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1FNRBu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 13:01:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: buffer index when streaming user-ptr buffers
Date: Tue, 14 Jun 2011 19:01:53 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <4DF78335.80109@matrix-vision.de>
In-Reply-To: <4DF78335.80109@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106141901.53376.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

On Tuesday 14 June 2011 17:50:13 Michael Jones wrote:
> In the V4L2 spec, the description for v4l2_buffer.index says "This field
> is only used for memory mapping I/O..."
> 
> However, in v4l-utils/contrib/capture-example.c, even user-pointer
> buffers are indeed given a buf.index before being passed to VIDIOC_QBUF.
>  And at least in the OMAP ISP driver, this information is relied upon in
> QBUF regardless of V4L2_MEMORY_MMAP/USERPTR.  videobuf-core also uses
> v4l2_buffer->index even if b->memory == V4L2_MEMORY_USERPTR.
> 
> Is this a bug in the OMAP driver and videobuf-core, and an unnecessary
> assignment in capture-example?  Or is the V4L2 spec out of touch/ out of
> date?

The spec is out of date. The index field is used for userptr buffers as well.

-- 
Regards,

Laurent Pinchart
