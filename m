Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:36199 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbbDAUdi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Apr 2015 16:33:38 -0400
Date: Wed, 1 Apr 2015 22:33:04 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] Send and receive decoded IR using lirc interface
Message-ID: <20150401203304.GB4721@hardeman.nu>
References: <cover.1426801061.git.sean@mess.org>
 <20150330211819.GA18426@hardeman.nu>
 <20150330230837.GA660@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150330230837.GA660@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 31, 2015 at 12:08:37AM +0100, Sean Young wrote:
>On Mon, Mar 30, 2015 at 11:18:19PM +0200, David Härdeman wrote:
>> On Thu, Mar 19, 2015 at 09:50:11PM +0000, Sean Young wrote:
>> >This patch series tries to fix the lirc interface and extend it so it can
>> >be used to send/recv scancodes in addition to raw IR:
>> >
>> > - Make it possible to receive scancodes from hardware that generates 
>> >   scancodes (with rc protocol information)
>> > - Make it possible to receive decoded scancodes from raw IR, from the 
>> >   in-kernel decoders (not mce mouse/keyboard). Now you can take any
>> >   remote, run ir-rec and you will get both the raw IR and the decoded
>> >   scancodes plus rc protocol information.
>> > - Make it possible to send scancodes; in kernel-encoding of IR
>> > - Make it possible to send scancodes for hardware that can only do that
>> >   (so that lirc_zilog can be moved out of staging, not completed yet)
>> > - Possibly the lirc interface can be used for cec?
>> >
>> >This requires a little refactoring.
>> > - All rc-core devices will have a lirc device associated with them
>> > - The rc-core <-> lirc bridge no longer is a "decoder", this never made 
>> >   sense and caused confusion
>> 
>> IIRC, it was written that way to make the lirc module optional.
>
>It does make the lirc module optional, but it does not make sense that
>lirc is a decoder, when it handles other things like transmit and displaying
>raw IR from userspace. An unsuspecting user will be surprised to learn
>that he/she has to "echo +lirc > protocols" in order to lircd/mode2 to
>work (this has come up on linux-media a couple of times).

Yes...I agree that it's suboptimal.

>More importantly it makes receiving decoded IR (from the other real
>decoders) a real mess. That's why I chose this solution.

rc-core was supposed (at least in theory) to support other remote
control schemes as well (RF...maybe CEC...etc), so I still think making
a lirc device optional for non-IR hardware makes sense.

>> >This requires new API for rc-core lirc devices.
>> > - New feature LIRC_CAN_REC_SCANCODE and LIRC_CAN_SEND_SCANCODE
>> > - REC_MODE and SEND_MODE do not enable LIRC_MODE_SCANCODE by default since 
>> >   this would confuse existing userspace code
>> > - For each scancode we need: 
>> >   - rc protocol (RC_TYPE_*) 
>> >   - toggle and repeat bit for some protocols
>> >   - 32 bit scancode
>> 
>> I haven't looked at the patches in detail, but I think exposing the
>> scancodes to userspace requires some careful consideration.
>> 
>> First of all, scancode length should be dynamic, there are protocols
>> (NEC48 and, at least theoretically, RC6) that have scancodes > 32 bits.
>
>Ok, interesting. We should allow for that.
>
>> Second, if we expose protocol type (which we should, not doing so is
>> throwing away valuable information) we should tackle the NEC scancode
>> question. I've already explained my firm conviction that always
>> reporting NEC as a 32 bit scancode is the only sane thing to do. Mauro
>> is of the opinion that NEC16/24/32 should be essentially different
>> protocols.
>
>In the patch set, I had to write a nec encoder called ir_nec_encode(). 
>Since it does not know which type of nec it is, it has to guess based on
>the width of the scancode. I thought it was pretty hideous. Your solution
>of using 32 bit whatever the nec variant would be a strange API as well;

Why is it strange? The different NEC variants send/receive 32 bits "on
the wire". We are talking about the communication between userspace and
the kernel and I don't think there's anything weird about saying "these
bits have been received/should be sent" without any further
(unnecessary) parsing being done by the kernel before/after. Adding
separate NEC16/NEC24/NEC32 "protocols" (where the same 32 bits have been
parsed and mashed by the kernel) adds complexity to the kernel while
providing no benefits whatsoever.

>it would be much nicer if the nec variant could be specified for transmit.
>
>> Third, we should still have a way to represent the protocol in the
>> keymap as well.
>
>Agreed; this work is separate from keymap handling though.

Yes. Absolutely. But it's another aspect where the protocol numbers will
be exposed to userspace.

>> And on a much more general level...I still think we should start from
>> scratch with a rc specific chardev with it's own API that is generic
>> enough to cover both scancode / raw ir / future / other protocols (not
>> that such an undertaking would preclude adding stuff to the lirc API of
>> course).
>
>I hope my patches show that that adding scancodes with protocol information
>is not difficult and it fits in with the general lirc design. I have
>toyed with adding a new chardev but I don't know what it adds when the
>lirc interface suffices. It just ends up looking like lirc with an new 
>name and new ioctls.

The chardev I suggested does add a few things. Versioning. Explicit
support for different kinds of RC hardware (raw IR, scancode IR,
others), and it gives the opportunity to clean up the lirc ioctls
(they're pretty messy...a lot of them don't seem to ever have been used
while other functionality is missing...like the ability to set all TX/RX
parameters in one go).

>The only thing it adds is nanosecond precision (rather than microseconds)
>and being able to send IR signals ad infinitum if the hardware supports
>it (not many). Neither of these are needed for real world IR use cases.
>
>A new interface does not add anything useful, so why would anyone use it
>rather than the existing lirc interface?

I'll expand a bit more in a separate email....but I don't think my
proposal is really in the way of extending the lirc device as you
propose...it's rather something to keep in mind..

Regards,
David

