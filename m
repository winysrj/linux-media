Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51332 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab0I2VDy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Sep 2010 17:03:54 -0400
Received: by yxp4 with SMTP id 4so407174yxp.19
        for <linux-media@vger.kernel.org>; Wed, 29 Sep 2010 14:03:53 -0700 (PDT)
Message-ID: <4CA3A9B3.6080703@gmail.com>
Date: Wed, 29 Sep 2010 18:03:47 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: Giorgio <mywing81@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: ASUS My Cinema-P7131 Hybrid (saa7134) and slow IR
References: <AANLkTik4NpV5C=Ct_8u=awZ-tthDC=ORJj8u1DHTNu+q@mail.gmail.com> <4CA37755.5060608@redhat.com>
In-Reply-To: <4CA37755.5060608@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 29-09-2010 14:28, Mauro Carvalho Chehab escreveu:
> Em 29-09-2010 14:06, Giorgio escreveu:
>> Hello,
>>
>> I have an Asus P7131 Hybrid card, and it works like a charm with
>> Ubuntu 8.04 and stock kernel 2.6.24. But, after upgrading my system to
>> Ubuntu 10.04 x86-64, I noticed that the remote control was quite slow
>> to respond. Sometimes the keypresses aren't recognized, and you have
>> to keep pressing the same button two or three times until it works.
>> The remote feels slow, not very responsive.
>> So, to investigate the issue, I loaded the ir-common module with
>> debug=1 and looked at the logs. They report lots of "ir-common:
>> spurious timer_end". The funny thing is, I have tried the Ubuntu 10.04
>> i386 livecd (with the same kernel) and the problem is not present
>> there.
> 
>> Sep 27 15:48:59 holden-desktop kernel: [  256.770031] ir-common: spurious timer_end
>> Sep 27 15:48:59 holden-desktop kernel: [  256.880030] ir-common: spurious timer_end
> 
> It is using the old RC support. This support will be removed soon, so, the
> better is to convert it to use the new IR core, and fix a bug there, if is
> there any.
> 
> Please apply the attached patch (it is against my -git tree, but it will probably
> apply fine if you have a new kernel).
> 
> You should notice that the RC_MAP_ASUS_PC39 table is not ready for the new IR
> infrastructure. So, you'll need to enable ir-core debug, and check what scancodes are
> detected there. Probably, all we need is to add the RC5 address to all codes at the table.
> 

Giorgio,

Based on the pastebin you posted via IRC, this is likely the patch you
need to also change your current keytable to work with the new RC core.

Cheers,
Mauro

---

saa7134: port Asus P7131 Hybrid to use the new rc-core

The rc map table were corrected thanks to Giorgio input.

