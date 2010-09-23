Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:26814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab0IWEeK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 00:34:10 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o8N4Y94E013481
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 23 Sep 2010 00:34:09 -0400
Received: from pedra (vpn-239-203.phx2.redhat.com [10.3.239.203])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o8N4X3me018821
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 23 Sep 2010 00:34:08 -0400
Date: Thu, 23 Sep 2010 01:32:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] V4L/DVB: Remove the usage of I2C_HW_B_CX2388x on
 ir-kbd-i2c.c
Message-ID: <20100923013255.1de2651a@pedra>
In-Reply-To: <cover.1285215968.git.mchehab@redhat.com>
References: <cover.1285215968.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Move the cx88 specific initialization for Hauppauge XVR remotes
into cx88-input, removing the need for test it inside ir-kbd-i2c.

The reference at cx88 for this symbol, at:

drivers/media/video/cx88/cx88-i2c.c:    core->i2c_adap.id = I2C_HW_B_CX2388x;
drivers/media/video/cx88/cx88-vp3054-i2c.c:     vp3054_i2c->adap.id = I2C_HW_B_CX2388x;

Can't be removed yet, since lirc-i2c still uses it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx88/cx88-i2c.c b/drivers/media/video/cx88/cx88-i2c.c
index b897f86..f53836b 100644
--- a/drivers/media/video/cx88/cx88-i2c.c
+++ b/drivers/media/video/cx88/cx88-i2c.c
@@ -183,41 +183,3 @@ int cx88_i2c_init(struct cx88_core *core, struct pci_dev *pci)
 
 	return core->i2c_rc;
 }
-
-void cx88_i2c_init_ir(struct cx88_core *core)
-{
-	/* Instantiate the IR receiver device, if present */
-	if (0 == core->i2c_rc) {
-		struct i2c_board_info info;
-		const unsigned short addr_list[] = {
-			0x18, 0x6b, 0x71,
-			I2C_CLIENT_END
-		};
-		const unsigned short *addrp;
-
-		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
-		/*
-		 * We can't call i2c_new_probed_device() because it uses
-		 * quick writes for probing and at least some R receiver
-		 * devices only reply to reads.
-		 */
-		for (addrp = addr_list; *addrp != I2C_CLIENT_END; addrp++) {
-			if (i2c_smbus_xfer(&core->i2c_adap, *addrp, 0,
-					   I2C_SMBUS_READ, 0,
-					   I2C_SMBUS_QUICK, NULL) >= 0) {
-				info.addr = *addrp;
-				i2c_new_device(&core->i2c_adap, &info);
-				break;
-			}
-		}
-	}
-}
-
-/* ----------------------------------------------------------------------- */
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index eccc5e4..d52ce0e 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -609,13 +609,54 @@ void cx88_ir_irq(struct cx88_core *core)
 	return;
 }
 
+
+void cx88_i2c_init_ir(struct cx88_core *core)
+{
+	struct i2c_board_info info;
+	const unsigned short addr_list[] = {
+		0x18, 0x6b, 0x71,
+		I2C_CLIENT_END
+	};
+	const unsigned short *addrp;
+	/* Instantiate the IR receiver device, if present */
+	if (0 != core->i2c_rc)
+		return;
+
+	memset(&info, 0, sizeof(struct i2c_board_info));
+	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
+
+	/*
+	 * We can't call i2c_new_probed_device() because it uses
+	 * quick writes for probing and at least some RC receiver
+	 * devices only reply to reads.
+	 * Also, Hauppauge XVR needs to be specified, as address 0x71
+	 * conflicts with another remote type used with saa7134
+	 */
+	for (addrp = addr_list; *addrp != I2C_CLIENT_END; addrp++) {
+		info.platform_data = NULL;
+		memset(&core->init_data, 0, sizeof(core->init_data));
+
+		if (*addrp == 0x71) {
+			/* Hauppauge XVR */
+			core->init_data.name = "cx88 Hauppauge XVR remote";
+			core->init_data.ir_codes = RC_MAP_HAUPPAUGE_NEW;
+			core->init_data.type = IR_TYPE_RC5;
+			core->init_data.internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
+
+			info.platform_data = &core->init_data;
+		}
+		if (i2c_smbus_xfer(&core->i2c_adap, *addrp, 0,
+					I2C_SMBUS_READ, 0,
+					I2C_SMBUS_QUICK, NULL) >= 0) {
+			info.addr = *addrp;
+			i2c_new_device(&core->i2c_adap, &info);
+			break;
+		}
+	}
+}
+
 /* ---------------------------------------------------------------------- */
 
 MODULE_AUTHOR("Gerd Knorr, Pavel Machek, Chris Pascoe");
 MODULE_DESCRIPTION("input driver for cx88 GPIO-based IR remote controls");
 MODULE_LICENSE("GPL");
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index bda9e3e..127118f 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -31,9 +31,8 @@
 #include <media/videobuf-dma-sg.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/cx2341x.h>
