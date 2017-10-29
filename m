Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59711 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751666AbdJ2U6a (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 16:58:30 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 04/28] media: merge ir_tx_z8f0811_haup and ir_rx_z8f0811_haup i2c devices
Date: Sun, 29 Oct 2017 20:58:29 +0000
Message-Id: <a12dd25d049b63b21ecdd80fc363d45c7cc12b1a.1509309834.git.sean@mess.org>
In-Reply-To: <cover.1509309834.git.sean@mess.org>
References: <cover.1509309834.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These two devices ids are really just one device with multiple
addresses. Probing becomes much simpler if we simply fold this into
one i2c device with two address.

Note that this breaks the lirc_zilog driver, however we will teach
ir-kbd-i2c to do what lirc_zilog does in a later commit.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/i2c/ir-kbd-i2c.c               |  4 ++--
 drivers/media/pci/cx18/cx18-cards.h          |  8 +-------
 drivers/media/pci/cx18/cx18-i2c.c            | 13 +++++--------
 drivers/media/pci/ivtv/ivtv-cards.h          | 22 +++++++---------------
 drivers/media/pci/ivtv/ivtv-i2c.c            | 20 ++++----------------
 drivers/media/usb/hdpvr/hdpvr-core.c         | 11 ++---------
 drivers/media/usb/hdpvr/hdpvr-i2c.c          | 23 +++++------------------
 drivers/media/usb/hdpvr/hdpvr.h              |  3 +--
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c | 13 +++----------
 9 files changed, 30 insertions(+), 87 deletions(-)

diff --git a/drivers/media/i2c/ir-kbd-i2c.c b/drivers/media/i2c/ir-kbd-i2c.c
index 22f32717638a..ec669ec4cfc5 100644
--- a/drivers/media/i2c/ir-kbd-i2c.c
+++ b/drivers/media/i2c/ir-kbd-i2c.c
@@ -501,8 +501,8 @@ static const struct i2c_device_id ir_kbd_id[] = {
 	/* Generic entry for any IR receiver */
 	{ "ir_video", 0 },
 	/* IR device specific entries should be added here */
-	{ "ir_rx_z8f0811_haup", 0 },
-	{ "ir_rx_z8f0811_hdpvr", 0 },
+	{ "ir_z8f0811_haup", 0 },
+	{ "ir_z8f0811_hdpvr", 0 },
 	{ }
 };
 
diff --git a/drivers/media/pci/cx18/cx18-cards.h b/drivers/media/pci/cx18/cx18-cards.h
index 667e2d7b1d03..5478f62b5cf3 100644
--- a/drivers/media/pci/cx18/cx18-cards.h
+++ b/drivers/media/pci/cx18/cx18-cards.h
@@ -25,13 +25,7 @@
 #define CX18_HW_418_AV			(1 << 4)
 #define CX18_HW_GPIO_MUX		(1 << 5)
 #define CX18_HW_GPIO_RESET_CTRL		(1 << 6)
-#define CX18_HW_Z8F0811_IR_TX_HAUP	(1 << 7)
-#define CX18_HW_Z8F0811_IR_RX_HAUP	(1 << 8)
-#define CX18_HW_Z8F0811_IR_HAUP	(CX18_HW_Z8F0811_IR_RX_HAUP | \
-				 CX18_HW_Z8F0811_IR_TX_HAUP)
-
-#define CX18_HW_IR_ANY (CX18_HW_Z8F0811_IR_RX_HAUP | \
-			CX18_HW_Z8F0811_IR_TX_HAUP)
+#define CX18_HW_Z8F0811_IR_HAUP		(1 << 7)
 
 /* video inputs */
 #define	CX18_CARD_INPUT_VID_TUNER	1
diff --git a/drivers/media/pci/cx18/cx18-i2c.c b/drivers/media/pci/cx18/cx18-i2c.c
index 7f588eeac60f..f0eb181f2b94 100644
--- a/drivers/media/pci/cx18/cx18-i2c.c
+++ b/drivers/media/pci/cx18/cx18-i2c.c
@@ -47,8 +47,7 @@ static const u8 hw_addrs[] = {
 	0,				/* CX18_HW_418_AV */
 	0,				/* CX18_HW_GPIO_MUX */
 	0,				/* CX18_HW_GPIO_RESET_CTRL */
-	CX18_Z8F0811_IR_TX_I2C_ADDR,	/* CX18_HW_Z8F0811_IR_TX_HAUP */
-	CX18_Z8F0811_IR_RX_I2C_ADDR,	/* CX18_HW_Z8F0811_IR_RX_HAUP */
+	CX18_Z8F0811_IR_RX_I2C_ADDR,	/* CX18_HW_Z8F0811_IR_HAUP */
 };
 
 /* This array should match the CX18_HW_ defines */
