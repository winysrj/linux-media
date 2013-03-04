Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:53082 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758432Ab3CDSeb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 13:34:31 -0500
Received: by mail-ea0-f177.google.com with SMTP id n13so894251eaa.8
        for <linux-media@vger.kernel.org>; Mon, 04 Mar 2013 10:34:30 -0800 (PST)
Message-ID: <5134E780.4000700@googlemail.com>
Date: Mon, 04 Mar 2013 19:27:12 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 01/11] em28xx-i2c: replace printk() with the corresponding
 em28xx macros
References: <1362339464-3373-1-git-send-email-fschaefer.oss@googlemail.com> <1362339464-3373-2-git-send-email-fschaefer.oss@googlemail.com> <20130304150931.050dd815@redhat.com>
In-Reply-To: <20130304150931.050dd815@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 04.03.2013 19:09, schrieb Mauro Carvalho Chehab:
> Em Sun,  3 Mar 2013 20:37:34 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Reduces the number of characters/lines, unifies the code and improves readability.
> Had you actually test this patch? The reason why printk() is used on some
> places is because dev->name is not available early.

The em28xx-specific macros are using printk, too.
They are actually just an abbreviation of the current printks (saving us
the KERN_XY and the the dev->name parameter).
See em28xx.h.

> That's said, it makes sense to replace all those em28xx-specific printk
> functions by the standard pr_fmt-based ones (pr_err, pr_info, pr_debug, etc).

Yeah, I agree.
But that would be a separate patch series... ;)
I can do that (later) if you want.

Regards,
Frank

