Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43160 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab0BDCn7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 21:43:59 -0500
Message-ID: <4B6A3468.3070700@infradead.org>
Date: Thu, 04 Feb 2010 00:43:52 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 14/15] - zl10353
References: <4B673790.3030706@arcor.de> <4B675B19.3080705@redhat.com>	 <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com>	 <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com>	 <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de>	 <4B69D8CC.2030008@arcor.de> <4B69DEDA.3020200@arcor.de> <829197381002031249w5542bccfpccfa8554e7c6b280@mail.gmail.com> <4B69E575.5010201@arcor.de>
In-Reply-To: <4B69E575.5010201@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Ringel wrote:
> Am 03.02.2010 21:49, schrieb Devin Heitmueller:
>> On Wed, Feb 3, 2010 at 3:38 PM, Stefan Ringel <stefan.ringel@arcor.de> wrote:
>>   
>>> signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
>>>
>>> --- a/drivers/media/dvb/frontends/zl10353.h
>>> +++ b/drivers/media/dvb/frontends/zl10353.h
>>> @@ -45,6 +45,8 @@ struct zl10353_config
>>>        /* clock control registers (0x51-0x54) */
>>>        u8 clock_ctl_1;  /* default: 0x46 */
>>>        u8 pll_0;        /* default: 0x15 */
>>> +
>>> +       int tm6000:1;
>>>  };
>>>     
>> Why is this being submitted as its own patch?  It is code that is not
>> used by *anything*.  If you really did require a new field in the
>> zl10353 config, that field should be added in the same patch as
>> whatever requires it.
>>
>> Devin
>>
>>

Hi Stefan,

Due to the problem with your emailer, most of the patches failed:

2/15 3/15 4/15 5/15 6/15 7/15 2/15 (the second one 8th in the sequence)
9/15 11/15 12/15 13/15 and 15/15.

In brief, only two patches applied: the 1/15 and a patch also called 2/15
(I suspect it is the 10th patch).

So, after reading our comments, reading README.patches and applying the 
Asaulted-patches extension to your thunderbird, please resubmit the patches.
 
> Actually doesn't work zl10353 with tm6010, it have a little different
> between a few registers, so I think that I use it.
> 
> for example:
> zl10353 use 0x64 , but not mine (0x63)
> register 0x5f is 0x17 not 0x13
> register 0x5e is 0x40 not 0x00 for auto
> and tuner go is 0x70 not 0x71
> 
> the other register are ok. I have no idea how I can set it.

I agree with Devin that the patch 14/15 shouldn't be applied as-is.

I have no idea why zl10353 needs a different setup, but you don't need
to add an extra parameter to identify the bridge driver. There's a field
at struct i2c_client that can be used: i2c_adapter->id.

This is already initialized with I2C_HW_B_TM6000 (although it currently
uses a fake value).

It is still ugly to do some specific initialization like this, but, when
we have no other glue, due to the lack of datasheets, this is a better
alternative than adding an extra fake parameter at the config struct.

All you need is some code like:


diff --git a/linux/drivers/media/dvb/frontends/zl10353.c b/linux/drivers/media/dvb/frontends/zl10353.c
--- a/linux/drivers/media/dvb/frontends/zl10353.c
+++ b/linux/drivers/media/dvb/frontends/zl10353.c
@@ -597,6 +597,10 @@ static int zl10353_init(struct dvb_front
 	    zl10353_read_register(state, 0x51) != zl10353_reset_attach[2]) {
 		rc = zl10353_write(fe, zl10353_reset_attach,
 				   sizeof(zl10353_reset_attach));
+
+		if (state->i2c->id == I2C_HW_B_TM6000) {
+			/* Do special init needed by tm6000 driver */
+		}
 #if 1
 		if (debug_regs)
 			zl10353_dump_regs(fe);
diff --git a/linux/drivers/staging/tm6000/tm6000-i2c.c b/linux/drivers/staging/tm6000/tm6000-i2c.c
--- a/linux/drivers/staging/tm6000/tm6000-i2c.c
+++ b/linux/drivers/staging/tm6000/tm6000-i2c.c
@@ -33,8 +33,6 @@
 #include "tuner-xc2028.h"
 
 
-/*FIXME: Hack to avoid needing to patch i2c-id.h */
-#define I2C_HW_B_TM6000 I2C_HW_B_EM28XX
 /* ----------------------------------------------------------- */
 
 static unsigned int i2c_debug = 0;
diff --git a/linux/include/linux/i2c-id.h b/linux/include/linux/i2c-id.h
--- a/linux/include/linux/i2c-id.h
+++ b/linux/include/linux/i2c-id.h
@@ -42,6 +42,7 @@
 #define I2C_HW_B_AU0828		0x010023 /* auvitek au0828 usb bridge */
 #define I2C_HW_B_CX231XX	0x010024 /* Conexant CX231XX USB based cards */
 #define I2C_HW_B_HDPVR		0x010025 /* Hauppauge HD PVR */
+#define I2C_HW_B_TM6000		0x010026 /* TM5600/6000/6010 video bridge */
 
 /* --- SGI adapters							*/
 #define I2C_HW_SGI_VINO		0x160000


-- 

Cheers,
Mauro
