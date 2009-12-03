Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:54870 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752755AbZLCCfe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Dec 2009 21:35:34 -0500
Subject: Re: [RFC v2] Another approach to IR
From: hermann pitton <hermann-pitton@arcor.de>
To: Andy Walls <awalls@radix.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Jarod Wilson <jarod@redhat.com>,
	Jon Smirl <jonsmirl@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, j@jannau.net,
	khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
In-Reply-To: <1259803179.3085.24.camel@palomino.walls.org>
References: <4B1567D8.7080007@redhat.com>
	 <20091201201158.GA20335@core.coreip.homeip.net>
	 <4B15852D.4050505@redhat.com>
	 <20091202093803.GA8656@core.coreip.homeip.net>
	 <4B16614A.3000208@redhat.com>
	 <20091202171059.GC17839@core.coreip.homeip.net>
	 <9e4733910912020930t3c9fe973k16fd353e916531a4@mail.gmail.com>
	 <4B16BE6A.7000601@redhat.com>
	 <20091202195634.GB22689@core.coreip.homeip.net>
	 <2D11378A-041C-4B56-91FF-3E62F5F19753@wilsonet.com>
	 <20091202201404.GD22689@core.coreip.homeip.net>
	 <1259803179.3085.24.camel@palomino.walls.org>
Content-Type: text/plain
Date: Thu, 03 Dec 2009 03:27:45 +0100
Message-Id: <1259807265.3236.13.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Mittwoch, den 02.12.2009, 20:19 -0500 schrieb Andy Walls:
> On Wed, 2009-12-02 at 12:14 -0800, Dmitry Torokhov wrote:
> > On Wed, Dec 02, 2009 at 03:04:30PM -0500, Jarod Wilson wrote:
> 
> 
> > Didn't Jon posted his example whith programmable remote pretending to be
> > several separate remotes (depending on the mode of operation) so that
> > several devices/applications can be controlled without interfering with
> > each other?
> 
> 
> There are a few features that can be used to distinguish remotes:
> 
> 1. Carrier freq
> 2. Protocol (NEC, Sony, JVC, RC-5...)
> 3. Protocol variant (NEC original, NEC with extended addresses,
> 		     RC-5, RC-5 with exteneded commands,
> 		     RC-6 Mode 0, RC-6 Mode 6B, ...)
> 4. System # or Address sent by the remote (16 bits max, I think)
> 5. Set of possible Commands or Information words sent from the remote.
> 6. Pulse width deviation from standard (mean, variance)
> 
> 
> 1, 5, and 6 are really a sort of "fingerprint" and likely not worth the
> effort, even if you have hardware that can measure things with some
> accuracy.

I don't follow closely enough, but eventually we have (different)
remotes a receiver chip can distinguish in hardware, firmware might be
involved too.

If I don't get it wrong, Dmitry is asking in the first place, how such
sender receiver combinations switch to different emulated digital
information for a bunch of different types of hardware in living rooms.

Starting with RC5, IIRC, there is of course such switch over to another
device around. We are only one more.

To repeat, on such bundled cheapest remotes with some TV/DVB cards
around, there are only some minimal implementations of RC5, likely they
use that protocol even illegally, at least they make chips in use
unidentifiable and this seems to be by will.

So, if some try to implement now the highest level, they are far away
from to know what hardware goes how far with them.

At least fun to see they have some starting point ;)

Cheers,
Hermann


