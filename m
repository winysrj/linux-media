Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:39875 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932645AbdGKTvG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 15:51:06 -0400
Date: Tue, 11 Jul 2017 20:50:58 +0100
From: Sean Young <sean@mess.org>
To: Mason <slash.tmp@free.fr>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>
Subject: Re: Infrared support on tango boards
Message-ID: <20170711195058.y425mohdbzjeihgy@gofer.mess.org>
References: <e5063c2c-52db-7d75-e090-fbc49ab76deb@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5063c2c-52db-7d75-e090-fbc49ab76deb@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 10, 2017 at 11:44:08AM +0200, Mason wrote:
> Hello,
> 
> First of all, let's see if I got this right.
> 
> An infrared remote control emits IR pulses to send a bitstream.
> This is the "raw" data. The bit sequence depends on the button
> being pressed (or released), and the protocol being used, right?
> 
> An infrared receiver "captures" this bitstream, which is then
> translated to a "scancode" using the appropriate (protocol)
> decoder, IIUC.

That's right.

> How does one know which decoder to use, out of
> the dozen protocols available?

Well, that depends on the protocol the remote uses to send.

> Are there ambiguities such that
> a bitstream may be valid under two different protocols?

Not really. If you send 0x75460 with protocol rc6-6a-20, the sony protocol
will decode it as 0. There are a few more like that, but not many.

Now also consider that when you load a keymap, only the protocol used by
the keymap is enabled so this shouldn't be a problem anyway.

> 
> Hmmm, I'm missing a step for going from
> 00000000  a9 07 00 00 2e 72 0e 00  04 00 04 00 41 cb 04 00  |.....r......A...|
> 00000010  a9 07 00 00 2e 72 0e 00  00 00 00 00 00 00 00 00  |.....r..........|
> to
> 2589.901611: event type EV_MSC(0x04): scancode = 0x4cb41
> 2589.901611: event type EV_SYN(0x00).
> (not the same IR frame, BTW)

The first is a hexdump of struct input_event, the second is a pretty
print of it.

> Once we have a scancode, there is another translation pass,
> to the higher-level concept of an actual key, such as "1",
> which all applications can agree on.

Yep, that's what the keymaps in drivers/media/rc/keymaps/ are for.

> On the board I'm working on (Sigma SMP8758) there are two distinct
> infrared hardware blocks.
> 
> A) the first block supports 3 protocols in HW (NEC, RC-5, RC-6A)
> Documentation states:
> "supports NEC format, RC5 format, RC5 extended format, RC6A format,
> interrupt driven, contains error detection"
> 
> B) the second block doesn't understand protocols and only captures
> raw bitstreams AFAIU.
> Documentation states:
> "Support for up to 2 IR sources
> Contains debounce and noise filter
> Contains Timestamp mode or Delta mode
> Scancodes are timestamped
> Freely user programmable
> May support any IR protocol or format
> May support any scan code length
> Timebase either variable system clock or fixed 27MHz clock
> Interrupt driven
> GPIO pin user selectable"
> 
> Tangent: it seems complicated to use two IR sources concurrently...
> Wouldn't both receivers capture both sources?

Yes, it would. 
 
> Back on topic: it seems to me that Linux supports many protocol
> decoders, including the 3 supported by block A. I am also assuming
> that IR signals are pretty low bandwidth? Thus, it would appear
> to make sense to only use block B, to have the widest support.

Absolutely right. That's what the winbond-cir driver does too. However,
for wakeup from suspend the winbond-cir uses the hardware decoder.


Sean
