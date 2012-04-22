Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:47277 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205Ab2DVU5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Apr 2012 16:57:03 -0400
Subject: Re: HVR-1600: Skipped encoder MPEG, MDL 63, 62 times - it must have
 dropped out of rotation
From: Andy Walls <awalls@md.metrocast.net>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-media@vger.kernel.org
Date: Sun, 22 Apr 2012 16:56:52 -0400
In-Reply-To: <jn1a43$vlj$1@dough.gmane.org>
References: <jn1a43$vlj$1@dough.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1335128213.2602.23.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2012-04-22 at 12:03 -0400, Brian J. Murrell wrote:
> I've got an HVR-1600 in a fairly fast machine (P4 3GHz, two cores) on a
> 3.2.0 kernel and seem to be getting lots of this sort of thing:
> 
> Apr 19 20:09:10 pvr kernel: [34651.015170] cx18-0: Skipped encoder MPEG, MDL 63, 62 times - it must have dropped out of rotation
> Apr 19 20:10:05 pvr kernel: [34705.375793] cx18-0: Skipped encoder IDX, MDL 415, 2 times - it must have dropped out of rotation
> Apr 19 20:12:45 pvr kernel: [34865.535784] cx18-0: Skipped encoder IDX, MDL 426, 2 times - it must have dropped out of rotation
> Apr 19 20:12:45 pvr kernel: [34865.609900] cx18-0: Skipped encoder IDX, MDL 430, 1 times - it must have dropped out of rotation
> Apr 19 20:12:45 pvr kernel: [34865.684180] cx18-0: Could not find MDL 426 for stream encoder IDX
> Apr 19 20:12:58 pvr kernel: [34878.912976] cx18-0: Could not find MDL 430 for stream encoder IDX
> Apr 19 20:13:00 pvr kernel: [34880.850172] cx18-0: Skipped encoder MPEG, MDL 53, 62 times - it must have dropped out of rotation
> Apr 19 20:15:25 pvr kernel: [35025.696747] cx18-0: Skipped encoder IDX, MDL 435, 2 times - it must have dropped out of rotation
> Apr 19 20:15:25 pvr kernel: [35025.771765] cx18-0: Skipped encoder IDX, MDL 439, 1 times - it must have dropped out of rotation
> Apr 19 20:15:25 pvr kernel: [35025.847732] cx18-0: Could not find MDL 435 for stream encoder IDX
> Apr 19 20:15:25 pvr kernel: [35025.901315] cx18-0: Skipped TS, MDL 82, 16 times - it must have dropped out of rotation
> Apr 19 20:15:32 pvr kernel: [35032.370364] cx18-0: Skipped encoder IDX, MDL 435, 2 times - it must have dropped out of rotation
> Apr 19 20:15:38 pvr kernel: [35039.074592] cx18-0: Could not find MDL 439 for stream encoder IDX
> Apr 19 20:15:40 pvr kernel: [35040.938552] cx18-0: Skipped encoder MPEG, MDL 29, 62 times - it must have dropped out of rotation
> Apr 19 20:18:05 pvr kernel: [35185.859652] cx18-0: Skipped encoder IDX, MDL 445, 2 times - it must have dropped out of rotation
> Apr 19 20:18:05 pvr kernel: [35185.933816] cx18-0: Skipped encoder IDX, MDL 449, 1 times - it must have dropped out of rotation
> Apr 19 20:18:05 pvr kernel: [35186.008176] cx18-0: Could not find MDL 445 for stream encoder IDX
> Apr 19 20:18:19 pvr kernel: [35199.237035] cx18-0: Could not find MDL 449 for stream encoder IDX
> Apr 19 20:18:19 pvr kernel: [35199.289870] cx18-0: Could not find MDL 49 for stream encoder MPEG
> Apr 19 20:18:25 pvr kernel: [35205.879310] cx18-0: Skipped encoder IDX, MDL 450, 2 times - it must have dropped out of rotation
> Apr 19 20:23:26 pvr kernel: [35506.147134] cx18-0: Skipped encoder IDX, MDL 402, 2 times - it must have dropped out of rotation
> Apr 19 20:24:19 pvr kernel: [35559.705155] cx18-0: Skipped encoder MPEG, MDL 16, 62 times - it must have dropped out of rotation
> 
> IIRC I was told previously that it was due to interrupts not being
> serviced quickly enough.  Am I recalling correctly?

Yes.

> Could that really be a problem even with a dual core 3GHz P4?

Yes.  You are looking at the evidence in those log messages.

If, in your system, IRQ service for device A under some circumstances
has precendence over IRQ service for the CX23418 and hence holds off its
service; and the irq handler in the driver for device A decides to
perform some some long I/O operations with device A; then it doesn't
matter how fast your CPU is. 

You may wish to use perf or ftrace, or some other tool/method of
measuring kernel interrupt handling latency to find out what causes any
delays from the CX23418 raising its IRQ line to cx18_irq_handler() being
called by the kernel.

I can tell you that I have optimized cx18_irq_handler(), and the
functions it calls, to death.  I simply cannot make it perform
significantly better.  The required PCI MMIO operations to the CX23418
dominate the time consumed in cx18_irq_handler().
[I await "Challenge accepted" from anyone. ;) ]

> Also, are those messages related to the clearqam path or the
> MPEG2 hardware encoder path?  i.e. are those digital recording
> messages or analog recording messages?

MPEG: analog video encoder DMA buffers
IDX:  MPEG index data DMA buffers from the analog video encoder
TS:   DTV (ATSC or QAM) DMA buffers

Every message above in your log, indicates your system "lost" a
notifcation from the CX23418 as it was too slow to respond to the
CX23418's interrupt.  Hence your recording/viewing of said stream missed
some data.

Note, the IDX stream only matters if you have an application that calls
the VIDIOC_G_ENC_INDEX ioctl() to collect I-Frame offsets in the MPEG
stream.  That is very rare, so I would not worry about lost IDX buffers.

> Cheers,
> b.

Regards,
Andy

