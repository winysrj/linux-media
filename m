Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:39619 "EHLO smtp5-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752618AbdGJJo1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 05:44:27 -0400
From: Mason <slash.tmp@free.fr>
Subject: Infrared support on tango boards
To: linux-media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sean Young <sean@mess.org>,
        Thibaud Cornic <thibaud_cornic@sigmadesigns.com>
Message-ID: <e5063c2c-52db-7d75-e090-fbc49ab76deb@free.fr>
Date: Mon, 10 Jul 2017 11:44:08 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

First of all, let's see if I got this right.

An infrared remote control emits IR pulses to send a bitstream.
This is the "raw" data. The bit sequence depends on the button
being pressed (or released), and the protocol being used, right?

An infrared receiver "captures" this bitstream, which is then
translated to a "scancode" using the appropriate (protocol)
decoder, IIUC. How does one know which decoder to use, out of
the dozen protocols available? Are there ambiguities such that
a bitstream may be valid under two different protocols?

Hmmm, I'm missing a step for going from
00000000  a9 07 00 00 2e 72 0e 00  04 00 04 00 41 cb 04 00  |.....r......A...|
00000010  a9 07 00 00 2e 72 0e 00  00 00 00 00 00 00 00 00  |.....r..........|
to
2589.901611: event type EV_MSC(0x04): scancode = 0x4cb41
2589.901611: event type EV_SYN(0x00).
(not the same IR frame, BTW)

Once we have a scancode, there is another translation pass,
to the higher-level concept of an actual key, such as "1",
which all applications can agree on.


On the board I'm working on (Sigma SMP8758) there are two distinct
infrared hardware blocks.

A) the first block supports 3 protocols in HW (NEC, RC-5, RC-6A)
Documentation states:
"supports NEC format, RC5 format, RC5 extended format, RC6A format,
interrupt driven, contains error detection"

B) the second block doesn't understand protocols and only captures
raw bitstreams AFAIU.
Documentation states:
"Support for up to 2 IR sources
Contains debounce and noise filter
Contains Timestamp mode or Delta mode
Scancodes are timestamped
Freely user programmable
May support any IR protocol or format
May support any scan code length
Timebase either variable system clock or fixed 27MHz clock
Interrupt driven
GPIO pin user selectable"

Tangent: it seems complicated to use two IR sources concurrently...
Wouldn't both receivers capture both sources?

Back on topic: it seems to me that Linux supports many protocol
decoders, including the 3 supported by block A. I am also assuming
that IR signals are pretty low bandwidth? Thus, it would appear
to make sense to only use block B, to have the widest support.

What do you think?

Regards.
