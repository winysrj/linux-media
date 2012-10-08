Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48857 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab2JHTpt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 15:45:49 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so2249324bkc.19
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2012 12:45:47 -0700 (PDT)
Message-ID: <50732D5E.4000706@googlemail.com>
Date: Mon, 08 Oct 2012 21:45:34 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: How to add support for the em2765 webcam Speedlink VAD Laplace
 to the kernel ?
References: <5032225A.9080305@googlemail.com> <50323559.7040107@redhat.com> <50328E22.4090805@redhat.com> <50337293.8050808@googlemail.com> <50337FF4.2030200@redhat.com> <5033B177.8060609@googlemail.com> <5033C573.2000304@redhat.com> <50349017.4020204@googlemail.com> <503521B4.6050207@redhat.com> <503A7097.4050709@googlemail.com> <505F16AD.8010909@googlemail.com> <20121006085624.128f7f2c@redhat.com> <5071869E.1090400@googlemail.com> <20121007130848.3f10bf36@infradead.org>
In-Reply-To: <20121007130848.3f10bf36@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 07.10.2012 18:08, schrieb Mauro Carvalho Chehab:

<snip>
>>>>> Ist that correct ?
>>>> Mauro, could you please elaborate your plan ?
>>>> What exactly do you want me to do to get this device supported by the
>>>> kernel ?
>>> Basically, the core em28xx module will have:
>>> 	drivers/media/usb/em28xx/em28xx-cards.c
>>> 	drivers/media/usb/em28xx/em28xx-i2c.c
>>> 	drivers/media/usb/em28xx/em28xx-core.c
>>>
>>> Eventually, part of the functions under em28xx-core could be moved
>>> to em28xx-video, as they would be used just there. For the already
>>> supported em2710/em2750 webcams, we should need to change the logic
>>> there to use the new gspca-em2xxx module, but this change can be
>>> done later.
>>>
>>> The em28xx-alsa module already have:
>>> 	drivers/media/usb/em28xx/em28xx-audio.c
>>> Nothing changes on it.
>>>
>>> The em28xx-dvb module already have:
>>> 	drivers/media/usb/em28xx/em28xx-dvb.c
>>> Nothing changes on it.
>>>
>>> The new em28xx-v4l module will have:
>>> 	drivers/media/usb/em28xx/em28xx-vbi.c
>>> 	drivers/media/usb/em28xx/em28xx-video.c
>>>
>>> The em28xx-rc module already have:
>>> 	drivers/media/usb/em28xx/em28xx-input.c
>>> It makes sense to split it into two separate files, one with just the
>>> remote control stuff, and the other one with the webcam snapshot buttons.
>>>
>>> The file with the webcam buttons support should be merged with the em28xx
>>> gspca module, together with the code you wrote.
>> Ok, but then there is not much left in the gspca driver. ;)
> Yes.
> That's what I said at the beginning of those discussions ;)
>
>> The two main remaining things feature blocks are
>> - USB-bulk-support
>> - data/frame processing
>> and I think it would make sense to have them both in em28xx, too.
> Ok. Well, DVB uses dvb bulk (or, at least, with some variants). So,
> maybe part of the code could be moved to em28xx core, if makes sense.
>
>> I would say that the main reason for a gspca subdriver would be
>> - the different code for i2c bus B (there is still a chance that this is
>> something SpeedLink specific !)
> See cx88: there's one special board that requires a special code for
> a second bus. It was mapped there as a separate driver (see 
> drivers/media/pci/cx88/cx88-vp3054-i2c.c).
>
> It could make sense to put the secondary em28xx I2C bus on a separate
> driver, especially if the code there are really specific for SpeedLink
> (I don't think so, but tests are of course needed).
>
>> - the complicating buttons stuff
>> - the ov2640 code (as long as no sub-module is used for that)
>> which would require adding lots of new code to the em28xx-driver not
>> needed by 95% of the devices.
> Separate drivers for sensors make sense.

In theory, that's the best solution.

>  I would love to split the sensors
> from the gspca drivers. It is still there simply because gspca driver is really
> old, and nobody has all devices supported there. So, changing it for old
> drivers will likely never happen. Newer drivers are doing the same thing
> just because of the inercial movement... developers there just used to not split
> i2c... changing to a new model requires them some time and effort.

The problem is, that many drivers are not written written from scratch
based on a complete datasheet / knowledge of the device.
If that would be the case, everything would be fine.
But for drivers based on reverse-engineering and with incomplete or even
missing hardware specs, the usage of sub-drivers means a time-intensive
and often problematic extra conversion step.
This is also why the gspca-conversion will probably never happen. Even
if we could test all those devices, the amount of work would be enormous
and there will likely always be any "magic register sequences" needed
for one driver but not working with another one.
And forcing a new driver to be converted to using subdrivers before
getting accepted for kernel inclusion can easily result in several
further kernel releases before users get their devices working.

Of course that doesn't mean we should give up the goal ! But we should
also be aware of the drawbacks.
The trick will be to find the right balance between ideology and pragmatism.


Don't get me wrong, I don't want to complain about this special case.
But maybe it's a good example for the problems.
Some people might give up earlier than me... ;)


