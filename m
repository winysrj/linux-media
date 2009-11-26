Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbZKZNZ4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 08:25:56 -0500
Message-ID: <4B0E81C8.7050203@redhat.com>
Date: Thu, 26 Nov 2009 11:25:28 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph>  <m3einork1o.fsf@intrepid.localdomain> <1259025275.3871.55.camel@palomino.walls.org>
In-Reply-To: <1259025275.3871.55.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Mon, 2009-11-23 at 22:46 +0100, Krzysztof Halasa wrote:
>> lirc@bartelmus.de (Christoph Bartelmus) writes:
>>
>>>> I think we shouldn't at this time worry about IR transmitters.
>>> Sorry, but I have to disagree strongly.
>>> Any interface without transmitter support would be absolutely unacceptable
>>> for many LIRC users, including myself.
>> I don't say don't use a transmitter.
>> I say the transmitter is not an input device, they are completely
>> independent functions. I can't see any reason to try and fit both in the
>> same interface - can you?
> 
> The underlying hardware need not be completely independent.
> 
> For example, the CX2584[0123], CX2388[578], CX23418, and CX2310[012]
> chips have IR hardware that shares a common timing source, interrupt
> line, interrupt status register, etc, between IR Rx and Tx.  They can
> also do things like loopback of Tx to Rx.
> 
> That said, an underlying hardware implementation can be split up to user
> space with separate interfaces Tx and Rx.  The underlying driver module
> would have to manage the dependencies.  I would guess that would be
> easier for driver modules, if the userspace interfaces were designed
> with such combined IR Tx/Rx hardware in mind.

True, but, in the case of Rx, there are already API's for it. Tx case is
simpler, as we don't have any API for it yet.

I'm not sure if all the existing hardware for TX currently supports only
raw pulse/code sequencies, but I still think that, even on the Tx case, 
it is better to send scancodes to the driver, and let it do the conversion
to raw pulse/code, if the hardware requires pulse/code instead of scancodes. 

However, as we have green field,
I would add the protocol explicitly for each scancode to be transmitted, like:

struct ir_tx {
	enum ir_protocol proto;
	u32 scancode;
};

Eventually, we might have a protocol "raw" and some extra field to allow passing
a raw pulse/code sequence instead of a scancode.

Cheers,
Mauro.
