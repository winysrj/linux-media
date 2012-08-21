Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932196Ab2HUSV5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 14:21:57 -0400
Message-ID: <5033C573.2000304@redhat.com>
Date: Tue, 21 Aug 2012 14:29:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org, hdegoede@redhat.com,
	mchehab@infradead.org
Subject: Re: How to add support for the em2765 webcam Speedlink VAD Laplace
 to the kernel ?
References: <5032225A.9080305@googlemail.com> <50323559.7040107@redhat.com> <50328E22.4090805@redhat.com> <50337293.8050808@googlemail.com> <50337FF4.2030200@redhat.com> <5033B177.8060609@googlemail.com>
In-Reply-To: <5033B177.8060609@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hmm... before reading the rest of this email... I found some doc saying that
em2765 is UVC compliant. Doesn't the uvcdriver work with this device?


Em 21-08-2012 13:04, Frank Schäfer escreveu:
> Am 21.08.2012 14:32, schrieb Mauro Carvalho Chehab:
>> Em 21-08-2012 08:35, Frank Schäfer escreveu:
>>> Am 20.08.2012 21:21, schrieb Mauro Carvalho Chehab:
>>>> Em 20-08-2012 10:02, Hans de Goede escreveu:
>>>>> Hi,
>>>>>
>>>>> On 08/20/2012 01:41 PM, Frank Schäfer wrote:
>>>>>> Hi,
>>>>>>
>>>>>> after a break of 2 1/2 kernel releases (sorry, I was busy with another
>>>>>> project), I would like to bring up again the question how to add support
>>>>>> for this device to the kernel.
>>>>>> See
>>>>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg44417.html
>>>>>> ("Move em27xx/em28xx webcams to a gspca subdriver ?") for the previous
>>>>>> discussion.
>>>>>>
>>>>>> Current status is, that I've reverse-engineered the Windows driver and
>>>>>> written a new gspca-subdriver for testing, which is feature complete and
>>>>>> working stable (will send a patch shortly !).
>>>>>>
>>>>>> The device uses an em2765-bridge, so my first idea was of course to
>>>>>> modify/extend the em28xx-driver.
>>>>>> But during the reverse-engineering-process, it turned out that writing a
>>>>>> new gspca-subdriver was much easier than modifying the em28xx-driver.
>>>>>>
>>>>>> The device has the following special characteristics:
>>>>>> - supports only bulk transfers (em28xx driver supports ISOC only)
>>>> Em28xx driver supports both isoc and bulk transfers, as bulk is
>>>> required by DVB.
>>> Hmm... are you 100% sure ? Must have been added recently then...
>>>
>>> I did a quick check of the current code, but can't find anything. Could
>>> you please give me a pointer to the code parts ?
>>> Btw, if I'm not understanding the code wrong, em28xx_usb_probe() still
>>> seems to return -ENODEV if no isoc-in endpoint is found, so bulk-ep-only
>>> devices should not work...
>> Perhaps I'm tricked by tm6000 code... both codes are similar.
>> There are a few differences with regards to isoc/bulk hanlding
>> there.
>>
>>>>>> - uses "proprietary" read/write procedures for the sensor
>>>> Sure about that? It doesn't use I2C?
>>> According to the datasheet of the OV2640 it should be SCCB.
>> SCCB is a variant of I2C.
> 
> I'm not sure if Omnivison would admit that. :D

Maybe there are trademarks envolved ;)

>>> Anyway, I'm referring to how communication works on the USB level.
>>> Take a look at http://linuxtv.org/wiki/index.php/VAD_Laplace section
>>> "Reverse Engineering (evaluation of USB-logs)" to see how it is working.
>> Ok. From your logs, it seems that em2765 uses a different bus for
>> sensor communication. It is not unusual to have more than one bus on
>> some modern devices (cx231xx has 3 I2C buses, plus one extra bus that
>> can be switched).
> 
> Yes, but I'm wondering why.
> Shouldn't it be possible to connect both (sensor and eeprom) to the same
> bus ? Or are i2c and sccb devices incompatible ?
> We've seen so many em28xx devices (some of them beeing much more
> complex) and none of them has used two busses so far.
> Strange...

Most devices nowadays have 2 i2c buses. TV boards typically uses an
I2C switch on them. The rationale is to avoid receiving signal
interference. Some newer em28xx devices have more than one bus, although,
on TV chipsets, this is controlled via one register, that commands
bus switch:

	/* em28xx I2C Clock Register (0x06) */
	#define EM2874_I2C_SECONDARY_BUS_SELECT	0x04 /* em2874 has two i2c busses */

