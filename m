Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:58744 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbZCTVca (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 17:32:30 -0400
Subject: Re: [linux-dvb] FusionHDTV7 and v4l causes kernel panic
From: Andy Walls <awalls@radix.net>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <008a01c9a988$e11cd7a0$0a00a8c0@vorg>
References: <000701c9a5de$09033e20$0a00a8c0@vorg>
	 <49BE5B36.1080901@linuxtv.org> <003a01c9a69a$0de42640$0a00a8c0@vorg>
	 <1237252028.3303.41.camel@palomino.walls.org>
	 <000401c9a838$c690c0a0$0a00a8c0@vorg>
	 <1237430932.3303.103.camel@palomino.walls.org>
	 <008a01c9a988$e11cd7a0$0a00a8c0@vorg>
Content-Type: text/plain
Date: Fri, 20 Mar 2009 17:33:24 -0400
Message-Id: <1237584804.3295.7.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-03-20 at 11:22 -0700, Timothy D. Lenz wrote:
> Not sure where I was suposed to reply to. When replying I find the replys are coming from diffrent lists and out look is picking
> that up. At the bottom it says v4l related stuff should go to linux-media@vger.kernel.org, but the thread started in
> linux-dvb@linuxtv.org. So I'm re-replying in linux-dvb@linuxtv.org.

Tim,

I didn't forget.  I saw your message.  (I've been busy with yardwork
today.)  Linux-media or linux-dvb are both appropriate lists.

> After searching the internet for ways to redirect the error to serial or other system and not getting to work, I typed out by hand
> what is on the screen minus the cpu dump which is mostly scrolled off anyway and thus gone. In trying to get the dump out ttyS0 I
> found I was getting different dumps to screen.
> When I use:
>   kernel /boot/vmlinuz-2.6.26.8.20090311.1 root=/dev/hda1 ro quiet console=ttyS0,115200n8 console=tty0
> 
> I get:
> Call Trace:
>  [<f8aa406f>] netup_ci_slot_status+0x2e/0x34 [cx23885]
>  [<f8aa07ff>] cx23885_irq+0x327/0x3d8 [cx23885]
>  [<c013d10c>] handle_IRQ_event+0x1a/0x3f
>  [<c013df36>] handle_fasteoi_irq+0x76/0xab
>  [<c0105236>] do_IRQ+0x4f/0x65
>  [<c010366f>] common_interrupt+0x23/0x28
>  =======================
> Code: 00 74 04 0f 0b eb fe 89 d8 e8 ed a3 ff ff ba 01 00 00 00 5b 89 d0 5e c3 51
>  89 d1 8b 15 20 ba 3e c0 e8 52 ff ff ff 5a c3 53 89 c3 <f0> 0f ba 2a 00 19 c0 31
>  c9 85 c0 75 54 8d 42 04 39 42 04 74 04
> EIP: [<c012a8c6>] queue_work+0x3/0x68 SS:ESR 0068:f7733f40
> Kernel panic - not syncing: Fatal exception in interrupt
> 
> When I use the default setting:
>   kernel /boot/vmlinuz-2.6.26.8.20090311.1 root=/dev/hda1 ro quiet
> 
> I get:
> Call Trace:
>  [<f8aa406f>] netup_ci_slot_status+0x2e/0x34 [cx23885]
>  [<f8aa07ff>] cx23885_irq+0x327/0x3d8 [cx23885]
>  [<c013d10c>] handle_IRQ_event+0x1a/0x3f
>  [<c013df36>] handle_fasteoi_irq+0x76/0xab
>  [<c0105236>] do_IRQ+0x4f/0x65
>  [<c010366f>] common_interrupt+0x23/0x28
>  [<c0308096>] _spin_unlock_irq+0x5/0x19
>  [<c011e3ba>] do_syslog+0x12f/0x2f1
>  [<c010369c>] reschedule_interrupt+0x28/0x30
>  [<c012cd38>] autoremove_wake_function+0x0/0x2d
>  [<c018f27a>] kmsg_read+0x0/0x36
>  [<c01888cf>] proc_reg_read+0x60/0x73
>  [<c018886f>] proc_reg_read+0x0/0x73
>  [<c015d9cf>] vfs_read+0x81/0xf4
>  [<c015dada>] sys_read+0x3c/0x63
>  [<c0102c7d>] sysenter_past_esp+0x6a/0x91
>  =======================
> Code: 00 74 04 0f 0b eb fe 89 d8 e8 ed a3 ff ff ba 01 00 00 00 5b 89 d0 5e c3 51
>  89 d1 8b 15 20 ba 3e c0 e8 52 ff ff ff 5a c3 53 89 c3 <f0> 0f ba 2a 00 19 c0 31
>  c9 85 c0 75 54 8d 42 04 39 42 04 74 04
> EIP: [<c012a8c6>] queue_work+0x3/0x68 SS:ESR 0068:f7693e7c
> Kernel panic - not syncing: Fatal exception in interrupt
> 
> It may be a bit different each time because I think I've seen longer "Call Trace" dumps