Thanks-to: Giorgio <mywing81@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/IR/keymaps/rc-asus-pc39.c b/drivers/media/IR/keymaps/rc-asus-pc39.c
index 2aa068c..c39c892 100644
--- a/drivers/media/IR/keymaps/rc-asus-pc39.c
+++ b/drivers/media/IR/keymaps/rc-asus-pc39.c
@@ -20,56 +20,56 @@
 
 static struct ir_scancode asus_pc39[] = {
 	/* Keys 0 to 9 */
-	{ 0x15, KEY_0 },
-	{ 0x29, KEY_1 },
-	{ 0x2d, KEY_2 },
-	{ 0x2b, KEY_3 },
-	{ 0x09, KEY_4 },
-	{ 0x0d, KEY_5 },
-	{ 0x0b, KEY_6 },
-	{ 0x31, KEY_7 },
-	{ 0x35, KEY_8 },
-	{ 0x33, KEY_9 },
+	{ 0x0815, KEY_0 },
+	{ 0x0829, KEY_1 },
+	{ 0x082d, KEY_2 },
+	{ 0x082b, KEY_3 },
+	{ 0x0809, KEY_4 },
+	{ 0x080d, KEY_5 },
+	{ 0x080b, KEY_6 },
+	{ 0x0831, KEY_7 },
+	{ 0x0835, KEY_8 },
+	{ 0x0833, KEY_9 },
 
-	{ 0x3e, KEY_RADIO },		/* radio */
-	{ 0x03, KEY_MENU },		/* dvd/menu */
-	{ 0x2a, KEY_VOLUMEUP },
-	{ 0x19, KEY_VOLUMEDOWN },
-	{ 0x37, KEY_UP },
-	{ 0x3b, KEY_DOWN },
-	{ 0x27, KEY_LEFT },
-	{ 0x2f, KEY_RIGHT },
-	{ 0x25, KEY_VIDEO },		/* video */
-	{ 0x39, KEY_AUDIO },		/* music */
+	{ 0x083e, KEY_RADIO },		/* radio */
+	{ 0x0803, KEY_MENU },		/* dvd/menu */
+	{ 0x082a, KEY_VOLUMEUP },
+	{ 0x0819, KEY_VOLUMEDOWN },
+	{ 0x0837, KEY_UP },
+	{ 0x083b, KEY_DOWN },
+	{ 0x0827, KEY_LEFT },
+	{ 0x082f, KEY_RIGHT },
+	{ 0x0825, KEY_VIDEO },		/* video */
+	{ 0x0839, KEY_AUDIO },		/* music */
 
-	{ 0x21, KEY_TV },		/* tv */
-	{ 0x1d, KEY_EXIT },		/* back */
-	{ 0x0a, KEY_CHANNELUP },	/* channel / program + */
-	{ 0x1b, KEY_CHANNELDOWN },	/* channel / program - */
-	{ 0x1a, KEY_ENTER },		/* enter */
+	{ 0x0821, KEY_TV },		/* tv */
+	{ 0x081d, KEY_EXIT },		/* back */
+	{ 0x080a, KEY_CHANNELUP },	/* channel / program + */
+	{ 0x081b, KEY_CHANNELDOWN },	/* channel / program - */
+	{ 0x081a, KEY_ENTER },		/* enter */
 
-	{ 0x06, KEY_PAUSE },		/* play/pause */
-	{ 0x1e, KEY_PREVIOUS },		/* rew */
-	{ 0x26, KEY_NEXT },		/* forward */
-	{ 0x0e, KEY_REWIND },		/* backward << */
-	{ 0x3a, KEY_FASTFORWARD },	/* forward >> */
-	{ 0x36, KEY_STOP },
-	{ 0x2e, KEY_RECORD },		/* recording */
-	{ 0x16, KEY_POWER },		/* the button that reads "close" */
+	{ 0x0806, KEY_PAUSE },		/* play/pause */
+	{ 0x081e, KEY_PREVIOUS },	/* rew */
+	{ 0x0826, KEY_NEXT },		/* forward */
+	{ 0x080e, KEY_REWIND },		/* backward << */
+	{ 0x083a, KEY_FASTFORWARD },	/* forward >> */
+	{ 0x0836, KEY_STOP },
+	{ 0x082e, KEY_RECORD },		/* recording */
+	{ 0x0816, KEY_POWER },		/* the button that reads "close" */
 
-	{ 0x11, KEY_ZOOM },		/* full screen */
-	{ 0x13, KEY_MACRO },		/* recall */
-	{ 0x23, KEY_HOME },		/* home */
-	{ 0x05, KEY_PVR },		/* picture */
-	{ 0x3d, KEY_MUTE },		/* mute */
-	{ 0x01, KEY_DVD },		/* dvd */
+	{ 0x0811, KEY_ZOOM },		/* full screen */
+	{ 0x0813, KEY_MACRO },		/* recall */
+	{ 0x0823, KEY_HOME },		/* home */
+	{ 0x0805, KEY_PVR },		/* picture */
+	{ 0x083d, KEY_MUTE },		/* mute */
+	{ 0x0801, KEY_DVD },		/* dvd */
 };
 
 static struct rc_keymap asus_pc39_map = {
 	.map = {
 		.scan    = asus_pc39,
 		.size    = ARRAY_SIZE(asus_pc39),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.ir_type = IR_TYPE_RC5,
 		.name    = RC_MAP_ASUS_PC39,
 	}
 };
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index a6ac462..e3a4395 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -772,8 +772,10 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
 	case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
 		ir_codes     = RC_MAP_ASUS_PC39;
-		mask_keydown = 0x0040000;
-		rc5_gpio = 1;
+		mask_keydown = 0x0040000;	/* Enable GPIO18 line on both edges */
+		mask_keyup   = 0x0040000;
+		mask_keycode = 0xffff;
+		raw_decode   = 1;
 		break;
 	case SAA7134_BOARD_ENCORE_ENLTV:
 	case SAA7134_BOARD_ENCORE_ENLTV_FM:
