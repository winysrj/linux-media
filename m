Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62692 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab2LOM5E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 07:57:04 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so2428068eek.19
        for <linux-media@vger.kernel.org>; Sat, 15 Dec 2012 04:57:02 -0800 (PST)
Message-ID: <50CC73AA.40106@googlemail.com>
Date: Sat, 15 Dec 2012 13:57:14 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 2/5] em28xx: respect the message size constraints for
 i2c transfers
References: <1355502533-25636-1-git-send-email-fschaefer.oss@googlemail.com> <1355502533-25636-3-git-send-email-fschaefer.oss@googlemail.com> <50CB5A0A.3030305@iki.fi>
In-Reply-To: <50CB5A0A.3030305@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 14.12.2012 17:55, schrieb Antti Palosaari:
> On 12/14/2012 06:28 PM, Frank Schäfer wrote:
>> The em2800 can transfer up to 4 bytes per i2c message.
>> All other em25xx/em27xx/28xx chips can transfer at least 64 bytes per
>> message.
>>
>> I2C adapters should never split messages transferred via the I2C
>> subsystem
>> into multiple message transfers, because the result will almost
>> always NOT be
>> the same as when the whole data is transferred to the I2C client in a
>> single
>> message.
>> If the message size exceeds the capabilities of the I2C adapter,
>> -EOPNOTSUPP
>> should be returned.
>>
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>
>
>> +    if (len < 1 || len > 4)
>> +        return -EOPNOTSUPP;
>
> That patch seem to be good for my eyes, but that check for len < 1 is
> something I would like to double checked. Generally len = 0 is OK and
> is used some cases, probing and sometimes when all registers are read
> for example.
>
> Did you test it returns some error for zero len messages?
>

First of all: thank you for reviewing the patch !

Yeah, messages with zero length could be used for device detection.
But yes, I checked that and it doesn't work.

For the em2800 algorithm, it doesn't work because of the way the mesage
length is encoded in the first two bytes of register 0x05:

118                buf2[1] = 0x84 + len - 1;

Bit 2 is used for read/write, that's why it is

67                b2[5] = 0x80 + len - 1;

for writes.


The more interesting case is the em28xx i2c algorithm...
But zero length messages don't work there, too (at least not with the
em2765 and em2820).
To be more precise: they SEEM to work, but they don't. Even when there
is no i2c device, you get no error (neither from the USB subsystem, nor
from the bridge status register).

Regards,
Frank


