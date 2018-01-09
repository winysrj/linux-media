Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:58869 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754885AbeAIRmo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Jan 2018 12:42:44 -0500
Date: Tue, 9 Jan 2018 15:42:35 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Ingo Molnar <mingo@kernel.org>,
        Josef Griebichler <griebichler.josef@gmx.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Rik van Riel <riel@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@redhat.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        LMML <linux-media@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: dvb usb issues since kernel 4.9
Message-ID: <20180109154235.2a42f0a0@vento.lan>
In-Reply-To: <CA+55aFwuAojr7vAfiRO-2je-wDs7pu+avQZNhX_k9NN=D7_zVQ@mail.gmail.com>
References: <CA+55aFx90oOU-3R8pCeM0ESTDYhmugD5znA9LrGj1zhazWBtcg@mail.gmail.com>
        <Pine.LNX.4.44L0.1801081354450.1908-100000@iolanthe.rowland.org>
        <CA+55aFwuAojr7vAfiRO-2je-wDs7pu+avQZNhX_k9NN=D7_zVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 8 Jan 2018 11:51:04 -0800
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> On Mon, Jan 8, 2018 at 11:15 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> >
> > Both dwc2_hsotg and ehci-hcd use the tasklets embedded in the
> > giveback_urb_bh member of struct usb_hcd.  See usb_hcd_giveback_urb()
> > in drivers/usb/core/hcd.c; the calls are
> >
> >         else if (high_prio_bh)
> >                 tasklet_hi_schedule(&bh->bh);
> >         else
> >                 tasklet_schedule(&bh->bh);
> >
> > As it turns out, high_prio_bh gets set for interrupt and isochronous
> > URBs but not for bulk and control URBs.  The DVB driver in question
> > uses bulk transfers.  
> 
> Ok, so we could try out something like the appended?
> 
> NOTE! I have not tested this at all. It LooksObvious(tm), but...
> 
>                     Linus



>  kernel/softirq.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 2f5e87f1bae2..97b080956fea 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -79,12 +79,16 @@ static void wakeup_softirqd(void)
>  
>  /*
>   * If ksoftirqd is scheduled, we do not want to process pending softirqs
> - * right now. Let ksoftirqd handle this at its own rate, to get fairness.
> + * right now. Let ksoftirqd handle this at its own rate, to get fairness,
> + * unless we're doing some of the synchronous softirqs.
>   */
> -static bool ksoftirqd_running(void)
> +#define SOFTIRQ_NOW_MASK ((1 << HI_SOFTIRQ) | (1 << TASKLET_SOFTIRQ))
> +static bool ksoftirqd_running(unsigned long pending)
>  {
>  	struct task_struct *tsk = __this_cpu_read(ksoftirqd);
>  
> +	if (pending & SOFTIRQ_NOW_MASK)
> +		return false;
>  	return tsk && (tsk->state == TASK_RUNNING);
>  }
>  
> @@ -325,7 +329,7 @@ asmlinkage __visible void do_softirq(void)
>  
>  	pending = local_softirq_pending();
>  
> -	if (pending && !ksoftirqd_running())
> +	if (pending && !ksoftirqd_running(pending))
>  		do_softirq_own_stack();
>  
>  	local_irq_restore(flags);
> @@ -352,7 +356,7 @@ void irq_enter(void)
>  
>  static inline void invoke_softirq(void)
>  {
> -	if (ksoftirqd_running())
> +	if (ksoftirqd_running(local_softirq_pending()))
>  		return;
>  
>  	if (!force_irqthreads) {


Hi Linus,

Patch makes sense to me, although I was not able to test it myself.

I set a RPi3 machine here with vanilla Kernel 4.14.11 running a standard
raspbian distribution (with elevator=deadline). Right now, I'm trying to
reproduce the bug with dvbv5-zap. I may eventually do more tests on 
some other slow machines.

Usually, applications like tvheadend records just one channel. So, instead
of a ~58 Mbits/s payload, it uses, typically, ~11 Mbits/s for a HD channel.
This is usually filtered by hardware. Here, I'm forcing to record the
entire TS, in order to make easier to reproduce the issue. So, I'm forcing
a condition that it is usually worse than real usecases (at last for HD - I
I don't have any DVB stream here with a 4K channel).

>From what I checked so far, with vanila upstream Kernel on RPi3, just
receiving a DVB stream - or receiving it and writing to /dev/null works
with or without your patch.

The problem starts to happen when there are concurrency with writes.

On my preliminar tests, writing to a file on an ext4 partition at a
USB stick loses data up to the point to make it useless (1/4 of the data
is lost!). However, writing to a class 10 microSD card is doable.

If you're curious enough, this is what I'm doing (that are the results
while using class 10 microSD card):

$ FILE=/tmp/out.ts; for i in $(seq 1 6); do echo "step $i"; rm $FILE 2>/dev/null; dvbv5-zap -l universal -c ~/vivo-channels.conf NBR -o $FILE -P -t60 2>&1|grep -E "(buffer|received)"; du $FILE 2>/dev/null; done 
step 1
  Setting buffer length to 7250000
buffer overrun
buffer overrun
buffer overrun
buffer overrun
buffer overrun
buffer overrun
buffer overrun
received 347504652 bytes (5656 Kbytes/sec)
339368	/tmp/out.ts
step 2
  Setting buffer length to 7250000
buffer overrun
received 408995880 bytes (6656 Kbytes/sec)
399416	/tmp/out.ts
step 3
  Setting buffer length to 7250000
received 412999716 bytes (6722 Kbytes/sec)
403328	/tmp/out.ts
step 4
  Setting buffer length to 7250000
buffer overrun
received 415564788 bytes (6763 Kbytes/sec)
405832	/tmp/out.ts
step 5
  Setting buffer length to 7250000
received 412999716 bytes (6722 Kbytes/sec)
403324	/tmp/out.ts
step 6
  Setting buffer length to 7250000
received 408366080 bytes (6646 Kbytes/sec)
398796	/tmp/out.ts

My plan is to do more tests along this week, and try to tweak a little
bit both userspace and kernelspace, in order to see if I can get better
results.

Thanks,
Mauro
