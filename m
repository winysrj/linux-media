Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756502Ab0BBPlB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 10:41:01 -0500
Message-ID: <4B684782.9090703@redhat.com>
Date: Tue, 02 Feb 2010 13:40:50 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] V4L/DVB: lgs8gxx: remove firmware for lgs8g75
References: <1257041675.3136.310.camel@localhost> <4B0AB325.8020605@infradead.org>
In-Reply-To: <4B0AB325.8020605@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Ben Hutchings wrote:
>> The recently added support for lgs8g75 included some 8051 machine code
>> without accompanying source code.  Replace this with use of the
>> firmware loader.
>>
>> Compile-tested only.
>>
>> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>> ---
>> This firmware can be added to linux-firmware.git instead, and I will be
>> requesting that very shortly.
> 
> Had you submitted a patch for it already? Could you please test the patch before we commit it at the tree?

Ping.

> 
>> Ben.
>>
>>  drivers/media/dvb/frontends/Kconfig   |    1 +
>>  drivers/media/dvb/frontends/lgs8gxx.c |   50 ++++++--------------------------
>>  2 files changed, 11 insertions(+), 40 deletions(-)
>>
>> diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
>> index d7c4837..26b00ab 100644
>> --- a/drivers/media/dvb/frontends/Kconfig
>> +++ b/drivers/media/dvb/frontends/Kconfig
>> @@ -553,6 +553,7 @@ config DVB_LGS8GL5
>>  config DVB_LGS8GXX
>>  	tristate "Legend Silicon LGS8913/LGS8GL5/LGS8GXX DMB-TH demodulator"
>>  	depends on DVB_CORE && I2C
>> +	select FW_LOADER
>>  	default m if DVB_FE_CUSTOMISE
>>  	help
>>  	  A DMB-TH tuner module. Say Y when you want to support this frontend.
>> diff --git a/drivers/media/dvb/frontends/lgs8gxx.c b/drivers/media/dvb/frontends/lgs8gxx.c
>> index eabcadc..1bfcf85 100644
>> --- a/drivers/media/dvb/frontends/lgs8gxx.c
>> +++ b/drivers/media/dvb/frontends/lgs8gxx.c
>> @@ -24,6 +24,7 @@
>>   */
>>  
>>  #include <asm/div64.h>
>> +#include <linux/firmware.h>
>>  
>>  #include "dvb_frontend.h"
>>  
>> @@ -46,42 +47,6 @@ module_param(fake_signal_str, int, 0644);
>>  MODULE_PARM_DESC(fake_signal_str, "fake signal strength for LGS8913."
>>  "Signal strength calculation is slow.(default:on).");
>>  
>> -static const u8 lgs8g75_initdat[] = {
>> -	0x01, 0x30, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
>> -	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
>> -	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
>> -	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
>> -	0x00, 0x01, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
>> -	0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
>> -	0xE4, 0xF5, 0xA8, 0xF5, 0xB8, 0xF5, 0x88, 0xF5,
>> -	0x89, 0xF5, 0x87, 0x75, 0xD0, 0x00, 0x11, 0x50,
>> -	0x11, 0x50, 0xF4, 0xF5, 0x80, 0xF5, 0x90, 0xF5,
>> -	0xA0, 0xF5, 0xB0, 0x75, 0x81, 0x30, 0x80, 0x01,
>> -	0x32, 0x90, 0x80, 0x12, 0x74, 0xFF, 0xF0, 0x90,
>> -	0x80, 0x13, 0x74, 0x1F, 0xF0, 0x90, 0x80, 0x23,
>> -	0x74, 0x01, 0xF0, 0x90, 0x80, 0x22, 0xF0, 0x90,
>> -	0x00, 0x48, 0x74, 0x00, 0xF0, 0x90, 0x80, 0x4D,
>> -	0x74, 0x05, 0xF0, 0x90, 0x80, 0x09, 0xE0, 0x60,
>> -	0x21, 0x12, 0x00, 0xDD, 0x14, 0x60, 0x1B, 0x12,
>> -	0x00, 0xDD, 0x14, 0x60, 0x15, 0x12, 0x00, 0xDD,
>> -	0x14, 0x60, 0x0F, 0x12, 0x00, 0xDD, 0x14, 0x60,
>> -	0x09, 0x12, 0x00, 0xDD, 0x14, 0x60, 0x03, 0x12,
>> -	0x00, 0xDD, 0x90, 0x80, 0x42, 0xE0, 0x60, 0x0B,
>> -	0x14, 0x60, 0x0C, 0x14, 0x60, 0x0D, 0x14, 0x60,
>> -	0x0E, 0x01, 0xB3, 0x74, 0x04, 0x01, 0xB9, 0x74,
>> -	0x05, 0x01, 0xB9, 0x74, 0x07, 0x01, 0xB9, 0x74,
>> -	0x0A, 0xC0, 0xE0, 0x74, 0xC8, 0x12, 0x00, 0xE2,
>> -	0xD0, 0xE0, 0x14, 0x70, 0xF4, 0x90, 0x80, 0x09,
>> -	0xE0, 0x70, 0xAE, 0x12, 0x00, 0xF6, 0x12, 0x00,
>> -	0xFE, 0x90, 0x00, 0x48, 0xE0, 0x04, 0xF0, 0x90,
>> -	0x80, 0x4E, 0xF0, 0x01, 0x73, 0x90, 0x80, 0x08,
>> -	0xF0, 0x22, 0xF8, 0x7A, 0x0C, 0x79, 0xFD, 0x00,
>> -	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xD9,
>> -	0xF6, 0xDA, 0xF2, 0xD8, 0xEE, 0x22, 0x90, 0x80,
>> -	0x65, 0xE0, 0x54, 0xFD, 0xF0, 0x22, 0x90, 0x80,
>> -	0x65, 0xE0, 0x44, 0xC2, 0xF0, 0x22
>> -};
>> -
>>  /* LGS8GXX internal helper functions */
>>  
>>  static int lgs8gxx_write_reg(struct lgs8gxx_state *priv, u8 reg, u8 data)
>> @@ -627,9 +592,14 @@ static int lgs8913_init(struct lgs8gxx_state *priv)
>>  
>>  static int lgs8g75_init_data(struct lgs8gxx_state *priv)
>>  {
>> -	const u8 *p = lgs8g75_initdat;
>> +	const struct firmware *fw;
>> +	int rc;
>>  	int i;
>>  
>> +	rc = request_firmware(&fw, "lgs8g75.fw", &priv->i2c->dev);
>> +	if (rc)
>> +		return rc;
>> +
>>  	lgs8gxx_write_reg(priv, 0xC6, 0x40);
>>  
>>  	lgs8gxx_write_reg(priv, 0x3D, 0x04);
>> @@ -640,16 +610,16 @@ static int lgs8g75_init_data(struct lgs8gxx_state *priv)
>>  	lgs8gxx_write_reg(priv, 0x3B, 0x00);
>>  	lgs8gxx_write_reg(priv, 0x38, 0x00);
>>  
>> -	for (i = 0; i < sizeof(lgs8g75_initdat); i++) {
>> +	for (i = 0; i < fw->size; i++) {
>>  		lgs8gxx_write_reg(priv, 0x38, 0x00);
>>  		lgs8gxx_write_reg(priv, 0x3A, (u8)(i&0xff));
>>  		lgs8gxx_write_reg(priv, 0x3B, (u8)(i>>8));
>> -		lgs8gxx_write_reg(priv, 0x3C, *p);
>> -		p++;
>> +		lgs8gxx_write_reg(priv, 0x3C, fw->data[i]);
>>  	}
>>  
>>  	lgs8gxx_write_reg(priv, 0x38, 0x00);
>>  
>> +	release_firmware(fw);
>>  	return 0;
>>  }
>>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
