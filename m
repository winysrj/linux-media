Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:41681 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755457AbeARKSK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 05:18:10 -0500
Subject: Re: V4L2 v4l2_event_dequeue blocks forever when USB/UVC disconnects
To: Michael Walz <m.walz@digitalendoscopy.de>,
        linux-media@vger.kernel.org
References: <f31e8344-75fc-c636-8e0e-b41954465e29@digitalendoscopy.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c1b2f8ed-c81a-3545-db28-8a0db57fdb8b@xs4all.nl>
Date: Thu, 18 Jan 2018 11:18:01 +0100
MIME-Version: 1.0
In-Reply-To: <f31e8344-75fc-c636-8e0e-b41954465e29@digitalendoscopy.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On 01/18/18 10:57, Michael Walz wrote:
> Hi there,
> 
> I am currently developing a USB/UVC camera and I think I discovered an 
> issue in the V4L2 event system. In userland I have implemented a thread 
> for the VIDIOC_DQEVENT ioctl, which blocks until there is a new event. 
> This works perfectly until the camera is disconnected during operation:
> 
> 
> In v4l2_event_dequeue() the thread is put to sleep with
> 
> wait_event_interruptible(fh->wait, fh->navailable != 0)
> 
> 
> and woken up only from  __v4l2_event_queue_fh()
> 
> wake_up_all(&fh->wait);
> 
> 
> So the event-dq-thread will only wake up when there is really a new 
> event queued. It will not wake up when the event is unsubscribed in 
> v4l2_event_unsubscribe() and it will also not wake up when 
> video_unregister_device() and and consequently v4l2_fh_exit() is called.
> 
> In userland, when the device is disconnected while streaming video, 
> VIDIOC_DQBUF and all other ioctls return with proper error codes, but 
> VIDIOC_DQEVENT blocks until doomsday.
> The only (dirty) workaround I found is sending a signal to the userland 
> thread to force the wait_event_interruptible() to return.
> 
> I think this issue could be solved. I discovered that in videobuf2 a 
> similar issue is solved by checking the flag q->streaming in
> wait_event_interruptible() in __vb2_wait_for_done_vb(). In 
> __vb2_queue_cancel() this flag is deasserted and all threads are woken 
> up with wake_up_all.
> I suggest that the problem could be solved by waking the 
> event-dq-threads in v4l2_event_unsubscribe_all() or 
> v4l2_event_unsubscribe() so that v4l2_event_dequeue() can return.
> 
> Problem is that I have almost no experience in kernel development. Can 
> somebody with more knowledge in these matters please have a look at this 
> issue and confirm or correct my observations?

You're absolutely correct, this is a bug. There are two problems: the
first is that v4l2_event_unsubscribe doesn't call wake_up_all, the
second is that __v4l2_event_dequeue doesn't detect if the device was
unplugged.

Are you able to compile the kernel if I give you a patch to test?

It should be a fairly easy fix.

Regards,

	Hans