>
> Regards,
> Mauro
>
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>> ---
>>  drivers/media/usb/em28xx/em28xx-i2c.c |   55 ++++++++++++++-------------------
>>  1 Datei geändert, 24 Zeilen hinzugefügt(+), 31 Zeilen entfernt(-)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
>> index 8532c1d..8819b54 100644
>> --- a/drivers/media/usb/em28xx/em28xx-i2c.c
>> +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
>> @@ -399,7 +399,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char *eedata, int len)
>>  	/* Check if board has eeprom */
>>  	err = i2c_master_recv(&dev->i2c_client, &buf, 0);
>>  	if (err < 0) {
>> -		em28xx_errdev("board has no eeprom\n");
>> +		em28xx_info("board has no eeprom\n");
>>  		memset(eedata, 0, len);
>>  		return -ENODEV;
>>  	}
>> @@ -408,8 +408,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char *eedata, int len)
>>  
>>  	err = i2c_master_send(&dev->i2c_client, &buf, 1);
>>  	if (err != 1) {
>> -		printk(KERN_INFO "%s: Huh, no eeprom present (err=%d)?\n",
>> -		       dev->name, err);
>> +		em28xx_errdev("failed to read eeprom (err=%d)\n", err);
>>  		return err;
>>  	}
>>  
>> @@ -426,9 +425,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char *eedata, int len)
>>  
>>  		if (block !=
>>  		    (err = i2c_master_recv(&dev->i2c_client, p, block))) {
>> -			printk(KERN_WARNING
>> -			       "%s: i2c eeprom read error (err=%d)\n",
>> -			       dev->name, err);
>> +			em28xx_errdev("i2c eeprom read error (err=%d)\n", err);
>>  			return err;
>>  		}
>>  		size -= block;
>> @@ -436,7 +433,7 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char *eedata, int len)
>>  	}
>>  	for (i = 0; i < len; i++) {
>>  		if (0 == (i % 16))
>> -			printk(KERN_INFO "%s: i2c eeprom %02x:", dev->name, i);
>> +			em28xx_info("i2c eeprom %02x:", i);
>>  		printk(" %02x", eedata[i]);
>>  		if (15 == (i % 16))
>>  			printk("\n");
>> @@ -445,55 +442,51 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, unsigned char *eedata, int len)
>>  	if (em_eeprom->id == 0x9567eb1a)
>>  		dev->hash = em28xx_hash_mem(eedata, len, 32);
>>  
>> -	printk(KERN_INFO "%s: EEPROM ID= 0x%08x, EEPROM hash = 0x%08lx\n",
>> -	       dev->name, em_eeprom->id, dev->hash);
>> +	em28xx_info("EEPROM ID = 0x%08x, EEPROM hash = 0x%08lx\n",
>> +		    em_eeprom->id, dev->hash);
>>  
>> -	printk(KERN_INFO "%s: EEPROM info:\n", dev->name);
>> +	em28xx_info("EEPROM info:\n");
>>  
>>  	switch (em_eeprom->chip_conf >> 4 & 0x3) {
>>  	case 0:
>> -		printk(KERN_INFO "%s:\tNo audio on board.\n", dev->name);
>> +		em28xx_info("\tNo audio on board.\n");
>>  		break;
>>  	case 1:
>> -		printk(KERN_INFO "%s:\tAC97 audio (5 sample rates)\n",
>> -				 dev->name);
>> +		em28xx_info("\tAC97 audio (5 sample rates)\n");
>>  		break;
>>  	case 2:
>> -		printk(KERN_INFO "%s:\tI2S audio, sample rate=32k\n",
>> -				 dev->name);
>> +		em28xx_info("\tI2S audio, sample rate=32k\n");
>>  		break;
>>  	case 3:
>> -		printk(KERN_INFO "%s:\tI2S audio, 3 sample rates\n",
>> -				 dev->name);
>> +		em28xx_info("\tI2S audio, 3 sample rates\n");
>>  		break;
>>  	}
>>  
>>  	if (em_eeprom->chip_conf & 1 << 3)
>> -		printk(KERN_INFO "%s:\tUSB Remote wakeup capable\n", dev->name);
>> +		em28xx_info("\tUSB Remote wakeup capable\n");
>>  
>>  	if (em_eeprom->chip_conf & 1 << 2)
>> -		printk(KERN_INFO "%s:\tUSB Self power capable\n", dev->name);
>> +		em28xx_info("\tUSB Self power capable\n");
>>  
>>  	switch (em_eeprom->chip_conf & 0x3) {
>>  	case 0:
>> -		printk(KERN_INFO "%s:\t500mA max power\n", dev->name);
>> +		em28xx_info("\t500mA max power\n");
>>  		break;
>>  	case 1:
>> -		printk(KERN_INFO "%s:\t400mA max power\n", dev->name);
>> +		em28xx_info("\t400mA max power\n");
>>  		break;
>>  	case 2:
>> -		printk(KERN_INFO "%s:\t300mA max power\n", dev->name);
>> +		em28xx_info("\t300mA max power\n");
>>  		break;
>>  	case 3:
>> -		printk(KERN_INFO "%s:\t200mA max power\n", dev->name);
>> +		em28xx_info("\t200mA max power\n");
>>  		break;
>>  	}
>> -	printk(KERN_INFO "%s:\tTable at 0x%02x, strings=0x%04x, 0x%04x, 0x%04x\n",
>> -				dev->name,
>> -				em_eeprom->string_idx_table,
>> -				em_eeprom->string1,
>> -				em_eeprom->string2,
>> -				em_eeprom->string3);
>> +	em28xx_info("\tTable at offset 0x%02x, strings=0x%04x, 0x%04x, 0x%04x\n",
>> +		    em_eeprom->string_idx_table,
>> +		    em_eeprom->string1,
>> +		    em_eeprom->string2,
>> +		    em_eeprom->string3);
>>  
>>  	return 0;
>>  }
>> @@ -570,8 +563,8 @@ void em28xx_do_i2c_scan(struct em28xx *dev)
>>  		if (rc < 0)
>>  			continue;
>>  		i2c_devicelist[i] = i;
>> -		printk(KERN_INFO "%s: found i2c device @ 0x%x [%s]\n",
>> -		       dev->name, i << 1, i2c_devs[i] ? i2c_devs[i] : "???");
>> +		em28xx_info("found i2c device @ 0x%x [%s]\n",
>> +			    i << 1, i2c_devs[i] ? i2c_devs[i] : "???");
>>  	}
>>  
>>  	dev->i2c_hash = em28xx_hash_mem(i2c_devicelist,
>

