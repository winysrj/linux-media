Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40640 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbcFXPcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 11:32:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Erik Andren <erik.andren@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 04/19] m5602_core: move skeletons to the .c file
Date: Fri, 24 Jun 2016 12:31:45 -0300
Message-Id: <511ebc093c3c8342ad68622616b29808b8eac571.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mc5602_brigde.h is included at m5602 submodules. This
causes Gcc 6.1 to complain:

drivers/media/usb/gspca/m5602/m5602_bridge.h:124:28: warning: 'sensor_urb_skeleton' defined but not used [-Wunused-const-variable=]
 static const unsigned char sensor_urb_skeleton[] = {
                            ^~~~~~~~~~~~~~~~~~~
drivers/media/usb/gspca/m5602/m5602_bridge.h:119:28: warning: 'bridge_urb_skeleton' defined but not used [-Wunused-const-variable=]
 static const unsigned char bridge_urb_skeleton[] = {
                           ^~~~~~~~~~~~~~~~~~~

Let's shut up gcc 6.1 warnings by moving those data structures
to the core, as they're used only there.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/gspca/m5602/m5602_bridge.h | 15 ---------------
 drivers/media/usb/gspca/m5602/m5602_core.c   | 15 +++++++++++++++
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/media/usb/gspca/m5602/m5602_bridge.h b/drivers/media/usb/gspca/m5602/m5602_bridge.h
index 19eb1a64f9d6..43ebc03d844d 100644
--- a/drivers/media/usb/gspca/m5602/m5602_bridge.h
+++ b/drivers/media/usb/gspca/m5602/m5602_bridge.h
@@ -115,21 +115,6 @@
 
 /*****************************************************************************/
 
-/* A skeleton used for sending messages to the m5602 bridge */
-static const unsigned char bridge_urb_skeleton[] = {
-	0x13, 0x00, 0x81, 0x00
-};
-
-/* A skeleton used for sending messages to the sensor */
-static const unsigned char sensor_urb_skeleton[] = {
-	0x23, M5602_XB_GPIO_EN_H, 0x81, 0x06,
-	0x23, M5602_XB_MISC_CTRL, 0x81, 0x80,
-	0x13, M5602_XB_I2C_DEV_ADDR, 0x81, 0x00,
-	0x13, M5602_XB_I2C_REG_ADDR, 0x81, 0x00,
-	0x13, M5602_XB_I2C_DATA, 0x81, 0x00,
-	0x13, M5602_XB_I2C_CTRL, 0x81, 0x11
-};
-
 struct sd {
 	struct gspca_dev gspca_dev;
 
diff --git a/drivers/media/usb/gspca/m5602/m5602_core.c b/drivers/media/usb/gspca/m5602/m5602_core.c
index d926e62cb80b..e4a0658e3f83 100644
--- a/drivers/media/usb/gspca/m5602/m5602_core.c
+++ b/drivers/media/usb/gspca/m5602/m5602_core.c
@@ -37,6 +37,21 @@ static const struct usb_device_id m5602_table[] = {
 
 MODULE_DEVICE_TABLE(usb, m5602_table);
 
+/* A skeleton used for sending messages to the sensor */
+static const unsigned char sensor_urb_skeleton[] = {
+	0x23, M5602_XB_GPIO_EN_H, 0x81, 0x06,
+	0x23, M5602_XB_MISC_CTRL, 0x81, 0x80,
+	0x13, M5602_XB_I2C_DEV_ADDR, 0x81, 0x00,
+	0x13, M5602_XB_I2C_REG_ADDR, 0x81, 0x00,
+	0x13, M5602_XB_I2C_DATA, 0x81, 0x00,
+	0x13, M5602_XB_I2C_CTRL, 0x81, 0x11
+};
+
+/* A skeleton used for sending messages to the m5602 bridge */
+static const unsigned char bridge_urb_skeleton[] = {
+	0x13, 0x00, 0x81, 0x00
+};
+
 /* Reads a byte from the m5602 */
 int m5602_read_bridge(struct sd *sd, const u8 address, u8 *i2c_data)
 {
-- 
2.7.4


