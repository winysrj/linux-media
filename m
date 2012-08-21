Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63947 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab2HULfa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 07:35:30 -0400
Received: by bkwj10 with SMTP id j10so2150359bkw.19
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2012 04:35:29 -0700 (PDT)
Message-ID: <50337293.8050808@googlemail.com>
Date: Tue, 21 Aug 2012 13:35:47 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, hdegoede@redhat.com,
	mchehab@infradead.org
Subject: Re: How to add support for the em2765 webcam Speedlink VAD Laplace
 to the kernel ?
References: <5032225A.9080305@googlemail.com> <50323559.7040107@redhat.com> <50328E22.4090805@redhat.com>
In-Reply-To: <50328E22.4090805@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 20.08.2012 21:21, schrieb Mauro Carvalho Chehab:
> Em 20-08-2012 10:02, Hans de Goede escreveu:
>> Hi,
>>
>> On 08/20/2012 01:41 PM, Frank Schäfer wrote:
>>> Hi,
>>>
>>> after a break of 2 1/2 kernel releases (sorry, I was busy with another
>>> project), I would like to bring up again the question how to add support
>>> for this device to the kernel.
>>> See
>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg44417.html
>>> ("Move em27xx/em28xx webcams to a gspca subdriver ?") for the previous
>>> discussion.
>>>
>>> Current status is, that I've reverse-engineered the Windows driver and
>>> written a new gspca-subdriver for testing, which is feature complete and
>>> working stable (will send a patch shortly !).
>>>
>>> The device uses an em2765-bridge, so my first idea was of course to
>>> modify/extend the em28xx-driver.
>>> But during the reverse-engineering-process, it turned out that writing a
>>> new gspca-subdriver was much easier than modifying the em28xx-driver.
>>>
>>> The device has the following special characteristics:
>>> - supports only bulk transfers (em28xx driver supports ISOC only)
> Em28xx driver supports both isoc and bulk transfers, as bulk is
> required by DVB.

Hmm... are you 100% sure ? Must have been added recently then...

I did a quick check of the current code, but can't find anything. Could
you please give me a pointer to the code parts ?
Btw, if I'm not understanding the code wrong, em28xx_usb_probe() still
seems to return -ENODEV if no isoc-in endpoint is found, so bulk-ep-only
devices should not work...


>
>>> - uses "proprietary" read/write procedures for the sensor
> Sure about that? It doesn't use I2C?

According to the datasheet of the OV2640 it should be SCCB.

Anyway, I'm referring to how communication works on the USB level.
Take a look at http://linuxtv.org/wiki/index.php/VAD_Laplace section
"Reverse Engineering (evaluation of USB-logs)" to see how it is working.

Interestingly, the standard I2C reads are used, too, for reading the
EEPROM. So maybe there is a "physical" difference.

"Proprietary" is probably not the best name, but I don't have e better
one at the moment (suggestions ?).


>>> - uses 16bit eeprom
>>> - em25xx-eeprom with different layout
> There are other supported chips with 16bit eeproms. Currently,
> support for 16bit eeproms is disabled just because this weren't
> needed so far, but I'm sure this is a need there.

Yes, I've read the comment in em28xx_i2c_eeprom():
"...there is the risk that we could corrupt the eeprom (since a 16-bit
read call is interpreted as a write call by 8-bit eeproms)..."
How can we know if a device uses an 8bit or 16bit EEPROM ? Can we derive
that from the uses em27xx/28xx-chip ?

Anyway, this problem is common to both solutions (gspca or em28xx-driver).

>>> - sensor OV2640
> There is a driver for it at:
> 	drivers/media/i2c/soc_camera/ov2640.c
>
> The better is to use it (even if this got mapped via gspca).

Yes, I know. This is already on my ToDo list.

>>> - different frame processing
>>> - 3 buttons (snapshot, mute, light) which need special treatment
>>> (GPIO-polling, status-reseting, ...)
> Need to see the code to better understand that.

Take a look at the patch.

http://www.spinics.net/lists/linux-media/msg52084.html

I've sent it to the list 3 minutes after I started this thread and also
CC'ed you.


