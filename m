Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:48955 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbaJ0OZt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Oct 2014 10:25:49 -0400
Received: by mail-pd0-f177.google.com with SMTP id v10so5729085pde.36
        for <linux-media@vger.kernel.org>; Mon, 27 Oct 2014 07:25:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20141027094619.69851745.m.chehab@samsung.com>
References: <BLU437-SMTP74723F476D15D78EEEA959BA900@phx.gbl>
	<20141027094619.69851745.m.chehab@samsung.com>
Date: Mon, 27 Oct 2014 10:25:48 -0400
Message-ID: <CAOcJUbyK7Y5=fMfEGv5rhC3bPpeiiS3Mp1z+8cVfHoqy-opy5Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] xc5000: tuner firmware update
From: Michael Ira Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Richard Vollkommer <linux@hauppauge.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 27, 2014 at 7:46 AM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> Em Sat, 25 Oct 2014 16:17:21 -0400
> Michael Krufky <mkrufky@hotmail.com> escreveu:
>
>> From: Richard Vollkommer <linux@hauppauge.com>
>>
>> - Update the xc5000 tuner firmware to version 1.6.821
>>
>> - Update the xc5000c tuner firmware to version 4.1.33
>>
>> Firmware files can be downloaded from:
>>
>> - http://hauppauge.lightpath.net/software/hvr950q/xc5000c-4.1.33.zip
>> - http://hauppauge.lightpath.net/software/hvr950q/xc5000-1.6.821.zip
>>
>> Signed-off-by: Richard Vollkommer <linux@hauppauge.com>
>> Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
>> Signed-off-by: Michael Ira Krufky <mkrufky@linuxtv.org>
>
> Hi Michael,
>
> Please use a logic that would allow the old firmware files to allow
> falling back to the previous firmware version if the new one is not
> available.
>
> Regards,
> Mauro
>
>> ---
>>  drivers/media/tuners/xc5000.c | 14 +++++++-------
>>  1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
>> index e44c8ab..fafff4c 100644
>> --- a/drivers/media/tuners/xc5000.c
>> +++ b/drivers/media/tuners/xc5000.c
>> @@ -222,15 +222,15 @@ struct xc5000_fw_cfg {
>>       u8 fw_checksum_supported;
>>  };
>>
>> -#define XC5000A_FIRMWARE "dvb-fe-xc5000-1.6.114.fw"
>> -static const struct xc5000_fw_cfg xc5000a_1_6_114 = {
>> +#define XC5000A_FIRMWARE "dvb-fe-xc5000-1.6.821.fw"
>> +static const struct xc5000_fw_cfg xc5000a_fw_cfg = {
>>       .name = XC5000A_FIRMWARE,
>>       .size = 12401,
>> -     .pll_reg = 0x806c,
>> +     .pll_reg = 0x8067,
>>  };
>>
>> -#define XC5000C_FIRMWARE "dvb-fe-xc5000c-4.1.30.7.fw"
>> -static const struct xc5000_fw_cfg xc5000c_41_024_5 = {
>> +#define XC5000C_FIRMWARE "dvb-fe-xc5000c-4.1.33.fw"
>> +static const struct xc5000_fw_cfg xc5000c_fw_cfg = {
>>       .name = XC5000C_FIRMWARE,
>>       .size = 16497,
>>       .pll_reg = 0x13,
>> @@ -243,9 +243,9 @@ static inline const struct xc5000_fw_cfg *xc5000_assign_firmware(int chip_id)
>>       switch (chip_id) {
>>       default:
>>       case XC5000A:
>> -             return &xc5000a_1_6_114;
>> +             return &xc5000a_fw_cfg;
>>       case XC5000C:
>> -             return &xc5000c_41_024_5;
>> +             return &xc5000c_fw_cfg;
>>       }
>>  }
>>


Mauro,

I like the idea of supporting older firmware revisions if the new one
is not present, but, the established president for this sort of thing
has always been to replace older firmware with newer firmware without
backward compatibility support for older binaries.

Although the current driver can work with both old and new firmware
versions, this hasn't been the case in the past, and won't always be
the case with future firmware revisions.

Hauppauge has provided links to the new firmware for both the XC5000
and XC5000C chips along with licensing.  Maybe instead, we can just
upstream those into the linux-firmware packages for distribution.

I don't think supporting two different firmware versions is a good
idea for the case of the xc5000 driver.

-Mike Krufky
