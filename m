Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:40677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064Ab0L3NFi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 08:05:38 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBUD5cEK013190
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 30 Dec 2010 08:05:38 -0500
Received: from [10.11.8.93] (vpn-8-93.rdu.redhat.com [10.11.8.93])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBUD5WRd015194
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 30 Dec 2010 08:05:35 -0500
Message-ID: <4D1C839C.3090102@redhat.com>
Date: Thu, 30 Dec 2010 11:05:32 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v2] [media] ivtv: Add Adaptec Remote Controller
References: <cover.1293709356.git.mchehab@redhat.com> <20101230094509.2ecbf089@gaivota>
In-Reply-To: <20101230094509.2ecbf089@gaivota>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

>From f4b19dd8ac2d15666975f262cc1bdf461d48e687 Mon Sep 17 00:00:00 2001
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Thu, 30 Dec 2010 09:31:10 -0200
Subject: [PATCH] [media] ivtv: Add Adaptec Remote Controller

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

There are two Adaptec cards defined there, but AVC-2010 doesn't have a
remote controller. So, the logic at lirc_i2c seems to be for Adaptec AVC-2410.

As we'll remove lirc_i2c from kernel, move the getkey code to ivtv driver, and
use it for AVC-2410.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

---

v2: Update comment and add a new entry at hw_devicenames table


diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index 6817092..71912ec 100644
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
@@ -143,8 +145,34 @@ static const char * const hw_devicenames[] = {
 	"ir_video",		/* IVTV_HW_I2C_IR_RX_HAUP_INT */
 	"ir_tx_z8f0811_haup",	/* IVTV_HW_Z8F0811_IR_TX_HAUP */
 	"ir_rx_z8f0811_haup",	/* IVTV_HW_Z8F0811_IR_RX_HAUP */
+	"ir_adaptec",
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
@@ -190,6 +218,12 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
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
@@ -219,7 +253,6 @@ struct i2c_client *ivtv_i2c_new_ir_legacy(struct ivtv *itv)
 		0x1a,	/* Hauppauge IR external - collides with WM8739 */
 		0x18,	/* Hauppauge IR internal */
 		0x71,	/* Hauppauge IR (PVR150) */
-		0x6b,	/* Adaptec IR */
 		I2C_CLIENT_END
 	};
 

