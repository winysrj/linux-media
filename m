Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:38425 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbaC3U7Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 16:59:24 -0400
Date: Sun, 30 Mar 2014 22:59:20 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: lmedm04 NEC scancode question
Message-ID: <20140330205920.GA1127@hardeman.nu>
References: <20140328003847.GA23351@hardeman.nu>
 <53385FEC.4050409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53385FEC.4050409@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 30, 2014 at 07:18:20PM +0100, Malcolm Priestley wrote:
>On 28/03/14 00:38, David Härdeman wrote:
>>I'm trying to make sure that the extended NEC parsing is consistent
>>across drivers and I have a question regarding
>>drivers/media/usb/dvb-usb-v2/lmedm04.c
>>
>>In commit 616a4b83 you changed the scancode from something like this:
>>
>>	ibuf[2] << 24 | ibuf[3] << 16 | ibuf[4] << 8 | ibuf[5]
>>
>>into:
>>
>>	if ((ibuf[4] + ibuf[5]) == 0xff) {
>>		key = ibuf[5];
>>		key += (ibuf[3] > 0)
>>			? (ibuf[3] ^ 0xff) << 8 : 0;
>>		key += (ibuf[2] ^ 0xff) << 16;
>>
>>which can be written as:
>>
>>	(ibuf[2] ^ 0xff) << 16 |
>>	(ibuf[3] > 0) ? (ibuf[3] ^ 0xff) << 8 : 0 |
>>	ibuf[5]
>>
>>At the same time the keymap was changed from (one example from each
>>type):
>>
>>	0xef12ba45 = KEY_0
>>	0xff40ea15 = KEY_0
>>	0xff00e31c = KEY_0
>These original key maps need to restored for 32 bit.

With my patch series, NEC16 keymaps are still ok, they'll get
automagically translated to their NEC32 counterparts when they are
loaded into the in-memory scancode table (by treating any scancode >=
0xffff as NEC16, scancode >= 0xffffff as NECX and scancodes >= 0xffffff
as NEC32).

For example, a keymap with a scancode of 0x1122 is interpreted as a
NEC16 scancode with 0x11 as the address and 0x22 as the command, which
will be stored in the in-memory table as 0x11ee22dd (NEC16 is 0xAACC and
translated into 0xAAÂÂCCĈĈ as NEC32).

>>into:
>>
>>	0x10ed45   = KEY_0 (0x10ed = ~0xef12; 0x45 = ~0xba)
>>	0xbf15     = KEY_0 (0xbf = 0x00bf = ~0xff40; 0x15 = ~0xea)
>>	0x1c       = KEY_0 (0x1c = 0x001c; this is a NEC16 coding?)
>>
>Bits 8~23 are inverted on the key map because they are shifted >> 8.
>
>Bits 8~15 are removed from the scan code.

Not sure I follow. Bytes 2 and 4 are usually inverted in NEC (if it's
the oldschool NEC16 protocol), why would bits 8-23 be inverted?

>>I am assuming (given the ^ 0xff) that the hardware sends inverted bytes?
>>And that the reason ibuf[5] does not need ^ 0xff is that it already is
>>the inverted command (i.e. ibuf[5] == ~ibuf[4]).
>>
>>To put it differently:
>>
>>         ibuf[2] = ~addr         = not_addr;
>>         ibuf[3] = ~not_addr     = addr;
>>         ibuf[4] = ~cmd          = not_cmd;
>>         ibuf[5] = ~not_cmd      = cmd;
>>
>>And the scancode can then be understood as:
>>
>>	addr << 16 | not_addr << 8 | cmd
>>
>>Except for when addr = 0x00 in which case the scancode is simply NEC16:
>>
>>	0x00 << 8 | cmd
>>
>>Is my interpretation correct?
>>
>No inverting.
>
>At the time of the patch I couldn't get the 32 bit code to work correctly on
>rc_core so it was assumed to be 24 bit.
>
>I have tested the patch series...
>
>Is there a patch missing?  I get build error from ati_remote.c and
>imon.c

Mea culpa, I used a .config with some drivers disabled, I've regenerated
the patch series to take ati_remote.c and imon.c into account as well,
I'll post a new patch series as soon as I've understood the lmedm04.c
scancode parsing...

>error: too few arguments to function 'rc_g_keycode_from_table'
>
>Anyway, I removed the errors.

For your testing purposes you could just disable those two drivers.

>Just needs the inverting removed and the original 32 bit key maps to work.

I'd prefer to have the scancode entries that are NEC16 in NEC16 notation
if possible.

If I understand you correctly, ibuf[2] - ibuf[5] corresponds to bytes 1
- 4 of the 32 bit NEC scancode without any inversion/conversion, right?

If so, the scancodes would be for example:

Type1: 0xef12ba45 -> NECX with addr 0xef12 and cmd 0x45 = 0xef1245

Type2: 0xff40ea15 -> NECX with addr 0xff40 and cmd 0x15 = 0xff4015

Type3: 0xff00e31c -> NEC16 with addr 0xff and cmd 0x1c = 0xff1c
(is that really addr 0xff and not 0x00? if it is 0x00, then that would
indicate a different byte order than simply ibuf[2] to ibuf[5]?)

Thanks for your input.

-- 
David Härdeman
