Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39778 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbZGVBfv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 21:35:51 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Steven Toth <stoth@kernellabs.com>
Subject: Re: [PATCH] dvb: make digital side of pcHDTV HD-3000 functional again
Date: Tue, 21 Jul 2009 21:35:47 -0400
Cc: Trent Piepho <xyzzy@speakeasy.org>, linux-media@vger.kernel.org
References: <200907201020.47581.jarod@redhat.com> <200907201650.23749.jarod@redhat.com> <4A65CF79.1040703@kernellabs.com>
In-Reply-To: <4A65CF79.1040703@kernellabs.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907212135.47557.jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 21 July 2009 10:23:53 Steven Toth wrote:
> > Hrm, okay, I'll double-check that... If its not there, perhaps the card
> > isn't quite seated correctly. Or the machine is bunk. Or the card has
> > gone belly up. Amusing that it works as much as it does though, if any
> > of the above is the case...
> >
> > Thanks for the info!
> >
> 
> Jrod,
> 
> Yeah. If the pci enable bit for the transport engine is not enabled (thus 
> showing up as pci device 8802) then I'm going to be surprised if the risc engine 
> runs up at all (or runs perfectly).
> 
> I've seen issue like this in the past with various cx88 boards and it invariable 
> turn out to be a corrupt eeprom or a badly seated PCI card.
> 
> or, no eeprom at all (unlikely on this board).

So its either I have *two* machines with bad, but only slightly bad,
and in the same way, PCI slots which seem to work fine with any other
card I have (uh, unlikely), or my HD-3000 has gone belly up on me in
some subtle way. The cx8802 part never shows up under lspci on either
machine I've tried it in. Suck.

-- 
Jarod Wilson
jarod@redhat.com
