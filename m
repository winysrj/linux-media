Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38099 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab2IWODN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 10:03:13 -0400
Received: by bkcjk13 with SMTP id jk13so461107bkc.19
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2012 07:03:12 -0700 (PDT)
Message-ID: <505F16AD.8010909@googlemail.com>
Date: Sun, 23 Sep 2012 16:03:25 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, hdegoede@redhat.com,
	mchehab@infradead.org
Subject: Re: How to add support for the em2765 webcam Speedlink VAD Laplace
 to the kernel ?
References: <5032225A.9080305@googlemail.com> <50323559.7040107@redhat.com> <50328E22.4090805@redhat.com> <50337293.8050808@googlemail.com> <50337FF4.2030200@redhat.com> <5033B177.8060609@googlemail.com> <5033C573.2000304@redhat.com> <50349017.4020204@googlemail.com> <503521B4.6050207@redhat.com> <503A7097.4050709@googlemail.com>
In-Reply-To: <503A7097.4050709@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ping !

Am 26.08.2012 20:53, schrieb Frank Schäfer:
> Sorry for the delayed reply, I got distracted by something with higher
> prority.
>
>
> Am 22.08.2012 20:15, schrieb Mauro Carvalho Chehab:
>> Em 22-08-2012 04:53, Frank Schäfer escreveu:
>>> Am 21.08.2012 19:29, schrieb Mauro Carvalho Chehab:
>>>> Hmm... before reading the rest of this email... I found some doc saying that
>>>> em2765 is UVC compliant. Doesn't the uvcdriver work with this device?
>>> Yeah, I stumbled over that, too. :D
>>> But this device is definitely not UVC compliant. Take a look at the
>>> lsusb output.
>>> Maybe they are using a different firmware or something like that, but I
>>> have no idea why the hell they should make a UVC compliant device
>>> non-UVC-compliant...
>>> Another notable difference to the devices we've seen so far is the
>>> em25xx-style EEPROM. Maybe there is a connection.
>>>
>>> Btw, do we know any em25xx devices ???
>> No, I never heard about em25xx. It seems that there are some new em275xx
>> chips, but I don't have any technical data.
> Maybe they changed the name and there was never a em2580/em2585.
> But I assume this is an older chip design.

In the mean time I was told that em2580/em2585 devices really exists.
They are used for example in intraoral cameras for dentists.
The em2765 seems to be a kind of relabled em25xx.

Both chips have two i2c busses and work only with 16 bit address
eeproms, which have to be connected to bus A.
The sensor read/write procedure used for this webcam is very likely the
standard method for accessing i2c bus B of these chips.
It COULD also be vendor specific procedure, but I don't think 3 other
slave addresses would be probed in that case...

