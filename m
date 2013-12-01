Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:42123 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab3LAVGV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Dec 2013 16:06:21 -0500
Received: by mail-ea0-f182.google.com with SMTP id o10so11223525eaj.41
        for <linux-media@vger.kernel.org>; Sun, 01 Dec 2013 13:06:20 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/7] em28xx: extend the support for device buttons
Date: Sun,  1 Dec 2013 22:06:52 +0100
Message-Id: <1385932017-2276-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1385932017-2276-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1385932017-2276-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current code supports only a single snapshot button assigned to
register 0x0c bit 5. But devices may be equipped with multiple buttons
with different functionalities and they can also be assigned to the
various GPI-ports.

Extend the em28xx-input code to handle multiple buttons assigned to different
GPI-ports / register addresses and bits.
Also make easier to extend the code with further button types.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |   20 ++++-
 drivers/media/usb/em28xx/em28xx-input.c |  150 +++++++++++++++++++++++--------
 drivers/media/usb/em28xx/em28xx.h       |   27 +++++-
 3 Dateien geändert, 154 Zeilen hinzugefügt(+), 43 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index a519669..ebb112c 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -413,6 +413,20 @@ static struct em28xx_reg_seq pctv_520e[] = {
 };
 
 /*
+ *  Button definitions
+ */
+static struct em28xx_button std_snapshot_button[] = {
+	{
+		.role         = EM28XX_BUTTON_SNAPSHOT,
+		.reg_r        = EM28XX_R0C_USBSUSP,
+		.reg_clearing = EM28XX_R0C_USBSUSP,
+		.mask         = EM28XX_R0C_USBSUSP_SNAPSHOT,
+		.inverted     = 0,
+	},
+	{-1, 0, 0, 0, 0},
+};
+
+/*
  *  Board definitions
  */
 struct em28xx_board em28xx_boards[] = {
@@ -1391,7 +1405,7 @@ struct em28xx_board em28xx_boards[] = {
 	},
 	[EM2820_BOARD_PROLINK_PLAYTV_USB2] = {
 		.name         = "SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0",
-		.has_snapshot_button = 1,
+		.buttons = std_snapshot_button,
 		.tda9887_conf = TDA9887_PRESENT,
 		.tuner_type   = TUNER_YMEC_TVF_5533MF,
 		.decoder      = EM28XX_SAA711X,
@@ -1413,7 +1427,7 @@ struct em28xx_board em28xx_boards[] = {
 	},
 	[EM2860_BOARD_SAA711X_REFERENCE_DESIGN] = {
 		.name                = "EM2860/SAA711X Reference Design",
-		.has_snapshot_button = 1,
+		.buttons = std_snapshot_button,
 		.tuner_type          = TUNER_ABSENT,
 		.decoder             = EM28XX_SAA711X,
 		.input               = { {
@@ -2841,7 +2855,7 @@ static void request_module_async(struct work_struct *work)
 
 	if (dev->board.has_dvb)
 		request_module("em28xx-dvb");
-	if (dev->board.has_snapshot_button ||
+	if (dev->board.buttons ||
 	    ((dev->board.ir_codes || dev->board.has_ir_i2c) && !disable_ir))
 		request_module("em28xx-rc");
 #endif /* CONFIG_MODULES */
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index ea181e4..20c6a8a 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -31,7 +31,7 @@
 #include "em28xx.h"
 
 #define EM28XX_SNAPSHOT_KEY KEY_CAMERA
-#define EM28XX_SBUTTON_QUERY_INTERVAL 500
+#define EM28XX_BUTTONS_QUERY_INTERVAL 500
 
 static unsigned int ir_debug;
 module_param(ir_debug, int, 0644);
@@ -470,38 +470,69 @@ static int em28xx_probe_i2c_ir(struct em28xx *dev)
 }
 
 /**********************************************************
- Handle Webcam snapshot button
+ Handle buttons
  **********************************************************/
 
-static void em28xx_query_sbutton(struct work_struct *work)
+static void em28xx_query_buttons(struct work_struct *work)
 {
-	/* Poll the register and see if the button is depressed */
 	struct em28xx *dev =
-		container_of(work, struct em28xx, sbutton_query_work.work);
-	int ret;
-
-	ret = em28xx_read_reg(dev, EM28XX_R0C_USBSUSP);
-
-	if (ret & EM28XX_R0C_USBSUSP_SNAPSHOT) {
-		u8 cleared;
-		/* Button is depressed, clear the register */
-		cleared = ((u8) ret) & ~EM28XX_R0C_USBSUSP_SNAPSHOT;
-		em28xx_write_regs(dev, EM28XX_R0C_USBSUSP, &cleared, 1);
-
-		/* Not emulate the keypress */
-		input_report_key(dev->sbutton_input_dev, EM28XX_SNAPSHOT_KEY,
-				 1);
-		/* Now unpress the key */
-		input_report_key(dev->sbutton_input_dev, EM28XX_SNAPSHOT_KEY,
-				 0);
+		container_of(work, struct em28xx, buttons_query_work.work);
+	u8 i, j;
+	int regval;
+	bool pressed;
+
+	/* Poll and evaluate all addresses */
+	for (i = 0; i < dev->num_button_polling_addresses; i++) {
+		/* Read value from register */
+		regval = em28xx_read_reg(dev, dev->button_polling_addresses[i]);
+		if (regval < 0)
+			continue;
+		/* Check states of the buttons and act */
+		j = 0;
+		while (dev->board.buttons[j].role >= 0 &&
+			 dev->board.buttons[j].role < EM28XX_NUM_BUTTON_ROLES) {
+			struct em28xx_button *button = &dev->board.buttons[j];
+			/* Check if button uses the current address */
+			if (button->reg_r != dev->button_polling_addresses[i]) {
+				j++;
+				continue;
+			}
+			/* Determine if button is pressed */
+			pressed = regval & button->mask;
+			if (button->inverted)
+				pressed = !pressed;
+			/* Handle button state */
+			if (!pressed) {
+				j++;
+				continue;
+			}
+			switch (button->role) {
+			case EM28XX_BUTTON_SNAPSHOT:
+				/* Emulate the keypress */
+				input_report_key(dev->sbutton_input_dev,
+						 EM28XX_SNAPSHOT_KEY, 1);
+				/* Unpress the key */
+				input_report_key(dev->sbutton_input_dev,
+						 EM28XX_SNAPSHOT_KEY, 0);
+				break;
+			default:
+				WARN_ONCE(1, "BUG: unhandled button role.");
+			}
+			/* Clear button state (if needed) */
+			if (button->reg_clearing)
+				em28xx_write_reg(dev, button->reg_clearing,
+						 (~regval & button->mask)
+						    | (regval & ~button->mask));
+			/* Next button */
+			j++;
+		}
 	}
-
 	/* Schedule next poll */
-	schedule_delayed_work(&dev->sbutton_query_work,
-			      msecs_to_jiffies(EM28XX_SBUTTON_QUERY_INTERVAL));
+	schedule_delayed_work(&dev->buttons_query_work,
+			      msecs_to_jiffies(EM28XX_BUTTONS_QUERY_INTERVAL));
 }
 
-static void em28xx_register_snapshot_button(struct em28xx *dev)
+static int em28xx_register_snapshot_button(struct em28xx *dev)
 {
 	struct input_dev *input_dev;
 	int err;
@@ -510,14 +541,13 @@ static void em28xx_register_snapshot_button(struct em28xx *dev)
 	input_dev = input_allocate_device();
 	if (!input_dev) {
 		em28xx_errdev("input_allocate_device failed\n");
-		return;
+		return -ENOMEM;
 	}
 
 	usb_make_path(dev->udev, dev->snapshot_button_path,
 		      sizeof(dev->snapshot_button_path));
 	strlcat(dev->snapshot_button_path, "/sbutton",
 		sizeof(dev->snapshot_button_path));
-	INIT_DELAYED_WORK(&dev->sbutton_query_work, em28xx_query_sbutton);
 
 	input_dev->name = "em28xx snapshot button";
 	input_dev->phys = dev->snapshot_button_path;
@@ -535,25 +565,71 @@ static void em28xx_register_snapshot_button(struct em28xx *dev)
 	if (err) {
 		em28xx_errdev("input_register_device failed\n");
 		input_free_device(input_dev);
-		return;
+		return err;
 	}
 
 	dev->sbutton_input_dev = input_dev;
-	schedule_delayed_work(&dev->sbutton_query_work,
-			      msecs_to_jiffies(EM28XX_SBUTTON_QUERY_INTERVAL));
-	return;
+	return 0;
+}
 
+static void em28xx_init_buttons(struct em28xx *dev)
+{
+	u8  i = 0, j = 0;
+	bool addr_new = 0;
+
+	while (dev->board.buttons[i].role >= 0 &&
+			 dev->board.buttons[i].role < EM28XX_NUM_BUTTON_ROLES) {
+		struct em28xx_button *button = &dev->board.buttons[i];
+		/* Check if polling address is already on the list */
+		addr_new = 1;
+		for (j = 0; j < dev->num_button_polling_addresses; j++) {
+			if (button->reg_r == dev->button_polling_addresses[j]) {
+				addr_new = 0;
+				break;
+			}
+		}
+		/* Check if max. number of polling addresses is exceeded */
+		if (addr_new && dev->num_button_polling_addresses
+					   >= EM28XX_NUM_BUTTON_ADDRESSES_MAX) {
+			WARN_ONCE(1, "BUG: maximum number of button polling addresses exceeded.");
+			addr_new = 0;
+		}
+		/* Register input device (if needed) */
+		if (button->role == EM28XX_BUTTON_SNAPSHOT) {
+			if (em28xx_register_snapshot_button(dev) < 0)
+				addr_new = 0;
+		}
+		/* Add read address to list of polling addresses */
+		if (addr_new) {
+			unsigned int index = dev->num_button_polling_addresses;
+			dev->button_polling_addresses[index] = button->reg_r;
+			dev->num_button_polling_addresses++;
+		}
+		/* Next button */
+		i++;
+	}
+
+	/* Start polling */
+	if (dev->num_button_polling_addresses) {
+		INIT_DELAYED_WORK(&dev->buttons_query_work,
+							  em28xx_query_buttons);
+		schedule_delayed_work(&dev->buttons_query_work,
+			       msecs_to_jiffies(EM28XX_BUTTONS_QUERY_INTERVAL));
+	}
 }
 
-static void em28xx_deregister_snapshot_button(struct em28xx *dev)
+static void em28xx_shutdown_buttons(struct em28xx *dev)
 {
+	/* Cancel polling */
+	cancel_delayed_work_sync(&dev->buttons_query_work);
+	/* Clear polling addresses list */
+	dev->num_button_polling_addresses = 0;
+	/* Deregister input devices */
 	if (dev->sbutton_input_dev != NULL) {
 		em28xx_info("Deregistering snapshot button\n");
-		cancel_delayed_work_sync(&dev->sbutton_query_work);
 		input_unregister_device(dev->sbutton_input_dev);
 		dev->sbutton_input_dev = NULL;
 	}
-	return;
 }
 
 static int em28xx_ir_init(struct em28xx *dev)
@@ -564,8 +640,8 @@ static int em28xx_ir_init(struct em28xx *dev)
 	u64 rc_type;
 	u16 i2c_rc_dev_addr = 0;
 
-	if (dev->board.has_snapshot_button)
-		em28xx_register_snapshot_button(dev);
+	if (dev->board.buttons)
+		em28xx_init_buttons(dev);
 
 	if (dev->board.has_ir_i2c) {
 		i2c_rc_dev_addr = em28xx_probe_i2c_ir(dev);
@@ -688,7 +764,7 @@ static int em28xx_ir_fini(struct em28xx *dev)
 {
 	struct em28xx_IR *ir = dev->ir;
 
-	em28xx_deregister_snapshot_button(dev);
+	em28xx_shutdown_buttons(dev);
 
 	/* skip detach on non attached boards */
 	if (!ir)
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 8003c2f..e185d00 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -181,6 +181,9 @@
 /* time in msecs to wait for i2c writes to finish */
 #define EM2800_I2C_XFER_TIMEOUT		20
 
+/* max. number of button state polling addresses */
+#define EM28XX_NUM_BUTTON_ADDRESSES_MAX		5
+
 enum em28xx_mode {
 	EM28XX_SUSPEND,
 	EM28XX_ANALOG_MODE,
@@ -380,6 +383,19 @@ struct em28xx_led {
 	bool inverted;
 };
 
+enum em28xx_button_role {
+	EM28XX_BUTTON_SNAPSHOT = 0,
+	EM28XX_NUM_BUTTON_ROLES, /* must be the last */
+};
+
+struct em28xx_button {
+	enum em28xx_button_role role;
+	u8 reg_r;
+	u8 reg_clearing;
+	u8 mask;
+	bool inverted;
+};
+
 struct em28xx_board {
 	char *name;
 	int vchannels;
@@ -401,7 +417,6 @@ struct em28xx_board {
 	unsigned int mts_firmware:1;
 	unsigned int max_range_640_480:1;
 	unsigned int has_dvb:1;
-	unsigned int has_snapshot_button:1;
 	unsigned int is_webcam:1;
 	unsigned int valid:1;
 	unsigned int has_ir_i2c:1;
@@ -419,6 +434,9 @@ struct em28xx_board {
 
 	/* LEDs that need to be controlled explicitly */
 	struct em28xx_led	  *analog_capturing_led;
+
+	/* Buttons */
+	struct em28xx_button	  *buttons;
 };
 
 struct em28xx_eeprom {
@@ -648,10 +666,13 @@ struct em28xx {
 
 	enum em28xx_mode mode;
 
-	/* Snapshot button */
+	/* Button state polling */
+	struct delayed_work buttons_query_work;
+	u8 button_polling_addresses[EM28XX_NUM_BUTTON_ADDRESSES_MAX];
+	u8 num_button_polling_addresses;
+	/* Snapshot button input device */
 	char snapshot_button_path[30];	/* path of the input dev */
 	struct input_dev *sbutton_input_dev;
-	struct delayed_work sbutton_query_work;
 
 	struct em28xx_dvb *dvb;
 };
-- 
1.7.10.4

