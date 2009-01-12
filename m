Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:50906 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbZALBVI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2009 20:21:08 -0500
Subject: Re: saa7134: race between device initialization and first interrupt
From: Andy Walls <awalls@radix.net>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Hartmut Hackmann <hartmut.hackmann@t-online.de>,
	v4l-list <video4linux-list@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Marcin Slusarz <marcin.slusarz@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <1231722231.10277.38.camel@palomino.walls.org>
References: <20090104215738.GA9285@joi>
	 <20090108005039.6eeeb470@pedra.chehab.org>
	 <1231555687.3122.59.camel@palomino.walls.org> <20090110120213.GA5737@joi>
	 <1231591056.3111.7.camel@palomino.walls.org>
	 <1231641126.2613.10.camel@pc10.localdom.local>
	 <1231643119.10110.41.camel@palomino.walls.org>
	 <1231718073.8278.32.camel@pc10.localdom.local>
	 <1231722231.10277.38.camel@palomino.walls.org>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 20:22:59 -0500
Message-Id: <1231723379.10277.46.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> 
> So "dev->input" is NULL when saa7134-tvaudio.c:mute_input_7133() is
> called and that is what causes the Oops.  It was called by the
> saa7134_irq() handler trying to take action, shortly after request_irq()
> was called.  Can you think of why this would happen?
> 
Hermann,

I just looked at request_irq() on my Fedora 7


int request_irq(unsigned int irq, irq_handler_t handler,
                unsigned long irqflags, const char *devname, void *dev_id)
{
[...]
#ifdef CONFIG_DEBUG_SHIRQ
        if (irqflags & IRQF_SHARED) {
                /*
                 * It's a shared IRQ -- the driver ought to be prepared for it
                 * to happen immediately, so let's make sure....
                 * We do this before actually registering it, to make sure that
                 * a 'real' IRQ doesn't run in parallel with our fake
                 */
                unsigned long flags;

                local_irq_save(flags);
                handler(irq, dev_id);
                local_irq_restore(flags);
        }
#endif
[...]

Maybe the kernels with the reported oops were built with
CONFIG_DEBUG_SHIRQ set, which will call the saa7134_irq() handler
immediately.  CONFIG_DEBUG_SHIRQ is obviously intended to "smoke out"
device driver irq handlers that could experience an intermittent oops
with shared irqs.

Maybe you could enable this in you kernel and reproduce the Ooops?

Regards,
Andy

> I don't know.  If no one here can test it and confirm a fix, maybe we
> just forget about it until someone with hardware complains?
> 
> 
> Regards,
> Andy
> 
> > Thanks,
> > Hermann


