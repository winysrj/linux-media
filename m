Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:53417 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760996AbZALWjY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2009 17:39:24 -0500
Subject: Re: saa7134: race between device initialization and first interrupt
From: hermann pitton <hermann-pitton@arcor.de>
To: Andy Walls <awalls@radix.net>
Cc: Hartmut Hackmann <hartmut.hackmann@t-online.de>,
	v4l-list <video4linux-list@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Marcin Slusarz <marcin.slusarz@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Trent Piepho <xyzzy@speakeasy.org>
In-Reply-To: <1231723379.10277.46.camel@palomino.walls.org>
References: <20090104215738.GA9285@joi>
	 <20090108005039.6eeeb470@pedra.chehab.org>
	 <1231555687.3122.59.camel@palomino.walls.org> <20090110120213.GA5737@joi>
	 <1231591056.3111.7.camel@palomino.walls.org>
	 <1231641126.2613.10.camel@pc10.localdom.local>
	 <1231643119.10110.41.camel@palomino.walls.org>
	 <1231718073.8278.32.camel@pc10.localdom.local>
	 <1231722231.10277.38.camel@palomino.walls.org>
	 <1231723379.10277.46.camel@palomino.walls.org>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 23:39:37 +0100
Message-Id: <1231799977.18328.21.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Sonntag, den 11.01.2009, 20:22 -0500 schrieb Andy Walls:
> > 
> > So "dev->input" is NULL when saa7134-tvaudio.c:mute_input_7133() is
> > called and that is what causes the Oops.  It was called by the
> > saa7134_irq() handler trying to take action, shortly after request_irq()
> > was called.  Can you think of why this would happen?
> > 
> Hermann,
> 
> I just looked at request_irq() on my Fedora 7
> 
> 
> int request_irq(unsigned int irq, irq_handler_t handler,
>                 unsigned long irqflags, const char *devname, void *dev_id)
> {
> [...]
> #ifdef CONFIG_DEBUG_SHIRQ
>         if (irqflags & IRQF_SHARED) {
>                 /*
>                  * It's a shared IRQ -- the driver ought to be prepared for it
>                  * to happen immediately, so let's make sure....
>                  * We do this before actually registering it, to make sure that
>                  * a 'real' IRQ doesn't run in parallel with our fake
>                  */
>                 unsigned long flags;
> 
>                 local_irq_save(flags);
>                 handler(irq, dev_id);
>                 local_irq_restore(flags);
>         }
> #endif
> [...]
> 
> Maybe the kernels with the reported oops were built with
> CONFIG_DEBUG_SHIRQ set, which will call the saa7134_irq() handler
> immediately.  CONFIG_DEBUG_SHIRQ is obviously intended to "smoke out"
> device driver irq handlers that could experience an intermittent oops
> with shared irqs.
> 
> Maybe you could enable this in you kernel and reproduce the Ooops?

only on the 2.6.27.2 on the amd quad this was not enabled.

The Fedora 8 and Fedora 10 kernels do have it enabled and it seems to
make no difference and the old 2.6.22 i did not check yet.

I'll send configs and other info of all 4 machines I can test on off
list. Maybe there are ideas for stress tests to hit the supposed race.

Cheers,
Hermann


> Regards,
> Andy
> 
> > I don't know.  If no one here can test it and confirm a fix, maybe we
> > just forget about it until someone with hardware complains?


