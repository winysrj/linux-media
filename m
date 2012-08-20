Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab2HTTVh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 15:21:37 -0400
Message-ID: <50328E22.4090805@redhat.com>
Date: Mon, 20 Aug 2012 16:21:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: How to add support for the em2765 webcam Speedlink VAD Laplace
 to the kernel ?
References: <5032225A.9080305@googlemail.com> <50323559.7040107@redhat.com>
In-Reply-To: <50323559.7040107@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-08-2012 10:02, Hans de Goede escreveu:
> Hi,
> 
> On 08/20/2012 01:41 PM, Frank Schäfer wrote:
>> Hi,
>>
>> after a break of 2 1/2 kernel releases (sorry, I was busy with another
>> project), I would like to bring up again the question how to add support
>> for this device to the kernel.
>> See
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg44417.html
>> ("Move em27xx/em28xx webcams to a gspca subdriver ?") for the previous
>> discussion.
>>
>> Current status is, that I've reverse-engineered the Windows driver and
>> written a new gspca-subdriver for testing, which is feature complete and
>> working stable (will send a patch shortly !).
>>
>> The device uses an em2765-bridge, so my first idea was of course to
>> modify/extend the em28xx-driver.
>> But during the reverse-engineering-process, it turned out that writing a
>> new gspca-subdriver was much easier than modifying the em28xx-driver.
>>
>> The device has the following special characteristics:
>> - supports only bulk transfers (em28xx driver supports ISOC only)

Em28xx driver supports both isoc and bulk transfers, as bulk is
required by DVB.

>> - uses "proprietary" read/write procedures for the sensor

Sure about that? It doesn't use I2C?

>> - uses 16bit eeprom
>> - em25xx-eeprom with different layout

There are other supported chips with 16bit eeproms. Currently,
support for 16bit eeproms is disabled just because this weren't
needed so far, but I'm sure this is a need there.

>> - sensor OV2640

There is a driver for it at:
	drivers/media/i2c/soc_camera/ov2640.c

The better is to use it (even if this got mapped via gspca).

>> - different frame processing
>> - 3 buttons (snapshot, mute, light) which need special treatment
>> (GPIO-polling, status-reseting, ...)

Need to see the code to better understand that.

>>
>> Another important point to mention: you can see from the USB-logs
>> (sensor probing) that there must be at least 3 other webcam devices.

What do you mean?

>>
>> Some pros and cons for both solutions:
>>
>> em28xx:
>> + one driver for all 25xx/26xx/27xx/28xx devices
>> + no duplicate code (bridge register defines, bridge read/write fcns)
>> + other devices COULD benefit from the new functions/code
>> - big task/lots of work
>> - code gets bloated with stuff, which is only needed by a few special
>> devices

It all depends on what's needed ;)

>>
>> gspca:
>> + driver already exists (see patch)

Which patch?

>> + default driver for webcams
>> + much easier to understand and extend
>> + same or even less amount of new code lines
>> + keeps em28xx-code "simple"
>> - code duplication
>> - support for em28xx-webcams spread over to 2 different drivers

The spread of em27xx support on 2 different drivers can lead into
problems for the users to know what driver implements support for
their device.

So, if we're going to do that, then the better is to move support
for all em27xx devices out of em28xx driver, but I think that this
will end by creating duplicated stuff.

Btw, how is audio with your em2765 device? Is it provided via
snd-usb-audio, or does it require some code like the one inside
em28xx?

>> I have no strong opinion whether support for this device should finally
>> be added to em28xx or gspca and
>> I'm willing to continue working on both solutions as much as my time
>> permits and as long as I'm having fun (I'm doing this as a hobby !).
>> Anyway, the em28xx driver is very complex and I really think it would
>> take several further kernel releases to get the job done...
>> I would also be willing to spend some time for moving the em28xx-webcam
>> code to a gspca subdriver, but I don't have any of these devices for
>> testing.
>>
>> What do you think ?
> 
> I think given the special way this camera uses the bridge (not using
> standard i2c interface, weird button layout, etc.). That it is likely server
> better by a specialized driver. As the (new) gspca maintainer I'm fine with
> taking it as a gspca sub-driver, but given the code duplication issue,
> that is a call Mauro should make.
> 
> Note that luckily these devices do use a unique USB id and not one of the
> generic em28xx ids so from that pov having a specialized driver for them
> is not an issue.

Hans,

Not sure if all em2765 cameras will have unique USB id's: at em28xx,
the known em2710/em2750 cameras that don't have unique ID's; detecting
between them requires to probe for the type of sensor.

Regards,
Mauro