On those devices (em2874/em2875, afaikt), hardware manufacturers put
the TV tuner and demod at the second bus, keeping the first bus 
for remote controller and eeprom.

You'll see several supported devices using the secondary bus for TV and
demod. As, currently, the TV eeprom is not read on those devices, nobody
cared enough to add a separate I2C bus code for it, as all access used
by the driver happen just on the second bus.

>> A proper mapping for it to use ov2640 driver is to create two i2c
>> buses, one used by eeprom access, and another one for sensor.
> 
> Sure.
> 
>>
>>> Interestingly, the standard I2C reads are used, too, for reading the
>>> EEPROM. So maybe there is a "physical" difference.
>>>
>>> "Proprietary" is probably not the best name, but I don't have e better
>>> one at the moment (suggestions ?).
>> It is just another bus: instead of using req 3/4 for read/write, it uses
>> req 6 for both reads/writes at the i2c-like sensor bus.
>>
>>>>>> - uses 16bit eeprom
>>>>>> - em25xx-eeprom with different layout
>>>> There are other supported chips with 16bit eeproms. Currently,
>>>> support for 16bit eeproms is disabled just because this weren't
>>>> needed so far, but I'm sure this is a need there.
>>> Yes, I've read the comment in em28xx_i2c_eeprom():
>>> "...there is the risk that we could corrupt the eeprom (since a 16-bit
>>> read call is interpreted as a write call by 8-bit eeproms)..."
>>> How can we know if a device uses an 8bit or 16bit EEPROM ? Can we derive
>>> that from the uses em27xx/28xx-chip ?
>> I don't know any other way to check it than to read the chip ID, at register
>> 0x0a. Those are the chip ID's that we currently know:
>>
>> enum em28xx_chip_id {
>> 	CHIP_ID_EM2800 = 7,
>> 	CHIP_ID_EM2710 = 17,
>> 	CHIP_ID_EM2820 = 18,	/* Also used by some em2710 */
>> 	CHIP_ID_EM2840 = 20,
>> 	CHIP_ID_EM2750 = 33,
>> 	CHIP_ID_EM2860 = 34,
>> 	CHIP_ID_EM2870 = 35,
>> 	CHIP_ID_EM2883 = 36,
>> 	CHIP_ID_EM2874 = 65,
>> 	CHIP_ID_EM2884 = 68,
>> 	CHIP_ID_EM28174 = 113,
>> };
>>
>> Even if we add it as a separate driver, it is likely wise to re-use the
>> registers description at drivers/media/usb/em28xx/em28xx-reg.h, moving it
>> to drivers/include/media, as em2765 likely uses the same registers. 
>> It also makes sense to add a chip detection at the existing driver, 
>> for it to bail out if it detects an em2765 (and the reverse on the new
>> driver).
> 
> em2765 has chip-id 0x36 = 54.
> Do you want me to send a patch ?

Yes, please send it when you'll be ready for driver submission.

> Do you really think the em28xx driver should always bail out when it
> detects the em2765 ?

Well, having 2 drivers for the same chipset is a very bad idea. Either
one should use it.

Another option would be to have a generic em28xx dispatcher driver
that would handle all of them, probe the board, and then starting
either one, depending if the driver is webcam or not.

Btw, this is on my TODO list (with low priority), as there are several
devices that have only DVB. So, it makes sense to split the analog
TV driver, just like we did with the DVB and alsa drivers. This way,
an em28xx core driver will contain only the probe and the core functions
like i2c and the common helper functions, while all the rest would be
on separate drivers.

IMO, doing that that could be better than coding em2765 as a
completely separate driver.

It shouldn't be hard to split the code like that: most of the TV-specific
code is already under em28xx-video. There are still some stuff under
em28xx-core that could likely be moved into em28xx-video as well, as
the code is specific for TV.

The probing code, plus the card descriptions is at em28xx-cards. Some
code there, under em28xx_init_dev() are due to analog init. Moving it
into em28xx-video and adding there a code like the one at the end of
em28xx-dvb - the calls for em28xx_(un)register_extension() - should
be enough for em28xx-video to be an independent module, that would be
loaded by the core driver only if the device has analog TV.

If you want, please feel free to take this way, working on the
existing em28xx code to split it like that.

