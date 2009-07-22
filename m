Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:55313 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbZGVGvN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 02:51:13 -0400
Date: Tue, 21 Jul 2009 23:51:12 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jarod Wilson <jarod@redhat.com>
cc: Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] dvb: make digital side of pcHDTV HD-3000 functional
 again
In-Reply-To: <200907212135.47557.jarod@redhat.com>
Message-ID: <Pine.LNX.4.58.0907212343130.11911@shell2.speakeasy.net>
References: <200907201020.47581.jarod@redhat.com> <200907201650.23749.jarod@redhat.com>
 <4A65CF79.1040703@kernellabs.com> <200907212135.47557.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 21 Jul 2009, Jarod Wilson wrote:
> On Tuesday 21 July 2009 10:23:53 Steven Toth wrote:
> > > Hrm, okay, I'll double-check that... If its not there, perhaps the card
> > > isn't quite seated correctly. Or the machine is bunk. Or the card has
> > > gone belly up. Amusing that it works as much as it does though, if any
> > > of the above is the case...
> > >
> > > Thanks for the info!
> > >
> >
> > Jrod,
> >
> > Yeah. If the pci enable bit for the transport engine is not enabled (thus
> > showing up as pci device 8802) then I'm going to be surprised if the risc engine
> > runs up at all (or runs perfectly).
> >
> > I've seen issue like this in the past with various cx88 boards and it invariable
> > turn out to be a corrupt eeprom or a badly seated PCI card.
> >
> > or, no eeprom at all (unlikely on this board).
>
> So its either I have *two* machines with bad, but only slightly bad,
> and in the same way, PCI slots which seem to work fine with any other
> card I have (uh, unlikely), or my HD-3000 has gone belly up on me in
> some subtle way. The cx8802 part never shows up under lspci on either
> machine I've tried it in. Suck.

Check your eeprom, it could be set incorrectly.

"i2cdump -f 0 0x50" will show the contents if the HD-3000 has i2c bus 0.
i2cdump with no arguments will tell you what each bus is.

The first 12 bytes should look something like this:
00: 06 ff ff ff 63 70 00 30 e0 01 40 ff 00 00 00 00    ?...cp.0??@.....


The first byte should have bit 0x04 set to enable mpeg.
