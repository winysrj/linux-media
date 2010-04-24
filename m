Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:34937 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab0DXVOF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Apr 2010 17:14:05 -0400
Subject: [PATCH 1/4] ir-core: remove IR_TYPE_PD
To: mchehab@redhat.com
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org
Date: Sat, 24 Apr 2010 23:14:00 +0200
Message-ID: <20100424211400.11570.90001.stgit@localhost.localdomain>
In-Reply-To: <20100424210843.11570.82007.stgit@localhost.localdomain>
References: <20100424210843.11570.82007.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pulse-distance is not a protocol, it is a line coding (used by some protocols,
like NEC). Looking at the uses of IR_TYPE_PD, the real protocol seems to be
NEC in all cases (drivers/media/video/cx88/cx88-input.c is the only user).

So, remove IR_TYPE_PD while it is still easy to do so.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/IR/ir-sysfs.c           |    6 ------
 drivers/media/video/cx88/cx88-input.c |    8 ++++----
 include/media/ir-kbd-i2c.h            |    2 +-
 include/media/rc-map.h                |    9 ++++-----
 4 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index 501dc2f..facca11 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -56,8 +56,6 @@ static ssize_t show_protocol(struct device *d,
 		s = "Unknown";
 	else if (ir_type == IR_TYPE_RC5)
 		s = "rc-5";
-	else if (ir_type == IR_TYPE_PD)
-		s = "pulse-distance";
 	else if (ir_type == IR_TYPE_NEC)
 		s = "nec";
 	else if (ir_type == IR_TYPE_RC6)
@@ -99,8 +97,6 @@ static ssize_t store_protocol(struct device *d,
 	while ((buf = strsep((char **) &data, " \n")) != NULL) {
 		if (!strcasecmp(buf, "rc-5") || !strcasecmp(buf, "rc5"))
 			ir_type |= IR_TYPE_RC5;
-		if (!strcasecmp(buf, "pd") || !strcasecmp(buf, "pulse-distance"))
-			ir_type |= IR_TYPE_PD;
 		if (!strcasecmp(buf, "nec"))
 			ir_type |= IR_TYPE_NEC;
 		if (!strcasecmp(buf, "jvc"))
@@ -145,8 +141,6 @@ static ssize_t show_supported_protocols(struct device *d,
 		buf += sprintf(buf, "unknown ");
 	if (ir_dev->props->allowed_protos & IR_TYPE_RC5)
 		buf += sprintf(buf, "rc-5 ");
-	if (ir_dev->props->allowed_protos & IR_TYPE_PD)
-		buf += sprintf(buf, "pulse-distance ");
 	if (ir_dev->props->allowed_protos & IR_TYPE_NEC)
 		buf += sprintf(buf, "nec ");
 	if (buf == orgbuf)
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index 5e60b48..0de9bdf 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -271,7 +271,7 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		break;
 	case CX88_BOARD_TERRATEC_CINERGY_1400_DVB_T1:
 		ir_codes = RC_MAP_CINERGY_1400;
-		ir_type = IR_TYPE_PD;
+		ir_type = IR_TYPE_NEC;
 		ir->sampling = 0xeb04; /* address */
 		break;
 	case CX88_BOARD_HAUPPAUGE:
@@ -374,18 +374,18 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	case CX88_BOARD_PROF_7301:
 	case CX88_BOARD_PROF_6200:
 		ir_codes = RC_MAP_TBS_NEC;
-		ir_type = IR_TYPE_PD;
+		ir_type = IR_TYPE_NEC;
 		ir->sampling = 0xff00; /* address */
 		break;
 	case CX88_BOARD_TEVII_S460:
 	case CX88_BOARD_TEVII_S420:
 		ir_codes = RC_MAP_TEVII_NEC;
-		ir_type = IR_TYPE_PD;
+		ir_type = IR_TYPE_NEC;
 		ir->sampling = 0xff00; /* address */
 		break;
 	case CX88_BOARD_DNTV_LIVE_DVB_T_PRO:
 		ir_codes         = RC_MAP_DNTV_LIVE_DVBT_PRO;
-		ir_type          = IR_TYPE_PD;
+		ir_type          = IR_TYPE_NEC;
 		ir->sampling     = 0xff00; /* address */
 		break;
 	case CX88_BOARD_NORWOOD_MICRO:
diff --git a/include/media/ir-kbd-i2c.h b/include/media/ir-kbd-i2c.h
index 057ff64..0506e45 100644
--- a/include/media/ir-kbd-i2c.h
+++ b/include/media/ir-kbd-i2c.h
@@ -36,7 +36,7 @@ enum ir_kbd_get_key_fn {
 struct IR_i2c_init_data {
 	char			*ir_codes;
 	const char             *name;
-	u64          type; /* IR_TYPE_RC5, IR_TYPE_PD, etc */
+	u64          type; /* IR_TYPE_RC5, etc */
 	/*
 	 * Specify either a function pointer or a value indicating one of
 	 * ir_kbd_i2c's internal get_key functions
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 67af24e..ba53fe2 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -13,11 +13,10 @@
 
 #define IR_TYPE_UNKNOWN	0
 #define IR_TYPE_RC5	(1  << 0)	/* Philips RC5 protocol */
-#define IR_TYPE_PD	(1  << 1)	/* Pulse distance encoded IR */
-#define IR_TYPE_NEC	(1  << 2)
-#define IR_TYPE_RC6	(1  << 3)	/* Philips RC6 protocol */
-#define IR_TYPE_JVC	(1  << 4)	/* JVC protocol */
-#define IR_TYPE_SONY	(1  << 5)	/* Sony12/15/20 protocol */
+#define IR_TYPE_NEC	(1  << 1)
+#define IR_TYPE_RC6	(1  << 2)	/* Philips RC6 protocol */
+#define IR_TYPE_JVC	(1  << 3)	/* JVC protocol */
+#define IR_TYPE_SONY	(1  << 4)	/* Sony12/15/20 protocol */
 #define IR_TYPE_OTHER	(1u << 31)
 
 struct ir_scancode {