>
>> The big question is, which devices can we expect to appear in the future ?
> We'll never know that ;)
>
>> I'm pretty sure there are much more cameras (like the mentioned
>> intraoral camera devices fro dentists). 
> Some of the webcams already supported by em28xx driver are intraoral ones.
>
>> As I said before, I can see the
>> Windows driver probing 4 ic2 slave addresses.
>> Tuner i2c clients are also mentioned in the em2580/em2585 datasheet, so
>> these chips could be designed for TV stuff, too (although we haven't
>> seen such a device yet).
> Provided that the vast majority of registers don't change, I'm in favor of
> keeping just one driver. If they end to come with new concepts, a completely
> different register set, etc, then a new driver makes sense.

I agree.
At the moment, it looks like the em25xx uses a subset of the em28xx
registers.
IIRC, there is only a single register (related to audio mute) which the
em28xx driver doesn't know/use yet and I wouldn't wonder if it works
with the em27xx/em28xx, too.

>
>>>> In the mean time I have ported the gspca driver to the ic2 interface,
>>>> which was necessary to experiment with the ov2640 soc-camera driver,
>>> Good!
>> It still needs some issues to be resolved (there seems to be a nice
>> USB-locking issue cause by the interaction with the gspca_main module...).
> Yeah, a locking with gspca will require a new locking schema. We'll need it
> anyway, in order to provide proper locking for cases where the same physical
> device uses more than one independent driver, like:
> 	- snd-usb-audio em28xx;
> 	- IR mce driver and cx231xx;
> 	...
>
> Greg KH once proposed to extend the devres subsystem in order to handle resource
> locking between different drivers. That looked promising, but, unfortunately,
> I got distracted by hundreds of other things, and didn't have any time yet to
> dig into it and write some RFC patches.

Uff... so yet another big point on the todo list. :(
I'm not sure that we can expect the device beeing supported by the
kernel before 2015...

>
>>
>>>
>>>> but also increased the code size enormously.
>>> Why?
>> Additional functions (i2c_xfer, i2c_xfer, ...), structs (i2c_algorithm,
>> i2c_adapter, i2c_client, ...).
>> Also some code duplication is required (e.g. i2c_check_for_device methods)
>> And of course everything times 2 because we have two busses.
> Ok. Well, this is not that big ;)

Last time I checked it were >200 lines of extra code. Cleaning up the
code will reduce this, but not that much.

>
>>>> Unfortunately, lots of changes to the ov2640 driver would be necessary
>>>> use it. It starts with the init sequence and continues with a long
>>>> sequence of sensor register writes at capturing start.
>>>> My hope was, that the differences can be neglected, but unfortunately
>>>> this is not the case.
>>>> Given the amount of work, the fact that most of these registers are
>>>> undocumented and the high risk to break things for other users of the
>>>> driver, I think we should stay with the "custom" code for this webcam at
>>>> least for the moment.
>>> Well, then do a new ov2640 i2c driver. We can later try to merge both, if
>>> we can get enough spec data.
>> I'm not sure we will ever get them.
>> The datasheet we have is already detailed and manufacturers never
>> document everything (even for there customers).
>>
>> I will see what I can do to use the existing driver, but it's definitely
>> a bigger task...
> One thing that you may do is to add a platform_data config option there that
> tells it to behave as expected by em28xx. This is a hack, if we don't know
> exactly what's different, as we generally prefer to pass parameters that enable
> or disable known features. Yet, this is better than duplicating the driver,
> as, by having it altogether, it will be easier to later fix it.

Hmm... might be a good idea.

Regards,
Frank

>
> Regards,
> Mauro

