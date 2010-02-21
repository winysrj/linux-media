Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:39649 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab0BUXLg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2010 18:11:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: More videobuf and streaming I/O questions
Date: Mon, 22 Feb 2010 00:12:18 +0100
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <201002201500.21118.hverkuil@xs4all.nl>
In-Reply-To: <201002201500.21118.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002220012.20797.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Saturday 20 February 2010 15:00:21 Hans Verkuil wrote:
> I have a few more questions regarding the streaming I/O API:
> 
> 1) The spec mentions that the memory field should be set for VIDIOC_DQBUF.
> But videobuf doesn't need it and it makes no sense to me either unless it
> is for symmetry with VIDIOC_QBUF. Strictly speaking QBUF doesn't need it
> either, but it is a good sanity check.
>
> Can I remove the statement in the spec that memory should be set for DQBUF?
> The alternative is to add a check against the memory field in videobuf, but
> that's rather scary.

In that case I would remove it for QBUF as well, and state that the memory 
field must be ignored by drivers (but should they fill it when returning from 
QBUF/DQBUF ?)

> 2) What to do with REQBUFS when called with a count of 0? Thinking it over
> I agree that it shouldn't do an implicit STREAMOFF. But I do think that it
> is useful to allow as a simple check whether the I/O method is supported.

REQBUFS(0) should also free allocated buffers (if any).

> So a count of 0 will either return an error if streaming is still in
> progress or if the proposed I/O method is not supported, otherwise it will
> return 0 while leaving count to 0.
> 
> This allows one to use REQBUFS to test which I/O methods are supported by
> the driver without having the driver allocating any buffers.
> 
> This will become more important with embedded systems where almost
> certainly additional I/O methods will be introduced (in particular
> non-contiguous plane support).
> 
> Currently a count of 0 will result in an error in videobuf.
> 
> Note that drivers do not generally check for valid values of the memory
> field at the moment. So that is another thing we need to improve. But
> before I start working on that, I first want to know exactly how REQBUFS
> should work.

-- 
Regards,

Laurent Pinchart
