Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:33734 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbZLLAaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 19:30:30 -0500
Received: by bwz27 with SMTP id 27so1000371bwz.21
        for <linux-media@vger.kernel.org>; Fri, 11 Dec 2009 16:30:36 -0800 (PST)
To: linux-media@vger.kernel.org
Subject: Re: IR Receiver on an Tevii S470
Content-Disposition: inline
From: "Igor M. Liplianin" <liplianin@me.by>
Cc: Steven Toth <stoth@linuxtv.org>,
	Matthias Fechner <idefix@fechner.net>,
	Andy Walls <awalls@radix.net>
Date: Sat, 12 Dec 2009 02:30:36 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912120230.36902.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11 декабря 2009, "Igor M. Liplianin" <liplianin@me.by> wrote:
> On Thu, 2009-12-10 at 18:16 +0200, Igor M. Liplianin wrote:
> > On 10 декабря 2009 03:12:39 Andy Walls wrote:
> > > On Wed, 2009-12-09 at 17:54 +0200, Igor M. Liplianin wrote:
> > > > > > > Igor and Matthias,
> > > > > > >
> > > > > > > Please try the changes that I have for the TeVii S470 that are
> > > > > > > here:
> > > > > > >
> > > > > > > 	http://linuxtv.org/hg/~awalls/cx23885-ir
> > > >
> > > > In fact some time ago I was writing some code for cx23885 IR, but not
> > > > reached IR interrupts to work. Though I used PCI_MSK_AV_CORE (1 <<
> > > > 27), then test register PIN_CTRL for field FLD_IR_IRQ_STAT.
> > >
> > > Igor,
> > >
> > > You are exactly right on this.  I used the wrong interrupt status flag.
> > > I have pushed a patch to my repository to use the PCI_MSK_AV_CORE
> > > status flag.
> > >
> > > Could you please update an test the TeVii S470 again when you have
> > > time?
> > >
> > > > I have Compro E650F with RC6 remote, also have RC5 remote from TV
> > > > set. I will made little hack to test Compro & RC5.
> > >
> > > OK. Thank you.
> > >
> > > Regards,
> > > Andy
> >
> > First try, without pressing IR keys
> >
> > cx25840 3-0044: IRQ Enables:     rse rte roe
> > cx25840 3-0044: IRQ Status:  tsr
> > cx25840 3-0044: IRQ Enables:     rse rte roe
> > irq 16: nobody cared (try booting with the "irqpoll" option)
> > Pid: 0, comm: swapper Not tainted 2.6.32 #2
> > Call Trace:
> >  [<c1052db0>] ? __report_bad_irq+0x24/0x69
> >  [<c1052db7>] ? __report_bad_irq+0x2b/0x69
> >  [<c1052edc>] ? note_interrupt+0xe7/0x13f
> >  [<c1053416>] ? handle_fasteoi_irq+0x7a/0x97
> >  [<c1004411>] ? handle_irq+0x38/0x3f
> >  [<c1003bd1>] ? do_IRQ+0x38/0x89
> >  [<c1002ea9>] ? common_interrupt+0x29/0x30
> >  [<c1007a1e>] ? mwait_idle+0x7a/0x7f
> >  [<c1001b93>] ? cpu_idle+0x37/0x4c
> > handlers:
> > [<c13179ad>] (usb_hcd_irq+0x0/0x59)
> > [<f85ba5e7>] (azx_interrupt+0x0/0xe7 [snd_hda_intel])
> > [<f88b1d2b>] (cx23885_irq+0x0/0x4a5 [cx23885])
> > Disabling IRQ #16
> > cx25840 3-0044: IRQ Status:  tsr
> > cx25840 3-0044: IRQ Enables:     rse rte roe
> > cx25840 3-0044: IRQ Status:  tsr
>
> OK.  We're getting interrupts from the A/V core, but they are not IR
> related.  They must be audio and video interrupts from the A/V core.
>
> I have checked in new changes:
>
> 	http://linuxtv.org/hg/~awalls/cx23885-ir
>
> please try again when you have time.
>
> 	# modprobe cx25840 debug=2 ir_debug=2
> 	# modprobe cx23885 debug=7
>
> My only concern now, is that I have not turned off all the audio
> interrupts from the A/V core - I could not determine if registers
> 0x80c-0x80f were improtant to set.
>
> Regards,
> Andy
dmesg is full of repeated lines:

cx25840 3-0044: AV Core IRQ status (entry):           
cx25840 3-0044: AV Core IRQ status (exit):           
cx23885[0]/0: pci_status: 0x083f4000  pci_mask: 0x08000001
cx23885[0]/0: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
cx23885[0]/0: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x20
cx23885[0]/0: ts2_status: 0x00000000  ts2_mask: 0x00000000 count: 0xc7383f3a
cx23885[0]/0:  (PCI_MSK_AV_CORE   0x08000000)


Igor
