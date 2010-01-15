Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34273 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758566Ab0AOXBK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 18:01:10 -0500
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Order of dvb devices
Date: Sat, 16 Jan 2010 00:00:29 +0100
Cc: Andreas Besse <besse@motama.com>, linux-media@vger.kernel.org
References: <4B4F39BB.2060605@motama.com> <4B4F3FD5.5000603@motama.com> <829197381001140809p1b1af4a4v2678abbc4c41b9ec@mail.gmail.com>
In-Reply-To: <829197381001140809p1b1af4a4v2678abbc4c41b9ec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001160000.31965@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Thu, Jan 14, 2010 at 11:01 AM, Andreas Besse <besse@motama.com> wrote:
> > yes if there are different drivers I already observed the behaviour that
> > the ordering gets flipped after reboot.
> >
> > But if I assume, that there is only *one* driver that is loaded (e.g.
> > budget_av) for all dvb cards in the system, how is the ordering of these
> > devices determined? How does the driver "search" for available dvb cards?

The driver does not 'search' for a card. The driver registers the ids of
all supported cards with the pci subsystem of the kernel.

When the pci subsystem detects a new card, it calls the 'probe' routine
of the driver (for example saa7146_init_one for saa7146-based cards).
So the ordering is determined by the pci subsystem.

> I believe your assumption is incorrect.  I believe the enumeration
> order is not deterministic even for multiple instances of the same
> driver.  It is not uncommon to hear mythtv users complain that "I have
> two PVR-150 cards installed in my PC and the order sometimes get
> reversed on reboot".

Afaik the indeterministic behaviour is caused by udev, not by the
kernel. We never had these problems before udev was introduced.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
