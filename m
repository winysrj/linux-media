Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:53267 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754221Ab0EMDiV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 May 2010 23:38:21 -0400
Subject: Re: Remote control at Zolid Hybrid TV Tuner
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sander Pientka <cumulus0007@gmail.com>, linux-media@vger.kernel.org
In-Reply-To: <4BEAFA76.5070809@redhat.com>
References: <db09c9681002161116k52278916ob68884ddc989044@mail.gmail.com>
	 <1266375385.3176.5.camel@pc07.localdom.local>
	 <db09c9681002170838tdb15cbbu67cd45a518c11b4b@mail.gmail.com>
	 <1266445236.7202.17.camel@pc07.localdom.local>
	 <AANLkTin6b9JT1j0iNBmrp0UIhN9Z2Y-V6xdrEy7g5NQb@mail.gmail.com>
	 <4BEAFA76.5070809@redhat.com>
Content-Type: text/plain
Date: Thu, 13 May 2010 05:28:32 +0200
Message-Id: <1273721312.10695.12.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Mittwoch, den 12.05.2010, 15:59 -0300 schrieb Mauro Carvalho Chehab:
> Sander Pientka wrote:
> > Hi Hermann,
> > 
> > I am going to revive this old thread, I completely forgot about it and
> > I still want to solve this problem.
> > 
> > Yes, with the IR transmitter not plugged in, the gpio is reported as
> > 00000 by dmesg.
> > 
> > I am aware there is a picture of the backside missing on the wiki, I
> > will try to make one a.s.a.p.
> > 
> > NEC IR support seems to be built-in already: drivers/media/IR/ir-nec-decoder.c.
> > 
> > Besides, dmesg outputs a section of error messages I don't understand:
> > 
> > [ 1585.548221] tda18271_write_regs: ERROR: idx = 0x5, len = 1,
> > i2c_transfer returned: -5
> > [ 1585.548229] tda18271_toggle_output: error -5 on line 47
> > [ 1585.720118] tda18271_write_regs: ERROR: idx = 0x5, len = 1,
> > i2c_transfer returned: -5
> > [ 1585.720129] tda18271_init: error -5 on line 826
> > [ 1585.720136] tda18271_tune: error -5 on line 904
> > [ 1585.720141] tda18271_set_analog_params: error -5 on line 1041
> > [ 1586.381026] tda18271_write_regs: ERROR: idx = 0x6, len = 1,
> > i2c_transfer returned: -5
> > [ 1586.500589] tda18271_write_regs: ERROR: idx = 0x1d, len = 1,
> > i2c_transfer returned: -5
> > [ 1586.629447] tda18271_write_regs: ERROR: idx = 0x10, len = 1,
> > i2c_transfer returned: -5
> > [ 1586.629458] tda18271_channel_configuration: error -5 on line 160
> > [ 1586.629465] tda18271_set_analog_params: error -5 on line 1041
> > 
> > 
> > Do you have any idea about the origin of these errors? Do you think
> > they affect the IR functionality?
> 
> The above errors won't change anything at IR side. For IR, the better approach
> is to start using raw_decode mode. I've enabled it only for Avermedia M135A, 
> since this is the board I'm using at the IR refactoring tests, but the same approach
> should work fine for any other saa7134 board that uses GPIO18 or GPIO16. For GPIO18,
> all you need is to use something like:
> 
>         case SAA7134_BOARD_AVERMEDIA_M135A:
>                 ir_codes     = RC_MAP_AVERMEDIA_M135A_RM_JX;
>                 mask_keydown = 0x0040000;
>                 mask_keyup   = 0x0040000;
>                 mask_keycode = 0xffff;
>                 raw_decode   = 1;
>                 break;
> 
> (Of course, replacing the board name by your board name (SAA7134_BOARD_ZOLID_HYBRID_PCI?),
> and pointing to the proper ir_codes table. You'll likely need to write one table for
> the IR that were shipped with your board.
> 
> To do that, you'll need to enable debug at ir_core (modprobe ir_core debug=1), and type every
> key on your keyboard, associating the scancode number with a key name. See http://www.linuxtv.org/wiki/index.php/Remote_Controllers for a reference of the most comon keycodes.
> 
> For example, pressing the power button of an IR I have here (for Leadtek PVR3000), it
> gives this info at the dmesg log:
> ir_nec_decode: NEC scancode 0x0300
> 
> All I need to do is to write a new keymap:
> 
> add a new media/rc-map.h
> 
> 
>  as, for example:
> 	drivers/media/IR/keymaps/rc-leadtek_pvr3000.c
> (copying one of the existing keymaps) and add:
> 
> static struct ir_scancode leadtek_winfast_pvr3000_dlx[] = {
> 	{ 0x300, KEY_POWER2 },
> 
> for every key that it is there. Then, add the new file at drivers/media/IR/keymaps/Makefile.
> 
> I've tried to summarize the above patches on a change I just did at the wiki page. Feel 
> free to improve it, if needed.
> 
> Cheers,
> Mauro

Hi Mauro,

what I did try to point to, with some sarcasm involved, is that I can't
advice any v4l-dvb as reference anymore.

To start to look such up, with all patches involved, per user, who
likely does not know himself on what he exactly is, find the last
building kernel for him then, guess on pending pull requests that time,
and so on, is not making any sense for me.

Should we not state, that is nothing against Douglas at all or Hans with
his build reports, please be on latest .rc and git to test anything we
have around?

We are out of sync else.

Cheers,
Hermann






