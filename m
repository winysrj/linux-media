Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f181.google.com ([209.85.215.181]:35377 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaBIShP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Feb 2014 13:37:15 -0500
Received: by mail-ea0-f181.google.com with SMTP id k10so345008eaj.40
        for <linux-media@vger.kernel.org>; Sun, 09 Feb 2014 10:37:14 -0800 (PST)
Message-ID: <52F7CB31.4060608@googlemail.com>
Date: Sun, 09 Feb 2014 19:38:41 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: m.chehab@samsung.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] em28xx-i2c: remove duplicate error printing code
 from em28xx_i2c_xfer()
References: <1390168117-2925-1-git-send-email-fschaefer.oss@googlemail.com> <1390168117-2925-5-git-send-email-fschaefer.oss@googlemail.com> <20140204165039.01ef46a0@samsung.com>
In-Reply-To: <20140204165039.01ef46a0@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 04.02.2014 19:50, schrieb Mauro Carvalho Chehab:
> Em Sun, 19 Jan 2014 22:48:37 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>> ---
>>  drivers/media/usb/em28xx/em28xx-i2c.c |   11 +++--------
>>  1 Datei geändert, 3 Zeilen hinzugefügt(+), 8 Zeilen entfernt(-)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
>> index a26d7d4..1a514ca 100644
>> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
>> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
>> @@ -535,14 +535,9 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
>>  			 * This code is only called during device probe.
>>  			 */
>>  			rc = i2c_check_for_device(i2c_bus, addr);
>> -			if (rc < 0) {
>> -				if (rc == -ENXIO) {
>> -					if (i2c_debug > 1)
>> -						printk(KERN_CONT " no device\n");
>> -				} else {
>> -					if (i2c_debug > 1)
>> -						printk(KERN_CONT " ERROR: %i\n", rc);
>> -				}
>> +			if (rc == -ENXIO) {
>> +				if (i2c_debug > 1)
>> +					printk(KERN_CONT " no device\n");
> Even if the previous patch were accepted, this one is wrong, as -ENXIO
> doesn't always mean that there's no device. Also, other return codes
> may happen here (like -EIO).
Mauro... please read the patch and the corresponding code again.
You will notice that there is absolutely no functional change.
The patch just removes duplicate code.
Hence your comment makes no sense.

If you insist on the weird -ENODEV/-ENXIO inconsistency you've
introduced, then of course the patch needs to be rebased.

>>  				rt_mutex_unlock(&dev->i2c_bus_lock);
>>  				return rc;
>>  			}