-#if defined(CONFIG_VIDEO_CX88_DVB) || defined(CONFIG_VIDEO_CX88_DVB_MODULE)
 #include <media/videobuf-dvb.h>
-#endif
+#include <media/ir-kbd-i2c.h>
 
 #include "btcx-risc.h"
 #include "cx88-reg.h"
@@ -377,6 +376,9 @@ struct cx88_core {
 	/* IR remote control state */
 	struct cx88_IR             *ir;
 
+	/* I2C remote data */
+	struct IR_i2c_init_data    init_data;
+
 	struct mutex               lock;
 	/* various v4l controls */
 	u32                        freq;
@@ -650,7 +652,6 @@ extern const struct videobuf_queue_ops cx8800_vbi_qops;
 /* cx88-i2c.c                                                  */
 
 extern int cx88_i2c_init(struct cx88_core *core, struct pci_dev *pci);
-extern void cx88_i2c_init_ir(struct cx88_core *core);
 
 
 /* ----------------------------------------------------------- */
@@ -688,6 +689,7 @@ int cx88_ir_fini(struct cx88_core *core);
 void cx88_ir_irq(struct cx88_core *core);
 int cx88_ir_start(struct cx88_core *core);
 void cx88_ir_stop(struct cx88_core *core);
+extern void cx88_i2c_init_ir(struct cx88_core *core);
 
 /* ----------------------------------------------------------- */
 /* cx88-mpeg.c                                                 */
@@ -707,10 +709,3 @@ int cx88_set_freq (struct cx88_core  *core,struct v4l2_frequency *f);
 int cx88_get_control(struct cx88_core *core, struct v4l2_control *ctl);
 int cx88_set_control(struct cx88_core *core, struct v4l2_control *ctl);
 int cx88_video_mux(struct cx88_core *core, unsigned int input);
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- * kate: eol "unix"; indent-width 3; remove-trailing-space on; replace-trailing-space-save on; tab-width 8; replace-tabs off; space-indent off; mixed-indent off
- */
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index 02fbd08..91b2c88 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -325,25 +325,6 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		ir_type     = IR_TYPE_RC5;
 		ir_codes    = RC_MAP_FUSIONHDTV_MCE;
 		break;
-	case 0x0b:
-	case 0x47:
-	case 0x71:
-		if (adap->id == I2C_HW_B_CX2388x) {
-			/* Handled by cx88-input */
-			name = "CX2388x remote";
-			ir_type     = IR_TYPE_RC5;
-			ir->get_key = get_key_haup_xvr;
-			if (hauppauge == 1) {
-				ir_codes    = RC_MAP_HAUPPAUGE_NEW;
-			} else {
-				ir_codes    = RC_MAP_RC5_TV;
-			}
-		} else {
-			/* Handled by saa7134-input */
-			name        = "SAA713x remote";
-			ir_type     = IR_TYPE_OTHER;
-		}
-		break;
 	case 0x40:
 		name        = "AVerMedia Cardbus remote";
 		ir->get_key = get_key_avermedia_cardbus;
-- 
1.7.1