>>> Anyway, this problem is common to both solutions (gspca or em28xx-driver).
>> As eeprom reading is I2C, it could make some sense to use a generic driver
>> for reading its contents, removing the code from em28xx-i2c logic, and
>> re-using it on both drivers (assuming that we fork it).
> 
> Yes, I think that would be a good idea.
> 
>>>>>> - sensor OV2640
>>>> There is a driver for it at:
>>>> 	drivers/media/i2c/soc_camera/ov2640.c
>>>>
>>>> The better is to use it (even if this got mapped via gspca).
>>> Yes, I know. This is already on my ToDo list.
>>>
>>>>>> - different frame processing
>>>>>> - 3 buttons (snapshot, mute, light) which need special treatment
>>>>>> (GPIO-polling, status-reseting, ...)
>>>> Need to see the code to better understand that.
>>> Take a look at the patch.
>>>
>>> http://www.spinics.net/lists/linux-media/msg52084.html
>> Ok, let's do it via gspca, but please map both the standard I2C and 
>> the "SCCB" bus via the I2C API, and use the existing ov2640 driver.
> 
> Wow, that was a fast decision. ;)
> Could you please elaborate a bit more on that ?
> How are we going to handle em27xx/em28xx webcams in the future ?
> Only add THIS device via gspca ?
> Put all em2765 based webcams to a gspca driver ?
> Put all new devices to gspca ?
> Or move all webcams to gspca ?

The better is to move all webcams to the new code. I suspect, however, that
this can only happen if we keep just one probing code for all em28xx devices.

If you can work like that, I can certainly test the em2750 cameras I
have here (and fix, if needed).

>>> I've sent it to the list 3 minutes after I started this thread and also
>>> CC'ed you.
>>>
>>>
>>>>>> Another important point to mention: you can see from the USB-logs
>>>>>> (sensor probing) that there must be at least 3 other webcam devices.
>>>> What do you mean?
>>> The Windows driver probes 3 other sensor addresses (using the same
>>> "proprietary" reads). I've included them in my patch.
>>> The INF-file does not contain any other USB IDs, but I think it is
>>> unlikely that they are used by this device.
>>> SpeedLink spent different USB IDs even for identical devices with
>>> different body colors, so I think they would have done they same for
>>> variants with different sensors.
>>> It is more likely that the Windows driver is a kind of universal em2765
>>> driver.
>> With means that we'll sooner or later get some devices with other sensors.
> 
> I'm pretty sure about that. Two of them are:
> eb1a:2711    V-Gear TalkCamPro

This USB ID is a generic EmpiaTech ID. That means that those cameras don't
have any eeprom. I'm sure you'll find other devices with different
sensors sharing this very same USB ID, and maybe even some grabber devices.

> 1ae7:2001    SpeedLink Snappy Microphone
> 
>> So, it is better to be prepared for that, by exposing the sensor bus via I2C.
>>
>> I don't see any need to probe those other sensors right now: we should do it
>> only if we actually get one of those other devices in hands.
> 
> Ok. Probing the other 3 addresses doesn't hurt, and the idea behind is,
> that it easier for people to add support for new devices.
> The first thing they usually do is to add their USB-ID to the driver and
> see what happens. With a bit luck, dmesg the shows something like
> "unknown sensor detetced at address xy" or even "unknown Omnivison
> sensor detected at address xy", which is (hopefully) encouraging... ;)
> But if you want me to not probe them, I will disable them (I'm sure you
> agree that we should keep the addresses in the code, at least as comments).

If the sensor is Omnivision/Micron, its model typically can be identified
by reading the contents of sensor register 0. The code under em28xx_hint_sensor()
does that (it currently assumes a sensor at I2C address 0x5d). So, trying
to read from address 0, on the possible sensor addresses may help to
identify what sensor was used.

