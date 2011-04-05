Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48769 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab1DEMhc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 08:37:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC 2/4 v2] V4L: add videobuf2 helper functions to support multi-size video-buffers
Date: Tue, 5 Apr 2011 14:38:03 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange> <Pine.LNX.4.64.1104011011220.9530@axis700.grange> <Pine.LNX.4.64.1104011604360.11504@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1104011604360.11504@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104051438.04072.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Friday 01 April 2011 16:06:42 Guennadi Liakhovetski wrote:
> This patch extends the videobuf2 framework with new helper functions and
> modifies existing ones to support multi-size video-buffers.

[snip]

> diff --git a/include/media/videobuf2-core.h
> b/include/media/videobuf2-core.h index f87472a..88076fc 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -177,6 +177,10 @@ struct vb2_buffer {
>   *			plane should be set in the sizes[] array and optional
>   *			per-plane allocator specific context in alloc_ctxs[]
>   *			array
> + * @queue_add:		like above, but called from VIDIOC_CREATE_BUFS, but if
> + *			there are already buffers on the queue, it won't replace
> + *			them, but add new ones, possibly with a different format
> + *			and plane sizes

I don't think drivers will need to perform different operations in queue_setup 
and queue_add. You could merge the two operations.

>   * @wait_prepare:	release any locks taken while calling vb2 functions;
>   *			it is called before an ioctl needs to wait for a new
>   *			buffer to arrive; required to avoid a deadlock in
> @@ -194,6 +198,8 @@ struct vb2_buffer {
>   *			each hardware operation in this callback;
>   *			if an error is returned, the buffer will not be queued
>   *			in driver; optional
> + * @buf_submit:		called primarily to invalidate buffer caches for faster
> + *			consequent queuing; optional

What's the difference between buf_submit and buf_prepare ?

>   * @buf_finish:		called before every dequeue of the buffer back to
>   *			userspace; drivers may perform any operations required
>   *			before userspace accesses the buffer; optional

-- 
Regards,

Laurent Pinchart
