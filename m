Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:55061 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757998AbaGQXEa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 19:04:30 -0400
Received: by mail-oa0-f41.google.com with SMTP id j17so1861888oag.0
        for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 16:04:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53C85496.8060306@iki.fi>
References: <1405637017-24036-1-git-send-email-ljalvs@gmail.com>
	<53C85496.8060306@iki.fi>
Date: Fri, 18 Jul 2014 00:04:30 +0100
Message-ID: <CAGj5WxCjFpA0XPxo-c3mZMzicERc6H_PgKkimZGLe3Ed1f8znQ@mail.gmail.com>
Subject: Re: [PATCH 1/1 v2] si2168: Support Si2168-A20 firmware downloading.
From: Luis Alves <ljalvs@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think so... at least the known ones.

On Thu, Jul 17, 2014 at 11:56 PM, Antti Palosaari <crope@iki.fi> wrote:
> Thank for the patch! I will apply that sure too.
> Driver supports now all Si2168 versions?
>
> regards
> Antti
>
>
> On 07/18/2014 01:43 AM, Luis Alves wrote:
>>
>> (ignore the previous one, it was incomplete)
>>
>> This adds support for the Si2168-A20 firmware download.
>> Extracting the firmware:
>>
>> wget
>> http://www.tbsdtv.com/download/document/tbs6281/tbs6281-t2-t-driver_v1.0.0.6.zip
>> unzip tbs6281-t2-t-driver_v1.0.0.6.zip
>> dd if=tbs-6281_x64/tbs6281_64.sys of=dvb-demod-si2168-a20-01.fw
>> count=28656 bs=1 skip=1625088
>>
>> md5sum:
>> 32e06713b33915f674bfb2c209beaea5 /lib/firmware/dvb-demod-si2168-a20-01.fw
>>
>> Regards,
>> Luis
>>
>>
>> Signed-off-by: Luis Alves <ljalvs@gmail.com>
>> ---
>>   drivers/media/dvb-frontends/si2168.c      | 5 +++++
>>   drivers/media/dvb-frontends/si2168_priv.h | 1 +
>>   2 files changed, 6 insertions(+)
>>
>> diff --git a/drivers/media/dvb-frontends/si2168.c
>> b/drivers/media/dvb-frontends/si2168.c
>> index 7e45eeab..50c4a91 100644
>> --- a/drivers/media/dvb-frontends/si2168.c
>> +++ b/drivers/media/dvb-frontends/si2168.c
>> @@ -377,10 +377,14 @@ static int si2168_init(struct dvb_frontend *fe)
>>         chip_id = cmd.args[1] << 24 | cmd.args[2] << 16 | cmd.args[3] << 8
>> |
>>                         cmd.args[4] << 0;
>>
>> +       #define SI2168_A20 ('A' << 24 | 68 << 16 | '2' << 8 | '0' << 0)
>>         #define SI2168_A30 ('A' << 24 | 68 << 16 | '3' << 8 | '0' << 0)
>>         #define SI2168_B40 ('B' << 24 | 68 << 16 | '4' << 8 | '0' << 0)
>>
>>         switch (chip_id) {
>> +       case SI2168_A20:
>> +               fw_file = SI2168_A20_FIRMWARE;
>> +               break;
>>         case SI2168_A30:
>>                 fw_file = SI2168_A30_FIRMWARE;
>>                 break;
>> @@ -672,5 +676,6 @@ module_i2c_driver(si2168_driver);
>>   MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
>>   MODULE_DESCRIPTION("Silicon Labs Si2168 DVB-T/T2/C demodulator driver");
>>   MODULE_LICENSE("GPL");
>> +MODULE_FIRMWARE(SI2168_A20_FIRMWARE);
>>   MODULE_FIRMWARE(SI2168_A30_FIRMWARE);
>>   MODULE_FIRMWARE(SI2168_B40_FIRMWARE);
>> diff --git a/drivers/media/dvb-frontends/si2168_priv.h
>> b/drivers/media/dvb-frontends/si2168_priv.h
>> index bebb68a..ebbf502 100644
>> --- a/drivers/media/dvb-frontends/si2168_priv.h
>> +++ b/drivers/media/dvb-frontends/si2168_priv.h
>> @@ -22,6 +22,7 @@
>>   #include <linux/firmware.h>
>>   #include <linux/i2c-mux.h>
>>
>> +#define SI2168_A20_FIRMWARE "dvb-demod-si2168-a20-01.fw"
>>   #define SI2168_A30_FIRMWARE "dvb-demod-si2168-a30-01.fw"
>>   #define SI2168_B40_FIRMWARE "dvb-demod-si2168-b40-01.fw"
>>   #define SI2168_B40_FIRMWARE_FALLBACK "dvb-demod-si2168-02.fw"
>>
>
> --
> http://palosaari.fi/