>>>>>> Some pros and cons for both solutions:
>>>>>>
>>>>>> em28xx:
>>>>>> + one driver for all 25xx/26xx/27xx/28xx devices
>>>>>> + no duplicate code (bridge register defines, bridge read/write fcns)
>>>>>> + other devices COULD benefit from the new functions/code
>>>>>> - big task/lots of work
>>>>>> - code gets bloated with stuff, which is only needed by a few special
>>>>>> devices
>>>> It all depends on what's needed ;)
>>>>
>>>>>> gspca:
>>>>>> + driver already exists (see patch)
>>>> Which patch?
>>> See above.
>>>
>>>>>> + default driver for webcams
>>>>>> + much easier to understand and extend
>>>>>> + same or even less amount of new code lines
>>>>>> + keeps em28xx-code "simple"
>>>>>> - code duplication
>>>>>> - support for em28xx-webcams spread over to 2 different drivers
>>>> The spread of em27xx support on 2 different drivers can lead into
>>>> problems for the users to know what driver implements support for
>>>> their device.
>>> Ok, but that's what dmesg is for, isn't it ?
>>> And people willing to add support for a new device have to contact the
>>> linux-media ML anyway.
>> Well, if the driver's probe can handle it and return -ENODEV if it doesn't
>> mach a device it could work with, then we might not have much issues.
>>
>>> Btw: there is another "non-technical" argument for a gspca subdriver:
>>> For the remaining unsupported em2xxx webcams, we probably depend on
>>> people doing reverse-engineering of their device. People which might not
>>> be that skilled (like me ;-) ).
>>> A gspca subdriver is MUCH easier to understand and to modify, than the
>>> em28xx-driver. I really tried and I think I didn't give up to early, but...
>>>
>>>> So, if we're going to do that, then the better is to move support
>>>> for all em27xx devices out of em28xx driver, but I think that this
>>>> will end by creating duplicated stuff.
>>> You are probably right.
>>> I don't like the idea of having two different drivers for the same
>>> webcam family, but I think separate drivers for webcams and TV-devices
>>> would be ok.
>> Yeah, sure.
>>
>>> Concerning code duplication: I think it isn't too much. We should also
>>> take the total number of code lines into account. For example, we could
>>> get rid of field is_webcam in the em28xx device struct, which saves some
>>> lines of code.
>>> But form your own opinion by comparing the code.
>>>
>>>> Btw, how is audio with your em2765 device? Is it provided via
>>>> snd-usb-audio, or does it require some code like the one inside
>>>> em28xx?
>>> It works out of the box with snd-usb-audio.
>>> But, of course, at least in theory, there could be webcams requiring the
>>> special code.
>>> I'm not sure how likely that is, given that the audio part of webcam is
>>> just a microphone.
>> Empia has 2 "families" of chips: one with standard audio class and another
>> one with proprietary audio class. I won't doubt that there is some variant
>> of em2765 with proprietary audio class. If so, we may need to add some
>> logic at the gspca driver, in order to load and bind the em28xx-alsa
>> module.
> Ok.
> Have you seen any devices with both interfaces so far ?

AFAIK, it is either one or the other.

>>
>> That's one extra reason for trying to keep at least some common headers
>> accessed by both drivers.
> 
> Definitely. Using a common header for the bridge registers for both
> drivers is one of things on my ToDo list.
> Btw, what's the right place to put this header file ?
> 
>>
>>>>>> I have no strong opinion whether support for this device should finally
>>>>>> be added to em28xx or gspca and
>>>>>> I'm willing to continue working on both solutions as much as my time
>>>>>> permits and as long as I'm having fun (I'm doing this as a hobby !).
>>>>>> Anyway, the em28xx driver is very complex and I really think it would
>>>>>> take several further kernel releases to get the job done...
>>>>>> I would also be willing to spend some time for moving the em28xx-webcam
>>>>>> code to a gspca subdriver, but I don't have any of these devices for
>>>>>> testing.
>>>>>>
>>>>>> What do you think ?
>>>>> I think given the special way this camera uses the bridge (not using
>>>>> standard i2c interface, weird button layout, etc.). That it is likely server
>>>>> better by a specialized driver. As the (new) gspca maintainer I'm fine with
>>>>> taking it as a gspca sub-driver, but given the code duplication issue,
>>>>> that is a call Mauro should make.
>>>>>
>>>>> Note that luckily these devices do use a unique USB id and not one of the
>>>>> generic em28xx ids so from that pov having a specialized driver for them
>>>>> is not an issue.
>>>> Hans,
>>>>
>>>> Not sure if all em2765 cameras will have unique USB id's: at em28xx,
>>>> the known em2710/em2750 cameras that don't have unique ID's; detecting
>>>> between them requires to probe for the type of sensor.
>>> Hmmm... I'm aware of non-unique-id problem, but is it really possible
>>> that an ID is used for a webcam and a for example a DVB-T-device ?
>> There are some USB ID's at em28xx that are used by both grabber devices and
>> webcams.
> 
> Great. :(
> 
> Regards,
> Frank
> 
>>
>> Regards,
>> Mauro
> 

