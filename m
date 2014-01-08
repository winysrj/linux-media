Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:50482 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaAHTgY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 14:36:24 -0500
Received: by mail-ee0-f49.google.com with SMTP id c41so882299eek.22
        for <linux-media@vger.kernel.org>; Wed, 08 Jan 2014 11:36:23 -0800 (PST)
Message-ID: <52CDA8FC.4060602@googlemail.com>
Date: Wed, 08 Jan 2014 20:37:32 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 17/22] [media] em28xx-i2c: Fix error code for I2C error
 transfers
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com> <1388832951-11195-18-git-send-email-m.chehab@samsung.com> <52C9C346.6040602@googlemail.com> <20140106075515.645ed96c@samsung.com> <52CC394D.3040700@googlemail.com> <20140108095543.1b9d0ba2@samsung.com>
In-Reply-To: <20140108095543.1b9d0ba2@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 08.01.2014 12:55, schrieb Mauro Carvalho Chehab:
> Em Tue, 07 Jan 2014 18:28:45 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
...
>
>> But we also get this when a slave device isn't present or doesn't
>> answer, which means it doesn't ACK the data.
>> So ETIMEDOUT is wrong.
> It is still a timeout: the device didn't answer in time.
Ok, it's a 1 clock cycle timeout. :D :D :D

>
>> Yes, 0x10 _could_ be a more general error. In that case EIO would be the
>> better choice.
>> But that's pure speculation as long as we don't have the datasheets.
> The datasheet will not tell what are the corresponding Linux error codes.
Sure, we have to map the errors on our own.
But the datasheet should tell us for which error condition the bridge
returns which i2c state.

> ETIMEDOUT is better than the generic unspecific EIO.
The bridge should also be able to detect when something is fundamentally
wrong with SCL/SDA lines (bus not ready).
That's why I wouldn't return ETIMEDOUT for error codes we haven't seen
so far.
ETIMEDOUT for a clock stretching timeout (0x02 or 0x04) is of course right.

>
>> After reading the i2c fault codes descriptions again, I would agree to
>> change it from ENODEV to ENXIO.
>> ENXIO seems to be the intended error code for NACK errors and it's a bit
>> more unspecific than ENODEV.
>>
>> Would that be acceptable for you ?
> Yes.
Ok. fine, then let's use ENXIO for 0x10.

>
>>> 	- ENXIO - when the device is not temporarily not responding
>>> 		  (e. g. reg 05 returning something not 0x10 or 0x00)
>> For those I would return just EIO.
>> I thought we agree here ?
> No. With em28xx/xc3028/tvp5150, we've got some temporary not responding
> errors with return code 0x02 or 0x04, before fixing that xc3028 power down
> bug.
>
> What I suspect is that codes 0x02 and 0x04 are related to I2C stretching,
> and that's why they need to be retried up to a software given timeout.
Yeah, that's very likely.
ETIMEDOUT is ok for a clock stretching timeout, but I wonder why there
should be two of them. Can we narrow that down further ?
If you are looping over reg 0x05 only (not the whole procedure) after a
write for a very long time, which of these two states are temporary and
which never change ?
My theory would be, that one of them is temporary and means "busy,
client holds down SCL" and the other one is final and means "bridge gave
up waiting for the client to continue" (internal timeout).

> I prefer to use EIO only when we got an error while writing to reg 0x04
> or when the read operation didn't return the number of requested bytes.
The register read/write functions currently return the following error
codes:

device disconnected from USB port: -ENODEV
len > URB_MAX_CTRL_SIZE: -EINVAL (Btw, this one should probably should
be changed to a more appropriate error code)

or the error codes from the USB transfer, filtered/maopped with
usb_translate_errors():
-ENOMEM
-ENODEV
-EOPNOTSUPP
-EIO

I'm not sure if it is necessary to filter/map them further.
With the exeception of -EINVAL, they could probably be passed to to the
i2c client, too.
OTOH I doubt than any i2c client implements such a detailed error
handling. ;)
I have no objections against just returning EIO.

Regards,
Frank


