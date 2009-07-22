Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41767 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbZGVSAJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 14:00:09 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH] dvb: make digital side of pcHDTV HD-3000 functional again
Date: Wed, 22 Jul 2009 13:59:00 -0400
Cc: Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org
References: <200907201020.47581.jarod@redhat.com> <200907212135.47557.jarod@redhat.com> <Pine.LNX.4.58.0907212343130.11911@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0907212343130.11911@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907221359.00892.jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 22 July 2009 02:51:12 Trent Piepho wrote:
> On Tue, 21 Jul 2009, Jarod Wilson wrote:
> > On Tuesday 21 July 2009 10:23:53 Steven Toth wrote:
> > > > Hrm, okay, I'll double-check that... If its not there, perhaps the card
> > > > isn't quite seated correctly. Or the machine is bunk. Or the card has
> > > > gone belly up. Amusing that it works as much as it does though, if any
> > > > of the above is the case...
> > > >
> > > > Thanks for the info!
> > > >
> > >
> > > Jrod,
> > >
> > > Yeah. If the pci enable bit for the transport engine is not enabled (thus
> > > showing up as pci device 8802) then I'm going to be surprised if the risc engine
> > > runs up at all (or runs perfectly).
> > >
> > > I've seen issue like this in the past with various cx88 boards and it invariable
> > > turn out to be a corrupt eeprom or a badly seated PCI card.
> > >
> > > or, no eeprom at all (unlikely on this board).
> >
> > So its either I have *two* machines with bad, but only slightly bad,
> > and in the same way, PCI slots which seem to work fine with any other
> > card I have (uh, unlikely), or my HD-3000 has gone belly up on me in
> > some subtle way. The cx8802 part never shows up under lspci on either
> > machine I've tried it in. Suck.
> 
> Check your eeprom, it could be set incorrectly.
> 
> "i2cdump -f 0 0x50" will show the contents if the HD-3000 has i2c bus 0.
> i2cdump with no arguments will tell you what each bus is.
> 
> The first 12 bytes should look something like this:
> 00: 06 ff ff ff 63 70 00 30 e0 01 40 ff 00 00 00 00    ?...cp.0??@.....
> 
> 
> The first byte should have bit 0x04 set to enable mpeg.

So here's what was in my eeprom:

00: 00 00 00 00 63 70 00 30 e0 01 40 ff 00 00 00 00    ....cp.0??@.....

Sooo... For funsies, I figured out how to use i2cset, and made it match
your example. After rebooting, I have the cx8802 device showing up
again. Cool! Now to see if it actually *works*... :)

-- 
Jarod Wilson
jarod@redhat.com
