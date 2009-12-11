Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:63905 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849AbZLKCdx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 21:33:53 -0500
Subject: Re: IR Receiver on an Tevii S470
From: Andy Walls <awalls@radix.net>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: Matthias Fechner <idefix@fechner.net>, linux-media@vger.kernel.org,
	stoth@kernellabs.com
In-Reply-To: <200912101816.21587.liplianin@me.by>
References: <4B0459B1.50600@fechner.net>
	 <200912091754.09985.liplianin@me.by>
	 <1260407559.3084.6.camel@palomino.walls.org>
	 <200912101816.21587.liplianin@me.by>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Dec 2009 21:32:55 -0500
Message-Id: <1260498775.10685.5.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-12-10 at 18:16 +0200, Igor M. Liplianin wrote:
> On 10 декабря 2009 03:12:39 Andy Walls wrote:
> > On Wed, 2009-12-09 at 17:54 +0200, Igor M. Liplianin wrote:
> > > > > > Igor and Matthias,
> > > > > >
> > > > > > Please try the changes that I have for the TeVii S470 that are
> > > > > > here:
> > > > > >
> > > > > > 	http://linuxtv.org/hg/~awalls/cx23885-ir
> > >
> > > In fact some time ago I was writing some code for cx23885 IR, but not
> > > reached IR interrupts to work. Though I used PCI_MSK_AV_CORE (1 << 27),
> > > then test register PIN_CTRL for field FLD_IR_IRQ_STAT.
> >
> > Igor,
> >
> > You are exactly right on this.  I used the wrong interrupt status flag.
> > I have pushed a patch to my repository to use the PCI_MSK_AV_CORE status
> > flag.
> >
> > Could you please update an test the TeVii S470 again when you have time?
> >
> > > I have Compro E650F with RC6 remote, also have RC5 remote from TV set.
> > > I will made little hack to test Compro & RC5.
> >
> > OK. Thank you.
> >
> > Regards,
> > Andy
> First try, without pressing IR keys
> 
> cx25840 3-0044: IRQ Enables:     rse rte roe
> cx25840 3-0044: IRQ Status:  tsr                    
> cx25840 3-0044: IRQ Enables:     rse rte roe
> irq 16: nobody cared (try booting with the "irqpoll" option)
> Pid: 0, comm: swapper Not tainted 2.6.32 #2
> Call Trace:
>  [<c1052db0>] ? __report_bad_irq+0x24/0x69
>  [<c1052db7>] ? __report_bad_irq+0x2b/0x69
>  [<c1052edc>] ? note_interrupt+0xe7/0x13f
>  [<c1053416>] ? handle_fasteoi_irq+0x7a/0x97
>  [<c1004411>] ? handle_irq+0x38/0x3f
>  [<c1003bd1>] ? do_IRQ+0x38/0x89
>  [<c1002ea9>] ? common_interrupt+0x29/0x30
>  [<c1007a1e>] ? mwait_idle+0x7a/0x7f
>  [<c1001b93>] ? cpu_idle+0x37/0x4c
> handlers:
> [<c13179ad>] (usb_hcd_irq+0x0/0x59)
> [<f85ba5e7>] (azx_interrupt+0x0/0xe7 [snd_hda_intel])
> [<f88b1d2b>] (cx23885_irq+0x0/0x4a5 [cx23885])
> Disabling IRQ #16
> cx25840 3-0044: IRQ Status:  tsr                    
> cx25840 3-0044: IRQ Enables:     rse rte roe
> cx25840 3-0044: IRQ Status:  tsr                    

OK.  We're getting interrupts from the A/V core, but they are not IR
related.  They must be audio and video interrupts from the A/V core.

I have checked in new changes:

	http://linuxtv.org/hg/~awalls/cx23885-ir

please try again when you have time.

	# modprobe cx25840 debug=2 ir_debug=2
	# modprobe cx23885 debug=7

My only concern now, is that I have not turned off all the audio
interrupts from the A/V core - I could not determine if registers
0x80c-0x80f were improtant to set.

Regards,
Andy