<snip>
>>>> You'll see several supported devices using the secondary bus for TV and
>>>> demod. As, currently, the TV eeprom is not read on those devices, nobody
>>>> cared enough to add a separate I2C bus code for it, as all access used
>>>> by the driver happen just on the second bus.
>>> Well, the same applies to this webcam. We do not really need to read the
>>> EEPROM at the moment.
>>>
>>>
>>>>>> A proper mapping for it to use ov2640 driver is to create two i2c
>>>>>> buses, one used by eeprom access, and another one for sensor.
>>>>> Sure.
>>>>>
>>>>>>> Interestingly, the standard I2C reads are used, too, for reading the
>>>>>>> EEPROM. So maybe there is a "physical" difference.
>>>>>>>
>>>>>>> "Proprietary" is probably not the best name, but I don't have e better
>>>>>>> one at the moment (suggestions ?).
>>>>>> It is just another bus: instead of using req 3/4 for read/write, it uses
>>>>>> req 6 for both reads/writes at the i2c-like sensor bus.
>>>>>>
>>>>>>>>>> - uses 16bit eeprom
>>>>>>>>>> - em25xx-eeprom with different layout
>>>>>>>> There are other supported chips with 16bit eeproms. Currently,
>>>>>>>> support for 16bit eeproms is disabled just because this weren't
>>>>>>>> needed so far, but I'm sure this is a need there.
>>>>>>> Yes, I've read the comment in em28xx_i2c_eeprom():
>>>>>>> "...there is the risk that we could corrupt the eeprom (since a 16-bit
>>>>>>> read call is interpreted as a write call by 8-bit eeproms)..."
>>>>>>> How can we know if a device uses an 8bit or 16bit EEPROM ? Can we derive
>>>>>>> that from the uses em27xx/28xx-chip ?
>>>>>> I don't know any other way to check it than to read the chip ID, at register
>>>>>> 0x0a. Those are the chip ID's that we currently know:
>>>>>>
>>>>>> enum em28xx_chip_id {
>>>>>> 	CHIP_ID_EM2800 = 7,
>>>>>> 	CHIP_ID_EM2710 = 17,
>>>>>> 	CHIP_ID_EM2820 = 18,	/* Also used by some em2710 */
>>>>>> 	CHIP_ID_EM2840 = 20,
>>>>>> 	CHIP_ID_EM2750 = 33,
>>>>>> 	CHIP_ID_EM2860 = 34,
>>>>>> 	CHIP_ID_EM2870 = 35,
>>>>>> 	CHIP_ID_EM2883 = 36,
>>>>>> 	CHIP_ID_EM2874 = 65,
>>>>>> 	CHIP_ID_EM2884 = 68,
>>>>>> 	CHIP_ID_EM28174 = 113,
>>>>>> };
>>>>>>
>>>>>> Even if we add it as a separate driver, it is likely wise to re-use the
>>>>>> registers description at drivers/media/usb/em28xx/em28xx-reg.h, moving it
>>>>>> to drivers/include/media, as em2765 likely uses the same registers. 
>>>>>> It also makes sense to add a chip detection at the existing driver, 
>>>>>> for it to bail out if it detects an em2765 (and the reverse on the new
>>>>>> driver).
>>>>> em2765 has chip-id 0x36 = 54.
>>>>> Do you want me to send a patch ?
>>>> Yes, please send it when you'll be ready for driver submission.
>>> Will do that.
>>>
>>>>> Do you really think the em28xx driver should always bail out when it
>>>>> detects the em2765 ?
>>>> Well, having 2 drivers for the same chipset is a very bad idea. Either
>>>> one should use it.
>>>>
>>>> Another option would be to have a generic em28xx dispatcher driver
>>>> that would handle all of them, probe the board, and then starting
>>>> either one, depending if the driver is webcam or not.
>>> Sounds good.
>>>
>>>> Btw, this is on my TODO list (with low priority), as there are several
>>>> devices that have only DVB. So, it makes sense to split the analog
>>>> TV driver, just like we did with the DVB and alsa drivers. This way,
>>>> an em28xx core driver will contain only the probe and the core functions
>>>> like i2c and the common helper functions, while all the rest would be
>>>> on separate drivers.
>>> Yeah, a compact bridge module providing chip info, bridge register r/w
>>> functions and access to the 2 + 1 i2c busses sounds good.
>>> If I understand you right, this module should also do the probing and
>>> then call the right driver for the device, e.g. gspca for webcams ?
>>> Sounds complicating, because the bridge module is still needed after the
>>> handover to the other driver, but I know nearly nothing about the
>>> modules interaction possibilites (except that one module can call
>>> another ;) ).
>> It is not complicated.
>>
>> At the main driver, take a look at request_module_async(), at em28xx-cards: 
>> it basically schedules a deferred work that will load the needed drivers,
>> after em28xx finishes probing.
>>
>> At the sub-drivers, they use em28xx_register_extension() on their init
>> code. This function uses a table with 4 parameters, like this one:
>>
>> static struct em28xx_ops audio_ops = {
>> 	.id   = EM28XX_AUDIO,
>> 	.name = "Em28xx Audio Extension",
>> 	.init = em28xx_audio_init,
>> 	.fini = em28xx_audio_fini,
>> };
>>
>> The .init() function will then do everything that it is needed for the
>> device to run. It is called when the main driver detects a new card,
>> and it is ready for that (the main driver has some code there to avoid
>> race conditions, serializing the extensions load).
>>
>> The .fini() is called when the device got removed, or when the driver
>> calls em28xx_unregister_extension().
>>
>> The struct em28xx *dev is passed as a parameter on both calls, to allow
>> the several drivers to share common data.
>>
>> This logic works pretty well, even on SMP environments with lots of CPU.
>> The only care needed there (with won't affect a webcam driver) is to
>> properly lock the driver to avoid two different sub-drivers to access the
>> same device resources at the same time (this is needed between DVB and video
>> parts of the driver).
>>
>> By moving the TV part to a separate driver, it makes sense to also create
>> an em28xx_video structure, moving there everything that it is not common,
>> but this is an optimization that could be done anytime.
>>
>> I suggest you to create an em28xx_webcam struct and put there data that it
>> is specifics to the webcam driver there, if any.
> Ok, thanks for your explanations.
> I will see what I can do.
>
>>>> IMO, doing that that could be better than coding em2765 as a
>>>> completely separate driver.
>>> Sounds like the best approach. But also lots of non-trivial work which
>>> someone has to do first. I'm afraid too much for a beginner like me...
>>> And we should keep in mind that this probably means that people will
>>> have to wait several further kernel releases before their device gets
>>> supported.
>> Well, it is not that hard. If I had any time, I would do it right now.
>> It probably won't take more than a few hours of work to split the video
>> part into a separate driver, as 99% of the work is to move a few functions
>> between the .c files, and move the init code from em28xx-cards.c to
>> em28xx-video.
>>
>> I can seek for doing that after the media workshop that will happen
>> next week.
> Ok.
> Trying to summarize the plan, I'm not sure that I understand the driver
> layout completely yet..
> We are going to
> - separate the video part of the em28xx driver and create a compact
> module providing just the core fucntions
> - let this module do the probing an then either call "the rest" of the
> em28xx driver for DVB-devices or a gspca module for all em27xx/em28xx
> based webcams
> - use sub-modules for the sensors and possibly other commonly used
> features (e.g. an eeprom module) in the webcam module
>
> Ist that correct ?

Mauro, could you please elaborate your plan ?
What exactly do you want me to do to get this device supported by the
kernel ?

In the mean time I have ported the gspca driver to the ic2 interface,
which was necessary to experiment with the ov2640 soc-camera driver, but
also increased the code size enormously.
Unfortunately, lots of changes to the ov2640 driver would be necessary
use it. It starts with the init sequence and continues with a long
sequence of sensor register writes at capturing start.
My hope was, that the differences can be neglected, but unfortunately
this is not the case.
Given the amount of work, the fact that most of these registers are
undocumented and the high risk to break things for other users of the
driver, I think we should stay with the "custom" code for this webcam at
least for the moment.

Please also consider the time factor.

Regards,
Frank

>
>>> What about the GPIO/buttons stuff ? That's probably the biggest issue
>>> comparing this device with the others. Would be nice to have a more
>>> generic approach here, too.
>> See em28xx_query_sbutton(), at em28xx-input.c. It makes sense to move
>> the button code to a separate file, as this is needed only by the
>> webcam driver.
> The buttons/LED-stuff works different for this webcam.
> It has 3 buttons (snapshot, mute and illumination) and two LEDs
> (capturing, illumination).
> The snapshot button uses GPIO register set 2 (0x81/0x85), the two other
> buttons and the LEDs use GPIO register set 1 (0x80/0x84).
> The state of the mute and illumination buttons need to be reset by the
> driver, the bit of the snapshot button clears istself automatically when
> the button is depressed.
>
> So for a generic approach, we would need something like
>
> struct gpio_line {
>         reg_r
>         reg_w
>         bit
>         inverted
>         needs_reset
>         poll
>         callback
> }
>
> and corresponding functions.
>
> Seems to be too much overhead at the moment.
>
>>>> It shouldn't be hard to split the code like that: most of the TV-specific
>>>> code is already under em28xx-video. There are still some stuff under
>>>> em28xx-core that could likely be moved into em28xx-video as well, as
>>>> the code is specific for TV.
>>>>
>>>> The probing code, plus the card descriptions is at em28xx-cards. Some
>>>> code there, under em28xx_init_dev() are due to analog init. Moving it
>>>> into em28xx-video and adding there a code like the one at the end of
>>>> em28xx-dvb - the calls for em28xx_(un)register_extension() - should
>>>> be enough for em28xx-video to be an independent module, that would be
>>>> loaded by the core driver only if the device has analog TV.
>>>>
>>>> If you want, please feel free to take this way, working on the
>>>> existing em28xx code to split it like that.
>>> Ok, I will a look it. But that could take some time... ;)
>> Ok.
>>
>>>>>>> Anyway, this problem is common to both solutions (gspca or em28xx-driver).
>>>>>> As eeprom reading is I2C, it could make some sense to use a generic driver
>>>>>> for reading its contents, removing the code from em28xx-i2c logic, and
>>>>>> re-using it on both drivers (assuming that we fork it).
>>>>> Yes, I think that would be a good idea.
>>>>>
>>>>>>>>>> - sensor OV2640
>>>>>>>> There is a driver for it at:
>>>>>>>> 	drivers/media/i2c/soc_camera/ov2640.c
>>>>>>>>
>>>>>>>> The better is to use it (even if this got mapped via gspca).
>>>>>>> Yes, I know. This is already on my ToDo list.
>>>>>>>
>>>>>>>>>> - different frame processing
>>>>>>>>>> - 3 buttons (snapshot, mute, light) which need special treatment
>>>>>>>>>> (GPIO-polling, status-reseting, ...)
>>>>>>>> Need to see the code to better understand that.
>>>>>>> Take a look at the patch.
>>>>>>>
>>>>>>> http://www.spinics.net/lists/linux-media/msg52084.html
>>>>>> Ok, let's do it via gspca, but please map both the standard I2C and 
>>>>>> the "SCCB" bus via the I2C API, and use the existing ov2640 driver.
>>>>> Wow, that was a fast decision. ;)
>>>>> Could you please elaborate a bit more on that ?
>>>>> How are we going to handle em27xx/em28xx webcams in the future ?
>>>>> Only add THIS device via gspca ?
>>>>> Put all em2765 based webcams to a gspca driver ?
>>>>> Put all new devices to gspca ?
>>>>> Or move all webcams to gspca ?
>>>> The better is to move all webcams to the new code. I suspect, however, that
>>>> this can only happen if we keep just one probing code for all em28xx devices.
>>>>
>>>> If you can work like that, I can certainly test the em2750 cameras I
>>>> have here (and fix, if needed).
>>>  That would be necessary. And also testing any other changes to the
>>> em28xx driver, because I don't have such a device.
>> Yeah, sure. I'm sure that there are also other people with em28xx hardware
>> that can help testing, in order to avoid regressions there.
> I hope so.
> Do you know an affordable DVB-T devices with isoc and bulk endpoints
> using an 16bit-eeprom ? ;)
>
> Regards,
> Frank
>
>>>>>>> I've sent it to the list 3 minutes after I started this thread and also
>>>>>>> CC'ed you.
>>>>>>>
>>>>>>>
>>>>>>>>>> Another important point to mention: you can see from the USB-logs
>>>>>>>>>> (sensor probing) that there must be at least 3 other webcam devices.
>>>>>>>> What do you mean?
>>>>>>> The Windows driver probes 3 other sensor addresses (using the same
>>>>>>> "proprietary" reads). I've included them in my patch.
>>>>>>> The INF-file does not contain any other USB IDs, but I think it is
>>>>>>> unlikely that they are used by this device.
>>>>>>> SpeedLink spent different USB IDs even for identical devices with
>>>>>>> different body colors, so I think they would have done they same for
>>>>>>> variants with different sensors.
>>>>>>> It is more likely that the Windows driver is a kind of universal em2765
>>>>>>> driver.
>>>>>> With means that we'll sooner or later get some devices with other sensors.
>>>>> I'm pretty sure about that. Two of them are:
>>>>> eb1a:2711    V-Gear TalkCamPro
>>>> This USB ID is a generic EmpiaTech ID. That means that those cameras don't
>>>> have any eeprom. I'm sure you'll find other devices with different
>>>> sensors sharing this very same USB ID, and maybe even some grabber devices.
>>>>
>>>>> 1ae7:2001    SpeedLink Snappy Microphone
>>>>>
>>>>>> So, it is better to be prepared for that, by exposing the sensor bus via I2C.
>>>>>>
>>>>>> I don't see any need to probe those other sensors right now: we should do it
>>>>>> only if we actually get one of those other devices in hands.
>>>>> Ok. Probing the other 3 addresses doesn't hurt, and the idea behind is,
>>>>> that it easier for people to add support for new devices.
>>>>> The first thing they usually do is to add their USB-ID to the driver and
>>>>> see what happens. With a bit luck, dmesg the shows something like
>>>>> "unknown sensor detetced at address xy" or even "unknown Omnivison
>>>>> sensor detected at address xy", which is (hopefully) encouraging... ;)
>>>>> But if you want me to not probe them, I will disable them (I'm sure you
>>>>> agree that we should keep the addresses in the code, at least as comments).
>>>> If the sensor is Omnivision/Micron, its model typically can be identified
>>>> by reading the contents of sensor register 0. The code under em28xx_hint_sensor()
>>>> does that (it currently assumes a sensor at I2C address 0x5d). So, trying
>>>> to read from address 0, on the possible sensor addresses may help to
>>>> identify what sensor was used.
>>> Yes I'm doing this for Omnivision sensors in the gspca subdriver. And
>>> the the em28xx sensor probing function does it for Micron sensors.
>> Ok.
>>
>> Regards,
>> Mauro

