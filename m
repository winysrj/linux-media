Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab3AGREn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 12:04:43 -0500
Date: Mon, 7 Jan 2013 15:04:10 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/4] Some IR fixes for I2C devices on em28xx
Message-ID: <20130107150410.5f39a42c@redhat.com>
In-Reply-To: <50E9DC8F.4060902@googlemail.com>
References: <1357334152-3811-1-git-send-email-mchehab@redhat.com>
	<50E82900.9060701@googlemail.com>
	<20130105130647.75c96994@redhat.com>
	<50E9DC8F.4060902@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 06 Jan 2013 21:20:31 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 05.01.2013 16:06, schrieb Mauro Carvalho Chehab:
> > Em Sat, 05 Jan 2013 14:22:08 +0100
> > Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >
> >> Am 04.01.2013 22:15, schrieb Mauro Carvalho Chehab:
> >>> Frank pointed that IR was not working with I2C devices. So, I took some
> >>> time to fix them.
> >>>
> >>> Tested with Hauppauge WinTV USB2.
> >>>
> >>> Mauro Carvalho Chehab (4):
> >>>   [media] em28xx: initialize button/I2C IR earlier
> >>>   [media] em28xx: autoload em28xx-rc if the device has an I2C IR
> >>>   [media] em28xx: simplify IR names on I2C devices
> >>>   [media] em28xx: tell ir-kbd-i2c that WinTV uses an RC5 protocol
> >>>
> >>>  drivers/media/usb/em28xx/em28xx-cards.c |  2 +-
> >>>  drivers/media/usb/em28xx/em28xx-input.c | 29 ++++++++++++++++-------------
> >>>  2 files changed, 17 insertions(+), 14 deletions(-)
> >>>
> >> While these patches make I2C IR remote controls working again, they
> >> leave several issues unaddressed which should really be fixed:
> >> 1) the i2c client isn't unregistered on module unload. This was the
> >> reason for patch 2 in my series. There is also a FIXME comment about
> >> this in em28xx_release_resources() (although this is the wrong place to
> >> do it).
> > AFAIKT, this is not really needed, as the I2C clients are unregistered
> > when the I2C bus is unregistered.
> >
> > So, a device disconnect will release it. Also, an em28xx driver unload.
> >
> > The only difference might be if just ir-kbd-i2c and em28xx-rc are
> > unloaded, but em28xx is still loaded, but I think that, even on this
> > case, calling the .release code for an I2C bus will release it.
> >
> > So, I don't see any need for such patch. I might be wrong, of course, but,
> > in order to proof that a release code is needed, you'll need to check if
> > some memory are lost after module load/unload.
> 
> Mauro, just because code luckily 'works' in the current constellation,
> it isn't necessarily good code.

It doesn't luckly 'works'. It is rock solid. There were really few bug
reports for ir-kbd-i2c during all those years.

> It's this kind of issues that can easily cause regressions if the code
> changes somewhere else.

Nah. What causes regression is touching on a code that works for no
good reason and without enough testing.

Btw, I was told that audio on HVR-950 seemed to stop working.

Not sure what broke it, but, as I tested it some time ago, I suspect
was due to one of those recent patches (v4l2-compliance, vb2 or your
patches - we need to bisect to discover what broke it). None of those
touched on em28xx-alsa directly, but perhaps one of the patches had
a bad side effect.

> em28xx-input registers the i2c device, so it should unregister it on
> uninit/close/unload, too.
> Pretty simple and easy to fix (+5 - 2 = 3 additional lines of code).

Fair enough. Please send us a patch, after enough testing.

> >> 2) there is no error checking in em28xx_register_i2c_ir().
> >> em28xx_ir_init should really bail out if no i2c device is found.
> > A failure to initialize IR should not be fatal for the driver, as the
> > rest of the hardware still works.
> 
> I'm talking about em28xx-input and the RC part only. Of course not the
> whole driver.
> Do you really want to load module ir-kbd-i2c even though there is no
> device ?
> 
> 
> > Also, there's no way to warrant that the I2C code is actually running,
> > as ir-i2c-kbd may not even be compiled.
> >
> > So, returning 0 there doesn't mean that IR is working.
> 
> You can check the success of request_module.

> The whole thing is really easy to fix, I fail to see why you don't want
> to do it.

Ok, such change may make sense, but only as a separate patch, and not as
a big "fix" patch that does something else.

