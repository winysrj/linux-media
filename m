Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52579 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025AbbA2UZm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 15:25:42 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	John McMaster <johndmcmaster@gmail.com>
Subject: [PATCH] [media] gspca/touptek: Fix a few CodingStyle issues
Date: Thu, 29 Jan 2015 18:25:28 -0200
Message-Id: <2c794075d420f22ba4280f46ac7d43be0acb3e95.1422563122.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Checkpatch complained about a few issues, like FSF address. Also,
multi-line comments are not following the Kernel CodingStyle.

While not too late, let's fix those issues.

Cc: John McMaster <johndmcmaster@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/gspca/touptek.c b/drivers/media/usb/gspca/touptek.c
index 8b7c01e4b772..7bac6bc96063 100644
--- a/drivers/media/usb/gspca/touptek.c
+++ b/drivers/media/usb/gspca/touptek.c
@@ -17,10 +17,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
 #include "gspca.h"
@@ -32,80 +28,80 @@ MODULE_DESCRIPTION("ToupTek UCMOS / Amscope MU microscope camera driver");
 MODULE_LICENSE("GPL");
 
 /*
-Exposure reg is linear with exposure time
-Exposure (sec), E (reg)
-0.000400, 0x0002
-0.001000, 0x0005
-0.005000, 0x0019
-0.020000, 0x0064
-0.080000, 0x0190
-0.400000, 0x07D0
-1.000000, 0x1388
-2.000000, 0x2710
-
-Three gain stages
-0x1000: master channel enable bit
-0x007F: low gain bits
-0x0080: medium gain bit
-0x0100: high gain bit
-gain = enable * (1 + regH) * (1 + regM) * z * regL
-
-Gain implementation
-Want to do something similar to mt9v011.c's set_balance
-
-Gain does not vary with resolution (checked 640x480 vs 1600x1200)
-
-Constant derivation:
-
-Raw data:
-Gain,   GTOP,   B,	  R,	  GBOT
-1.00,   0x105C, 0x1068, 0x10C8, 0x105C
-1.20,   0x106E, 0x107E, 0x10D6, 0x106E
-1.40,   0x10C0, 0x10CA, 0x10E5, 0x10C0
-1.60,   0x10C9, 0x10D4, 0x10F3, 0x10C9
-1.80,   0x10D2, 0x10DE, 0x11C1, 0x10D2
-2.00,   0x10DC, 0x10E9, 0x11C8, 0x10DC
-2.20,   0x10E5, 0x10F3, 0x11CF, 0x10E5
-2.40,   0x10EE, 0x10FE, 0x11D7, 0x10EE
-2.60,   0x10F7, 0x11C4, 0x11DE, 0x10F7
-2.80,   0x11C0, 0x11CA, 0x11E5, 0x11C0
-3.00,   0x11C5, 0x11CF, 0x11ED, 0x11C5
-
-zR = 0.0069605943152454778
-	about 3/431 = 0.0069605568445475635
-zB = 0.0095695970695970703
-	about 6/627 = 0.0095693779904306216
-zG = 0.010889328063241107
-	about 6/551 = 0.010889292196007259
-about 10 bits for constant + 7 bits for value => at least 17 bit intermediate
-with 32 bit ints should be fine for overflow etc
-Essentially gains are in range 0-0x001FF
-
-However, V4L expects a main gain channel + R and B balance
-To keep things simple for now saturate the values of balance is too high/low
-This isn't really ideal but easy way to fit the Linux model
-
-Converted using gain model turns out to be quite linear:
-Gain, GTOP, B, R, GBOT
-1.00, 92, 104, 144, 92
-1.20, 110, 126, 172, 110
-1.40, 128, 148, 202, 128
-1.60, 146, 168, 230, 146
-1.80, 164, 188, 260, 164
-2.00, 184, 210, 288, 184
-2.20, 202, 230, 316, 202
-2.40, 220, 252, 348, 220
-2.60, 238, 272, 376, 238
-2.80, 256, 296, 404, 256
-3.00, 276, 316, 436, 276
-
-Maximum gain is 0x7FF * 2 * 2 => 0x1FFC (8188)
-or about 13 effective bits of gain
-The highest the commercial driver goes in my setup 436
-However, because could *maybe* damage circuits
-limit the gain until have a reason to go higher
-Solution: gain clipped and warning emitted
-*/
+ * Exposure reg is linear with exposure time
+ * Exposure (sec), E (reg)
+ * 0.000400, 0x0002
+ * 0.001000, 0x0005
+ * 0.005000, 0x0019
+ * 0.020000, 0x0064
+ * 0.080000, 0x0190
+ * 0.400000, 0x07D0
+ * 1.000000, 0x1388
+ * 2.000000, 0x2710
+ *
+ * Three gain stages
+ * 0x1000: master channel enable bit
+ * 0x007F: low gain bits
+ * 0x0080: medium gain bit
+ * 0x0100: high gain bit
+ * gain = enable * (1 + regH) * (1 + regM) * z * regL
+ *
+ * Gain implementation
+ * Want to do something similar to mt9v011.c's set_balance
+ *
+ * Gain does not vary with resolution (checked 640x480 vs 1600x1200)
+ *
+ * Constant derivation:
+ *
+ * Raw data:
+ * Gain,   GTOP,   B,	  R,	  GBOT
+ * 1.00,   0x105C, 0x1068, 0x10C8, 0x105C
+ * 1.20,   0x106E, 0x107E, 0x10D6, 0x106E
+ * 1.40,   0x10C0, 0x10CA, 0x10E5, 0x10C0
+ * 1.60,   0x10C9, 0x10D4, 0x10F3, 0x10C9
+ * 1.80,   0x10D2, 0x10DE, 0x11C1, 0x10D2
+ * 2.00,   0x10DC, 0x10E9, 0x11C8, 0x10DC
+ * 2.20,   0x10E5, 0x10F3, 0x11CF, 0x10E5
+ * 2.40,   0x10EE, 0x10FE, 0x11D7, 0x10EE
+ * 2.60,   0x10F7, 0x11C4, 0x11DE, 0x10F7
+ * 2.80,   0x11C0, 0x11CA, 0x11E5, 0x11C0
+ * 3.00,   0x11C5, 0x11CF, 0x11ED, 0x11C5
+ *
+ * zR = 0.0069605943152454778
+ *	about 3/431 = 0.0069605568445475635
+ * zB = 0.0095695970695970703
+ *	about 6/627 = 0.0095693779904306216
+ * zG = 0.010889328063241107
+ *	about 6/551 = 0.010889292196007259
+ * about 10 bits for constant + 7 bits for value => at least 17 bit
+ * intermediate with 32 bit ints should be fine for overflow etc
+ * Essentially gains are in range 0-0x001FF
+ *
+ * However, V4L expects a main gain channel + R and B balance
+ * To keep things simple for now saturate the values of balance is too high/low
+ * This isn't really ideal but easy way to fit the Linux model
+ *
+ * Converted using gain model turns out to be quite linear:
+ * Gain, GTOP, B, R, GBOT
+ * 1.00, 92, 104, 144, 92
+ * 1.20, 110, 126, 172, 110
+ * 1.40, 128, 148, 202, 128
+ * 1.60, 146, 168, 230, 146
+ * 1.80, 164, 188, 260, 164
+ * 2.00, 184, 210, 288, 184
+ * 2.20, 202, 230, 316, 202
+ * 2.40, 220, 252, 348, 220
+ * 2.60, 238, 272, 376, 238
+ * 2.80, 256, 296, 404, 256
+ * 3.00, 276, 316, 436, 276
+ *
+ * Maximum gain is 0x7FF * 2 * 2 => 0x1FFC (8188)
+ * or about 13 effective bits of gain
+ * The highest the commercial driver goes in my setup 436
+ * However, because could *maybe* damage circuits
+ * limit the gain until have a reason to go higher
+ * Solution: gain clipped and warning emitted
+ */
 #define GAIN_MAX		511
 
 /* Frame sync is a short read */
