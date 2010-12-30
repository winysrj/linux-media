Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:36031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab0L3LuG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 06:50:06 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBUBo69i002073
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 30 Dec 2010 06:50:06 -0500
Received: from gaivota (vpn-8-93.rdu.redhat.com [10.11.8.93])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBUBjLCn031659
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 30 Dec 2010 06:50:02 -0500
Date: Thu, 30 Dec 2010 09:45:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/4] [media] ivtv: Add Adaptec Remote Controller
Message-ID: <20101230094509.2ecbf089@gaivota>
In-Reply-To: <cover.1293709356.git.mchehab@redhat.com>
References: <cover.1293709356.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

lirc-i2c implements a get key logic for the Adaptec Remote
Controller, at address 0x6b. The only driver that seems to have
an Adaptec device is ivtv:

$ git grep -i adaptec drivers/media
drivers/media/video/cs53l32a.c: * cs53l32a (Adaptec AVC-2010 and AVC-2410) i2c ivtv driver.
drivers/media/video/cs53l32a.c: * Audio source switching for Adaptec AVC-2410 added by Trev Jackson
drivers/media/video/cs53l32a.c:   /* Set cs53l32a internal register for Adaptec 2010/2410 setup */
drivers/media/video/ivtv/ivtv-cards.c:/* Adaptec VideOh! AVC-2410 card */
drivers/media/video/ivtv/ivtv-cards.c:    { PCI_DEVICE_ID_IVTV16, IVTV_PCI_ID_ADAPTEC, 0x0093 },
drivers/media/video/ivtv/ivtv-cards.c:    .name = "Adaptec VideOh! AVC-2410",
drivers/media/video/ivtv/ivtv-cards.c:/* Adaptec VideOh! AVC-2010 card */
drivers/media/video/ivtv/ivtv-cards.c:    { PCI_DEVICE_ID_IVTV16, IVTV_PCI_ID_ADAPTEC, 0x0092 },
drivers/media/video/ivtv/ivtv-cards.c:    .name = "Adaptec VideOh! AVC-2010",
drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_CARD_AVC2410         7 /* Adaptec AVC-2410 */
drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_CARD_AVC2010         8 /* Adaptec AVD-2010 (No Tuner) */
drivers/media/video/ivtv/ivtv-cards.h:#define IVTV_PCI_ID_ADAPTEC                 0x9005
drivers/media/video/ivtv/ivtv-driver.c:            "\t\t\t 8 = Adaptec AVC-2410\n"
drivers/media/video/ivtv/ivtv-driver.c:            "\t\t\t 9 = Adaptec AVC-2010\n"
drivers/media/video/ivtv/ivtv-i2c.c:              0x6b,   /* Adaptec IR */

There are two Adaptec cards defined there, but only one has tuner.
I never found any device without tuners, but with a remote controllers, so
the logic at lirc_i2c seems to be for Adaptec AVC-2410.

As we'll remove lirc_i2c from kernel, move the getkey code to ivtv driver, and
use it for AVC2410.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index 6817092..8d1b016 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -94,6 +94,7 @@
 #define IVTV_HAUP_INT_IR_RX_I2C_ADDR 	0x18
 #define IVTV_Z8F0811_IR_TX_I2C_ADDR	0x70
 #define IVTV_Z8F0811_IR_RX_I2C_ADDR	0x71
+#define IVTV_ADAPTEC_IR			0x6b
 
 /* This array should match the IVTV_HW_ defines */
 static const u8 hw_addrs[] = {
@@ -118,6 +119,7 @@ static const u8 hw_addrs[] = {
 	IVTV_HAUP_INT_IR_RX_I2C_ADDR,	/* IVTV_HW_I2C_IR_RX_HAUP_INT */
 	IVTV_Z8F0811_IR_TX_I2C_ADDR,	/* IVTV_HW_Z8F0811_IR_TX_HAUP */
 	IVTV_Z8F0811_IR_RX_I2C_ADDR,	/* IVTV_HW_Z8F0811_IR_RX_HAUP */
+	IVTV_ADAPTEC_IR,
 };
 
 /* This array should match the IVTV_HW_ defines */
@@ -145,6 +147,31 @@ static const char * const hw_devicenames[] = {
 	"ir_rx_z8f0811_haup",	/* IVTV_HW_Z8F0811_IR_RX_HAUP */
 };
 
+static int get_key_adaptec(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
+{
+	unsigned char keybuf[4];
+
+	keybuf[0] = 0x00;
+	i2c_master_send(ir->c, keybuf, 1);
+	/* poll IR chip */
+	if (i2c_master_recv(ir->c, keybuf, sizeof(keybuf)) != sizeof(keybuf)) {
+		return 0;
+	}
+
+	/* key pressed ? */
+	if (keybuf[2] == 0xff)
+		return 0;
+
+	/* remove repeat bit */
+	keybuf[2] &= 0x7f;
+	keybuf[3] |= 0x80;
+
+	*ir_key = (u32) keybuf;
+	*ir_raw = (u32) keybuf;
+
+	return 1;
+}
+
 static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 {
 	struct i2c_board_info info;
@@ -190,6 +217,12 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 		init_data->type = RC_TYPE_RC5;
 		init_data->name = itv->card_name;
 		break;
+	case IVTV_CARD_AVC2410:
+		init_data->ir_codes = RC_MAP_EMPTY;
+		init_data->get_key = get_key_adaptec;
+		init_data->type = RC_TYPE_UNKNOWN;
+		init_data->name = itv->card_name;
+		break;
 	}
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
@@ -219,7 +252,6 @@ struct i2c_client *ivtv_i2c_new_ir_legacy(struct ivtv *itv)
 		0x1a,	/* Hauppauge IR external - collides with WM8739 */
 		0x18,	/* Hauppauge IR internal */
 		0x71,	/* Hauppauge IR (PVR150) */
-		0x6b,	/* Adaptec IR */
 		I2C_CLIENT_END
 	};
 
-- 
1.7.3.4


