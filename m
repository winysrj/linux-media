Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48133 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbaBISdP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Feb 2014 13:33:15 -0500
Received: by mail-ee0-f46.google.com with SMTP id c13so2496425eek.19
        for <linux-media@vger.kernel.org>; Sun, 09 Feb 2014 10:33:14 -0800 (PST)
Message-ID: <52F7CA40.2010106@googlemail.com>
Date: Sun, 09 Feb 2014 19:34:40 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: m.chehab@samsung.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] em28xx-i2c: do not map -ENXIO errors to -ENODEV for
 empty i2c transfers
References: <1390168117-2925-1-git-send-email-fschaefer.oss@googlemail.com> <1390168117-2925-4-git-send-email-fschaefer.oss@googlemail.com> <20140204164734.62354b70@samsung.com>
In-Reply-To: <20140204164734.62354b70@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 04.02.2014 19:47, schrieb Mauro Carvalho Chehab:
> Em Sun, 19 Jan 2014 22:48:36 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Commit e63b009d6e "" changed the error codes i2c ACK errors from -ENODEV to -ENXIO.
>> But it also introduced a line that maps -ENXIO back to -ENODEV in case of empty i2c
>> messages, which makes no sense, because
>> 1.) an ACK error is an ACK error no matter what the i2c message content is
>> 2.) -ENXIO is perfectly suited for probing, too
> I don't agree with this patch. 0-byte messages are only usin during device
> probe.
???

The error handling is inconsistent for no good reason.

The old code always returned -ENODEV.
Then you came to the conclusion that -ENODEV isn't good and we both
agreed that -ENXIO is appropriate.
But then you decided to keep -ENODEV for 0-Byte messages only.
Why ?
According to the i2c error code description, -ENXIO and -ENODEV are both
suited for probing.
AFAICS there are zero reasons for returning different error codes in
case of the same i2c ack error.
So please, either -ENODEV or -ENXIO instead of such inconsistencies.

>> 3.) we are loosing the ability to distinguish USB device disconnects
> Huh?
Maybe (like me) you didn't notice that before.
This is probably the most cogent argument for changing -ENODEV to -ENXIO
for i2c ack errors in case of USB devices. ;-)

Regards,
Frank

>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>> ---
>>  drivers/media/usb/em28xx/em28xx-i2c.c |    1 -
>>  1 Datei geändert, 1 Zeile entfernt(-)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
>> index ba6433c..a26d7d4 100644
>> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
>> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
>> @@ -539,7 +539,6 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
>>  				if (rc == -ENXIO) {
>>  					if (i2c_debug > 1)
>>  						printk(KERN_CONT " no device\n");
>> -					rc = -ENODEV;
>>  				} else {
>>  					if (i2c_debug > 1)
>>  						printk(KERN_CONT " ERROR: %i\n", rc);

