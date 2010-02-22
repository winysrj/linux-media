Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:58083 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab0BVJrk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 04:47:40 -0500
Date: Mon, 22 Feb 2010 10:47:41 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: More videobuf and streaming I/O questions
Message-ID: <20100222104741.2a8113be@tele>
In-Reply-To: <201002220012.20797.laurent.pinchart@ideasonboard.com>
References: <201002201500.21118.hverkuil@xs4all.nl>
	<201002220012.20797.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans and Laurent,

On Mon, 22 Feb 2010 00:12:18 +0100
Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> On Saturday 20 February 2010 15:00:21 Hans Verkuil wrote:
> > 1) The spec mentions that the memory field should be set for
> > VIDIOC_DQBUF. But videobuf doesn't need it and it makes no sense to
> > me either unless it is for symmetry with VIDIOC_QBUF. Strictly
> > speaking QBUF doesn't need it either, but it is a good sanity check.
> >
> > Can I remove the statement in the spec that memory should be set
> > for DQBUF? The alternative is to add a check against the memory
> > field in videobuf, but that's rather scary.
> 
> In that case I would remove it for QBUF as well, and state that the
> memory field must be ignored by drivers (but should they fill it when
> returning from QBUF/DQBUF ?)

Agree. It seems that the memory field is not useful at all in the struct
v4l2_buffer if a same process does reqbuf, qbuf, dqbuf and querybuf.


BTW, I had a pending question. The spec says that streamoff 'removes
all buffers from the incoming and outgoing queues' and return to 'the
same state as after calling VIDIOC_REQBUFS'. For output, there is no
problem. For capture, does this mean that the buffers previously queued
by qbuf are implicitly unqueued (i.e. that qbuf must be done again for
all buffers)?

In this case, streamoff does not work with two processes. A first
process is streaming when a second one does streamoff and then
streamon. The first process will stay blocked on polling because no
buffer is queued anymore. It cannot know this fact and the second
process cannot requeue the buffers...

To work correctly, the spec should say that streamoff discards the
content of the filled buffers and that it requeues these buffers as
empty either in the driver's incoming queue (capture) or outgoing queue
(output).

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
