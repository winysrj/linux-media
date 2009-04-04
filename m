Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:33809 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZDDLHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Apr 2009 07:07:49 -0400
Date: Sat, 4 Apr 2009 04:07:47 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Andy Walls <awalls@radix.net>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: When is a wake_up() not a wake up?
In-Reply-To: <1238798924.3130.72.camel@palomino.walls.org>
Message-ID: <Pine.LNX.4.58.0904040356210.5134@shell2.speakeasy.net>
References: <1238798924.3130.72.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 3 Apr 2009, Andy Walls wrote:
> 1. A work queue thread or read() call needs to send a command to the
> CX23418 using the cx18_api_call() function
> 2. It fills out a mailbox with a command for the CX23418
> 3. It prepares to wait, just in case a wait is needed
> 4. A SW1 interrupt is sent to the CX23418 telling it a mailbox is ready
> 5. The ack filed in the mailbox, a PCI MMIO location, is checked to see
> if the mailbox was ack'ed already
> 6. If not, schedule_timeout() for up to 10 msecs (a near eternity...)
> 7. Clean up the wait and move on

10ms isn't that long.  With a 100 HZ kernel it's only one jiffie.  The
shortest time msleep() can sleep on a 100 HZ kernel is 20 ms.

Is it possible that it's simply taking more than 10 ms for your process to
get run?

> Mar 31 23:36:56 palomino kernel: cx18-0:  irq: sending interrupt SW1: 8 to send CX18_CPU_DE_SET_MDL
> Mar 31 23:36:56 palomino kernel: cx18-0:  api: scheduling to wait for ack of CX18_CPU_DE_SET_MDL: req 51267 ack 51266, pid 21092, state 2
> Mar 31 23:36:56 palomino kernel: cx18-0:  irq: received interrupts SW1: 0  SW2: 8  HW2: 0
> Mar 31 23:36:56 palomino kernel: cx18-0:  irq: Wake up initiated on pid 21092 in state 2
> Mar 31 23:36:56 palomino kernel: cx18-0:  irq: Wake up succeeded on pid 21092, state 2 -> 0
> Mar 31 23:36:56 palomino kernel: cx18-0:  api: done wait for ack of CX18_CPU_DE_SET_MDL: req 51267 ack 51267, current pid 21092, current state 0, state 0
> Mar 31 23:36:56 palomino kernel: cx18-0:  warning: failed to be awakened upon RPU acknowledgment sending CX18_CPU_DE_SET_MDL; timed out waiting 10 msecs

Try some higher resolution time stamps, you can't really tell much about
when things are happening.

Here's some code I wrote to do it on x86.

#include <linux/calc64.h>
#define MHZ     1666.787
#define INT     (unsigned int)(MHZ * (1<<12) + 0.5)
#define FRAC    (unsigned int)(MHZ * (1<<21) / 1000.0 + 0.5)
#define timestamp(str, args...) { u64 _time; u32 _rem; rdtscll(_time); \
        _time = (_time - starttime)<<12; \
        _rem = do_div(_time, INT); \
        printk("%s - %u.%03u us " str "\n", __func__, \
                (unsigned int)_time, (_rem << 9) / FRAC , ## args); }
static u64 starttime;

Change MHZ to what /proc/cpuinfo tells you.  Call 'rdtscll(starttime)' some
time when your driver inits or a device gets opened or something like that.
Makes the time stamps easier to read when they start near zero.
