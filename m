Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:44882 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbZKZNte (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 08:49:34 -0500
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
In-Reply-To: <4B0E81C8.7050203@redhat.com>
References: <BDRae8rZjFB@christoph>  <m3einork1o.fsf@intrepid.localdomain>
	 <1259025275.3871.55.camel@palomino.walls.org> <4B0E81C8.7050203@redhat.com>
Content-Type: text/plain
Date: Thu, 26 Nov 2009 08:48:20 -0500
Message-Id: <1259243300.3062.61.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-11-26 at 11:25 -0200, Mauro Carvalho Chehab wrote:
> Andy Walls wrote:
> > On Mon, 2009-11-23 at 22:46 +0100, Krzysztof Halasa wrote:
> >> lirc@bartelmus.de (Christoph Bartelmus) writes:
> >>
> >>>> I think we shouldn't at this time worry about IR transmitters.
> >>> Sorry, but I have to disagree strongly.
> >>> Any interface without transmitter support would be absolutely unacceptable
> >>> for many LIRC users, including myself.
> >> I don't say don't use a transmitter.
> >> I say the transmitter is not an input device, they are completely
> >> independent functions. I can't see any reason to try and fit both in the
> >> same interface - can you?
> > 
> > The underlying hardware need not be completely independent.
> > 
> > For example, the CX2584[0123], CX2388[578], CX23418, and CX2310[012]
> > chips have IR hardware that shares a common timing source, interrupt
> > line, interrupt status register, etc, between IR Rx and Tx.  They can
> > also do things like loopback of Tx to Rx.
> > 
> > That said, an underlying hardware implementation can be split up to user
> > space with separate interfaces Tx and Rx.  The underlying driver module
> > would have to manage the dependencies.  I would guess that would be
> > easier for driver modules, if the userspace interfaces were designed
> > with such combined IR Tx/Rx hardware in mind.
> 
> True, but, in the case of Rx, there are already API's for it. Tx case is
> simpler, as we don't have any API for it yet.
> 
> I'm not sure if all the existing hardware for TX currently supports only
> raw pulse/code sequencies, but I still think that, even on the Tx case, 
> it is better to send scancodes to the driver, and let it do the conversion
> to raw pulse/code, if the hardware requires pulse/code instead of scancodes. 

That seems like a decision which will create a lots of duplicative code
in the kernel.  Add it's just busy-work to write such code when a
userspace application in common use already handles the protocols and
sends raw pulses to hardware that expects raw pulses.

> However, as we have green field,
> I would add the protocol explicitly for each scancode to be transmitted, like:
> 
> struct ir_tx {
> 	enum ir_protocol proto;
> 	u32 scancode;
> };
> 
> Eventually, we might have a protocol "raw" and some extra field to allow passing
> a raw pulse/code sequence instead of a scancode.

I think you would have to.  32 bits is really not enough for all
protocols, and it is already partial encoding of information anyway.

If the Tx driver has to break them down into pulses anyway, why not have
fields with more meaningful names

	mode
	toggle
	customer code (or system code or address),
	information (or command)

According to

	http://slycontrol.ru/scr/kb/rc6.htm

the "information" field could be up to 128 bits.

(Not that I'm going to put any RC-6 Mode 6A decoding/encoding in the
kernel.)		

Regards,
Andy

> Cheers,
> Mauro.


