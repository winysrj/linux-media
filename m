Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab2JFL4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Oct 2012 07:56:35 -0400
Date: Sat, 6 Oct 2012 08:56:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org, hdegoede@redhat.com,
	mchehab@infradead.org
Subject: Re: How to add support for the em2765 webcam Speedlink VAD Laplace
 to the kernel ?
Message-ID: <20121006085624.128f7f2c@redhat.com>
In-Reply-To: <505F16AD.8010909@googlemail.com>
References: <5032225A.9080305@googlemail.com>
	<50323559.7040107@redhat.com>
	<50328E22.4090805@redhat.com>
	<50337293.8050808@googlemail.com>
	<50337FF4.2030200@redhat.com>
	<5033B177.8060609@googlemail.com>
	<5033C573.2000304@redhat.com>
	<50349017.4020204@googlemail.com>
	<503521B4.6050207@redhat.com>
	<503A7097.4050709@googlemail.com>
	<505F16AD.8010909@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 23 Sep 2012 16:03:25 +0200
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Ping !

Sorry, too busy those days.
> 
> Am 26.08.2012 20:53, schrieb Frank Schäfer:
> > Sorry for the delayed reply, I got distracted by something with higher
> > prority.
> >
> >
> > Am 22.08.2012 20:15, schrieb Mauro Carvalho Chehab:
> >> Em 22-08-2012 04:53, Frank Schäfer escreveu:
> >>> Am 21.08.2012 19:29, schrieb Mauro Carvalho Chehab:
> >>>> Hmm... before reading the rest of this email... I found some doc saying that
> >>>> em2765 is UVC compliant. Doesn't the uvcdriver work with this device?
> >>> Yeah, I stumbled over that, too. :D
> >>> But this device is definitely not UVC compliant. Take a look at the
> >>> lsusb output.
> >>> Maybe they are using a different firmware or something like that, but I
> >>> have no idea why the hell they should make a UVC compliant device
> >>> non-UVC-compliant...
> >>> Another notable difference to the devices we've seen so far is the
> >>> em25xx-style EEPROM. Maybe there is a connection.
> >>>
> >>> Btw, do we know any em25xx devices ???
> >> No, I never heard about em25xx. It seems that there are some new em275xx
> >> chips, but I don't have any technical data.
> > Maybe they changed the name and there was never a em2580/em2585.
> > But I assume this is an older chip design.
> 
> In the mean time I was told that em2580/em2585 devices really exists.
> They are used for example in intraoral cameras for dentists.
> The em2765 seems to be a kind of relabled em25xx.

Ok.

> Both chips have two i2c busses and work only with 16 bit address
> eeproms, which have to be connected to bus A.
> The sensor read/write procedure used for this webcam is very likely the
> standard method for accessing i2c bus B of these chips.
> It COULD also be vendor specific procedure, but I don't think 3 other
> slave addresses would be probed in that case...

AFAIKT, newer em28xx chips are using this concept. The em28xx-i2c code require
changes to support two I2C buses, and to handle 16 bit eeproms. We never cared
of doing that because we never needed, so far, to read anything from those
devices' eeproms.


