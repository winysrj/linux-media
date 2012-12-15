Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33907 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab2LONBB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 08:01:01 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so2133880bkw.19
        for <linux-media@vger.kernel.org>; Sat, 15 Dec 2012 05:01:00 -0800 (PST)
Message-ID: <50CC7499.8020507@googlemail.com>
Date: Sat, 15 Dec 2012 14:01:13 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 5/5] em28xx: fix+improve+unify i2c error handling, debug
 messages and code comments
References: <1355502533-25636-1-git-send-email-fschaefer.oss@googlemail.com> <1355502533-25636-6-git-send-email-fschaefer.oss@googlemail.com> <50CB5BF8.5070201@iki.fi>
In-Reply-To: <50CB5BF8.5070201@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 14.12.2012 18:03, schrieb Antti Palosaari:
> On 12/14/2012 06:28 PM, Frank Schäfer wrote:
>> - check i2c slave address range (only 7 bit addresses supported)
>> - do not pass USB specific error codes to userspace/i2c-subsystem
>> - unify the returned error codes and make them compliant with
>>    the i2c subsystem spec
>> - check number of actually transferred bytes (via USB) everywehere
>> - fix/improve debug messages
>> - improve code comments
>>
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>
>
>> @@ -244,16 +294,20 @@ static int em28xx_i2c_xfer(struct i2c_adapter
>> *i2c_adap,
>>           dprintk2(2, "%s %s addr=%x len=%d:",
>>                (msgs[i].flags & I2C_M_RD) ? "read" : "write",
>>                i == num - 1 ? "stop" : "nonstop", addr, msgs[i].len);
>> +        if (addr > 0xff) {
>> +            dprintk2(2, " ERROR: 10 bit addresses not supported\n");
>> +            return -EOPNOTSUPP;
>> +        }
>
> There is own flag for 10bit I2C address. Use it (and likely not
> compare at all addr validly like that). This kind of address
> validation check is quite unnecessary - and after all if it is wanted
> then correct place is somewhere in I2C routines.

Well, to be 100% sure and strict, we should check both, the flag and the
actual address.
We support 7 bit addresses only, no matter which i2c algo is used. So
doing the address check in each i2c routine seems to be unnecessary code
duplication to me ?

BTW: with the em28xx algorithm, the i2c address is transferred as 16 bit
value. So 10 bit addresses COULD work in theory... ;)

Regards,
Frank
