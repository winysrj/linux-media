Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:45209 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab3CXMzX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Mar 2013 08:55:23 -0400
Received: by mail-ea0-f178.google.com with SMTP id g14so2012276eak.23
        for <linux-media@vger.kernel.org>; Sun, 24 Mar 2013 05:55:22 -0700 (PDT)
Message-ID: <514EF7F2.9000405@googlemail.com>
Date: Sun, 24 Mar 2013 13:56:18 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] em28xx: write output frame resolution to regs
 0x34+0x35 for em25xx family bridges
References: <1364059632-29070-1-git-send-email-fschaefer.oss@googlemail.com> <1364059632-29070-6-git-send-email-fschaefer.oss@googlemail.com> <20130324084436.76968b9e@redhat.com>
In-Reply-To: <20130324084436.76968b9e@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 24.03.2013 12:44, schrieb Mauro Carvalho Chehab:
> Em Sat, 23 Mar 2013 18:27:12 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> The Windows driver writes the output resolution to registers 0x34 (width / 16)
>> and 0x35 (height / 16) always.
>> We don't know yet what these registers are used for.
>>
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>> ---
>>  drivers/media/usb/em28xx/em28xx-core.c |    7 +++++++
>>  drivers/media/usb/em28xx/em28xx-reg.h  |    6 ++++++
>>  2 Dateien geändert, 13 Zeilen hinzugefügt(+)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
>> index 7b9f76b..0ce6b0f 100644
>> --- a/drivers/media/usb/em28xx/em28xx-core.c
>> +++ b/drivers/media/usb/em28xx/em28xx-core.c
>> @@ -766,6 +766,13 @@ static void em28xx_capture_area_set(struct em28xx *dev, u8 hstart, u8 vstart,
>>  	em28xx_write_regs(dev, EM28XX_R1E_CWIDTH, &cwidth, 1);
>>  	em28xx_write_regs(dev, EM28XX_R1F_CHEIGHT, &cheight, 1);
>>  	em28xx_write_regs(dev, EM28XX_R1B_OFLOW, &overflow, 1);
>> +
>> +	if (dev->is_em25xx) {
>> +		em28xx_write_reg(dev, 0x34, width >> 4);
>> +		em28xx_write_reg(dev, 0x35, height >> 4);
>> +	}
>> +	/* FIXME: function/meaning of these registers ? */
>> +	/* FIXME: align width+height to multiples of 4 ?! */
> Please move those comments to be _before_ the code you're commenting.
>
> E. g. something like:
>
> 	if (dev->is_em25xx) {
> 		/*
> 		 * FIXME:
>  		 *	- function/meaning of these registers are unknown;
> 		 *	- align width+height to multiples of 4 ?! 
> 		 */
> 		em28xx_write_reg(dev, 0x34, width >> 4);
> 		em28xx_write_reg(dev, 0x35, height >> 4);
> 	}

Ok, no problem.

Frank

>
>>  }
>>  
>>  static int em28xx_scaler_set(struct em28xx *dev, u16 h, u16 v)
>> diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
>> index 1b0ecd6..e08982a 100644
>> --- a/drivers/media/usb/em28xx/em28xx-reg.h
>> +++ b/drivers/media/usb/em28xx/em28xx-reg.h
>> @@ -167,6 +167,12 @@
>>  
>>  #define EM28XX_R34_VBI_START_H	0x34
>>  #define EM28XX_R35_VBI_START_V	0x35
>> +/* NOTE: the EM276x (and EM25xx, EM277x/8x ?) (camera bridges) use these
>> + * registers for a different unknown purpose.
>> + *   => register 0x34 is set to capture width / 16
>> + *   => register 0x35 is set to capture height / 16
>> + */
>> +
>>  #define EM28XX_R36_VBI_WIDTH	0x36
>>  #define EM28XX_R37_VBI_HEIGHT	0x37
>>  
>

