Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1750 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbaFCGjN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jun 2014 02:39:13 -0400
Message-ID: <538D6D81.3000001@xs4all.nl>
Date: Tue, 03 Jun 2014 08:38:57 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	linux-media@vger.kernel.org
Subject: Re: Poll and empty queues
References: <1401738463.2304.15.camel@nicolas-tpx230>
In-Reply-To: <1401738463.2304.15.camel@nicolas-tpx230>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicholas,

On 06/02/2014 09:47 PM, Nicolas Dufresne wrote:
> Hi everyone,
> 
> Recently in GStreamer we notice that we where not handling the POLLERR
> flag at all. Though we found that what the code do, and what the doc
> says is slightly ambiguous.
> 
>         "When the application did not call VIDIOC_QBUF or
>         VIDIOC_STREAMON yet the poll() function succeeds, but sets the
>         POLLERR flag in the revents field."
>         
> In our case, we first seen this error with a capture device. How things
> worked is that we first en-queue all allocated buffers. Our
> interpretation was that this would avoid not calling "VIDIOC_QBUF [...]
> yet", and only then we would call VIDIOC_STREAMON. This way, in our
> interpretation we would never get that error.
> 
> Though, this is not what the code does. Looking at videobuf2, if simply
> return this error when the queue is empty.
> 
> 	/*
> 	 * There is nothing to wait for if no buffers have already been queued.
> 	 */
> 	if (list_empty(&q->queued_list))
> 		return res | POLLERR;
> 
> So basically, we endup in this situation where as soon as all existing
> buffers has been dequeued, we can't rely on the driver to wait for a
> buffer to be queued and then filled again. This basically forces us into
> adding a new user-space mechanism, to wait for buffer to come back. We
> are wandering if this is a bug. If not, maybe it would be nice to
> improve the documentation.

Just for my understanding: I assume that gstreamer polls in one process or
thread and does the queuing/dequeuing in a different process/thread, is that
correct?

If it was all in one process, then it would make no sense polling for a
buffer to become available if you never queued one.

That is probably the reasoning behind what poll does today. That said, I've
always thought it was wrong and that it should be replaced by something like:

	if (!vb2_is_streaming(q))
		return res | POLLERR;

I.e.: only return an error if we're not streaming.

Regards,

	Hans
