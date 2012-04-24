Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:41173 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753785Ab2DXBEg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 21:04:36 -0400
Subject: Re: HVR-1600: Skipped encoder MPEG, MDL 63, 62 times - it must have
 dropped out of rotation
From: Andy Walls <awalls@md.metrocast.net>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-media@vger.kernel.org
Date: Mon, 23 Apr 2012 20:54:23 -0400
In-Reply-To: <jn4292$6te$1@dough.gmane.org>
References: <jn1a43$vlj$1@dough.gmane.org>
	 <1335128213.2602.23.camel@palomino.walls.org>
	 <jn4292$6te$1@dough.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1335228865.13891.12.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2012-04-23 at 13:07 -0400, Brian J. Murrell wrote:
> On 12-04-22 04:56 PM, Andy Walls wrote:
> > 
> > If, in your system, IRQ service for device A under some circumstances
> > has precendence over IRQ service for the CX23418 and hence holds off its
> > service; and the irq handler in the driver for device A decides to
> > perform some some long I/O operations with device A; then it doesn't
> > matter how fast your CPU is. 
> 
> Yes, quite true.  I was forgetting about how nasty an irq handler can be
> on other hardware.
> 
> > You may wish to use perf or ftrace, or some other tool/method of
> > measuring kernel interrupt handling latency to find out what causes any
> > delays from the CX23418 raising its IRQ line to cx18_irq_handler() being
> > called by the kernel.
> 
> Excellent idea.  I'm afraid I'm quite (read: very) green in the area of
> kernel performance profiling. 

Here's an example of me checking latencies in the ivtv driver:

http://www.spinics.net/lists/linux-media/msg15762.html

Here are some good articles:

http://lwn.net/Articles/322666/
http://lwn.net/Articles/322731/
http://lwn.net/Articles/366796/
http://lwn.net/Articles/365835/
http://lwn.net/Articles/410200/
http://lwn.net/Articles/425583/
http://lwn.net/Articles/370423/

http://people.redhat.com/srostedt/ftrace-tutorial.odp
https://events.linuxfoundation.org/slides/2010/linuxcon_japan/linuxcon_jp2010_rostedt.pdf

An account of an in depth investigation into the maximum interrupts
disabled duration on some Sony of America test systems:
https://events.linuxfoundation.org/slides/2010/linuxcon_japan/linuxcon_jp2010_rowand.pdf


>  But I'm smart.  Looking around, it seems
> that with ftrace, I am looking for the irqsoff tracer, is that correct?

That sounds good as good as any.  (I always just end up learning what I
have to do when I need it.)


>  Unfortunately my kernel doesn't have that one:

It was probably just compiled without it.  On my Fedora 15 system, that
is the case with the stock kernel:

[andy@palomino ~]$  grep IRQSOFF_TRACER /boot/config-`uname -r`
# CONFIG_IRQSOFF_TRACER is not set

> # cat /sys/kernel/debug/tracing/available_tracers
> blk function_graph mmiotrace wakeup_rt wakeup function nop

*sigh*  So much for being convenient and easy.


> I can't seem to find any useful information on using perf to analyze ISR
> latency.  Any pointers?

Not really.  I have never used perf.  I assume you found this page:

https://perf.wiki.kernel.org/

> Cheers,
> b.

Regards,
Andy


