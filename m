Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33331 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbcCCRuv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 12:50:51 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Olli Salonen <olli.salonen@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Erik Andresen <erik@vontaene.de>,
	=?UTF-8?q?Torbj=C3=B6rn=20Jansson?=
	<torbjorn.jansson@mbox200.swipnet.se>,
	Nicolas Sugino <nsugino@3way.com.ar>,
	Patrick Boettcher <patrick.boettcher@posteo.de>,
	Christian Dale <kernel@techmunk.com>,
	Benjamin Larsson <benjamin@southpole.se>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] [media] dw2102: move USB IDs to dvb-usb-ids.h
Date: Thu,  3 Mar 2016 14:50:17 -0300
Message-Id: <9e6013a0f085737a084053c6269ebf57c06c8497.1457027402.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, dw2102 assumes that the USB IDs will be either at
an external header or defined internally. That doesn't sound
right.

So, let's move the definitions to just one place.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/dvb-usb-ids.h | 13 ++++++++
 drivers/media/usb/dvb-usb/dw2102.c   | 60 ++----------------------------------
 2 files changed, 16 insertions(+), 57 deletions(-)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 0afad395ef97..fc90a39ab9b7 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -58,6 +58,14 @@
 #define USB_VID_TELESTAR			0x10b9
 #define USB_VID_VISIONPLUS			0x13d3
 #define USB_VID_SONY				0x1415
+#define USB_PID_TEVII_S421			0xd421
+#define USB_PID_TEVII_S480_1			0xd481
+#define USB_PID_TEVII_S480_2			0xd482
+#define USB_PID_TEVII_S630			0xd630
+#define USB_PID_TEVII_S632			0xd632
+#define USB_PID_TEVII_S650			0xd650
+#define USB_PID_TEVII_S660			0xd660
+#define USB_PID_TEVII_S662			0xd662
 #define USB_VID_TWINHAN				0x1822
 #define USB_VID_ULTIMA_ELECTRONIC		0x05d8
 #define USB_VID_UNIWILL				0x1584
@@ -141,6 +149,7 @@
 #define USB_PID_GENIUS_TVGO_DVB_T03			0x4012
 #define USB_PID_GRANDTEC_DVBT_USB_COLD			0x0fa0
 #define USB_PID_GRANDTEC_DVBT_USB_WARM			0x0fa1
+#define USB_PID_GOTVIEW_SAT_HD				0x5456
 #define USB_PID_INTEL_CE9500				0x9500
 #define USB_PID_ITETECH_IT9135				0x9135
 #define USB_PID_ITETECH_IT9135_9005			0x9005
@@ -159,6 +168,8 @@
 #define USB_PID_KWORLD_UB499_2T_T09			0xe409
 #define USB_PID_KWORLD_VSTREAM_COLD			0x17de
 #define USB_PID_KWORLD_VSTREAM_WARM			0x17df
+#define USB_PID_PROF_1100				0xb012
+#define USB_PID_TERRATEC_CINERGY_S			0x0064
 #define USB_PID_TERRATEC_CINERGY_T_USB_XE		0x0055
 #define USB_PID_TERRATEC_CINERGY_T_USB_XE_REV2		0x0069
 #define USB_PID_TERRATEC_CINERGY_T_STICK		0x0093
@@ -361,6 +372,8 @@
 #define USB_PID_YUAN_STK7700D				0x1efc
 #define USB_PID_YUAN_STK7700D_2				0x1e8c
 #define USB_PID_DW2102					0x2102
+#define USB_PID_DW2104					0x2104
+#define USB_PID_DW3101					0x3101
 #define USB_PID_XTENSIONS_XD_380			0x0381
 #define USB_PID_TELESTAR_STARSTICK_2			0x8000
 #define USB_PID_MSI_DIGI_VOX_MINI_III                   0x8807
diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 6d0dd859d684..084a6c93d015 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -13,6 +13,7 @@
  *
  * see Documentation/dvb/README.dvb-usb for more information
  */
+#include "dvb-usb-ids.h"
 #include "dw2102.h"
 #include "si21xx.h"
 #include "stv0299.h"
@@ -38,61 +39,6 @@
 /* Max transfer size done by I2C transfer functions */
 #define MAX_XFER_SIZE  64
 
-#ifndef USB_PID_DW2102
-#define USB_PID_DW2102 0x2102
-#endif
-
-#ifndef USB_PID_DW2104
-#define USB_PID_DW2104 0x2104
-#endif
-
-#ifndef USB_PID_DW3101
-#define USB_PID_DW3101 0x3101
-#endif
-
-#ifndef USB_PID_CINERGY_S
-#define USB_PID_CINERGY_S 0x0064
-#endif
-
-#ifndef USB_PID_TEVII_S630
-#define USB_PID_TEVII_S630 0xd630
-#endif
-
-#ifndef USB_PID_TEVII_S650
-#define USB_PID_TEVII_S650 0xd650
-#endif
-
-#ifndef USB_PID_TEVII_S660
-#define USB_PID_TEVII_S660 0xd660
-#endif
-
-#ifndef USB_PID_TEVII_S662
-#define USB_PID_TEVII_S662 0xd662
-#endif
-
-#ifndef USB_PID_TEVII_S480_1
-#define USB_PID_TEVII_S480_1 0xd481
-#endif
-
-#ifndef USB_PID_TEVII_S480_2
-#define USB_PID_TEVII_S480_2 0xd482
-#endif
-
-#ifndef USB_PID_PROF_1100
-#define USB_PID_PROF_1100 0xb012
-#endif
-
-#ifndef USB_PID_TEVII_S421
-#define USB_PID_TEVII_S421 0xd421
-#endif
-
-#ifndef USB_PID_TEVII_S632
-#define USB_PID_TEVII_S632 0xd632
-#endif
-
-#ifndef USB_PID_GOTVIEW_SAT_HD
-#define USB_PID_GOTVIEW_SAT_HD 0x5456
-#endif
 
 #define DW210X_READ_MSG 0
 #define DW210X_WRITE_MSG 1
@@ -1709,7 +1655,7 @@ static struct usb_device_id dw2102_table[] = {
 	[CYPRESS_DW2101] = {USB_DEVICE(USB_VID_CYPRESS, 0x2101)},
 	[CYPRESS_DW2104] = {USB_DEVICE(USB_VID_CYPRESS, USB_PID_DW2104)},
 	[TEVII_S650] = {USB_DEVICE(0x9022, USB_PID_TEVII_S650)},
-	[TERRATEC_CINERGY_S] = {USB_DEVICE(USB_VID_TERRATEC, USB_PID_CINERGY_S)},
+	[TERRATEC_CINERGY_S] = {USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_S)},
 	[CYPRESS_DW3101] = {USB_DEVICE(USB_VID_CYPRESS, USB_PID_DW3101)},
 	[TEVII_S630] = {USB_DEVICE(0x9022, USB_PID_TEVII_S630)},
 	[PROF_1100] = {USB_DEVICE(0x3011, USB_PID_PROF_1100)},
@@ -1801,7 +1747,7 @@ static int dw2102_load_firmware(struct usb_device *dev,
 			dw210x_op_rw(dev, 0xbf, 0x0040, 0, &reset, 0,
 					DW210X_WRITE_MSG);
 			break;
-		case USB_PID_CINERGY_S:
+		case USB_PID_TERRATEC_CINERGY_S:
 		case USB_PID_DW2102:
 			dw210x_op_rw(dev, 0xbf, 0x0040, 0, &reset, 0,
 					DW210X_WRITE_MSG);
-- 
2.5.0

