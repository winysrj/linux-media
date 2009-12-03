Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:57436 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbZLCSSA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 13:18:00 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jon Smirl <jonsmirl@gmail.com>, Jarod Wilson <jarod@wilsonet.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
References: <4B155288.1060509@redhat.com>
	<20091202093803.GA8656@core.coreip.homeip.net>
	<4B16614A.3000208@redhat.com>
	<20091202171059.GC17839@core.coreip.homeip.net>
	<9e4733910912020930t3c9fe973k16fd353e916531a4@mail.gmail.com>
	<4B16BE6A.7000601@redhat.com>
	<20091202195634.GB22689@core.coreip.homeip.net>
	<2D11378A-041C-4B56-91FF-3E62F5F19753@wilsonet.com>
	<9e4733910912021620s7a2b09a8v88dd45eef38835a@mail.gmail.com>
	<4B1720E6.3000802@redhat.com>
	<9e4733910912022108j71d0c27fh75dacfa79dca7c22@mail.gmail.com>
	<4B179C5A.2090504@redhat.com>
Date: Thu, 03 Dec 2009 19:18:03 +0100
In-Reply-To: <4B179C5A.2090504@redhat.com> (Mauro Carvalho Chehab's message of
	"Thu, 03 Dec 2009 09:09:14 -0200")
Message-ID: <m37ht33oro.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

> Btw, looking at that code, while it is not impossible to split the 
> IR pulse/space measures from the NEC decoder itself, and make it generic
> to support other protocols, it is not a trivial task, and may result on
> a less stable driver.

And it's not needed at all.
Protocol decoders can be easily run in parallel, I've done it on saa713x
and this is trivial at least there. Can do that when the lirc interface
is available.

> The advantage of the NEC decoding approach on saa7134 is that you know for
> sure how much time it is required to get the entire code. So, the code 
> can easily abort the reception of a bad code. The disadvantage is that 
> only one protocol can be decoded at the same time.

This isn't a hard thing to fix.

> The same problem also happens with almost all in-kernel drivers: the decoders
> for raw mode were constructed to work with just one pulse/space code at the
> same time. A conversion into a generic code can happen, but it will require
> several tests to be sure that they won't cause undesirable side-effects.

IOW any such receiver has to be tested, sure.

> The advantage of hardware decoders is that you don't need to be polling the
> IR serial port at a high rate, as you'll get directly the code. So, you'll
> free the CPU to do something else.

Which device requires polling the port?
Most are IRQ-driven, aren't they?
-- 
Krzysztof Halasa
