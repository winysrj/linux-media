Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:33227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab1AYBXO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 20:23:14 -0500
Message-ID: <4D3E25FC.7010308@redhat.com>
Date: Mon, 24 Jan 2011 23:23:08 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 13/13] [media] remove the old RC_MAP_HAUPPAUGE_NEW RC
 map
References: <cover.1295882104.git.mchehab@redhat.com>	 <20110124131848.59f438d3@pedra> <1295915548.2420.44.camel@localhost>
In-Reply-To: <1295915548.2420.44.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 24-01-2011 22:32, Andy Walls escreveu:
> On Mon, 2011-01-24 at 13:18 -0200, Mauro Carvalho Chehab wrote:
>> The rc-hauppauge-new map is a messy thing, as it bundles 3
>> different remote controllers as if they were just one,
>> discarding the address byte. Also, some key maps are wrong.
>>
>> With the conversion to the new rc-core, it is likely that
>> most of the devices won't be working properly, as the i2c
>> driver and the raw decoders are now providing 16 bits for
>> the remote, instead of just 8.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> All the patch emails didn't/haven't come through to me.
> 
> Did you miss cx23885-input.c, or is that using a map that isn't affected
> by these changes?
> 
> Also one comment below:
> 
>>  delete mode 100644 drivers/media/rc/keymaps/rc-hauppauge-new.c
> [...]
>> diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
>> index d2b20ad..b18373a 100644
>> --- a/drivers/media/video/ir-kbd-i2c.c
>> +++ b/drivers/media/video/ir-kbd-i2c.c
>> @@ -300,7 +300,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>>  		ir->get_key = get_key_haup;
>>  		rc_type     = RC_TYPE_RC5;
>>  		if (hauppauge == 1) {
>> -			ir_codes    = RC_MAP_HAUPPAUGE_NEW;
>> +			ir_codes    = RC_MAP_HAUPPAUGE;
>>  		} else {
>>  			ir_codes    = RC_MAP_RC5_TV;
>>  		}
>> @@ -327,7 +327,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
>>  		name        = "Hauppauge/Zilog Z8";
>>  		ir->get_key = get_key_haup_xvr;
>>  		rc_type     = RC_TYPE_RC5;
>> -		ir_codes    = hauppauge ? RC_MAP_HAUPPAUGE_NEW : RC_MAP_RC5_TV;
>> +		ir_codes    = hauppauge ? RC_MAP_HAUPPAUGE : RC_MAP_RC5_TV;
>>  		break;
>>  	}
> 
> The "hauppauge" module parameter was to make ir-kbd-i2c to default to a
> keymap for the old black remote.
> 
> If you have combined the black remote's keymap with the grey remote's
> keymap, why keep the "hauppauge" module parameter?

This is the next step. I wrote another patch cleaning it. I just didn't send to the ML yet.
See enclosed.

commit 2442b2539971c43aa51503b960735c4eb85b10ed
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Mon Jan 24 13:38:32 2011 -0200

    [media] rc/keymaps: Remove the obsolete rc-rc5-tv keymap
    
    This keymap were used for the Hauppauge Black remote controller
    only. It also contains some keycodes not found there. As the
    Hauppauge Black is now part of the hauppauge keymap, just remove
    it.
    
    Also, remove the modprobe hacks to select between the Gray
    and the Black versions of the remote controller as:
    	- Both are supported by default by the keymap;
    	- If the user just wants one keyboard supported,
    	  it is just a matter of changing the keymap via
    	  the userspace tool (ir-keytable), removing
    	  the keys that he doesn't desire. As ir-keytable
    	  auto-loads the keys via udev, this is better than
    	  obscure modprobe parameters.
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
index e6bd958..c5b3a23 100644
--- a/drivers/media/rc/keymaps/Makefile
+++ b/drivers/media/rc/keymaps/Makefile
@@ -68,7 +68,6 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
 			rc-purpletv.o \
 			rc-pv951.o \
 			rc-hauppauge.o \
-			rc-rc5-tv.o \
 			rc-rc6-mce.o \
 			rc-real-audio-220-32-keys.o \
 			rc-streamzap.o \