> 
> >> 3) All RC maps should be assigned at the same place, no matter if the
> >> receiver/demodulator is built in or external. Spreading them over the
> >> code is inconsistent and makes the code bug prone.
> > I don't agree. It is better to keep RC maps for those devices together
> > with the RC protocol setting, get_key config, etc. At boards config,
> > it is very easy to identify I2C IR's, as there's an special field there
> > to mark those devices (has_ir_i2c). So, if the board has_ir_i2c, the
> > IR config is inside em28xx-input. 
> 
> ... which is exactly what made it so easy to cause this regression !!!
> 
> It's not obvious for programmers that no RC map has to be specified for
> i2c RCs in the board data.
> It's also not obvious that em28xx-input silently overwrites the rc-map
> assigned at board level.
> In general, it's not obvious that two completely different code areas
> have to be touched for these devices.
> That's why we really should avoid those board specific code parts spread
> all over the driver as much as possible.
> In case of the RC map it's really easy.
> 
> I also fail to see what you would loose in em28xx-input. We would still
> assign the RC map to dev->init_data.
> If you prefer seeing the used RC map in the em28xx-input code directly,
> then the same should apply for devices with built-in IR
> recceiver/decoder (which means moving all rc-map assignments to
> em28xx-input).
> You could also get rid of field ir_codes this way.

I don't agree with the changes you're proposing, for the already explained
reasons. Your arguments are, IMHO, weak, as there are really few devices
with I2C IRs, and I doubt that we'll have a sudden burst of patches
adding new I2C IRs.

> 
> > That's the same logic that it is
> > there for has_dvb: if this field is true, the DVB specifics is inside
> > em28xx-dvb.
> 
> Different case.
> Avoiding board specific code parts there likely isn't possible (and
> reasonable), although it should be the goal.

It is possible. We did it on tm6000. Yet, just like IR's, there are
board-specific functions to initialize DVB device-specific code.

The thing is: on both I2C IR and DVB, you can't specify completely a
board at em28xx cards structure. So, the best is to put everything
board specific related to DVB and RC inside their own .c code, than
to spread it into em28xx cards struct and em28xx-input/em28xx-dvb.

> >> 4) the list of known i2c devices in em28xx-i2c.c misses client address
> >> 0x3e >> 1 = 0x1f. See client list in em28xx_register_i2c_ir().
> > Ok. Separate patch, please.
> 
> Coming soon.
> 
> >> 5) there should be a warning message for the case that we call
> >> ir-kbd-i2c with an unknown rc device.
> > Why? All boards with has_ir_i2c have entries there. I double-checked.
> > Adding will just bloat the code with no reason. We just need to take
> > care if we get a patch adding I2C IR support for an old card, to be
> > sure that data is filled on both places.
> >
> > Considering that we don't receive any IR I2C code for several years,
> > and that newer devices won't use that part of the code, it seems highly
> > unlikely that such code would be ever used.
> 
> Yes, this is indeed more a theoretical thing.
> I think good code should have such a warning, but that's also matter of
> taste.
> Talking about code bloating seems a bit exaggerated to me, we are
> talking about 1 or 2 extra lines of code.
> 
> 
> >> 6) because we use our own key polling functions with ir-kbd-i2c, we
> >> should also select the polling interval value manually. That makes
> >> things consistent and avoids confusion.
> > I disagree. The polling interval is mainly dictated by the RC protocol
> > used (e. g. the minimal time for a repeat code) and by the speed that 
> > users can type things. It is typically ~100 ms everywhere, except when
> > there are some exceptional cases, like GPIO polling.
> 
> Yepp, and that's the responsibility of the driver. em28xx-input and not
> ir-kbd-i2c !
> The driver that supplies the key polling functions.

Again, I disagree.

> 
> > Regards,
> > Mauro
> 
> 
> Mauro,
> I would like to repeat what I've already said above: just because code
> 'works' in a specific constellation, it isn't necessarily good code.
> The fact that this code has been suffering from a big fat regression for
> a long time should really draw our attention !
> So let's try to avoid this happening again by fixing the issues the code
> has, so that it becomes much more robust.
> I'm offering to send patches.

The regression is there just because it is a code that most people don't
use or even care: only very few boards have buttons; only 4 boards use
I2C IRs. Also, because developers didn't test the new code with those
very old hardware (6 years or more) that use I2C IR's.

In practice, very very few people use a TV card with a hardware IR decoder
for remote controllers. They prefer to just disable that code, either at
driver's init or at compile time.

Why? Simple: most people just use their keyboards, as the capture board
is inside their desktop machines.

The ones that use the TV devices like a TV VDR hardware very likely prefer
to buy an mceusb compatible hardware that it is a way more flexible,
being capable of working with other protocols, use hardware IR decoders
and to send IR codes to other devices.

Regards,
Mauro
