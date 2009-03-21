Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:65501 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbZCUXHS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Mar 2009 19:07:18 -0400
Subject: Re: [linux-dvb] FusionHDTV7 and v4l causes kernel panic
From: Andy Walls <awalls@radix.net>
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
In-Reply-To: <000401c9aa59$730d42f0$0a00a8c0@vorg>
References: <000701c9a5de$09033e20$0a00a8c0@vorg>
	 <49BE5B36.1080901@linuxtv.org> <003a01c9a69a$0de42640$0a00a8c0@vorg>
	 <1237252028.3303.41.camel@palomino.walls.org>
	 <000401c9a838$c690c0a0$0a00a8c0@vorg>
	 <1237430932.3303.103.camel@palomino.walls.org>
	 <008a01c9a988$e11cd7a0$0a00a8c0@vorg>
	 <1237597841.3284.71.camel@palomino.walls.org>
	 <001c01c9aa04$0347d480$0a00a8c0@vorg>
	 <1237649572.3291.14.camel@palomino.walls.org>
	 <000401c9aa59$730d42f0$0a00a8c0@vorg>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 19:08:22 -0400
Message-Id: <1237676902.3298.6.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-03-21 at 12:15 -0700, Timothy D. Lenz wrote:
> modprobe cx23885 card=10 debug =7  still cause panic.
> 
> I searched in /usr/src/v4l/v4l-dvb/linux/drivers/media/video/cx23885/cx23885-core.c and the closest section to what you list looks
> like this:
> 
>  if ((pci_status & PCI_MSK_GPIO0) || (pci_status & PCI_MSK_GPIO1))
>   /* handled += cx23885_irq_gpio(dev, pci_status); */
>   handled += netup_ci_slot_status(dev, pci_status);
> 

Oh.  You're not using the latest v4l-dvb repo.  I see Hans fix your
particular bug about 8 days ago and it was pulled in some time after
then:

http://linuxtv.org/hg/v4l-dvb/rev/6e85a8c897e9

[big snip]

Use the latest v4l-dvb.  I bet you'll be fine.

Regards,
Andy



> ----- Original Message ----- 
> From: "Andy Walls" <awalls@radix.net>
> To: "Timothy D. Lenz" <tlenz@vorgon.com>
> Cc: <linux-media@vger.kernel.org>
> Sent: Saturday, March 21, 2009 8:32 AM
> Subject: Re: [linux-dvb] FusionHDTV7 and v4l causes kernel panic
> 
> 
> > On Sat, 2009-03-21 at 02:03 -0700, Timothy D. Lenz wrote:
> > > Not sure what you ment by "if you got the panic to stop by commenting out the call to the problem function?" You want me to
> comment
> > > something out in the driver and recompile v4l?
> >
> > Yes.  I sent two different e-mails.  I'm soory if it caused confusion.
> >
> > To see what's going on we need the panic to stop so we can see what the
> > driver is doing in the logs when being modporbe'd.
> >
> > PLease  add "#if 0/#endif" around to following block of code in
> > linux/driver/media/video/cx23885/cx23885-core.c:cx23885_irq():
> >
> > #if 0
> >         if (cx23885_boards[dev->board].cimax > 0 &&
> >                 ((pci_status & PCI_MSK_GPIO0) || (pci_status & PCI_MSK_GPIO1)))
> >                 /* handled += cx23885_irq_gpio(dev, pci_status); */
> >                 handled += netup_ci_slot_status(dev, pci_status);
> > #endif
> >
> > and recompile and reinstall v4l-dvb.  That should stop this particular
> > panic for you.  (Things still may not work, though.)
> >
> >