OK.  This is the failure mode I thought.  I'm not sure how it can
happen: the driver treats your device like a NetUp unit, but you have a
FusionHDTV7.  I'll take a harder look later tonight.

In the meantime, as a workaround you can "#if 0" out the following block
of code in
linux/driver/media/video/cx23885/cx23885-core.c:cx23885_irq():
        
#if 0
        if (cx23885_boards[dev->board].cimax > 0 &&
                ((pci_status & PCI_MSK_GPIO0) || (pci_status & PCI_MSK_GPIO1)))
                /* handled += cx23885_irq_gpio(dev, pci_status); */
                handled += netup_ci_slot_status(dev, pci_status);
#endif

that should stop this particular panic for you.  Things still may not
work right though...

Regards,
Andy



> ----- Original Message ----- 
> From: "Andy Walls" <awalls@radix.net>
> To: <linux-media@vger.kernel.org>
> Cc: <linux-dvb@linuxtv.org>
> Sent: Wednesday, March 18, 2009 7:48 PM
> Subject: Re: [linux-dvb] FusionHDTV7 and v4l causes kernel panic
> 
> 
> > On Wed, 2009-03-18 at 19:16 -0700, Timothy D. Lenz wrote:
> > > I've added
> > >     console=ttyS0,115200 console=tty0
> > > to the kernel command line options and with out the console=tty0 part the dump no longer shows on the monitor, so redirect seems
> to
> > > work but loging the serial port on a second computer gets nothing. I tested the connection with echo and that worked but the
> kernel
> > > dump won't go out the port.  The last 2 lines of the screen are:
> > >
> > > EIP: [<c012a8c6>] queue_work+0x3/0x68 SS:ESP 0068:f778dd24
> > > Kernel panic - not syncing: Fatal exception in interrupt
> >
> > Hmm.  The only thing in the cx23885 driver that tries to schedule work,
> > and thus the only thing that could possibly pass in a bad argument, is
> > the netup_ci_slot_status() function.  It gets called when an IRQ comes
> > in indicating a GPIO[01] event, and the driver thinks the card is a
> > NetUp Dual DVB-S2 CI card.
> >
> > That's consistent with the "fatal exception in interrupt", but without
> > the backtrace, one can't be completely sure this call to queue work was
> > initiated by the cx23885 driver and a problem with cx23885 data
> > structures.  (But it is the most likely scenario, IMO)
> > I just can't see how netup_ci_slot_status() get's called for your card.
> >
> >
> > > Any way to get the dump to go out the serial port?
> >
> > Does 9600 baud help? (Just a guess.)
> >
> > Regards,
> > Andy
> >
> > > ----- Original Message ----- 
> > > From: "Andy Walls" <awalls@radix.net>
> > > To: "Timothy D. Lenz" <tlenz@vorgon.com>
> > > Cc: <linux-media@vger.kernel.org>
> > > Sent: Monday, March 16, 2009 6:07 PM
> > > Subject: Re: [linux-dvb] FusionHDTV7 and v4l causes kernel panic
> > >
> > >
> > > > On Mon, 2009-03-16 at 17:46 -0700, Timothy D. Lenz wrote:
> > > > > When it panics, there is no log, just a bunch of stuff that that scrolls fast on the main monitor then cold lock.
> > > > >  No way to scroll
> > > > > back.
> > > >
> > > > Not even Shift+PageUp ?
> > > >
> > > >
> > > >
> > > > >  I looked at the logs and the ones that are text had nothing about it.
> > > >
> > > > Digital camera or pencil and paper will be least complex way to capture
> > > > the ooops data.  Please don't leave out the "Code" bytes at the bottom
> > > > and do your best to make sure those are absolutely correct.
> > > >
> > > > Regards,
> > > > Andy
> > > >
> > > >
> > > > > ----- Original Message ----- 
> > > > > From: "Steven Toth" <stoth@linuxtv.org>
> > > > > To: <linux-media@vger.kernel.org>
> > > > > Cc: <linux-dvb@linuxtv.org>
> > > > > Sent: Monday, March 16, 2009 6:59 AM
> > > > > Subject: Re: [linux-dvb] FusionHDTV7 and v4l causes kernel panic
> > > > >
> > > > >
> > > > > > Timothy D. Lenz wrote:
> > > > > > > Using kernel 2.6.26.8 and v4l from a few days ago. When I modprobe cx23885 to load the drivers, I get kernel panic
> > > > > >
> > > > > > We'll need the oops.
> > > > > >
> > > > > > - Steve
> > > > > >
> > > > > > _______________________________________________
> > > > > > linux-dvb users mailing list
> > > > > > For V4L/DVB development, please use instead linux-media@vger.kernel.org
> > > > > > linux-dvb@linuxtv.org
> > > > > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 
> 
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

