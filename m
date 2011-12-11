Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.seznam.cz ([77.75.72.43]:60632 "EHLO smtp1.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab1LKXpM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Dec 2011 18:45:12 -0500
Message-ID: <4EE53D86.2000108@email.cz>
Date: Mon, 12 Dec 2011 00:32:22 +0100
From: =?UTF-8?B?TWlyZWsgU2x1Z2XFiA==?= <thunder.m@email.cz>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
Subject: Fix radio issues and few minor bugs.
References: <4EE0C6E2.4090103@email.cz> <4EE11C90.2040108@redhat.com>
In-Reply-To: <4EE11C90.2040108@redhat.com>
Content-Type: multipart/mixed; boundary="------------000309010108040803090306"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000309010108040803090306
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi, i have few extra patches against current git, kernel 3.2.0rc-1, 
primary they should fix radio issues with some XC4000 and XC2028 tuners, 
but there are also some minor bug fixes. Number 7 is not my work, it is 
Istvan Varga patch.

M. Slugeň

--------------000309010108040803090306
Content-Type: text/x-patch;
 name="0001-Update-xc4000-tuner-definition-number-81-is-already-.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename*0="0001-Update-xc4000-tuner-definition-number-81-is-already-.pa";
 filename*1="tch"

>From 6192e1b178814c7a42f9a1bc8b438024513f220f Mon Sep 17 00:00:00 2001
From: Miroslav Slugeň <thunder.m@email.cz>
Date: Sun, 11 Dec 2011 22:47:32 +0100
Subject: [PATCH 1/7] Update xc4000 tuner definition, number 81 is already in use by TUNER_PARTSNIC_PTI_5NF05

---
 include/media/tuner.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/media/tuner.h b/include/media/tuner.h
index 89c290b..29e1920 100644
--- a/include/media/tuner.h
+++ b/include/media/tuner.h
@@ -127,7 +127,6 @@
 #define TUNER_PHILIPS_FMD1216MEX_MK3	78
 #define TUNER_PHILIPS_FM1216MK5		79
 #define TUNER_PHILIPS_FQ1216LME_MK3	80	/* Active loopthrough, no FM */
-#define TUNER_XC4000			81	/* Xceive Silicon Tuner */
 
 #define TUNER_PARTSNIC_PTI_5NF05	81
 #define TUNER_PHILIPS_CU1216L           82
@@ -136,6 +135,8 @@
 #define TUNER_PHILIPS_FQ1236_MK5	85	/* NTSC, TDA9885, no FM radio */
 #define TUNER_TENA_TNF_5337		86
 
+#define TUNER_XC4000			87	/* Xceive Silicon Tuner */
+
 /* tv card specific */
 #define TDA9887_PRESENT 		(1<<0)
 #define TDA9887_PORT1_INACTIVE 		(1<<1)
-- 
1.7.2.3


--------------000309010108040803090306
Content-Type: text/x-patch;
 name="0002-Put-analog-radio-and-analog-TV-together-both-require.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename*0="0002-Put-analog-radio-and-analog-TV-together-both-require.pa";
 filename*1="tch"

>From b7b8a326eaf65e404f9483e3d918d3af3a8d9531 Mon Sep 17 00:00:00 2001
From: Miroslav Slugeň <thunder.m@email.cz>
Date: Sun, 11 Dec 2011 22:56:15 +0100
Subject: [PATCH 2/7] Put analog radio and analog TV together both required same offset.

---
 drivers/media/common/tuners/tuner-xc2028.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index 3acbaa0..95b8c79 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -942,12 +942,10 @@ static int generic_set_freq(struct dvb_frontend *fe, u32 freq /* in HZ */,
 	 */
 	switch (new_type) {
 	case V4L2_TUNER_ANALOG_TV:
+	case V4L2_TUNER_RADIO:
 		rc = send_seq(priv, {0x00, 0x00});
 
-		/* Analog mode requires offset = 0 */
-		break;
-	case V4L2_TUNER_RADIO:
-		/* Radio mode requires offset = 0 */
+		/* Analog modes requires offset = 0 */
 		break;
 	case V4L2_TUNER_DIGITAL_TV:
 		/*
-- 
1.7.2.3


--------------000309010108040803090306
Content-Type: text/x-patch;
 name="0003-Fix-possible-null-dereference-for-Leadtek-DTV-3200H-.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename*0="0003-Fix-possible-null-dereference-for-Leadtek-DTV-3200H-.pa";
 filename*1="tch"

>From 173991a979f5f75dbbaf38f1b053d50043a40729 Mon Sep 17 00:00:00 2001
From: Miroslav Slugeň <thunder.m@email.cz>
Date: Sun, 11 Dec 2011 22:57:58 +0100
Subject: [PATCH 3/7] Fix possible null dereference for Leadtek DTV 3200H XC4000 tuner when no firmware file available.

---
 drivers/media/video/cx23885/cx23885-dvb.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index bcb45be..f0482b2 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -940,6 +940,11 @@ static int dvb_register(struct cx23885_tsport *port)
 
 			fe = dvb_attach(xc4000_attach, fe0->dvb.frontend,
 					&dev->i2c_bus[1].i2c_adap, &cfg);
+			if (!fe) {
+				printk(KERN_ERR "%s/2: xc4000 attach failed\n",
+				       dev->name);
+				goto frontend_detach;
+			}
 		}
 		break;
 	case CX23885_BOARD_TBS_6920:
-- 
1.7.2.3


--------------000309010108040803090306
Content-Type: text/x-patch;
 name="0004-All-radio-tuners-in-cx88-driver-using-same-address-f.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename*0="0004-All-radio-tuners-in-cx88-driver-using-same-address-f.pa";
 filename*1="tch"

>From bfd6d08e3756fb0d4ea917cb8f9379b2ba9c5087 Mon Sep 17 00:00:00 2001
From: Miroslav Slugeň <thunder.m@email.cz>
Date: Sun, 11 Dec 2011 23:00:06 +0100
Subject: [PATCH 4/7] All radio tuners in cx88 driver using same address for radio and tuner, so there is no need to probe
 it twice for same tuner and we can use radio_type UNSET, this also fix broken radio since kernel 2.6.39-rc1
 for those tuners.

---
 drivers/media/video/cx88/cx88-cards.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-cards.c b/drivers/media/video/cx88/cx88-cards.c
index 0d719fa..3929d93 100644
--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -1573,8 +1573,8 @@ static const struct cx88_board cx88_boards[] = {
 		.name           = "Pinnacle Hybrid PCTV",
 		.tuner_type     = TUNER_XC2028,
 		.tuner_addr     = 0x61,
-		.radio_type     = TUNER_XC2028,
-		.radio_addr     = 0x61,
+		.radio_type     = UNSET,
+		.radio_addr     = ADDR_UNSET,
 		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
@@ -1611,8 +1611,8 @@ static const struct cx88_board cx88_boards[] = {
 		.name           = "Leadtek TV2000 XP Global",
 		.tuner_type     = TUNER_XC2028,
 		.tuner_addr     = 0x61,
-		.radio_type     = TUNER_XC2028,
-		.radio_addr     = 0x61,
+		.radio_type     = UNSET,
+		.radio_addr     = ADDR_UNSET,
 		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
@@ -2043,8 +2043,8 @@ static const struct cx88_board cx88_boards[] = {
 		.name           = "Terratec Cinergy HT PCI MKII",
 		.tuner_type     = TUNER_XC2028,
 		.tuner_addr     = 0x61,
-		.radio_type     = TUNER_XC2028,
-		.radio_addr     = 0x61,
+		.radio_type     = UNSET,
+		.radio_addr     = ADDR_UNSET,
 		.input          = { {
 			.type   = CX88_VMUX_TELEVISION,
 			.vmux   = 0,
@@ -2082,9 +2082,9 @@ static const struct cx88_board cx88_boards[] = {
 	[CX88_BOARD_WINFAST_DTV1800H] = {
 		.name           = "Leadtek WinFast DTV1800 Hybrid",
 		.tuner_type     = TUNER_XC2028,
-		.radio_type     = TUNER_XC2028,
+		.radio_type     = UNSET,
 		.tuner_addr     = 0x61,
-		.radio_addr     = 0x61,
+		.radio_addr     = ADDR_UNSET,
 		/*
 		 * GPIO setting
 		 *
@@ -2123,9 +2123,9 @@ static const struct cx88_board cx88_boards[] = {
 	[CX88_BOARD_WINFAST_DTV1800H_XC4000] = {
 		.name		= "Leadtek WinFast DTV1800 H (XC4000)",
 		.tuner_type	= TUNER_XC4000,
-		.radio_type	= TUNER_XC4000,
+		.radio_type	= UNSET,
 		.tuner_addr	= 0x61,
-		.radio_addr	= 0x61,
+		.radio_addr	= ADDR_UNSET,
 		/*
 		 * GPIO setting
 		 *
@@ -2164,9 +2164,9 @@ static const struct cx88_board cx88_boards[] = {
 	[CX88_BOARD_WINFAST_DTV2000H_PLUS] = {
 		.name		= "Leadtek WinFast DTV2000 H PLUS",
 		.tuner_type	= TUNER_XC4000,
-		.radio_type	= TUNER_XC4000,
+		.radio_type	= UNSET,
 		.tuner_addr	= 0x61,
-		.radio_addr	= 0x61,
+		.radio_addr	= ADDR_UNSET,
 		/*
 		 * GPIO
 		 *   2: 1: mute audio
-- 
1.7.2.3


--------------000309010108040803090306
Content-Type: text/x-patch;
 name="0005-Fix-mode-mask-setting-in-tuner_core-for-radio-only-t.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename*0="0005-Fix-mode-mask-setting-in-tuner_core-for-radio-only-t.pa";
 filename*1="tch"

>From e8f226b66dc58399a8daf808ba204ec9562abd85 Mon Sep 17 00:00:00 2001
From: Miroslav Slugeň <thunder.m@email.cz>
Date: Mon, 12 Dec 2011 00:16:22 +0100
Subject: [PATCH 5/7] Fix mode mask setting in tuner_core for radio only tuners.

---
 drivers/media/video/tuner-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 11cc980..8e7e769 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -317,13 +317,13 @@ static void set_type(struct i2c_client *c, unsigned int type,
 		if (!dvb_attach(tea5767_attach, &t->fe,
 				t->i2c->adapter, t->i2c->addr))
 			goto attach_failed;
-		t->mode_mask = T_RADIO;
+		new_mode_mask = T_RADIO;
 		break;
 	case TUNER_TEA5761:
 		if (!dvb_attach(tea5761_attach, &t->fe,
 				t->i2c->adapter, t->i2c->addr))
 			goto attach_failed;
-		t->mode_mask = T_RADIO;
+		new_mode_mask = T_RADIO;
 		break;
 	case TUNER_PHILIPS_FMD1216ME_MK3:
 		buffer[0] = 0x0b;
-- 
1.7.2.3


--------------000309010108040803090306
Content-Type: text/x-patch;
 name="0006-All-radio-tuners-in-cx83885-driver-using-same-addres.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename*0="0006-All-radio-tuners-in-cx83885-driver-using-same-addres.pa";
 filename*1="tch"

>From 57d785e912c369f2ace56bd5000f99f968d87a9e Mon Sep 17 00:00:00 2001
From: Miroslav Slugeň <thunder.m@email.cz>
Date: Mon, 12 Dec 2011 00:19:34 +0100
Subject: [PATCH 6/7] All radio tuners in cx83885 driver using same address for radio and tuner, so there is no need to probe
 it twice for same tuner and we can use radio_type UNSET. Be aware radio support in cx23885 is not yet
 completed, so this is only minor fix for future support.

---
 drivers/media/video/cx23885/cx23885-cards.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index c3cf089..187c462 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -213,8 +213,8 @@ struct cx23885_board cx23885_boards[] = {
 		.portc		= CX23885_MPEG_DVB,
 		.tuner_type	= TUNER_XC4000,
 		.tuner_addr	= 0x61,
-		.radio_type	= TUNER_XC4000,
-		.radio_addr	= 0x61,
+		.radio_type	= UNSET,
+		.radio_addr	= ADDR_UNSET,
 		.input		= {{
 			.type	= CX23885_VMUX_TELEVISION,
 			.vmux	= CX25840_VIN2_CH1 |
-- 
1.7.2.3


--------------000309010108040803090306
Content-Type: text/x-patch;
 name="0007-Add-support-for-two-new-types-of-Leadtek-Winfast-TV-.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename*0="0007-Add-support-for-two-new-types-of-Leadtek-Winfast-TV-.pa";
 filename*1="tch"

>From f21b0f83b9b51da1664ae0efd4f0d412d681e6fa Mon Sep 17 00:00:00 2001
From: Miroslav Slugeň <thunder.m@email.cz>
Date: Mon, 12 Dec 2011 00:20:24 +0100
Subject: [PATCH 7/7] Add support for two new types of Leadtek Winfast TV 2000XP tuner, author of
 this patch is Istvan Varga. Only resending current reformated version against
 actual git.

---
 drivers/media/video/cx88/cx88-cards.c |   91 +++++++++++++++++++++++++++++++++
 drivers/media/video/cx88/cx88-input.c |    4 ++
 drivers/media/video/cx88/cx88.h       |    2 +
 3 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-cards.c b/drivers/media/video/cx88/cx88-cards.c
index 3929d93..dca369d 100644
--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -1643,6 +1643,78 @@ static const struct cx88_board cx88_boards[] = {
 			.gpio3  = 0x0000,
 		},
 	},
+	[CX88_BOARD_WINFAST_TV2000_XP_GLOBAL_6F36] = {
+		.name           = "Leadtek TV2000 XP Global (SC4100)",
+		.tuner_type     = TUNER_XC4000,
+		.tuner_addr     = 0x61,
+		.radio_type     = UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.input          = { {
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 0,
+			.gpio0  = 0x0400,       /* pin 2 = 0 */
+			.gpio1  = 0x0000,
+			.gpio2  = 0x0C04,       /* pin 18 = 1, pin 19 = 0 */
+			.gpio3  = 0x0000,
+		}, {
+			.type   = CX88_VMUX_COMPOSITE1,
+			.vmux   = 1,
+			.gpio0  = 0x0400,       /* pin 2 = 0 */
+			.gpio1  = 0x0000,
+			.gpio2  = 0x0C0C,       /* pin 18 = 1, pin 19 = 1 */
+			.gpio3  = 0x0000,
+		}, {
+			.type   = CX88_VMUX_SVIDEO,
+			.vmux   = 2,
+			.gpio0  = 0x0400,       /* pin 2 = 0 */
+			.gpio1  = 0x0000,
+			.gpio2  = 0x0C0C,       /* pin 18 = 1, pin 19 = 1 */
+			.gpio3  = 0x0000,
+		} },
+		.radio = {
+			.type   = CX88_RADIO,
+			.gpio0  = 0x0400,        /* pin 2 = 0 */
+			.gpio1  = 0x0000,
+			.gpio2  = 0x0C00,       /* pin 18 = 0, pin 19 = 0 */
+			.gpio3  = 0x0000,
+		},
+	},
+	[CX88_BOARD_WINFAST_TV2000_XP_GLOBAL_6F43] = {
+		.name           = "Leadtek TV2000 XP Global (XC4100)",
+		.tuner_type     = TUNER_XC4000,
+		.tuner_addr     = 0x61,
+		.radio_type     = UNSET,
+		.radio_addr     = ADDR_UNSET,
+		.input          = { {
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 0,
+			.gpio0  = 0x0400,       /* pin 2 = 0 */
+			.gpio1  = 0x6040,       /* pin 14 = 1, pin 13 = 0 */
+			.gpio2  = 0x0000,
+			.gpio3  = 0x0000,
+		}, {
+			.type   = CX88_VMUX_COMPOSITE1,
+			.vmux   = 1,
+			.gpio0  = 0x0400,       /* pin 2 = 0 */
+			.gpio1  = 0x6060,       /* pin 14 = 1, pin 13 = 1 */
+			.gpio2  = 0x0000,
+			.gpio3  = 0x0000,
+		}, {
+			.type   = CX88_VMUX_SVIDEO,
+			.vmux   = 2,
+			.gpio0  = 0x0400,       /* pin 2 = 0 */
+			.gpio1  = 0x6060,       /* pin 14 = 1, pin 13 = 1 */
+			.gpio2  = 0x0000,
+			.gpio3  = 0x0000,
+		} },
+		.radio = {
+			.type   = CX88_RADIO,
+			.gpio0  = 0x0400,        /* pin 2 = 0 */
+			.gpio1  = 0x6000,        /* pin 14 = 1, pin 13 = 0 */
+			.gpio2  = 0x0000,
+			.gpio3  = 0x0000,
+		},
+	},
 	[CX88_BOARD_POWERCOLOR_REAL_ANGEL] = {
 		.name           = "PowerColor RA330",	/* Long names may confuse LIRC. */
 		.tuner_type     = TUNER_XC2028,
@@ -2719,6 +2791,21 @@ static const struct cx88_subid cx88_subids[] = {
 		.subdevice = 0x6618,
 		.card      = CX88_BOARD_WINFAST_TV2000_XP_GLOBAL,
 	}, {
+		/* TV2000 XP Global [107d:6618] */
+		.subvendor = 0x107d,
+		.subdevice = 0x6619,
+		.card      = CX88_BOARD_WINFAST_TV2000_XP_GLOBAL,
+	}, {
+		/* WinFast TV2000 XP Global with XC4000 tuner */
+		.subvendor = 0x107d,
+		.subdevice = 0x6f36,
+		.card      = CX88_BOARD_WINFAST_TV2000_XP_GLOBAL_6F36,
+	}, {
+		/* WinFast TV2000 XP Global with XC4000 tuner and different GPIOs */
+		.subvendor = 0x107d,
+		.subdevice = 0x6f43,
+		.card      = CX88_BOARD_WINFAST_TV2000_XP_GLOBAL_6F43,
+	}, {
 		.subvendor = 0xb034,
 		.subdevice = 0x3034,
 		.card      = CX88_BOARD_PROF_7301,
@@ -3075,6 +3162,8 @@ static int cx88_xc4000_tuner_callback(struct cx88_core *core,
 	switch (core->boardnr) {
 	case CX88_BOARD_WINFAST_DTV1800H_XC4000:
 	case CX88_BOARD_WINFAST_DTV2000H_PLUS:
+	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL_6F36:
+	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL_6F43:
 		return cx88_xc4000_winfast2000h_plus_callback(core,
 							      command, arg);
 	}
@@ -3250,6 +3339,8 @@ static void cx88_card_setup_pre_i2c(struct cx88_core *core)
 
 	case CX88_BOARD_WINFAST_DTV1800H_XC4000:
 	case CX88_BOARD_WINFAST_DTV2000H_PLUS:
+	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL_6F36:
+	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL_6F43:
 		cx88_xc4000_winfast2000h_plus_callback(core,
 						       XC4000_TUNER_RESET, 0);
 		break;
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index e614201..ebf448c 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -103,6 +103,8 @@ static void cx88_ir_handle_key(struct cx88_IR *ir)
 	case CX88_BOARD_WINFAST_DTV1800H_XC4000:
 	case CX88_BOARD_WINFAST_DTV2000H_PLUS:
 	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
+	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL_6F36:
+	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL_6F43:
 		gpio = (gpio & 0x6ff) | ((cx_read(MO_GP1_IO) << 8) & 0x900);
 		auxgpio = gpio;
 		break;
@@ -302,6 +304,8 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	case CX88_BOARD_WINFAST2000XP_EXPERT:
 	case CX88_BOARD_WINFAST_DTV1000:
 	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
+	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL_6F36:
+	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL_6F43:
 		ir_codes = RC_MAP_WINFAST;
 		ir->gpio_addr = MO_GP0_IO;
 		ir->mask_keycode = 0x8f8;
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index fa8d307..c9659de 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -244,6 +244,8 @@ extern const struct sram_channel const cx88_sram_channels[];
 #define CX88_BOARD_TEVII_S464              86
 #define CX88_BOARD_WINFAST_DTV2000H_PLUS   87
 #define CX88_BOARD_WINFAST_DTV1800H_XC4000 88
+#define CX88_BOARD_WINFAST_TV2000_XP_GLOBAL_6F36 89
+#define CX88_BOARD_WINFAST_TV2000_XP_GLOBAL_6F43 90
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,
-- 
1.7.2.3


--------------000309010108040803090306
Content-Type: text/x-patch;
 name="0000-cover-letter.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="0000-cover-letter.patch"

>From f21b0f83b9b51da1664ae0efd4f0d412d681e6fa Mon Sep 17 00:00:00 2001
From: Miroslav Slugeň <thunder.m@email.cz>
Date: Mon, 12 Dec 2011 00:20:45 +0100
Subject: [PATCH 0/7] *** SUBJECT HERE ***

*** BLURB HERE ***

Miroslav Slugeň (7):
  Update xc4000 tuner definition, number 81 is already in use by
    TUNER_PARTSNIC_PTI_5NF05
  Put analog radio and analog TV together both required same offset.
  Fix possible null dereference for Leadtek DTV 3200H XC4000 tuner when
    no firmware file available.
  All radio tuners in cx88 driver using same address for radio and
    tuner, so there is no need to probe     it twice for same tuner and
    we can use radio_type UNSET, this also fix broken radio since
    kernel 2.6.39-rc1     for those tuners.
  Fix mode mask setting in tuner_core for radio only tuners.
  All radio tuners in cx83885 driver using same address for radio and
    tuner, so there is no need to probe     it twice for same tuner and
    we can use radio_type UNSET. Be aware radio support in cx23885 is
    not yet     completed, so this is only minor fix for future
    support.
  Add support for two new types of Leadtek Winfast TV 2000XP tuner,
    author of     this patch is Istvan Varga. Only resending current
    reformated version against     actual git.

 drivers/media/common/tuners/tuner-xc2028.c  |    6 +-
 drivers/media/video/cx23885/cx23885-cards.c |    4 +-
 drivers/media/video/cx23885/cx23885-dvb.c   |    5 +
 drivers/media/video/cx88/cx88-cards.c       |  115 ++++++++++++++++++++++++---
 drivers/media/video/cx88/cx88-input.c       |    4 +
 drivers/media/video/cx88/cx88.h             |    2 +
 drivers/media/video/tuner-core.c            |    4 +-
 include/media/tuner.h                       |    3 +-
 8 files changed, 122 insertions(+), 21 deletions(-)

-- 
1.7.2.3


--------------000309010108040803090306--
