Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:32881 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbZLJQQW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 11:16:22 -0500
Received: by bwz27 with SMTP id 27so6228074bwz.21
        for <linux-media@vger.kernel.org>; Thu, 10 Dec 2009 08:16:27 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Andy Walls <awalls@radix.net>
Subject: Re: IR Receiver on an Tevii S470
Date: Thu, 10 Dec 2009 18:16:21 +0200
Cc: Matthias Fechner <idefix@fechner.net>, linux-media@vger.kernel.org,
	stoth@kernellabs.com
References: <4B0459B1.50600@fechner.net> <200912091754.09985.liplianin@me.by> <1260407559.3084.6.camel@palomino.walls.org>
In-Reply-To: <1260407559.3084.6.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200912101816.21587.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10 декабря 2009 03:12:39 Andy Walls wrote:
> On Wed, 2009-12-09 at 17:54 +0200, Igor M. Liplianin wrote:
> > > > > Igor and Matthias,
> > > > >
> > > > > Please try the changes that I have for the TeVii S470 that are
> > > > > here:
> > > > >
> > > > > 	http://linuxtv.org/hg/~awalls/cx23885-ir
> >
> > In fact some time ago I was writing some code for cx23885 IR, but not
> > reached IR interrupts to work. Though I used PCI_MSK_AV_CORE (1 << 27),
> > then test register PIN_CTRL for field FLD_IR_IRQ_STAT.
>
> Igor,
>
> You are exactly right on this.  I used the wrong interrupt status flag.
> I have pushed a patch to my repository to use the PCI_MSK_AV_CORE status
> flag.
>
> Could you please update an test the TeVii S470 again when you have time?
>
> > I have Compro E650F with RC6 remote, also have RC5 remote from TV set.
> > I will made little hack to test Compro & RC5.
>
> OK. Thank you.
>
> Regards,
> Andy
First try, without pressing IR keys

cx25840 3-0044: IRQ Enables:     rse rte roe
cx25840 3-0044: IRQ Status:  tsr                    
cx25840 3-0044: IRQ Enables:     rse rte roe
irq 16: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Not tainted 2.6.32 #2
Call Trace:
 [<c1052db0>] ? __report_bad_irq+0x24/0x69
 [<c1052db7>] ? __report_bad_irq+0x2b/0x69
 [<c1052edc>] ? note_interrupt+0xe7/0x13f
 [<c1053416>] ? handle_fasteoi_irq+0x7a/0x97
 [<c1004411>] ? handle_irq+0x38/0x3f
 [<c1003bd1>] ? do_IRQ+0x38/0x89
 [<c1002ea9>] ? common_interrupt+0x29/0x30
 [<c1007a1e>] ? mwait_idle+0x7a/0x7f
 [<c1001b93>] ? cpu_idle+0x37/0x4c
handlers:
[<c13179ad>] (usb_hcd_irq+0x0/0x59)
[<f85ba5e7>] (azx_interrupt+0x0/0xe7 [snd_hda_intel])
[<f88b1d2b>] (cx23885_irq+0x0/0x4a5 [cx23885])
Disabling IRQ #16
cx25840 3-0044: IRQ Status:  tsr                    
cx25840 3-0044: IRQ Enables:     rse rte roe
cx25840 3-0044: IRQ Status:  tsr                    

Sorry for not speaking to much :)
-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
