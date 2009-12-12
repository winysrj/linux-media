Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:57279 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761480AbZLLC7Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2009 21:59:16 -0500
Subject: Re: IR Receiver on an Tevii S470
From: Andy Walls <awalls@radix.net>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org, Steven Toth <stoth@linuxtv.org>,
	Matthias Fechner <idefix@fechner.net>
In-Reply-To: <200912120342.40061.liplianin@me.by>
References: <200912120230.36902.liplianin@me.by>
	 <1260579637.1826.4.camel@localhost>  <200912120342.40061.liplianin@me.by>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Dec 2009 21:58:48 -0500
Message-Id: <1260586728.1826.11.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-12-12 at 03:42 +0200, Igor M. Liplianin wrote:
> On 12 декабря 2009 03:00:37 Andy Walls wrote:
> > On Sat, 2009-12-12 at 02:30 +0200, Igor M. Liplianin wrote:
> > > On 11 декабря 2009, "Igor M. Liplianin" <liplianin@me.by> wrote:
> > > > On Thu, 2009-12-10 at 18:16 +0200, Igor M. Liplianin wrote:
> > > > > On 10 декабря 2009 03:12:39 Andy Walls wrote:
> > > > > > On Wed, 2009-12-09 at 17:54 +0200, Igor M. Liplianin wrote:
> > > > > > > > > > Igor and Matthias,
> > > > > > > > > >
> > > > > > > > > > Please try the changes that I have for the TeVii S470 that
> > > > > > > > > > are here:
> > > > > > > > > >
> > > > > > > > > > 	http://linuxtv.org/hg/~awalls/cx23885-ir
> > > > >
> > > > > First try, without pressing IR keys
> > > > >
> > > > > cx25840 3-0044: IRQ Enables:     rse rte roe
> > > > > cx25840 3-0044: IRQ Status:  tsr
> > > > > cx25840 3-0044: IRQ Enables:     rse rte roe
> > > > > irq 16: nobody cared (try booting with the "irqpoll" option)
> > > >
> > > > please try again when you have time.
> > > >
> > > > 	# modprobe cx25840 debug=2 ir_debug=2
> > > > 	# modprobe cx23885 debug=7
> > >
> > > dmesg is full of repeated lines:
> > >
> > > cx25840 3-0044: AV Core IRQ status (entry):
> > > cx25840 3-0044: AV Core IRQ status (exit):
> >
> > A strange thing here is that under this condition my changes should
> > never claim the AV Core interrupt is "handled".  I don't know why you
> > didn't get the "nobody cared" message again.
> I did, but not frequently. I thought it is obvious :)

OK, that's better. :P

I have checked in more changes, please try when you get the chance.

Please be aware that I reconfigured the drive of one signal PAD in the
AV Core - I'm hoping to stop false interrupts.  I did not reconfigure
the corresponding IO pin in the bridge driver - I left it at whatever
was the default.  


(I think I'm going to have to buy a CX23885 based card soon...)

Regards,
Andy



