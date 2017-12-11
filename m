Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:35074 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751234AbdLKVRy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 16:17:54 -0500
MIME-Version: 1.0
In-Reply-To: <1513020868.3036.0.camel@perches.com>
References: <20171211120612.3775893-1-arnd@arndb.de> <1513020868.3036.0.camel@perches.com>
From: Michael Ira Krufky <mkrufky@linuxtv.org>
Date: Mon, 11 Dec 2017 16:17:52 -0500
Message-ID: <CAOcJUbyARps1CeRFvLau3w-rBvn2QLbsY2PHGymbpUyuFCJ2HA@mail.gmail.com>
Subject: Re: [PATCH] tuners: tda8290: reduce stack usage with kasan
To: Joe Perches <joe@perches.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 11, 2017 at 2:34 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2017-12-11 at 13:06 +0100, Arnd Bergmann wrote:
>> With CONFIG_KASAN enabled, we get a relatively large stack frame in one function
>>
>> drivers/media/tuners/tda8290.c: In function 'tda8290_set_params':
>> drivers/media/tuners/tda8290.c:310:1: warning: the frame size of 1520 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>>
>> With CONFIG_KASAN_EXTRA this goes up to
>>
>> drivers/media/tuners/tda8290.c: In function 'tda8290_set_params':
>> drivers/media/tuners/tda8290.c:310:1: error: the frame size of 3200 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
>>
>> We can significantly reduce this by marking local arrays as 'static const', and
>> this should result in better compiled code for everyone.
> []
>> diff --git a/drivers/media/tuners/tda8290.c b/drivers/media/tuners/tda8290.c
> []
>> @@ -63,8 +63,8 @@ static int tda8290_i2c_bridge(struct dvb_frontend *fe, int close)
>>  {
>>       struct tda8290_priv *priv = fe->analog_demod_priv;
>>
>> -     unsigned char  enable[2] = { 0x21, 0xC0 };
>> -     unsigned char disable[2] = { 0x21, 0x00 };
>> +     static unsigned char  enable[2] = { 0x21, 0xC0 };
>> +     static unsigned char disable[2] = { 0x21, 0x00 };
>
> Doesn't match commit message.
>
> static const or just static?
>
>> @@ -84,9 +84,9 @@ static int tda8295_i2c_bridge(struct dvb_frontend *fe, int close)
>>  {
>>       struct tda8290_priv *priv = fe->analog_demod_priv;
>>
>> -     unsigned char  enable[2] = { 0x45, 0xc1 };
>> -     unsigned char disable[2] = { 0x46, 0x00 };
>> -     unsigned char buf[3] = { 0x45, 0x01, 0x00 };
>> +     static unsigned char  enable[2] = { 0x45, 0xc1 };
>> +     static unsigned char disable[2] = { 0x46, 0x00 };
>
> etc.
>
>


Joe is correct - they can be CONSTified. My bad -- a lot of the code I
wrote many years ago has this problem -- I wasn't so stack-conscious
back then.

The bytes in `enable` / `disable` don't get changed, but they may be
copied to another byte array that does get changed.  If would be best
to make these `static const`

Best regards,

Michael Ira Krufky
