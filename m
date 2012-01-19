Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43521 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755254Ab2ASBfl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Jan 2012 20:35:41 -0500
Subject: Re: cx18-0: Could not find buf 90 for stream TS
From: Andy Walls <awalls@md.metrocast.net>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-media@vger.kernel.org
Date: Wed, 18 Jan 2012 20:35:19 -0500
In-Reply-To: <4F16D5BD.6060609@interlinx.bc.ca>
References: <4F16D5BD.6060609@interlinx.bc.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1326936925.2458.21.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2012-01-18 at 09:22 -0500, Brian J. Murrell wrote:
> [ Apologies if this ends up as a duplicate post but my first posting
>   (via gmane) a couple of hours ago is still not on the list ]
> 
> I have an HVR-1600 on a 2.6.32[-33 Ubuntu] kernel (modinfo says the
> cx18 driver is version 1.2.0 

Any cx18 driver that reports a version less than 1.4.0 (IIRC) has some
problem I found that needed fixing.  At your earliest convenience, you
should upgrade to the latest stable kernel and modules from your distro.

However, upgrading the cx18 driver will likely not solve your current
problem. You have a system level problem.


> with srcversion "DBC252062593953C879E266")
> which I have MythTV driving.  Last night a number of recordings from
> the analog tuner failed.  The first failure correlates to the following
> in the kernel log:
> 
> Jan 17 20:30:34 pvr kernel: [565436.263521] cx18-0: Could not find buf 90 for stream TS
> Jan 17 20:30:34 pvr kernel: [565436.610052] cx18-0: Skipped TS, buffer 83, 19 times - it must have dropped out of rotation
> Jan 17 20:30:35 pvr kernel: [565437.360282] cx18-0: Could not find buf 50 for stream encoder MPEG
> Jan 17 20:30:35 pvr kernel: [565438.072959] cx18-0: Skipped encoder MPEG, buffer 33, 61 times - it must have dropped out of rotation
> Jan 17 20:30:36 pvr kernel: [565438.537061] cx18-0: Skipped TS, buffer 67, 19 times - it must have dropped out of rotation
> Jan 17 20:30:36 pvr kernel: [565438.590691] cx18-0: Skipped encoder MPEG, buffer 49, 55 times - it must have dropped out of rotation
> Jan 17 20:30:38 pvr kernel: [565440.265314] cx18-0: Could not find buf 81 for stream encoder MPEG
> Jan 17 20:30:38 pvr kernel: [565440.780971] cx18-0: Skipped TS, buffer 68, 19 times - it must have dropped out of rotation
> Jan 17 20:30:39 pvr kernel: [565441.705943] cx18-0: Skipped encoder MPEG, buffer 41, 42 times - it must have dropped out of rotation

These messages indicate your system is occasionally having trouble
servicing interrupt from the CX23418 in a timely manner.   These
messages are the cx18 driver sweeping up video data buffers that were
missed when the CX23418 transferred them over earlier, due to an
interrupt not being serviced in a timely manner.

These happened a few seconds apart, but there are not many.  That's OK
and nothing to worry about usually.  Notice the next warnings about
missed buffers happen ~80 seconds later.


> Jan 17 20:32:01 pvr kernel: [565523.657123] cx18-0: Skipped encoder MPEG, buffer 6, 62 times - it must have dropped out of rotation

And the one after this happens 17 seconds later.

> Jan 17 20:32:18 pvr kernel: [565540.248743] cx18-0: Skipped encoder MPEG, buffer 62, 62 times - it must have dropped out of rotation
> Jan 17 20:32:19 pvr kernel: [565541.337101] cx18-0: Could not find buf 35 for stream encoder MPEG
> Jan 17 20:32:19 pvr kernel: [565541.862825] cx18-0: Skipped TS, buffer 73, 19 times - it must have dropped out of rotation
> Jan 17 20:32:19 pvr kernel: [565541.975030] cx18-0: Skipped TS, buffer 82, 16 times - it must have dropped out of rotation


> Jan 17 20:32:20 pvr kernel: [565543.105033] cx18-0: Unable to find blank work order form to schedule incoming mailbox command processing
                                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^     
OK *this* message is bad. ----------------------------+

Your kernel is falling behind in servicing CX23418 interrupts and in
servicing work deferred by the cx18 driver to the [cx18-0-in] kernel
thread.

Something is hogging CPU resources such that the kernel thread isn't
getting CPU time.  Something might also be keep interrupts disabled for
too long.

The first thing I'd do is look at the output of 'cat /proc/interrupts'
and see what other linux kernel module is sharing the same interrupt
line as the cx18 driver.  I would then disable whatever device that was
(either remove the device, unload the kernel module, somehow ensure the
other device did not generate interrupts, or move the CX23418 card to
another PCI slot).

If you do decide to move cards, while you have the box open: remove
*all* the PCI cards, blow the dust out of PCI *all* the slots, and
reseat all the cards.

> Jan 17 20:32:21 pvr kernel: [565543.595668] cx18-0: Skipped encoder MPEG, buffer 34, 44 times - it must have dropped out of rotation
> Jan 17 20:32:24 pvr kernel: [565546.512745] cx18-0: ignoring gop_end: not (yet?) supported by the firmware

These are normal given the circumstances.

> At the same time as the analog recording a digital recording stopped
> (very) short of completing with only having captured 36MB.

If no deferred work can be queued (i.e. blank work order forms in the
cx18 driver cannot be obtained), then data transfer from the cx18 driver
to user space applications like MythTV will stop.  You should be able to
have all applications close /dev/video0 and then reopen it to get
transferrs working again.


> Beyond that, MythTV reports:
> 
> 2012-01-17 21:00:06.286397 W [2451/3732] RecThread mpegrecorder.cpp:1358 (StartEncoding) - MPEGRec(/dev/video1): StartEncoding failed
>                         eno: Input/output error (5)
> ...
> 2012-01-17 22:00:05.774512 W [2451/4335] RecThread mpegrecorder.cpp:1358 (StartEncoding) - MPEGRec(/dev/video1): StartEncoding failed
>                         eno: Input/output error (5)

Error 5 is errno=EIO "I/O Error" from the cx18 driver.  No surpirse.

> But ultimately all further recordings (both analog and digital) from
> that card failed.
> 
> Any ideas what happened?

Something in your system is hogging processor or keeping interrupts
disabled for too long, or both.  In my experience it is almost always
some other linux kernel module that is doing something stupid in its own
interrupt handler.

You might want to look into using ftrace or other in kernel tracing
utilties to figure out what's taking so long inside the kernel.

Regards.
Andy 

>   I can leave this machine as is for a few
> hours in case anyone wants any information from it before I reboot it.
> 
> Cheers,
> b.
> 
> 
> 


