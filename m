Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:36685 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758355Ab0AOXQ1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 18:16:27 -0500
Subject: Re: Order of dvb devices
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Andreas Besse <besse@motama.com>
In-Reply-To: <201001160000.31965@orion.escape-edv.de>
References: <4B4F39BB.2060605@motama.com> <4B4F3FD5.5000603@motama.com>
	 <829197381001140809p1b1af4a4v2678abbc4c41b9ec@mail.gmail.com>
	 <201001160000.31965@orion.escape-edv.de>
Content-Type: text/plain
Date: Sat, 16 Jan 2010 00:12:14 +0100
Message-Id: <1263597134.10285.7.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Samstag, den 16.01.2010, 00:00 +0100 schrieb Oliver Endriss:
> Devin Heitmueller wrote:
> > On Thu, Jan 14, 2010 at 11:01 AM, Andreas Besse <besse@motama.com> wrote:
> > > yes if there are different drivers I already observed the behaviour that
> > > the ordering gets flipped after reboot.
> > >
> > > But if I assume, that there is only *one* driver that is loaded (e.g.
> > > budget_av) for all dvb cards in the system, how is the ordering of these
> > > devices determined? How does the driver "search" for available dvb cards?
> 
> The driver does not 'search' for a card. The driver registers the ids of
> all supported cards with the pci subsystem of the kernel.
> 
> When the pci subsystem detects a new card, it calls the 'probe' routine
> of the driver (for example saa7146_init_one for saa7146-based cards).
> So the ordering is determined by the pci subsystem.
> 
> > I believe your assumption is incorrect.  I believe the enumeration
> > order is not deterministic even for multiple instances of the same
> > driver.  It is not uncommon to hear mythtv users complain that "I have
> > two PVR-150 cards installed in my PC and the order sometimes get
> > reversed on reboot".
> 
> Afaik the indeterministic behaviour is caused by udev, not by the
> kernel. We never had these problems before udev was introduced.
> 
> CU
> Oliver
> 

Agreed.

Hermann


