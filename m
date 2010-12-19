Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:36948 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932403Ab0LSWnL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Dec 2010 17:43:11 -0500
Subject: Re: Power frequency detection.
From: Andy Walls <awalls@md.metrocast.net>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Paulo Assis <pj.assis@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <1292796033.2052.111.camel@morgan.silverblock.net>
References: <73wo0g3yy30clob2isac30vm.1292782894810@email.android.com>
	 <alpine.LNX.2.00.1012191423030.23950@banach.math.auburn.edu>
	 <1292796033.2052.111.camel@morgan.silverblock.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Dec 2010 17:43:54 -0500
Message-ID: <1292798634.2052.143.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sun, 2010-12-19 at 17:00 -0500, Andy Walls wrote:
> On Sun, 2010-12-19 at 14:51 -0600, Theodore Kilgore wrote:

Just a few more details...

> So I might not be able to provide too much help.  I have 2 ideas for you
> coming from the perspective of me being a USB idiot:
> 
> 
> 1. Since the jlj_dostream() work handler function is essentially just a
> synchronous poll loop on the device, you could just have it process the
> ioctl() requests to change a control synchronously. 
> 
> a. The ioctl() call for the v4l2 control would submit a command to some
> queue you set up for the purpose, and then sleep on a wait queue. 
> 
> b. The jlj_dostream() function would check the command queue at its
> convenience, process any control command, and then wake up the wait
> queue that the ioctl() is waiting on.
> 
> For this idea, don't forget to implement the command queue with proper
> locking or other mutual exclusion.  You'll also need to think about how
> to place ioctl() callers on the wait_queue and how to wake them up in
> FIFO order, if you use this idea and allow multiple v4l2 control ioctl()
> to be queued.
> 
> 
> 
> 2. Restructure the workqueue function, jlj_dostream(), to handle a work
> object in one pass (e.g. no loop to read more than one frame), handle
> two different types of work objects (one for stream polling and one for
> control ioctl() requests), and have it automatically reschedule the
> stream polling work object.
> 
> a. When streaming, the current, single work object would still be used
> and jlj_dostream() must be able to check that the work object is the one
> indicating streaming work.  jlj_dostream() would only perform work
> required to read one whole frame, unless you want to get fancy and deal
> with partial frames.  The jlj_dostream() handler would then reschedule
> the work object for streaming - maybe with a sensible delay.
> 
> b. For a V4L2 control ioctl() that needs to send a command to the
> device, the ioctl() fills out the needed parameters in a scratch-pad
> location and queues a different work object, associated with those
> scratchpad parameters.  The ioctl() then sleeps on a wait queue
> associated with that work object.  When the work handler function,
> jlj_dostream(), gets called it must be able to determine the work object
> is the one associated with an ioctl() control.  jlj_dostream() then
> performs the actions required for the ioctl() and the wakes up the
> wait_queue on which the ioctl() is waiting.  The work object is not
> rescheduled by the work handler function.
> 
> 
> For this idea, you'll be relying on the single-threaded workqueue to
> provide mutual exclusion between processing of the two different types
> of work objects (streaming and v4l2 control ioctl).  You can structure
> things to have more than 1 work object for V4L2 control ioctl()
> processing, if you like, since the workqueue can queue any number of
> work objects.  But if you allow more than one ioctl() related work
> object to be queued, you'll have to be careful about how things are
> placed on the wait_queue and how they are awakened.
> 
> 

For implementing either of these ideas, you may also wish to investigate
the use of completions instead of wait_queues.  I've never used
completions myself, so I'm not sure if they'll work.

With a quick grep through the kernel, I only find the cx18 driver and
libsas as examples using multiple work objects for a work handler
function.  In both of those, the purpose of the of work object is
indicated with a field in the structure that also contains the work
object.

Regards,
Andy

