Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:60451 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379AbcGDNUv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 09:20:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Leandro Costantino <lcostantino@gmail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH alternative] [media] gspca: avoid unused variable warnings
Date: Mon,  4 Jul 2016 15:23:12 +0200
Message-Id: <20160704132341.1188066-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When CONFIG_INPUT is disabled, multiple gspca backend drivers
print compile-time warnings about unused variables:

media/usb/gspca/cpia1.c: In function 'sd_stopN':
media/usb/gspca/cpia1.c:1627:13: error: unused variable 'sd' [-Werror=unused-variable]
media/usb/gspca/konica.c: In function 'sd_stopN':
media/usb/gspca/konica.c:246:13: error: unused variable 'sd' [-Werror=unused-variable]

This converts the #if check into an if(), to let the compiler
see where the variables are used, at the expense of slightly
enlarging the gspca_dev structure.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: ee186fd96a5f ("[media] gscpa_t613: Add support for the camera button")
Fixes: c2f644aeeba3 ("[media] gspca_cpia1: Add support for button")
Fixes: b517af722860 ("V4L/DVB: gspca_konica: New gspca subdriver for konica chipset using cams")
---
This is one of two approaches to avoid the warning, please pick either
this or the other one.
---
 drivers/media/usb/gspca/cpia1.c  | 13 ++++++-------
 drivers/media/usb/gspca/gspca.h  |  2 +-
 drivers/media/usb/gspca/konica.c |  8 ++------
 drivers/media/usb/gspca/t613.c   |  8 ++------
 4 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/media/usb/gspca/cpia1.c b/drivers/media/usb/gspca/cpia1.c
index f23df4a9d8c5..29ce3faecada 100644
--- a/drivers/media/usb/gspca/cpia1.c
+++ b/drivers/media/usb/gspca/cpia1.c
@@ -540,10 +540,11 @@ static int do_command(struct gspca_dev *gspca_dev, u16 command,
 		/* test button press */
 		a = ((gspca_dev->usb_buf[1] & 0x02) == 0);
 		if (a != sd->params.qx3.button) {
-#if IS_ENABLED(CONFIG_INPUT)
-			input_report_key(gspca_dev->input_dev, KEY_CAMERA, a);
-			input_sync(gspca_dev->input_dev);
-#endif
+			if (IS_ENABLED(CONFIG_INPUT)) {
+				input_report_key(gspca_dev->input_dev,
+						 KEY_CAMERA, a);
+				input_sync(gspca_dev->input_dev);
+			}
 	        	sd->params.qx3.button = a;
 		}
 		if (sd->params.qx3.button) {
@@ -1637,16 +1638,14 @@ static void sd_stopN(struct gspca_dev *gspca_dev)
 	/* Update the camera status */
 	do_command(gspca_dev, CPIA_COMMAND_GetCameraStatus, 0, 0, 0, 0);
 
-#if IS_ENABLED(CONFIG_INPUT)
 	/* If the last button state is pressed, release it now! */
-	if (sd->params.qx3.button) {
+	if (IS_ENABLED(CONFIG_INPUT) && sd->params.qx3.button) {
 		/* The camera latch will hold the pressed state until we reset
 		   the latch, so we do not reset sd->params.qx3.button now, to
 		   avoid a false keypress being reported the next sd_start */
 		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 0);
 		input_sync(gspca_dev->input_dev);
 	}
-#endif
 }
 
 /* this function is called at probe and resume time */
diff --git a/drivers/media/usb/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
index d39adf90303b..0d0f8ba1d673 100644
--- a/drivers/media/usb/gspca/gspca.h
+++ b/drivers/media/usb/gspca/gspca.h
@@ -149,8 +149,8 @@ struct gspca_dev {
 	struct usb_device *dev;
 	struct file *capt_file;		/* file doing video capture */
 					/* protected by queue_lock */
-#if IS_ENABLED(CONFIG_INPUT)
 	struct input_dev *input_dev;
+#if IS_ENABLED(CONFIG_INPUT)
 	char phys[64];			/* physical device path */
 #endif
 
diff --git a/drivers/media/usb/gspca/konica.c b/drivers/media/usb/gspca/konica.c
index 39c96bb4c985..2abbde7ee532 100644
--- a/drivers/media/usb/gspca/konica.c
+++ b/drivers/media/usb/gspca/konica.c
@@ -246,15 +246,13 @@ static void sd_stopN(struct gspca_dev *gspca_dev)
 	struct sd *sd = (struct sd *) gspca_dev;
 
 	konica_stream_off(gspca_dev);
-#if IS_ENABLED(CONFIG_INPUT)
 	/* Don't keep the button in the pressed state "forever" if it was
 	   pressed when streaming is stopped */
-	if (sd->snapshot_pressed) {
+	if (IS_ENABLED(CONFIG_INPUT) && sd->snapshot_pressed) {
 		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 0);
 		input_sync(gspca_dev->input_dev);
 		sd->snapshot_pressed = 0;
 	}
-#endif
 }
 
 /* reception of an URB */
@@ -341,8 +339,7 @@ static void sd_isoc_irq(struct urb *urb)
 		if (st & 0x80) {
 			gspca_frame_add(gspca_dev, LAST_PACKET, NULL, 0);
 			gspca_frame_add(gspca_dev, FIRST_PACKET, NULL, 0);
-		} else {
-#if IS_ENABLED(CONFIG_INPUT)
+		} else if (IS_ENABLED(CONFIG_INPUT)) {
 			u8 button_state = st & 0x40 ? 1 : 0;
 			if (sd->snapshot_pressed != button_state) {
 				input_report_key(gspca_dev->input_dev,
@@ -351,7 +348,6 @@ static void sd_isoc_irq(struct urb *urb)
 				input_sync(gspca_dev->input_dev);
 				sd->snapshot_pressed = button_state;
 			}
-#endif
 			if (st & 0x01)
 				continue;
 		}
diff --git a/drivers/media/usb/gspca/t613.c b/drivers/media/usb/gspca/t613.c
index e2cc4e5a0ccb..fd2500725f25 100644
--- a/drivers/media/usb/gspca/t613.c
+++ b/drivers/media/usb/gspca/t613.c
@@ -823,14 +823,12 @@ static void sd_stopN(struct gspca_dev *gspca_dev)
 		msleep(20);
 		reg_w(gspca_dev, 0x0309);
 	}
-#if IS_ENABLED(CONFIG_INPUT)
 	/* If the last button state is pressed, release it now! */
-	if (sd->button_pressed) {
+	if (IS_ENABLED(CONFIG_INPUT) && sd->button_pressed) {
 		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 0);
 		input_sync(gspca_dev->input_dev);
 		sd->button_pressed = 0;
 	}
-#endif
 }
 
 static void sd_pkt_scan(struct gspca_dev *gspca_dev,
@@ -841,8 +839,7 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 	int pkt_type;
 
 	if (data[0] == 0x5a) {
-#if IS_ENABLED(CONFIG_INPUT)
-		if (len > 20) {
+		if (IS_ENABLED(CONFIG_INPUT) && len > 20) {
 			u8 state = (data[20] & 0x80) ? 1 : 0;
 			if (sd->button_pressed != state) {
 				input_report_key(gspca_dev->input_dev,
@@ -851,7 +848,6 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 				sd->button_pressed = state;
 			}
 		}
-#endif
 		/* Control Packet, after this came the header again,
 		 * but extra bytes came in the packet before this,
 		 * sometimes an EOF arrives, sometimes not... */
-- 
2.9.0