@@ -61,8 +60,7 @@ static const u8 hw_bus[] = {
 	0,	/* CX18_HW_418_AV */
 	0,	/* CX18_HW_GPIO_MUX */
 	0,	/* CX18_HW_GPIO_RESET_CTRL */
-	0,	/* CX18_HW_Z8F0811_IR_TX_HAUP */
-	0,	/* CX18_HW_Z8F0811_IR_RX_HAUP */
+	0,	/* CX18_HW_Z8F0811_IR_HAUP */
 };
 
 /* This array should match the CX18_HW_ defines */
@@ -74,8 +72,7 @@ static const char * const hw_devicenames[] = {
 	"cx23418_AV",
 	"gpio_mux",
 	"gpio_reset_ctrl",
-	"ir_tx_z8f0811_haup",
-	"ir_rx_z8f0811_haup",
+	"ir_z8f0811_haup",
 };
 
 static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
@@ -90,7 +87,7 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
 
 	/* Our default information for ir-kbd-i2c.c to use */
 	switch (hw) {
-	case CX18_HW_Z8F0811_IR_RX_HAUP:
+	case CX18_HW_Z8F0811_IR_HAUP:
 		init_data->ir_codes = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
 		init_data->type = RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC6_MCE |
@@ -129,7 +126,7 @@ int cx18_i2c_register(struct cx18 *cx, unsigned idx)
 		return sd != NULL ? 0 : -1;
 	}
 
-	if (hw & CX18_HW_IR_ANY)
+	if (hw == CX18_HW_Z8F0811_IR_HAUP)
 		return cx18_i2c_new_ir(cx, adap, hw, type, hw_addrs[idx]);
 
 	/* Is it not an I2C device or one we do not wish to register? */
diff --git a/drivers/media/pci/ivtv/ivtv-cards.h b/drivers/media/pci/ivtv/ivtv-cards.h
index e6f5c02981f1..06e7b4ed6444 100644
--- a/drivers/media/pci/ivtv/ivtv-cards.h
+++ b/drivers/media/pci/ivtv/ivtv-cards.h
@@ -109,24 +109,16 @@
 #define IVTV_HW_I2C_IR_RX_AVER		(1 << 16)
 #define IVTV_HW_I2C_IR_RX_HAUP_EXT	(1 << 17) /* External before internal */
 #define IVTV_HW_I2C_IR_RX_HAUP_INT	(1 << 18)
-#define IVTV_HW_Z8F0811_IR_TX_HAUP	(1 << 19)
-#define IVTV_HW_Z8F0811_IR_RX_HAUP	(1 << 20)
-#define IVTV_HW_I2C_IR_RX_ADAPTEC	(1 << 21)
-
-#define IVTV_HW_Z8F0811_IR_HAUP	(IVTV_HW_Z8F0811_IR_RX_HAUP | \
-				 IVTV_HW_Z8F0811_IR_TX_HAUP)
+#define IVTV_HW_Z8F0811_IR_HAUP		(1 << 19)
+#define IVTV_HW_I2C_IR_RX_ADAPTEC	(1 << 20)
 
 #define IVTV_HW_SAA711X   (IVTV_HW_SAA7115 | IVTV_HW_SAA7114)
 
-#define IVTV_HW_IR_RX_ANY (IVTV_HW_I2C_IR_RX_AVER | \
-			   IVTV_HW_I2C_IR_RX_HAUP_EXT | \
-			   IVTV_HW_I2C_IR_RX_HAUP_INT | \
-			   IVTV_HW_Z8F0811_IR_RX_HAUP | \
-			   IVTV_HW_I2C_IR_RX_ADAPTEC)
-
-#define IVTV_HW_IR_TX_ANY (IVTV_HW_Z8F0811_IR_TX_HAUP)
-
-#define IVTV_HW_IR_ANY	  (IVTV_HW_IR_RX_ANY | IVTV_HW_IR_TX_ANY)
+#define IVTV_HW_IR_ANY (IVTV_HW_I2C_IR_RX_AVER | \
+			IVTV_HW_I2C_IR_RX_HAUP_EXT | \
+			IVTV_HW_I2C_IR_RX_HAUP_INT | \
+			IVTV_HW_Z8F0811_IR_HAUP | \
+			IVTV_HW_I2C_IR_RX_ADAPTEC)
 
 /* video inputs */
 #define	IVTV_CARD_INPUT_VID_TUNER	1
diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
index 893962ac85de..66696e6ee587 100644
--- a/drivers/media/pci/ivtv/ivtv-i2c.c
+++ b/drivers/media/pci/ivtv/ivtv-i2c.c
@@ -117,8 +117,7 @@ static const u8 hw_addrs[] = {
 	IVTV_AVERMEDIA_IR_RX_I2C_ADDR,	/* IVTV_HW_I2C_IR_RX_AVER */
 	IVTV_HAUP_EXT_IR_RX_I2C_ADDR,	/* IVTV_HW_I2C_IR_RX_HAUP_EXT */
 	IVTV_HAUP_INT_IR_RX_I2C_ADDR,	/* IVTV_HW_I2C_IR_RX_HAUP_INT */
-	IVTV_Z8F0811_IR_TX_I2C_ADDR,	/* IVTV_HW_Z8F0811_IR_TX_HAUP */
-	IVTV_Z8F0811_IR_RX_I2C_ADDR,	/* IVTV_HW_Z8F0811_IR_RX_HAUP */
+	IVTV_Z8F0811_IR_RX_I2C_ADDR,	/* IVTV_HW_Z8F0811_IR_HAUP */
 	IVTV_ADAPTEC_IR_ADDR,		/* IVTV_HW_I2C_IR_RX_ADAPTEC */
 };
 
@@ -143,8 +142,7 @@ static const char * const hw_devicenames[] = {
 	"ir_video",		/* IVTV_HW_I2C_IR_RX_AVER */
 	"ir_video",		/* IVTV_HW_I2C_IR_RX_HAUP_EXT */
 	"ir_video",		/* IVTV_HW_I2C_IR_RX_HAUP_INT */
-	"ir_tx_z8f0811_haup",	/* IVTV_HW_Z8F0811_IR_TX_HAUP */
-	"ir_rx_z8f0811_haup",	/* IVTV_HW_Z8F0811_IR_RX_HAUP */
+	"ir_z8f0811_haup",	/* IVTV_HW_Z8F0811_IR_HAUP */
 	"ir_video",		/* IVTV_HW_I2C_IR_RX_ADAPTEC */
 };
 
@@ -181,18 +179,8 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 	struct IR_i2c_init_data *init_data = &itv->ir_i2c_init_data;
 	unsigned short addr_list[2] = { addr, I2C_CLIENT_END };
 
-	/* Only allow one IR transmitter to be registered per board */
-	if (hw & IVTV_HW_IR_TX_ANY) {
-		if (itv->hw_flags & IVTV_HW_IR_TX_ANY)
-			return -1;
-		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, type, I2C_NAME_SIZE);
-		return i2c_new_probed_device(adap, &info, addr_list, NULL)
-							   == NULL ? -1 : 0;
-	}
-
 	/* Only allow one IR receiver to be registered per board */
-	if (itv->hw_flags & IVTV_HW_IR_RX_ANY)
+	if (itv->hw_flags & IVTV_HW_IR_ANY)
 		return -1;
 
 	/* Our default information for ir-kbd-i2c.c to use */
@@ -211,7 +199,7 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 		init_data->type = RC_PROTO_BIT_RC5;
 		init_data->name = itv->card_name;
 		break;
-	case IVTV_HW_Z8F0811_IR_RX_HAUP:
+	case IVTV_HW_Z8F0811_IR_HAUP:
 		/* Default to grey remote */
 		init_data->ir_codes = RC_MAP_HAUPPAUGE;
 		init_data->internal_get_key_func = IR_KBD_GET_KEY_HAUP_XVR;
diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index dbe29c6c4d8b..99161e7b463f 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -364,16 +364,9 @@ static int hdpvr_probe(struct usb_interface *interface,
 		goto error;
 	}
 
-	client = hdpvr_register_ir_rx_i2c(dev);
+	client = hdpvr_register_ir_i2c(dev);
 	if (!client) {
-		v4l2_err(&dev->v4l2_dev, "i2c IR RX device register failed\n");
-		retval = -ENODEV;
-		goto reg_fail;
-	}
-
-	client = hdpvr_register_ir_tx_i2c(dev);
-	if (!client) {
-		v4l2_err(&dev->v4l2_dev, "i2c IR TX device register failed\n");
+		v4l2_err(&dev->v4l2_dev, "i2c IR device register failed\n");
 		retval = -ENODEV;
 		goto reg_fail;
 	}
diff --git a/drivers/media/usb/hdpvr/hdpvr-i2c.c b/drivers/media/usb/hdpvr/hdpvr-i2c.c
index 1db49ed5eaf1..4720d79b0282 100644
--- a/drivers/media/usb/hdpvr/hdpvr-i2c.c
+++ b/drivers/media/usb/hdpvr/hdpvr-i2c.c
@@ -32,24 +32,11 @@
 #define Z8F0811_IR_RX_I2C_ADDR	0x71
 
 
