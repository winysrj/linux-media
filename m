Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59609 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753101AbeDHVTt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 8 Apr 2018 17:19:49 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Matthias Reichl <hias@horus.com>
Cc: Carlo Caione <carlo@caione.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Alex Deryskyba <alex@codesnake.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        linux-amlogic@lists.infradead.org
Subject: [PATCH v2 5/7] media: rc: mce_kbd protocol encodes two scancodes
Date: Sun,  8 Apr 2018 22:19:40 +0100
Message-Id: <83e420c4229770af4a014c0c8034384ab15dde1e.1523221902.git.sean@mess.org>
In-Reply-To: <cover.1523221902.git.sean@mess.org>
References: <cover.1523221902.git.sean@mess.org>
In-Reply-To: <cover.1523221902.git.sean@mess.org>
References: <cover.1523221902.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If two keys are pressed, then both keys are encoded in the scancode. This
makes the mce keyboard more responsive.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-mce_kbd-decoder.c | 21 ++++++++++++---------
 drivers/media/rc/rc-main.c            |  2 +-
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/ir-mce_kbd-decoder.c b/drivers/media/rc/ir-mce_kbd-decoder.c
index 230b9397aa11..dcdba83290d2 100644
--- a/drivers/media/rc/ir-mce_kbd-decoder.c
+++ b/drivers/media/rc/ir-mce_kbd-decoder.c
@@ -147,13 +147,14 @@ static enum mce_kbd_mode mce_kbd_mode(struct mce_kbd_dec *data)
 static void ir_mce_kbd_process_keyboard_data(struct rc_dev *dev, u32 scancode)
 {
 	struct mce_kbd_dec *data = &dev->raw->mce_kbd;
-	u8 keydata   = (scancode >> 8) & 0xff;
+	u8 keydata1  = (scancode >> 8) & 0xff;
+	u8 keydata2  = (scancode >> 16) & 0xff;
 	u8 shiftmask = scancode & 0xff;
-	unsigned char keycode, maskcode;
+	unsigned char maskcode;
 	int i, keystate;
 
-	dev_dbg(&dev->dev, "keyboard: keydata = 0x%02x, shiftmask = 0x%02x\n",
-		keydata, shiftmask);
+	dev_dbg(&dev->dev, "keyboard: keydata2 = 0x%02x, keydata1 = 0x%02x, shiftmask = 0x%02x\n",
+		keydata2, keydata1, shiftmask);
 
 	for (i = 0; i < 7; i++) {
 		maskcode = kbd_keycodes[MCIR2_MASK_KEYS_START + i];
@@ -164,10 +165,12 @@ static void ir_mce_kbd_process_keyboard_data(struct rc_dev *dev, u32 scancode)
 		input_report_key(data->idev, maskcode, keystate);
 	}
 
-	if (keydata) {
-		keycode = kbd_keycodes[keydata];
-		input_report_key(data->idev, keycode, 1);
-	} else {
+	if (keydata1)
+		input_report_key(data->idev, kbd_keycodes[keydata1], 1);
+	if (keydata2)
+		input_report_key(data->idev, kbd_keycodes[keydata2], 1);
+
+	if (!keydata1 && !keydata2) {
 		for (i = 0; i < MCIR2_MASK_KEYS_START; i++)
 			input_report_key(data->idev, kbd_keycodes[i], 0);
 	}
@@ -319,7 +322,7 @@ static int ir_mce_kbd_decode(struct rc_dev *dev, struct ir_raw_event ev)
 
 		switch (data->wanted_bits) {
 		case MCIR2_KEYBOARD_NBITS:
-			scancode = data->body & 0xffff;
+			scancode = data->body & 0xffffff;
 			dev_dbg(&dev->dev, "keyboard data 0x%08x\n",
 				data->body);
 			if (scancode) {
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 9f4df60f62e1..b7071bde670a 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -51,7 +51,7 @@ static const struct {
 	[RC_PROTO_SANYO] = { .name = "sanyo",
 		.scancode_bits = 0x1fffff, .repeat_period = 125 },
 	[RC_PROTO_MCIR2_KBD] = { .name = "mcir2-kbd",
-		.scancode_bits = 0xffff, .repeat_period = 100 },
+		.scancode_bits = 0xffffff, .repeat_period = 100 },
 	[RC_PROTO_MCIR2_MSE] = { .name = "mcir2-mse",
 		.scancode_bits = 0x1fffff, .repeat_period = 100 },
 	[RC_PROTO_RC6_0] = { .name = "rc-6-0",
-- 
2.14.3
