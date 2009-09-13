Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:34820 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748AbZIMESj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 00:18:39 -0400
Subject: Re: (Saa7134) Re: ADS-Tech Instant TV PCI, no remote support,
	giving up.
From: hermann pitton <hermann-pitton@arcor.de>
To: Morvan Le Meut <mlemeut@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <4AAB586D.6080906@gmail.com>
References: <4AA53C05.10203@gmail.com> <4AA61508.9040506@gmail.com>
	 <op.uzxmzlj86dn9rq@crni> <4AA62C38.3050208@gmail.com>
	 <4AA63434.1010709@gmail.com> <4AA683BD.6070601@gmail.com>
	 <4AA695EE.70800@gmail.com> <4AA767F2.50702@gmail.com>
	 <op.uzzfgyvj3xmt7q@crni> <4AA77240.2040504@gmail.com>
	 <4AA77683.7010201@gmail.com> <4AA7C266.3000509@gmail.com>
	 <op.uzzz96se6dn9rq@crni> <4AA7E166.7030906@gmail.com>
	 <4AA81785.5000806@gmail.com> <4AA8BB20.4040701@gmail.com>
	 <4AA919CA.20701@gmail.com> <4AAA0247.8020004@gmail.com>
	 <4AAB586D.6080906@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 13 Sep 2009 06:15:52 +0200
Message-Id: <1252815352.3259.41.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Samstag, den 12.09.2009, 10:14 +0200 schrieb Morvan Le Meut: 
> Since i don't know where to look, i finally decided to use a basic 
> incorrect keymap :
>  /* ADS Tech Instant TV PCI Remote */
> static struct ir_scancode ir_codes_adstech_pci[] = {
>     /* too many repeating codes : incorrect gpio ?. */
>        
>     { 0x1f, KEY_MUTE },
>     { 0x1d, KEY_SEARCH },
>     { 0x17, KEY_EPG },        /* Guide */
>     { 0x0f, KEY_UP },
>     { 0x6, KEY_DOWN },
>     { 0x16, KEY_LEFT },
>     { 0x1e, KEY_RIGHT },
>     { 0x0e, KEY_SELECT },        /* Enter */
>     { 0x1a, KEY_INFO },
>     { 0x12, KEY_EXIT },
>     { 0x19, KEY_PREVIOUS },
>     { 0x11, KEY_NEXT },
>     { 0x18, KEY_REWIND },
>     { 0x10, KEY_FORWARD },
>     { 0x4, KEY_PLAYPAUSE },
>     { 0x07, KEY_STOP },
>     { 0x1b, KEY_RECORD },
>     { 0x13, KEY_TUNER },        /* Live */
>     { 0x0a, KEY_A },
>     { 0x03, KEY_PROG1 },        /* 1 */
>     { 0x01, KEY_PROG2 },        /* 2 */
>     { 0x0, KEY_VIDEO },
>     { 0x0b, KEY_CHANNELUP },
>     { 0x08, KEY_CHANNELDOWN },
>     { 0x15, KEY_VOLUMEUP },
>     { 0x1c, KEY_VOLUMEDOWN },
> };
> 
> struct ir_scancode_table ir_codes_adstech_pci_table = {
>     .scan = ir_codes_adstech_pci,
>     .size = ARRAY_SIZE(ir_codes_adstech_pci),
> };
> EXPORT_SYMBOL_GPL(ir_codes_adstech_pci_table);
> 
> No numbers in favor of arrows and ch+/- Vol+/- . Well 246 will be arrows 
> and  5 select, 7 and 8 are undefined, 9 become vol-, 1 epg and 3 is tuner.
> If someone, one day, wants to find that missig bit, i'll be happy to 
> help. ( Strange anyway : it's as if there was a 0x7f mask even when i 
> specify a 0xff one )
> Feel free to write a patch.
> 
> Morvan Le Meut a écrit :
> > um .. help, please ?
> > how can i make the driver read 1011011 instead of 011011 when i press 
> > Power instead of record on the remote ?
> >
> > thanks
> >

Morvan,

I still have a huge mail backlash and are not in details what you may
have tried already, but if you have a missing/unknown gpio on such a
remote, you start to test for that one with mask_keycode = 0x0 in
saa7134-input.c and if it is then found, you do add it to that mask.

If that doesn't help, it might be something special.

Cheers,
Hermann






