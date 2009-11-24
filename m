Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:46693 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757579AbZKXBPp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 20:15:45 -0500
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
From: Andy Walls <awalls@radix.net>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
In-Reply-To: <m3einork1o.fsf@intrepid.localdomain>
References: <BDRae8rZjFB@christoph>  <m3einork1o.fsf@intrepid.localdomain>
Content-Type: text/plain
Date: Mon, 23 Nov 2009 20:14:35 -0500
Message-Id: <1259025275.3871.55.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-11-23 at 22:46 +0100, Krzysztof Halasa wrote:
> lirc@bartelmus.de (Christoph Bartelmus) writes:
> 
> >> I think we shouldn't at this time worry about IR transmitters.
> >
> > Sorry, but I have to disagree strongly.
> > Any interface without transmitter support would be absolutely unacceptable
> > for many LIRC users, including myself.
> 
> I don't say don't use a transmitter.
> I say the transmitter is not an input device, they are completely
> independent functions. I can't see any reason to try and fit both in the
> same interface - can you?

The underlying hardware need not be completely independent.

For example, the CX2584[0123], CX2388[578], CX23418, and CX2310[012]
chips have IR hardware that shares a common timing source, interrupt
line, interrupt status register, etc, between IR Rx and Tx.  They can
also do things like loopback of Tx to Rx.

That said, an underlying hardware implementation can be split up to user
space with separate interfaces Tx and Rx.  The underlying driver module
would have to manage the dependencies.  I would guess that would be
easier for driver modules, if the userspace interfaces were designed
with such combined IR Tx/Rx hardware in mind.

Regards,
Andy

