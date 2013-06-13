Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758585Ab3FMKjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jun 2013 06:39:08 -0400
Date: Thu, 13 Jun 2013 07:39:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Chris Rankin <rankincj@yahoo.com>
Cc: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: 3.9.2 kernel - IR / em28xx_rc broken?
Message-ID: <20130613073903.77ea9c84@redhat.com>
In-Reply-To: <519A430E.4080006@googlemail.com>
References: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com>
	<519791E2.4080804@googlemail.com>
	<1368890230.26016.YahooMailNeo@web120301.mail.ne1.yahoo.com>
	<5197B34A.8010700@googlemail.com>
	<1368910949.59547.YahooMailNeo@web120304.mail.ne1.yahoo.com>
	<5198D669.6030007@googlemail.com>
	<1368972692.46197.YahooMailNeo@web120301.mail.ne1.yahoo.com>
	<51990B63.5090402@googlemail.com>
	<1368993591.43913.YahooMailNeo@web120305.mail.ne1.yahoo.com>
	<51993DDE.4070800@googlemail.com>
	<1369004659.18393.YahooMailNeo@web120305.mail.ne1.yahoo.com>
	<519A1939.6030907@googlemail.com>
	<1369054869.78400.YahooMailNeo@web120305.mail.ne1.yahoo.com>
	<519A287C.9010804@googlemail.com>
	<1369061513.11886.YahooMailNeo@web120305.mail.ne1.yahoo.com>
	<519A430E.4080006@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Sorry for not getting into it earlier... too much work those days.

Em Mon, 20 May 2013 17:36:46 +0200
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 20.05.2013 16:51, schrieb Chris Rankin:
> > ----- Original Message -----
> >
> >> If I had to guess, I would say you should check your rc_maps.cfg / keytable. ;)
> > This is unchanged between 3.8.x and 3.9.x, and so is correct by definition.
> 
> No, just because it didn't change it isn't automatically correct. ;)
> Which protocol type does you keytable specify/select ?
> It should be RC5. If it's none or unknown, it's just dump luck that
> things are working (because the driver fortunately configures the device
> for RC5 in case of  RC_BIT_UNKNOWN).

The RC_BIT_UNKNOWN has 3 usages:
	1) when the protocol is unknown;
	2) on legacy tables, when the full scancode is unknown;
	3) on broken devices where just the command part of the scancode
	   (7 or 8 bits) is known.

In the case of em28xx, only (2) applies.

So, the behavior on em28xx is to support legacy IR tables written using
the legacy input layer, that use to support only 8 bits for keycodes.
So, we don't know the address bits of the keycodes. 

The expected behavior on em28xx when RC_BIT_UNKNOWN is used, is that
the keycode tables would be 8-bits masked, and the same mask should
also be applied to the received keycodes. This is done by the RC core.

That is used only by a very few set of em28xx cards:

$ for i in $(git grep RC_MAP_ $(git grep -l  _UNKNOWN drivers/media/rc/keymaps/)|perl -ne 'print "$1\n" if (m/(RC_MAP_[\w\d\_]+)/)');do git grep $i drivers/media/usb/em28xx/; done
drivers/media/usb/em28xx/em28xx-cards.c:          .ir_codes       = RC_MAP_ATI_TV_WONDER_HD_600,
drivers/media/usb/em28xx/em28xx-input.c:                  rc->map_name = RC_MAP_EM_TERRATEC;
drivers/media/usb/em28xx/em28xx-cards.c:          .ir_codes     = RC_MAP_EVGA_INDTUBE,
drivers/media/usb/em28xx/em28xx-cards.c:          .ir_codes     = RC_MAP_GADMEI_RM008Z,
drivers/media/usb/em28xx/em28xx-cards.c:          .ir_codes     = RC_MAP_KAIOMY,
drivers/media/usb/em28xx/em28xx-input.c:                  rc->map_name = RC_MAP_PINNACLE_GREY;
drivers/media/usb/em28xx/em28xx-cards.c:          .ir_codes       = RC_MAP_TERRATEC_CINERGY_XS,
drivers/media/usb/em28xx/em28xx-cards.c:          .ir_codes     = RC_MAP_TERRATEC_CINERGY_XS,
drivers/media/usb/em28xx/em28xx-input.c:                  rc->map_name = RC_MAP_WINFAST_USBII_DELUXE;
drivers/media/usb/em28xx/em28xx-input.c:                  rc->map_name = RC_MAP_WINFAST_USBII_DELUXE;

Patches are welcome to replace the above scancode tables by one with
the full code, as we want to use RC_BIT_UNKNOWN only on broken hardware
where the scancode is only partially filled.

Btw, the bits that handles the masks are at rc-main.c, at
ir_establish_scancode():

	if (dev->scanmask)
		scancode &= dev->scanmask;

A quick look at em28xx shows that it is not using it anymore, so some
patch likely broke support for RC_BIT_UNKNOWN there.

So, a fix is needed there to fill dev->scanmask if a RC_BIT_UNKNOWN
table is used.

It should be noticed that tables with RC_BIT_UNKNOWN are generally 
not portable among devices, as some of those tables have the command
bits inverted.

> 
> > Kernel Upgrades Do Not Break Userspace.
> 
> Right.
> That's why I would say the third (scancode) change is problematic.
> Let's see what Mauro thinks about this.

For legacy tables, only 16 bits are needed (as all those tables are
for either RC5 or NEC), in the form of <addr><cmd> and dev->scanmask
should be 0xff.

The rationale to not mask the scancode to contain just the <cmd> part
is that the produced debug messages could be used by someone to
identify the address for those broken IR keytables and write a patch
for us fixing it.

Regards,
Mauro
