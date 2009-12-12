Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:42060 "HELO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933444AbZLMB3f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2009 20:29:35 -0500
Subject: Re: IR Receiver on an Tevii S470
From: Andy Walls <awalls@radix.net>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org, Steven Toth <stoth@linuxtv.org>,
	Matthias Fechner <idefix@fechner.net>
In-Reply-To: <200912121349.58436.liplianin@me.by>
References: <200912120230.36902.liplianin@me.by>
	 <200912120342.40061.liplianin@me.by> <1260586728.1826.11.camel@localhost>
	 <200912121349.58436.liplianin@me.by>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Dec 2009 09:15:27 -0500
Message-Id: <1260627327.3104.13.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-12-12 at 13:49 +0200, Igor M. Liplianin wrote:
> On 12 декабря 2009 04:58:48 Andy Walls wrote:
> > On Sat, 2009-12-12 at 03:42 +0200, Igor M. Liplianin wrote:
> > > On 12 декабря 2009 03:00:37 Andy Walls wrote:
> > > > On Sat, 2009-12-12 at 02:30 +0200, Igor M. Liplianin wrote:
> > > > > On 11 декабря 2009, "Igor M. Liplianin" <liplianin@me.by> wrote:
> > > > > > On Thu, 2009-12-10 at 18:16 +0200, Igor M. Liplianin wrote:
> > > > > > > On 10 декабря 2009 03:12:39 Andy Walls wrote:
> > > > > > > > On Wed, 2009-12-09 at 17:54 +0200, Igor M. Liplianin wrote:
> > > > > > > > > > > > Igor and Matthias,
> > > > > > > > > > > >
> > > > > > > > > > > > Please try the changes that I have for the TeVii S470
> > > > > > > > > > > > that are here:
> > > > > > > > > > > >
> > > > > > > > > > > > 	http://linuxtv.org/hg/~awalls/cx23885-ir
> > > > > > >

> >
> > I have checked in more changes, please try when you get the chance.

> cx23885[0]/0: pci_status: 0x08304000  pci_mask: 0x08000000
> cx23885[0]/0: vida_status: 0x00000000 vida_mask: 0x00000000 count: 0x0
> cx23885[0]/0: ts1_status: 0x00000000  ts1_mask: 0x00000000 count: 0x0
> cx23885[0]/0: ts2_status: 0x00000000  ts2_mask: 0x00000000 count: 0x47381f2a
> cx23885[0]/0:  (PCI_MSK_AV_CORE   0x08000000)

> cx25840 3-0044: AV Core IRQ status (entry): ir        
> cx25840 3-0044: IRQ Status:  tsr                    
> cx25840 3-0044: IRQ Enables:     rse rte roe

?! 

Those three lines make no sense together.  Maybe I should take out the
V4L2_SUBDEV_IO_PIN_ACTIVE_LOW setting in cx23885-cards.c.

I'm going to have to buy some hardware and experiment for myself.


BTW, what happens you press a button on an NEC remote?

Thanks for all your help.

Regards,
Andy



