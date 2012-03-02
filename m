Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:37793 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab2CBWtC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 17:49:02 -0500
Message-ID: <4F514CCB.8020502@kolumbus.fi>
Date: Sat, 03 Mar 2012 00:42:19 +0200
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Various nits, fixes and hacks for mantis CA support on
 SMP
References: <20120228010330.GA25786@uio.no>
In-Reply-To: <20120228010330.GA25786@uio.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Hi

Nice work. I looked your code very shortly.

I'm not happy with I2CDONE busy looping either.
I've tried twice lately to swith into I2C IRQ, but those patches have caused I2CDONE timeouts.

Do my following I2C logic thoughts make any sense?

I2C bus might have some underlying requirements:
1. When driver wants to talk to a DVB frontend, it first opens up an I2C gate, then talks, and finally closes the I2C gate. This is ok.
2. After setting up DVB frontend frequency etc. I2C bus should be quiet 10ms (radio silence, to fasten taking DVB TS lock). This is ok.

There might be race conditions, that the driver possibly manages:
1. If two threads talk into DVB frontend, one could turn off the I2C gate, while the other is talking to DVB frontend.
   This would case lack of I2CRACK: only way to recover would be to turn the I2C gate on, and then redo the I2C transfer.
2. Thread 1 turns I2C gate into DVB frontend and sets up frequency. It waits 10ms. Thread 2 will talk to some I2C device, thus breaking the silence. This case would not be so bad, because it would just delay taking the wanted DVB TS lock.

Regards,
Marko Ristola

28.02.2012 03:03, Steinar H. Gunderson kirjoitti:
> Hi,
> 
> This patch, against 3.3-rc4, is basically a conglomerate of patches that
> together seem to make CA support on mantis working and stable, even on SMP
> systems. (I'm using a Terratec Cinergy DVB-S2 card with a Conax CAM, with
> mumudvb as userspace.) There are a few fixes from this mailing list and some
> of my own; the end result is too ugly to include, and there are still things
> I don't understand at all, but I hope it can be useful for some.
> 
> Below is the list of what the patch does:
> 
>  - I've followed the instructions from some post on this mailing list
>    to enable CAM support in the first place (mantis_set_direction move
>    to mantis_pci.c, uncomment mantis_ca_init).
> 
>  - The MANTIS_GPIF_STATUS fix from http://patchwork.linuxtv.org/patch/8776/.
>    Not that it seems to change a lot for me, but it makes sense.
> 
>  - I've fixed a ton of SMP-related bugs. Basically a lot of the members of
>    mantis_ca were accessed from several threads without a mutex, which is a
>    big no-no; I've mostly changed to using atomic operations here, although
>    I also added some locks were it made sense (e.g. when resetting the CAM).
>    The ca_lock is replaced by a more general int_stat_lock, which ideally
>    is held when banging on MANTIS_INT_STAT. (I have no hardware
>    documentation, so I'm afraid I don't really know the specifics here.)
> 
>  - mantis_hif_write_wait() would never clear MANTIS_SBUF_OPDONE_BIT,
>    leading to a lot of operations never actually waiting for the callback.
>    I've added many such fixes, as well as debugging output when the
>    bit is in a surprising state (e.g., MANTIS_SBUF_OPDONE_BIT set before the
>    beginning of an operation, where it really should be cleared).
> 
>  - Some operations check for timeout by testing if wait_event_timeout()
>    return -ERESTARTSYS. However, wait_event_timeout() can can never
>    do this; the return value for timeout is zero. I've fixed this
>    (well, I seemingly forgot one; have to do that in the next version :-) ).
>    Unfortunately, this make the problems in the next point a _lot_ worse,
>    since timeouts are now actually percolated up the stack.
> 
>  - As others have noticed, sometimes, especially during DMA transfers,
>    the IRQ0 flag is never properly set and thus reads never return.
>    (The typical case for this is when we've just done a write and the
>    en50221 thread is waiting for the CAM status word to signal STATUSREG_DA;
>    if this doesn't happen in a reasonable amount of time, the upstream
>    libdvben50221.so will report errors back to mumudvb.) I have no idea why
>    this happens more often on SMP systems than on UMP systems, but they
>    really seem to do. I haven't found any reasonable workaround for reliable
>    polling either, so I'm making a hack -- if there's nothing returned in two
>    milliseconds, the read is simply assumed to have completed. This is an
>    unfortunate hack, but in practice it's identical to the previous behavior
>    except with a shorter timeout.
> 
>  - A hack to fix a mutex issue in the DVB layer; dvb_usercopy(), which is
>    called on all ioctls, not only copies data to and from userspace,
>    but also takes a lock on the file descriptor, which means that only one ioctl 
>    can run at a time. This means that if one thread of mumudvb is busy trying
>    to get, say, the SNR from the frontend (which can hang due to the issue
>    above), the CAM thread's ioctl(fd, CA_GET_SLOT_INFO, ...) will hang,
>    even though it doesn't need to communicate with the hardware at all.
>    This obviously requires a better fix, but I don't know the generic DVB
>    layer well enough to say what it is. Maybe it's some sort of remnant
>    of from when all ioctl()s took the BKL. Note that on UMP kernels without
>    preemption, mutex_lock is to the best of my knowledge a no-op, so these
>    delay issues would not show up on non-SMP.
> 
>  - Tiny cleanups: Removed some unused mmread()s and structure members.
>    Some debugging messages have been made more specific or clearer
>    (e.g. reads say what address they're from, the I2C subsystem reports
>    if there were any timeouts, the interrupt handler properly clears
>    the RISC status word so it isn't shown as <Unknown>).
> 
> I'm still not happy with the bit-banging on the I2C interface (as opposed to
> dealing with it in the interrupt handler); I long suspected it for causing
> the IRQ0 problems, especially as they seem to have a sort-of similar issue
> with I2CDONE/I2CRACk never being set, but it seem the DMA transfers is really
> what causes it somehow, so I've left it alone.
> 
> Anyway, if there are specific pieces people want me to split out for
> mainline, I'd be happy to do that and add the required Signed-Off-By lines
> etc. Let me know.
> 
> /* Steinar */