>>> Another important point to mention: you can see from the USB-logs
>>> (sensor probing) that there must be at least 3 other webcam devices.
> What do you mean?

The Windows driver probes 3 other sensor addresses (using the same
"proprietary" reads). I've included them in my patch.
The INF-file does not contain any other USB IDs, but I think it is
unlikely that they are used by this device.
SpeedLink spent different USB IDs even for identical devices with
different body colors, so I think they would have done they same for
variants with different sensors.
It is more likely that the Windows driver is a kind of universal em2765
driver.

>>> Some pros and cons for both solutions:
>>>
>>> em28xx:
>>> + one driver for all 25xx/26xx/27xx/28xx devices
>>> + no duplicate code (bridge register defines, bridge read/write fcns)
>>> + other devices COULD benefit from the new functions/code
>>> - big task/lots of work
>>> - code gets bloated with stuff, which is only needed by a few special
>>> devices
> It all depends on what's needed ;)
>
>>> gspca:
>>> + driver already exists (see patch)
> Which patch?

See above.

>>> + default driver for webcams
>>> + much easier to understand and extend
>>> + same or even less amount of new code lines
>>> + keeps em28xx-code "simple"
>>> - code duplication
>>> - support for em28xx-webcams spread over to 2 different drivers
> The spread of em27xx support on 2 different drivers can lead into
> problems for the users to know what driver implements support for
> their device.

Ok, but that's what dmesg is for, isn't it ?
And people willing to add support for a new device have to contact the
linux-media ML anyway.

Btw: there is another "non-technical" argument for a gspca subdriver:
For the remaining unsupported em2xxx webcams, we probably depend on
people doing reverse-engineering of their device. People which might not
be that skilled (like me ;-) ).
A gspca subdriver is MUCH easier to understand and to modify, than the
em28xx-driver. I really tried and I think I didn't give up to early, but...

> So, if we're going to do that, then the better is to move support
> for all em27xx devices out of em28xx driver, but I think that this
> will end by creating duplicated stuff.

You are probably right.
I don't like the idea of having two different drivers for the same
webcam family, but I think separate drivers for webcams and TV-devices
would be ok.
Concerning code duplication: I think it isn't too much. We should also
take the total number of code lines into account. For example, we could
get rid of field is_webcam in the em28xx device struct, which saves some
lines of code.
But form your own opinion by comparing the code.

> Btw, how is audio with your em2765 device? Is it provided via
> snd-usb-audio, or does it require some code like the one inside
> em28xx?

It works out of the box with snd-usb-audio.
But, of course, at least in theory, there could be webcams requiring the
special code.
I'm not sure how likely that is, given that the audio part of webcam is
just a microphone.

>>> I have no strong opinion whether support for this device should finally
>>> be added to em28xx or gspca and
>>> I'm willing to continue working on both solutions as much as my time
>>> permits and as long as I'm having fun (I'm doing this as a hobby !).
>>> Anyway, the em28xx driver is very complex and I really think it would
>>> take several further kernel releases to get the job done...
>>> I would also be willing to spend some time for moving the em28xx-webcam
>>> code to a gspca subdriver, but I don't have any of these devices for
>>> testing.
>>>
>>> What do you think ?
>> I think given the special way this camera uses the bridge (not using
>> standard i2c interface, weird button layout, etc.). That it is likely server
>> better by a specialized driver. As the (new) gspca maintainer I'm fine with
>> taking it as a gspca sub-driver, but given the code duplication issue,
>> that is a call Mauro should make.
>>
>> Note that luckily these devices do use a unique USB id and not one of the
>> generic em28xx ids so from that pov having a specialized driver for them
>> is not an issue.
> Hans,
>
> Not sure if all em2765 cameras will have unique USB id's: at em28xx,
> the known em2710/em2750 cameras that don't have unique ID's; detecting
> between them requires to probe for the type of sensor.

Hmmm... I'm aware of non-unique-id problem, but is it really possible
that an ID is used for a webcam and a for example a DVB-T-device ?

Regards,
Frank

> Regards,
> Mauro