-struct i2c_client *hdpvr_register_ir_tx_i2c(struct hdpvr_device *dev)
+struct i2c_client *hdpvr_register_ir_i2c(struct hdpvr_device *dev)
 {
 	struct IR_i2c_init_data *init_data = &dev->ir_i2c_init_data;
-	struct i2c_board_info hdpvr_ir_tx_i2c_board_info = {
-		I2C_BOARD_INFO("ir_tx_z8f0811_hdpvr", Z8F0811_IR_TX_I2C_ADDR),
-	};
-
-	init_data->name = "HD-PVR";
-	hdpvr_ir_tx_i2c_board_info.platform_data = init_data;
-
-	return i2c_new_device(&dev->i2c_adapter, &hdpvr_ir_tx_i2c_board_info);
-}
-
-struct i2c_client *hdpvr_register_ir_rx_i2c(struct hdpvr_device *dev)
-{
-	struct IR_i2c_init_data *init_data = &dev->ir_i2c_init_data;
-	struct i2c_board_info hdpvr_ir_rx_i2c_board_info = {
-		I2C_BOARD_INFO("ir_rx_z8f0811_hdpvr", Z8F0811_IR_RX_I2C_ADDR),
+	struct i2c_board_info info = {
+		I2C_BOARD_INFO("ir_z8f0811_hdpvr", Z8F0811_IR_RX_I2C_ADDR),
 	};
 
 	/* Our default information for ir-kbd-i2c.c to use */
@@ -59,9 +46,9 @@ struct i2c_client *hdpvr_register_ir_rx_i2c(struct hdpvr_device *dev)
 			  RC_PROTO_BIT_RC6_6A_32;
 	init_data->name = "HD-PVR";
 	init_data->polling_interval = 405; /* ms, duplicated from Windows */
-	hdpvr_ir_rx_i2c_board_info.platform_data = init_data;
+	info.platform_data = init_data;
 
-	return i2c_new_device(&dev->i2c_adapter, &hdpvr_ir_rx_i2c_board_info);
+	return i2c_new_device(&dev->i2c_adapter, &info);
 }
 
 static int hdpvr_i2c_read(struct hdpvr_device *dev, int bus,
diff --git a/drivers/media/usb/hdpvr/hdpvr.h b/drivers/media/usb/hdpvr/hdpvr.h
index a12e0af1d4e1..96e36a8e5f43 100644
--- a/drivers/media/usb/hdpvr/hdpvr.h
+++ b/drivers/media/usb/hdpvr/hdpvr.h
@@ -320,8 +320,7 @@ int hdpvr_cancel_queue(struct hdpvr_device *dev);
 /* i2c adapter registration */
 int hdpvr_register_i2c_adapter(struct hdpvr_device *dev);
 
-struct i2c_client *hdpvr_register_ir_rx_i2c(struct hdpvr_device *dev);
-struct i2c_client *hdpvr_register_ir_tx_i2c(struct hdpvr_device *dev);
+struct i2c_client *hdpvr_register_ir_i2c(struct hdpvr_device *dev);
 
 /*========================================================================*/
 /* buffer management */
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
index ff7b4d1d385d..f3003ca05f4b 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
@@ -585,17 +585,10 @@ static void pvr2_i2c_register_ir(struct pvr2_hdw *hdw)
 		init_data->type = RC_PROTO_BIT_RC5 | RC_PROTO_BIT_RC6_MCE |
 							RC_PROTO_BIT_RC6_6A_32;
 		init_data->name = hdw->hdw_desc->description;
-		/* IR Receiver */
-		info.addr          = 0x71;
-		info.platform_data = init_data;
-		strlcpy(info.type, "ir_rx_z8f0811_haup", I2C_NAME_SIZE);
-		pvr2_trace(PVR2_TRACE_INFO, "Binding %s to i2c address 0x%02x.",
-			   info.type, info.addr);
-		i2c_new_device(&hdw->i2c_adap, &info);
-		/* IR Trasmitter */
-		info.addr          = 0x70;
+		/* IR Transceiver */
+		info.addr = 0x71;
 		info.platform_data = init_data;
-		strlcpy(info.type, "ir_tx_z8f0811_haup", I2C_NAME_SIZE);
+		strlcpy(info.type, "ir_z8f0811_haup", I2C_NAME_SIZE);
 		pvr2_trace(PVR2_TRACE_INFO, "Binding %s to i2c address 0x%02x.",
 			   info.type, info.addr);
 		i2c_new_device(&hdw->i2c_adap, &info);
-- 
2.13.6
