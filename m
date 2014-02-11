Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38482 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbaBKXvO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 18:51:14 -0500
Message-ID: <52FAB76E.3040001@iki.fi>
Date: Wed, 12 Feb 2014 01:51:10 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	m.chehab@samsung.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] em28xx-i2c: do not map -ENXIO errors to -ENODEV for
 empty i2c transfers
References: <1390168117-2925-1-git-send-email-fschaefer.oss@googlemail.com> <1390168117-2925-4-git-send-email-fschaefer.oss@googlemail.com> <20140204164734.62354b70@samsung.com> <52F7CA40.2010106@googlemail.com>
In-Reply-To: <52F7CA40.2010106@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09.02.2014 20:34, Frank Schäfer wrote:
>
> Am 04.02.2014 19:47, schrieb Mauro Carvalho Chehab:
>> Em Sun, 19 Jan 2014 22:48:36 +0100
>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>
>>> Commit e63b009d6e "" changed the error codes i2c ACK errors from -ENODEV to -ENXIO.
>>> But it also introduced a line that maps -ENXIO back to -ENODEV in case of empty i2c
>>> messages, which makes no sense, because
>>> 1.) an ACK error is an ACK error no matter what the i2c message content is
>>> 2.) -ENXIO is perfectly suited for probing, too
>> I don't agree with this patch. 0-byte messages are only usin during device
>> probe.
> ???
>
> The error handling is inconsistent for no good reason.
>
> The old code always returned -ENODEV.
> Then you came to the conclusion that -ENODEV isn't good and we both
> agreed that -ENXIO is appropriate.
> But then you decided to keep -ENODEV for 0-Byte messages only.
> Why ?
> According to the i2c error code description, -ENXIO and -ENODEV are both
> suited for probing.
> AFAICS there are zero reasons for returning different error codes in
> case of the same i2c ack error.
> So please, either -ENODEV or -ENXIO instead of such inconsistencies.
>
>>> 3.) we are loosing the ability to distinguish USB device disconnects
>> Huh?
> Maybe (like me) you didn't notice that before.
> This is probably the most cogent argument for changing -ENODEV to -ENXIO
> for i2c ack errors in case of USB devices. ;-)

I looked the I2C spec and there seems to be *not* restriction I2C 
message len, nor any mention zero len is not valid. If that is the case, 
adapter should just do the zero len xfer if requested and return success 
if it is success (slave answers).

If adapter does not support zero len messages it should return 
EOPNOTSUPP according to kernel i2c fault codes document. I think em28xx 
supports, so that is not case here.

I think Frank is correct.

I2C spec is here:
http://www.nxp.com/documents/user_manual/UM10204.pdf

Hope this helps.

regards
Antti

-- 
http://palosaari.fi/
