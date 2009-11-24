Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:47223 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbZKXBuY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 20:50:24 -0500
Subject: Re: cx18: Reprise of YUV frame alignment improvements
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
In-Reply-To: <829197380911230909u27f6df33icbbc52c5268a1658@mail.gmail.com>
References: <1257913905.28958.32.camel@palomino.walls.org>
	 <829197380911221904uedc18e5qbc9a37cfcee23b5d@mail.gmail.com>
	 <1258978370.3058.25.camel@palomino.walls.org>
	 <829197380911230909u27f6df33icbbc52c5268a1658@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 23 Nov 2009 20:49:06 -0500
Message-Id: <1259027346.3871.76.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-11-23 at 12:09 -0500, Devin Heitmueller wrote:
> On Mon, Nov 23, 2009 at 7:12 AM, Andy Walls <awalls@radix.net> wrote:
> > 5. If you don't give an MDL back to the firmware, it never uses it
> > again.  That's why you see the sweep-up log messages.  As soon as an MDL
> > is skipped *on the order of the depth* of q_busy times, when looking for
> > the currently DMA_DONE'd MDL, that skipped MDL must have been dropped.
> > It is picked up and put back into rotation then.
> 
> Perhaps I am misinterpreting the definition of "sweep-up" in this
> context.  Don't the buffers get forcefully returned to the pool at
> that point?  

You've got it right.


> If so, why would I see the same error over and over long
> after the CPU utilization has dropped back to a reasonable level.
> 
> I feel like I must be missing something here.
> 
> 1.  CPU load goes up (ok)
> 2.  Packets start to get dropped (expected)
> 3.  CPU load goes back down (ok)
> 4.  Packets continue to get dropped and never recycled, even after
> minutes of virtually no CPU load?
> 
> I can totally appreciate the notion that the video would look choppy
> when the system is otherwise under high load, but my expectation would
> be that once the load drops back to 0, the video should look fine
> (perhaps with some small window of time where it is still recovering).


OK the messages are coming from the sweep up implementation, let's
assume it's not working right (which is reasonable to me).

The sweep up algorithm relies on an assumption.

Assumption: The firmware uses MDL on a FIFO basis based on the order in
which we submitted the MDLs to the firmware.  Thus, the order of MDLs in
the q_busy linked list should match how the firmware returns them.

Given that the decision to perform sweep up is based on the absolute
current depth of q_busy (was the buffer skipped q_busy.depth - 1 times
or more?), it turns out that

a. For large numbers of MDLs on q_busy, the assumption needs to only be
approximately true.

b. For very small numbers of MDLs on q_busy (i.e. 2), the assumption
needs to be strictly true or errant sweep-ups happen.

So I suspect for the case of the CX23418 firmware only having 1 MDL and
use giving it another MDL, the CX23418 might use the one we just gave it
first - violating the assumption amd causing errant sweep ups.


The fix is simple: don't sweep up a skipped buffer that meets the
current 

	skipped > = (q_busy.depth -1)

criteria in the case of

	q_full.depth > q_free.depth + qbusy.depth

Which says if we've got a lot of MDLs tied up waiting for the
application to read them, don't both sweeping up potentially lost
buffers until the q_busy.depth increases.  Since "lost" MDLs stay on
q_busy and are counted in q_busy.depth, this will always end up
returning MDLs to the firmware as the application reads data and returns
MDLs.



Of course that's all speculation about the problem.  If you could
reproduce the condition and then

# echo 271 > /sys/modules/cx18/parameters/debug

to record the sequence of CX18_DE_SET_MDLs and DMA_DONE sequence numbers
for the YUIV stream, it might provide conifrmation of what is going on.
271 is high volume messages for info, warning, mailbox, and dma debug
messages.  It will write a lot to your logs.

Regards,
Andy

