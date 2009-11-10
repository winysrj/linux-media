Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:2974 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbZKJN7G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 08:59:06 -0500
Received: by ey-out-2122.google.com with SMTP id 9so7652eyd.19
        for <linux-media@vger.kernel.org>; Tue, 10 Nov 2009 05:59:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4AF83EAB.4040104@tangobravo.co.uk>
References: <4AF83EAB.4040104@tangobravo.co.uk>
Date: Tue, 10 Nov 2009 08:59:09 -0500
Message-ID: <37219a840911100559n5379be9dy822093b71fe07d1f@mail.gmail.com>
Subject: Re: Siano DVB driver and locking/sleeping
From: Michael Krufky <mkrufky@linuxtv.org>
To: Tim Borgeaud <tim@tangobravo.co.uk>
Cc: linux-media@vger.kernel.org, udia@siano-ms.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 9, 2009 at 11:09 AM, Tim Borgeaud <tim@tangobravo.co.uk> wrote:
> I am actually a FreeBSD user that has been using some Linux DVB driver code
> to create a kernel module for FreeBSD. I am working at getting various bits
> of Linux driver code to compile on FreeBSD (see
> http://www.tangobravo.co.uk/v4l-compat).
>
> During development of compatibility code (to allow Linux driver source to be
> used more easily with FreeBSD) I have happened to take a look at the source
> code for the siano driver (drivers/media/dvb/siano/).
>
> Within the smscoreapi.c source code there is some code, concerning locking
> and waiting, that seems to run contrary to my expectations. It leads me to
> suspect that my "emulation" of Linux locking and waiting (sleeping)
> functionality may be incomplete or, just possibly, that the siano driver
> code could do with some adjustment.
>
>
> In smscoreapi.c there are two functions: smscore_getbuffer and
> smscore_putbuffer. These appear to be synchronized using a spin lock.
>
> In smscore_getbuffer:
> -----------------------------------------------------------------------
>  DEFINE_WAIT(wait);
>
>  spin_lock_irqsave(&coredev->bufferslock, flags);
>
>  /* This function must return a valid buffer, since the buffer list is
>   * finite, we check that there is an available buffer, if not, we wait
>   * until such buffer become available.
>   */
>
>  prepare_to_wait(&coredev->buffer_mng_waitq, &wait, TASK_INTERRUPTIBLE);
>
>  if (list_empty(&coredev->buffers))
>          schedule();
>
>  finish_wait(&coredev->buffer_mng_waitq, &wait);
>
>  cb = (struct smscore_buffer_t *) coredev->buffers.next;
>  list_del(&cb->entry);
>
>  spin_unlock_irqrestore(&coredev->bufferslock, flags);
> -------------------------------------------------------------------------------
>
> It appears that schedule() could be invoked while the coredev->bufferslock
> spinlock is held. I was under the impression that one should not hold a spin
> lock while calling a function that may cause a thread to sleep.
>
> This suggests that either:
>
> 1) The schedule() drops the spin lock in some way that I am unaware of. I'd
> like to know if I need to investigate such functionality of schedule().
>
> 2) It is permissible to sleep with a spin lock held and that in this case
> deadlock could not be caused.
>
>
> In addition, smscore_putbuffer simply consists of:
> -------------------------------------------------------------------------
>     wake_up_interruptible(&coredev->buffer_mng_waitq);
> list_add_locked(&cb->entry, &coredev->buffers, &coredev->bufferslock);
> -------------------------------------------------------------------------
>
> I am not certain how the synchronization works. However, without better
> knowledge of when certain events may take place in the Linux kernel, it
> appears that the wake_up_interruptible in smscore_putbuffer completes before
> any new buffer is actually added to the coredev->buffers list.
>
> As far as I can tell, if a thread is made to sleep inside smscore_getbuffer
> and the coredev->bufferslock is held during the sleep, the thread will wait
> for a second thread to execute the wake_up_interruptible in
> smscore_putbuffer (perhaps why the spin lock cannot be held before the
> wake_up?).
>
> Then, if the sleeping thread does not actually get woken until after the
> list_add_locked is invoked (from smscore_putbuffer), deadlock would appear
> possible since the list_add_locked function call will end up spinning while
> waiting for the spin lock to be released (by the sleeping thread).
>
> If the sleeping thread is woken and resumes before the list_add_locked
> completes (i.e. before it obtains the spin lock), then it would seem
> possible that the two statements in smscore_getbuffer:
>
>  cb = (struct smscore_buffer_t *) coredev->buffers.next;
>  list_del(&cb->entry);
>
> Will not produce the desired results. The buffers list will be empty and
> coredev->buffers->next == &coredev->buffers (not the address of a
> smscore_buffer_t).
>
> Even if the spin lock is dropped in schedule(), there might exist a race
> where, after the wake_up_interruptible it might be possible for the woken
> thread to try to retrieve the next buffer before the list_add_locked
> completes.
>
> Is there some synchronization in the siano driver or some functionality of
> Linux that I am unaware of that would prevent these potential problems?

The Siano driver is not a model Linux driver by any means.  You have
found problems in the driver that should be dealt with, not
replicated.

This is the open source community -- we're glad that Siano went as far
as contributing this driver to the Linux Kernel.  Anybody is welcome
to improve on the current codebase, patches are always welcome.

-Mike
