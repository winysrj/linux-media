Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686Ab3AEPHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Jan 2013 10:07:19 -0500
Date: Sat, 5 Jan 2013 13:06:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/4] Some IR fixes for I2C devices on em28xx
Message-ID: <20130105130647.75c96994@redhat.com>
In-Reply-To: <50E82900.9060701@googlemail.com>
References: <1357334152-3811-1-git-send-email-mchehab@redhat.com>
	<50E82900.9060701@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 05 Jan 2013 14:22:08 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 04.01.2013 22:15, schrieb Mauro Carvalho Chehab:
> > Frank pointed that IR was not working with I2C devices. So, I took some
> > time to fix them.
> >
> > Tested with Hauppauge WinTV USB2.
> >
> > Mauro Carvalho Chehab (4):
> >   [media] em28xx: initialize button/I2C IR earlier
> >   [media] em28xx: autoload em28xx-rc if the device has an I2C IR
> >   [media] em28xx: simplify IR names on I2C devices
> >   [media] em28xx: tell ir-kbd-i2c that WinTV uses an RC5 protocol
> >
> >  drivers/media/usb/em28xx/em28xx-cards.c |  2 +-
> >  drivers/media/usb/em28xx/em28xx-input.c | 29 ++++++++++++++++-------------
> >  2 files changed, 17 insertions(+), 14 deletions(-)
> >
> 
> While these patches make I2C IR remote controls working again, they
> leave several issues unaddressed which should really be fixed:
> 1) the i2c client isn't unregistered on module unload. This was the
> reason for patch 2 in my series. There is also a FIXME comment about
> this in em28xx_release_resources() (although this is the wrong place to
> do it).

AFAIKT, this is not really needed, as the I2C clients are unregistered
when the I2C bus is unregistered.

So, a device disconnect will release it. Also, an em28xx driver unload.

The only difference might be if just ir-kbd-i2c and em28xx-rc are
unloaded, but em28xx is still loaded, but I think that, even on this
case, calling the .release code for an I2C bus will release it.

So, I don't see any need for such patch. I might be wrong, of course, but,
in order to proof that a release code is needed, you'll need to check if
some memory are lost after module load/unload.

> 2) there is no error checking in em28xx_register_i2c_ir().
> em28xx_ir_init should really bail out if no i2c device is found.

A failure to initialize IR should not be fatal for the driver, as the
rest of the hardware still works.

Also, there's no way to warrant that the I2C code is actually running,
as ir-i2c-kbd may not even be compiled.

So, returning 0 there doesn't mean that IR is working.

> 3) All RC maps should be assigned at the same place, no matter if the
> receiver/demodulator is built in or external. Spreading them over the
> code is inconsistent and makes the code bug prone.

I don't agree. It is better to keep RC maps for those devices together
with the RC protocol setting, get_key config, etc. At boards config,
it is very easy to identify I2C IR's, as there's an special field there
to mark those devices (has_ir_i2c). So, if the board has_ir_i2c, the
IR config is inside em28xx-input. That's the same logic that it is
there for has_dvb: if this field is true, the DVB specifics is inside
em28xx-dvb.

> 4) the list of known i2c devices in em28xx-i2c.c misses client address
> 0x3e >> 1 = 0x1f. See client list in em28xx_register_i2c_ir().

Ok. Separate patch, please.

> 5) there should be a warning message for the case that we call
> ir-kbd-i2c with an unknown rc device.

Why? All boards with has_ir_i2c have entries there. I double-checked.
Adding will just bloat the code with no reason. We just need to take
care if we get a patch adding I2C IR support for an old card, to be
sure that data is filled on both places.

Considering that we don't receive any IR I2C code for several years,
and that newer devices won't use that part of the code, it seems highly
unlikely that such code would be ever used.

> 6) because we use our own key polling functions with ir-kbd-i2c, we
> should also select the polling interval value manually. That makes
> things consistent and avoids confusion.

I disagree. The polling interval is mainly dictated by the RC protocol
used (e. g. the minimal time for a repeat code) and by the speed that 
users can type things. It is typically ~100 ms everywhere, except when
there are some exceptional cases, like GPIO polling.

Regards,
Mauro