diff --git a/drivers/media/rc/keymaps/rc-rc5-tv.c b/drivers/media/rc/keymaps/rc-rc5-tv.c
deleted file mode 100644
index 4fcef9f..0000000
--- a/drivers/media/rc/keymaps/rc-rc5-tv.c
+++ /dev/null
@@ -1,81 +0,0 @@
-/* rc5-tv.h - Keytable for rc5_tv Remote Controller
- *
- * keymap imported from ir-keymaps.c
- *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <media/rc-map.h>
-
-/* generic RC5 keytable                                          */
-/* see http://users.pandora.be/nenya/electronics/rc5/codes00.htm */
-/* used by old (black) Hauppauge remotes                         */
-
-static struct rc_map_table rc5_tv[] = {
-	/* Keys 0 to 9 */
-	{ 0x00, KEY_0 },
-	{ 0x01, KEY_1 },
-	{ 0x02, KEY_2 },
-	{ 0x03, KEY_3 },
-	{ 0x04, KEY_4 },
-	{ 0x05, KEY_5 },
-	{ 0x06, KEY_6 },
-	{ 0x07, KEY_7 },
-	{ 0x08, KEY_8 },
-	{ 0x09, KEY_9 },
-
-	{ 0x0b, KEY_CHANNEL },		/* channel / program (japan: 11) */
-	{ 0x0c, KEY_POWER },		/* standby */
-	{ 0x0d, KEY_MUTE },		/* mute / demute */
-	{ 0x0f, KEY_TV },		/* display */
-	{ 0x10, KEY_VOLUMEUP },
-	{ 0x11, KEY_VOLUMEDOWN },
-	{ 0x12, KEY_BRIGHTNESSUP },
-	{ 0x13, KEY_BRIGHTNESSDOWN },
-	{ 0x1e, KEY_SEARCH },		/* search + */
-	{ 0x20, KEY_CHANNELUP },	/* channel / program + */
-	{ 0x21, KEY_CHANNELDOWN },	/* channel / program - */
-	{ 0x22, KEY_CHANNEL },		/* alt / channel */
-	{ 0x23, KEY_LANGUAGE },		/* 1st / 2nd language */
-	{ 0x26, KEY_SLEEP },		/* sleeptimer */
-	{ 0x2e, KEY_MENU },		/* 2nd controls (USA: menu) */
-	{ 0x30, KEY_PAUSE },
-	{ 0x32, KEY_REWIND },
-	{ 0x33, KEY_GOTO },
-	{ 0x35, KEY_PLAY },
-	{ 0x36, KEY_STOP },
-	{ 0x37, KEY_RECORD },		/* recording */
-	{ 0x3c, KEY_TEXT },		/* teletext submode (Japan: 12) */
-	{ 0x3d, KEY_SUSPEND },		/* system standby */
-
-};
-
-static struct rc_map_list rc5_tv_map = {
-	.map = {
-		.scan    = rc5_tv,
-		.size    = ARRAY_SIZE(rc5_tv),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
-		.name    = RC_MAP_RC5_TV,
-	}
-};
-
-static int __init init_rc_map_rc5_tv(void)
-{
-	return rc_map_register(&rc5_tv_map);
-}
-
-static void __exit exit_rc_map_rc5_tv(void)
-{
-	rc_map_unregister(&rc5_tv_map);
-}
-
-module_init(init_rc_map_rc5_tv)
-module_exit(exit_rc_map_rc5_tv)
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index b18373a..baa3e47 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -55,10 +55,6 @@
 static int debug;
 module_param(debug, int, 0644);    /* debug level (0,1,2) */
 
-static int hauppauge;
-module_param(hauppauge, int, 0644);    /* Choose Hauppauge remote */
-MODULE_PARM_DESC(hauppauge, "Specify Hauppauge remote: 0=black, 1=grey (defaults to 0)");
-
 
 #define MODULE_NAME "ir-kbd-i2c"
 #define dprintk(level, fmt, arg...)	if (debug >= level) \
@@ -105,10 +101,6 @@ static int get_key_haup_common(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw,
 		/* invalid key press */
 		return 0;
 
-	if (dev!=0x1e && dev!=0x1f)
-		/* not a hauppauge remote */
-		return 0;
-
 	if (!range)
 		code += 64;
 
@@ -299,11 +291,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		name        = "Hauppauge";
 		ir->get_key = get_key_haup;
 		rc_type     = RC_TYPE_RC5;
-		if (hauppauge == 1) {
-			ir_codes    = RC_MAP_HAUPPAUGE;
-		} else {
-			ir_codes    = RC_MAP_RC5_TV;
-		}
+		ir_codes    = RC_MAP_HAUPPAUGE;
 		break;
 	case 0x30:
 		name        = "KNC One";
@@ -327,7 +315,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		name        = "Hauppauge/Zilog Z8";
 		ir->get_key = get_key_haup_xvr;
 		rc_type     = RC_TYPE_RC5;
-		ir_codes    = hauppauge ? RC_MAP_HAUPPAUGE : RC_MAP_RC5_TV;
+		ir_codes    = RC_MAP_HAUPPAUGE;
 		break;
 	}
 
diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index 3c89d6f..d47f41a 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -205,8 +205,7 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 		break;
 	case IVTV_HW_I2C_IR_RX_HAUP_EXT:
 	case IVTV_HW_I2C_IR_RX_HAUP_INT:
-		/* Default to old black remote */
-		init_data->ir_codes = RC_MAP_RC5_TV;
+		init_data->ir_codes = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP;
 		init_data->type = RC_TYPE_RC5;
 		init_data->name = itv->card_name;