@@ -189,9 +185,9 @@ static const struct v4l2_pix_format vga_mode[] = {
 };
 
 /*
-As theres no known frame sync, the only way to keep synced is to try hard
-to never miss any packets
-*/
+ * As theres no known frame sync, the only way to keep synced is to try hard
+ * to never miss any packets
+ */
 #if MAX_NURBS < 4
 #error "Not enough URBs in the gspca table"
 #endif
@@ -218,7 +214,8 @@ static void reg_w(struct gspca_dev *gspca_dev, u16 value, u16 index)
 	char buff[1];
 	int rc;
 
-	PDEBUG(D_USBO, "reg_w bReq=0x0B, bReqT=0xC0, wVal=0x%04X, wInd=0x%04X\n",
+	PDEBUG(D_USBO,
+		"reg_w bReq=0x0B, bReqT=0xC0, wVal=0x%04X, wInd=0x%04X\n",
 		value, index);
 	rc = usb_control_msg(gspca_dev->dev, usb_rcvctrlpipe(gspca_dev->dev, 0),
 		0x0B, 0xC0, value, index, buff, 1, 500);
@@ -271,11 +268,11 @@ static void setexposure(struct gspca_dev *gspca_dev, s32 val)
 static int gainify(int in)
 {
 	/*
-	TODO: check if there are any issues with corner cases
-	0x000 (0):0x07F (127): regL
-	0x080 (128) - 0x0FF (255): regM, regL
-	0x100 (256) - max: regH, regM, regL
-	*/
+	 * TODO: check if there are any issues with corner cases
+	 * 0x000 (0):0x07F (127): regL
+	 * 0x080 (128) - 0x0FF (255): regM, regL
+	 * 0x100 (256) - max: regH, regM, regL
+	 */
 	if (in <= 0x7F)
 		return 0x1000 | in;
 	else if (in <= 0xFF)
@@ -446,18 +443,18 @@ static int configure(struct gspca_dev *gspca_dev)
 	PDEBUG(D_STREAM, "configure()\n");
 
 	/*
-	First driver sets a sort of encryption key
-	A number of futur requests of this type have wValue and wIndex encrypted
-	as follows:
-	-Compute key = this wValue rotate left by 4 bits
-		(decrypt.py rotates right because we are decrypting)
-	-Later packets encrypt packets by XOR'ing with key
-		XOR encrypt/decrypt is symmetrical
-		wValue, and wIndex are encrypted
-		bRequest is not and bRequestType is always 0xC0
-			This allows resyncing if key is unknown?
-	By setting 0 we XOR with 0 and the shifting and XOR drops out
-	*/
+	 * First driver sets a sort of encryption key
+	 * A number of futur requests of this type have wValue and wIndex
+	 * encrypted as follows:
+	 * -Compute key = this wValue rotate left by 4 bits
+	 *	(decrypt.py rotates right because we are decrypting)
+	 * -Later packets encrypt packets by XOR'ing with key
+	 *	XOR encrypt/decrypt is symmetrical
+	 *	wValue, and wIndex are encrypted
+	 *	bRequest is not and bRequestType is always 0xC0
+	 *		This allows resyncing if key is unknown?
+	 * By setting 0 we XOR with 0 and the shifting and XOR drops out
+	 */
 	rc = usb_control_msg(gspca_dev->dev, usb_rcvctrlpipe(gspca_dev->dev, 0),
 			     0x16, 0xC0, 0x0000, 0x0000, buff, 2, 500);
 	if (val_reply(gspca_dev, buff, rc)) {
@@ -466,13 +463,14 @@ static int configure(struct gspca_dev *gspca_dev)
 	}
 
 	/*
-	Next does some sort of 2 packet challenge / response
-	evidence suggests its an Atmel I2C crypto part but nobody cares to look
-	(to make sure its not cloned hardware?)
-	Ignore: I want to work with their hardware, not clone it
-	16 bytes out challenge, requestType: 0x40
-	16 bytes in response, requestType: 0xC0
-	*/
+	 * Next does some sort of 2 packet challenge / response
+	 * evidence suggests its an Atmel I2C crypto part but nobody cares to
+	 * look
+	 * (to make sure its not cloned hardware?)
+	 * Ignore: I want to work with their hardware, not clone it
+	 * 16 bytes out challenge, requestType: 0x40
+	 * 16 bytes in response, requestType: 0xC0
+	 */
 
 	rc = usb_control_msg(gspca_dev->dev, usb_sndctrlpipe(gspca_dev->dev, 0),
 			     0x01, 0x40, 0x0001, 0x000F, NULL, 0, 500);
@@ -496,11 +494,12 @@ static int configure(struct gspca_dev *gspca_dev)
 	}
 
 	/*
-	Serial number?  Doesn't seem to be required
-	cam1: \xE6\x0D\x00\x00, cam2: \x70\x19\x00\x00
-	rc = usb_control_msg(gspca_dev->dev, usb_rcvctrlpipe(gspca_dev->dev, 0),
-			     0x20, 0xC0, 0x0000, 0x0000, buff, 4, 500);
-	*/
+	 * Serial number?  Doesn't seem to be required
+	 * cam1: \xE6\x0D\x00\x00, cam2: \x70\x19\x00\x00
+	 * rc = usb_control_msg(gspca_dev->dev,
+	 *			usb_rcvctrlpipe(gspca_dev->dev, 0),
+	 *			0x20, 0xC0, 0x0000, 0x0000, buff, 4, 500);
+	 */
 
 	/* Large (EEPROM?) read, skip it since no idea what to do with it */
 	gspca_dev->usb_err = 0;
-- 
2.1.0