> 
> <snip>
> >>>> You'll see several supported devices using the secondary bus for TV and
> >>>> demod. As, currently, the TV eeprom is not read on those devices, nobody
> >>>> cared enough to add a separate I2C bus code for it, as all access used
> >>>> by the driver happen just on the second bus.
> >>> Well, the same applies to this webcam. We do not really need to read the
> >>> EEPROM at the moment.
> >>>
> >>>
> >>>>>> A proper mapping for it to use ov2640 driver is to create two i2c
> >>>>>> buses, one used by eeprom access, and another one for sensor.
> >>>>> Sure.
> >>>>>
> >>>>>>> Interestingly, the standard I2C reads are used, too, for reading the
> >>>>>>> EEPROM. So maybe there is a "physical" difference.
> >>>>>>>
> >>>>>>> "Proprietary" is probably not the best name, but I don't have e better
> >>>>>>> one at the moment (suggestions ?).
> >>>>>> It is just another bus: instead of using req 3/4 for read/write, it uses
> >>>>>> req 6 for both reads/writes at the i2c-like sensor bus.
> >>>>>>
> >>>>>>>>>> - uses 16bit eeprom
> >>>>>>>>>> - em25xx-eeprom with different layout
> >>>>>>>> There are other supported chips with 16bit eeproms. Currently,
> >>>>>>>> support for 16bit eeproms is disabled just because this weren't
> >>>>>>>> needed so far, but I'm sure this is a need there.
> >>>>>>> Yes, I've read the comment in em28xx_i2c_eeprom():
> >>>>>>> "...there is the risk that we could corrupt the eeprom (since a 16-bit
> >>>>>>> read call is interpreted as a write call by 8-bit eeproms)..."
> >>>>>>> How can we know if a device uses an 8bit or 16bit EEPROM ? Can we derive
> >>>>>>> that from the uses em27xx/28xx-chip ?
> >>>>>> I don't know any other way to check it than to read the chip ID, at register
> >>>>>> 0x0a. Those are the chip ID's that we currently know:
> >>>>>>
> >>>>>> enum em28xx_chip_id {
> >>>>>> 	CHIP_ID_EM2800 = 7,
> >>>>>> 	CHIP_ID_EM2710 = 17,
> >>>>>> 	CHIP_ID_EM2820 = 18,	/* Also used by some em2710 */
> >>>>>> 	CHIP_ID_EM2840 = 20,
> >>>>>> 	CHIP_ID_EM2750 = 33,
> >>>>>> 	CHIP_ID_EM2860 = 34,
> >>>>>> 	CHIP_ID_EM2870 = 35,
> >>>>>> 	CHIP_ID_EM2883 = 36,
> >>>>>> 	CHIP_ID_EM2874 = 65,
> >>>>>> 	CHIP_ID_EM2884 = 68,
> >>>>>> 	CHIP_ID_EM28174 = 113,
> >>>>>> };
> >>>>>>
> >>>>>> Even if we add it as a separate driver, it is likely wise to re-use the
> >>>>>> registers description at drivers/media/usb/em28xx/em28xx-reg.h, moving it
> >>>>>> to drivers/include/media, as em2765 likely uses the same registers. 
> >>>>>> It also makes sense to add a chip detection at the existing driver, 
> >>>>>> for it to bail out if it detects an em2765 (and the reverse on the new
> >>>>>> driver).
> >>>>> em2765 has chip-id 0x36 = 54.
> >>>>> Do you want me to send a patch ?
> >>>> Yes, please send it when you'll be ready for driver submission.
> >>> Will do that.
> >>>
> >>>>> Do you really think the em28xx driver should always bail out when it
> >>>>> detects the em2765 ?
> >>>> Well, having 2 drivers for the same chipset is a very bad idea. Either
> >>>> one should use it.
> >>>>
> >>>> Another option would be to have a generic em28xx dispatcher driver
> >>>> that would handle all of them, probe the board, and then starting
> >>>> either one, depending if the driver is webcam or not.
> >>> Sounds good.
> >>>
> >>>> Btw, this is on my TODO list (with low priority), as there are several
> >>>> devices that have only DVB. So, it makes sense to split the analog
> >>>> TV driver, just like we did with the DVB and alsa drivers. This way,
> >>>> an em28xx core driver will contain only the probe and the core functions
> >>>> like i2c and the common helper functions, while all the rest would be
> >>>> on separate drivers.
> >>> Yeah, a compact bridge module providing chip info, bridge register r/w
> >>> functions and access to the 2 + 1 i2c busses sounds good.
> >>> If I understand you right, this module should also do the probing and
> >>> then call the right driver for the device, e.g. gspca for webcams ?
> >>> Sounds complicating, because the bridge module is still needed after the
> >>> handover to the other driver, but I know nearly nothing about the
> >>> modules interaction possibilites (except that one module can call
> >>> another ;) ).
> >> It is not complicated.
> >>
> >> At the main driver, take a look at request_module_async(), at em28xx-cards: 
> >> it basically schedules a deferred work that will load the needed drivers,
> >> after em28xx finishes probing.
> >>
> >> At the sub-drivers, they use em28xx_register_extension() on their init
> >> code. This function uses a table with 4 parameters, like this one:
> >>
> >> static struct em28xx_ops audio_ops = {
> >> 	.id   = EM28XX_AUDIO,
> >> 	.name = "Em28xx Audio Extension",
> >> 	.init = em28xx_audio_init,
> >> 	.fini = em28xx_audio_fini,
> >> };
> >>
> >> The .init() function will then do everything that it is needed for the
> >> device to run. It is called when the main driver detects a new card,
> >> and it is ready for that (the main driver has some code there to avoid
> >> race conditions, serializing the extensions load).
> >>
> >> The .fini() is called when the device got removed, or when the driver
> >> calls em28xx_unregister_extension().
> >>
> >> The struct em28xx *dev is passed as a parameter on both calls, to allow
> >> the several drivers to share common data.
> >>
> >> This logic works pretty well, even on SMP environments with lots of CPU.
> >> The only care needed there (with won't affect a webcam driver) is to
> >> properly lock the driver to avoid two different sub-drivers to access the
> >> same device resources at the same time (this is needed between DVB and video
> >> parts of the driver).
> >>
> >> By moving the TV part to a separate driver, it makes sense to also create
> >> an em28xx_video structure, moving there everything that it is not common,
> >> but this is an optimization that could be done anytime.
> >>
> >> I suggest you to create an em28xx_webcam struct and put there data that it
> >> is specifics to the webcam driver there, if any.
> > Ok, thanks for your explanations.
> > I will see what I can do.
> >
> >>>> IMO, doing that that could be better than coding em2765 as a
> >>>> completely separate driver.
> >>> Sounds like the best approach. But also lots of non-trivial work which
> >>> someone has to do first. I'm afraid too much for a beginner like me...
> >>> And we should keep in mind that this probably means that people will
> >>> have to wait several further kernel releases before their device gets
> >>> supported.
> >> Well, it is not that hard. If I had any time, I would do it right now.
> >> It probably won't take more than a few hours of work to split the video
> >> part into a separate driver, as 99% of the work is to move a few functions
> >> between the .c files, and move the init code from em28xx-cards.c to
> >> em28xx-video.
> >>
> >> I can seek for doing that after the media workshop that will happen
> >> next week.
> > Ok.
> > Trying to summarize the plan, I'm not sure that I understand the driver
> > layout completely yet..
> > We are going to
> > - separate the video part of the em28xx driver and create a compact
> > module providing just the core fucntions
> > - let this module do the probing an then either call "the rest" of the
> > em28xx driver for DVB-devices or a gspca module for all em27xx/em28xx
> > based webcams

Yes.

> > - use sub-modules for the sensors and possibly other commonly used
> > features (e.g. an eeprom module) in the webcam module

I think that this should also be part of the em28xx core, as 2 I2C buses
and 16-bit eeproms are also used on newer em28xx chips (em2874/em2875 for
example). The way request_module_async works allow the main em28xx to load
a gspca-based em25xx/em27xx module that, in turn, will use symbols defined
on the main em28xx module.

> >
> > Ist that correct ?
> 
> Mauro, could you please elaborate your plan ?
> What exactly do you want me to do to get this device supported by the
> kernel ?

Basically, the core em28xx module will have:
	drivers/media/usb/em28xx/em28xx-cards.c
	drivers/media/usb/em28xx/em28xx-i2c.c
	drivers/media/usb/em28xx/em28xx-core.c

Eventually, part of the functions under em28xx-core could be moved
to em28xx-video, as they would be used just there. For the already
supported em2710/em2750 webcams, we should need to change the logic
there to use the new gspca-em2xxx module, but this change can be
done later.

The em28xx-alsa module already have:
	drivers/media/usb/em28xx/em28xx-audio.c
Nothing changes on it.

The em28xx-dvb module already have:
	drivers/media/usb/em28xx/em28xx-dvb.c
Nothing changes on it.

The new em28xx-v4l module will have:
	drivers/media/usb/em28xx/em28xx-vbi.c
	drivers/media/usb/em28xx/em28xx-video.c

The em28xx-rc module already have:
	drivers/media/usb/em28xx/em28xx-input.c
It makes sense to split it into two separate files, one with just the
remote control stuff, and the other one with the webcam snapshot buttons.

The file with the webcam buttons support should be merged with the em28xx
gspca module, together with the code you wrote.

> In the mean time I have ported the gspca driver to the ic2 interface,
> which was necessary to experiment with the ov2640 soc-camera driver,

Good!

> but also increased the code size enormously.

Why?

> Unfortunately, lots of changes to the ov2640 driver would be necessary
> use it. It starts with the init sequence and continues with a long
> sequence of sensor register writes at capturing start.
> My hope was, that the differences can be neglected, but unfortunately
> this is not the case.
> Given the amount of work, the fact that most of these registers are
> undocumented and the high risk to break things for other users of the
> driver, I think we should stay with the "custom" code for this webcam at
> least for the moment.

Well, then do a new ov2640 i2c driver. We can later try to merge both, if
we can get enough spec data.
> 
> Please also consider the time factor.
> 
> Regards,
> Frank
> 

Regards,
Mauro
