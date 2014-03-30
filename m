Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:46965 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaC3SS1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Mar 2014 14:18:27 -0400
Received: by mail-we0-f176.google.com with SMTP id x48so3804024wes.7
        for <linux-media@vger.kernel.org>; Sun, 30 Mar 2014 11:18:26 -0700 (PDT)
Message-ID: <53385FEC.4050409@gmail.com>
Date: Sun, 30 Mar 2014 19:18:20 +0100
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
CC: linux-media@vger.kernel.org
Subject: Re: lmedm04 NEC scancode question
References: <20140328003847.GA23351@hardeman.nu>
In-Reply-To: <20140328003847.GA23351@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28/03/14 00:38, David Härdeman wrote:
> Hi Malcolm,
>
Hi David


> I'm trying to make sure that the extended NEC parsing is consistent
> across drivers and I have a question regarding
> drivers/media/usb/dvb-usb-v2/lmedm04.c
>
> In commit 616a4b83 you changed the scancode from something like this:
>
> 	ibuf[2] << 24 | ibuf[3] << 16 | ibuf[4] << 8 | ibuf[5]
>
> into:
>
> 	if ((ibuf[4] + ibuf[5]) == 0xff) {
> 		key = ibuf[5];
> 		key += (ibuf[3] > 0)
> 			? (ibuf[3] ^ 0xff) << 8 : 0;
> 		key += (ibuf[2] ^ 0xff) << 16;
>
> which can be written as:
>
> 	(ibuf[2] ^ 0xff) << 16 |
> 	(ibuf[3] > 0) ? (ibuf[3] ^ 0xff) << 8 : 0 |
> 	ibuf[5]
>
> At the same time the keymap was changed from (one example from each
> type):
>
> 	0xef12ba45 = KEY_0
> 	0xff40ea15 = KEY_0
> 	0xff00e31c = KEY_0
These original key maps need to restored for 32 bit.

>
> into:
>
> 	0x10ed45   = KEY_0 (0x10ed = ~0xef12; 0x45 = ~0xba)
> 	0xbf15     = KEY_0 (0xbf = 0x00bf = ~0xff40; 0x15 = ~0xea)
> 	0x1c       = KEY_0 (0x1c = 0x001c; this is a NEC16 coding?)
>
Bits 8~23 are inverted on the key map because they are shifted >> 8.


Bits 8~15 are removed from the scan code.

> I am assuming (given the ^ 0xff) that the hardware sends inverted bytes?
> And that the reason ibuf[5] does not need ^ 0xff is that it already is
> the inverted command (i.e. ibuf[5] == ~ibuf[4]).
>
> To put it differently:
>
>          ibuf[2] = ~addr         = not_addr;
>          ibuf[3] = ~not_addr     = addr;
>          ibuf[4] = ~cmd          = not_cmd;
>          ibuf[5] = ~not_cmd      = cmd;
>
> And the scancode can then be understood as:
>
> 	addr << 16 | not_addr << 8 | cmd
>
> Except for when addr = 0x00 in which case the scancode is simply NEC16:
>
> 	0x00 << 8 | cmd
>
> Is my interpretation correct?
>
No inverting.

At the time of the patch I couldn't get the 32 bit code to work 
correctly on rc_core so it was assumed to be 24 bit.

I have tested the patch series...

Is there a patch missing?  I get build error from ati_remote.c and
imon.c

error: too few arguments to function 'rc_g_keycode_from_table'

Anyway, I removed the errors.

Just needs the inverting removed and the original 32 bit key maps to work.

Regards


Malcolm
