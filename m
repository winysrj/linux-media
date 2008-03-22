Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1JcuuA-0000ju-FJ
	for linux-dvb@linuxtv.org; Sat, 22 Mar 2008 05:00:27 +0100
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Sat, 22 Mar 2008 04:56:43 +0100
References: <47E4512E.5000602@googlemail.com>
In-Reply-To: <47E4512E.5000602@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803220456.43691@orion.escape-edv.de>
Subject: Re: [linux-dvb] [PATCH] 1/3: BUG FIX in dvb_ringbuffer_flush
Reply-To: linux-dvb@linuxtv.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Andrea wrote:
> I've been playing with DMX_SET_BUFFER_SIZE and I've had a problem when I tried to resize the buffer
> to a smaller size.
> 
> dvb_dmxdev_set_buffer_size flushes the ringbuffer and then replaces it with a new one.
> What happens if the current pointer is on a position that would be invalid in the new buffer? An
> access violation.
> 
> This because dvb_ringbuffer_flush resets the 2 pointers to the vaule of pwrite (which could be after
> the end of the new buffer).

Ack, this _is_ a bug. :-(

> I think it is safer to reset them to 0.

Nak. At the first glance one might think that this patch is correct.
Unfortunately, it introduces a subtle bug.

Citing the comments in dvb_ringbuffer.h:
| (2) If there is exactly one reader and one writer, there is no need
|     to lock read or write operations.
|     Two or more readers must be locked against each other.
|     Flushing the buffer counts as a read operation.
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
|     Two or more writers must be locked against each other.

With your patch all dvb_ringbuffer_flush() calls must also be considered
as write operations. As a consequence, you would have to add spinlock
protection at many places in the code...

So I suggest to leave dvb_ringbuffer_flush() as is and zero the read and
write pointers only where it is really required...

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
