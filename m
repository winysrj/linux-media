Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:53385 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbZDIBiH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2009 21:38:07 -0400
Subject: Re: When is a wake_up() not a wake up?
From: Andy Walls <awalls@radix.net>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
In-Reply-To: <Pine.LNX.4.58.0904040356210.5134@shell2.speakeasy.net>
References: <1238798924.3130.72.camel@palomino.walls.org>
	 <Pine.LNX.4.58.0904040356210.5134@shell2.speakeasy.net>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 22:38:46 -0400
Message-Id: <1239244727.19075.34.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-04-04 at 04:07 -0700, Trent Piepho wrote:
> On Fri, 3 Apr 2009, Andy Walls wrote:
> > 1. A work queue thread or read() call needs to send a command to the
> > CX23418 using the cx18_api_call() function
> > 2. It fills out a mailbox with a command for the CX23418
> > 3. It prepares to wait, just in case a wait is needed
> > 4. A SW1 interrupt is sent to the CX23418 telling it a mailbox is ready
> > 5. The ack filed in the mailbox, a PCI MMIO location, is checked to see
> > if the mailbox was ack'ed already
> > 6. If not, schedule_timeout() for up to 10 msecs (a near eternity...)
> > 7. Clean up the wait and move on
> 
> 10ms isn't that long.  With a 100 HZ kernel it's only one jiffie.  The
> shortest time msleep() can sleep on a 100 HZ kernel is 20 ms.
> 
> Is it possible that it's simply taking more than 10 ms for your process to
> get run?

After some testing with fine grained timestamps as you suggested, that
indeed appears to be the case.

For the high volume API command I care about, in 6097 out of 6100
samples, the firmware acknowledgment interrupt comes back in and the
process is awakened back to TASK_RUNNABLE in under 150 us.  0 out of
6100 samples finished the wakeup to TASK_RUNNABLE faster than 55 us.
However, I had 22 samples, where coming back from schedule_timeout()
took 10 msec or greater, despite the wakeup happening in under 150 us.

So the simple answer is to poll the ack field of the mailbox, with some
50 us busy waits perhaps, for this one high volume API command.

Regards,
Andy

