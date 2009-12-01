Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbZLARlk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 12:41:40 -0500
Message-ID: <4B155534.6060907@redhat.com>
Date: Tue, 01 Dec 2009 15:41:08 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Jon Smirl <jonsmirl@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
References: <9e4733910912010708u1064e2c6mbc08a01293c3e7fd@mail.gmail.com>  <1259682428.18599.10.camel@maxim-laptop>  <9e4733910912010816q32e829a2uce180bfda69ef86d@mail.gmail.com>  <4B154C54.5090906@redhat.com> <829197380912010909m59cb1078q5bd2e00af0368aaf@mail.gmail.com> <alpine.LRH.2.00.0912011833070.11226@pub6.ifh.de>
In-Reply-To: <alpine.LRH.2.00.0912011833070.11226@pub6.ifh.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patrick Boettcher wrote:

>> The fact that the driver currently uses the same lookup table for both
>> types of remote controls however, was perhaps not the best design
>> choice.  It really should be separated out, and merged with the
>> regular ir-functions.c.  I just never got around to it.
> 
> I did not follow all the discussion, still I have a comment:
> 
> I will soon work on a device where it is the driver who is doing the
> decoding of the IR-frames. It is (maybe, I'm still missing some pieces
> to be sure) possible to receive different protocols at the same time
> with this hardware.

That's good news! Needing to pass a modprobe parameter to select the protocol
is not nice, and, while an ioctl will be needed to select IR protocols
(as there are some hardwares where this is not possible at all), the better
is to auto-detect the protocol.

Cheers,
Mauro.
