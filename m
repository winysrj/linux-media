Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:46295 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756929AbZLFRsR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Dec 2009 12:48:17 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Jon Smirl <jonsmirl@gmail.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
References: <20091204220708.GD25669@core.coreip.homeip.net> <BEJgSGGXqgB@lirc>
	<9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>
	<1260070593.3236.6.camel@pc07.localdom.local>
	<20091206065512.GA14651@core.coreip.homeip.net>
	<4B1B99A5.2080903@redhat.com>
Date: Sun, 06 Dec 2009 18:48:21 +0100
In-Reply-To: <4B1B99A5.2080903@redhat.com> (Mauro Carvalho Chehab's message of
	"Sun, 06 Dec 2009 09:46:45 -0200")
Message-ID: <m3638k6lju.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

>> I do not believe you are being realistic. Sometimes we just need to say
>> that the device is a POS and is just not worth it. Remember, there is
>> still "lirc hole" for the hard core people still using solder to produce
>> something out of the spare electronic components that may be made to
>> work

Which device? It was about a remote controller, not the receiver. The IR
receivers are frequently coupled with a DVB etc. receiver. There is
absolutely no problem supporting almost any remote if the hardware is
compatible with the receiver (i.e. IR to IR, the carrier frequency is
not 36 vs 56 kHz, the receiver supports the protocol etc).

I don't say we need to support in-kernel decoding for arbitrary
protocols.

>> (never mind that it causes the CPU constantly poll the device, not
>> letting it sleep and wasting electricity as a result - just hypotetical
>> example here).

Very hypotetical, indeed :-)

Most (all?) home-made receivers don't need polling, they use IRQs
instead ("the" home-made receiver is based on serial port and uses IRQ).
They are hardly the "obscure hardware" that nobody has.

The "more advanced" receivers using shift registers may use polling.

> Fully agreed. The costs (our time) to add and keep supporting an in-kernel
> driver for an IR that just one person is still using is higher than 
> asking the user to get a new IR. This time would be better spent adding a new
> driver for other devices.

Agreed, I think nobody argues we should support such things in the
kernel.


Once again: how about agreement about the LIRC interface
(kernel-userspace) and merging the actual LIRC code first? In-kernel
decoding can wait a bit, it doesn't change any kernel-user interface.
-- 
Krzysztof Halasa
