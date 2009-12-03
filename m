Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:59705 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915AbZLCBV1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Dec 2009 20:21:27 -0500
Subject: Re: [RFC v2] Another approach to IR
From: Andy Walls <awalls@radix.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>, Jarod Wilson <jarod@redhat.com>,
	Jon Smirl <jonsmirl@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, j@jannau.net,
	khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
In-Reply-To: <20091202201404.GD22689@core.coreip.homeip.net>
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
Content-Type: text/plain
Date: Wed, 02 Dec 2009 20:19:39 -0500
Message-Id: <1259803179.3085.24.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2009-12-02 at 12:14 -0800, Dmitry Torokhov wrote:
> On Wed, Dec 02, 2009 at 03:04:30PM -0500, Jarod Wilson wrote:


> Didn't Jon posted his example whith programmable remote pretending to be
> several separate remotes (depending on the mode of operation) so that
> several devices/applications can be controlled without interfering with
> each other?


There are a few features that can be used to distinguish remotes:

1. Carrier freq
2. Protocol (NEC, Sony, JVC, RC-5...)
3. Protocol variant (NEC original, NEC with extended addresses,
		     RC-5, RC-5 with exteneded commands,
		     RC-6 Mode 0, RC-6 Mode 6B, ...)
4. System # or Address sent by the remote (16 bits max, I think)
5. Set of possible Commands or Information words sent from the remote.
6. Pulse width deviation from standard (mean, variance)


1, 5, and 6 are really a sort of "fingerprint" and likely not worth the
effort, even if you have hardware that can measure things with some
accuracy.

Regards,
Andy

