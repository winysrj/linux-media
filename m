Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:45070 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757683AbZLFVlq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Dec 2009 16:41:46 -0500
Subject: Re: IR Receiver on an Tevii S470
From: Andy Walls <awalls@radix.net>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: Matthias Fechner <idefix@fechner.net>, linux-media@vger.kernel.org
In-Reply-To: <200911220303.36715.liplianin@me.by>
References: <4B0459B1.50600@fechner.net> <4B081F0B.1060204@fechner.net>
	 <1258836102.1794.7.camel@localhost>  <200911220303.36715.liplianin@me.by>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Dec 2009 16:40:54 -0500
Message-Id: <1260135654.3101.15.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-11-22 at 03:03 +0200, Igor M. Liplianin wrote:
> On 21 ноября 2009 22:41:42 Andy Walls wrote:
> > > Matthias Fechner schrieb:
> > > > I bought some days ago a Tevii S470 DVB-S2 (PCI-E) card and got it
> > > > running with the driver from:
> > > > http://mercurial.intuxication.org/hg/s2-liplianin
> > > >
> > > > But I was not successfull in got the IR receiver working.
> > > > It seems that it is not supported yet by the driver.
> > > >
> > > > Is there maybe some code available to get the IR receiver with evdev
> > > > running?

> > If the card is using the built in IR controller in the CX23885, then
> > you'll have to wait until I port my CX23888 IR controller changes to
> > work with the IR controller in the CX23885.  That should be somewhat
> > straightforward, but will take time.  Then we'll still need you to
> > experiment with a patch.

> It's cx23885 definitely.
> Remote uses NEC codes.
> In any case I can test.


On Mon, 2009-11-23, Igor M. Liplianin wrote:
> Receiver connected to cx23885 IR_RX(pin 106). It is not difficult to
> track.


Igor,

As I make patches for test, perhaps you can help answer some questions
which will save some experimentation:


1. Does the remote for the TeVii S470 use the same codes as

linux/drivers/media/common/ir-keymaps.c : ir_codes_tevii_nec[]

or some other remote code table we have in the kernel?


2. Does the remote for the TeVii S470, like other TeVii remotes, use a
standard NEC address of 0x00 (so that Addr'Addr is 0xff00) ?  Or does it
use another address?


3. When you traced board wiring from the IR receiver to the IR_RX pin on
the CX23885, did you notice any external components that might modify
the signal?  For example, a capacitor that integrates carrier bursts
into baseband pulses.


Thanks.

Regards,
Andy

