Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47591 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753075AbZKGVr4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:47:56 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:47:56 +0000
Message-ID: <1257630476.15927.400.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 10/75] V4L/DVB: declare MODULE_FIRMWARE for modules using
 XC2028 and XC3028L tuners
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
I'm not really sure whether it's better to do this in the drivers which
specify which firmware file to use, or just once in the xc2028 tuner
driver.  Your call.

Ben.

 drivers/media/dvb/dvb-usb/cxusb.c           |    1 +
 drivers/media/dvb/dvb-usb/dib0700_devices.c |    1 +
 drivers/media/video/cx18/cx18-driver.c      |    1 +
 drivers/media/video/cx23885/cx23885-dvb.c   |    3 +++
 drivers/media/video/cx88/cx88-cards.c       |    2 ++
 drivers/media/video/em28xx/em28xx-cards.c   |    3 +++
 drivers/media/video/ivtv/ivtv-driver.c      |    1 +
 drivers/media/video/saa7134/saa7134-cards.c |    2 ++
 8 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
index f65591f..bc44d30 100644
--- a/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/drivers/media/dvb/dvb-usb/cxusb.c
@@ -1863,3 +1863,4 @@ MODULE_AUTHOR("Chris Pascoe <c.pascoe@itee.uq.edu.au>");
 MODULE_DESCRIPTION("Driver for Conexant USB2.0 hybrid reference design");
 MODULE_VERSION("1.0-alpha");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(XC2028_DEFAULT_FIRMWARE);
diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 684146f..d003ff0 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -408,6 +408,7 @@ static struct xc2028_ctrl stk7700ph_xc3028_ctrl = {
 	.max_len = 64,
 	.demod = XC3028_FE_DIBCOM52,
 };
+MODULE_FIRMWARE(XC2028_DEFAULT_FIRMWARE);
 
 static struct xc2028_config stk7700ph_xc3028_config = {
 	.i2c_addr = 0x61,
diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
index e12082b..6fdd57e 100644
--- a/drivers/media/video/cx18/cx18-driver.c
+++ b/drivers/media/video/cx18/cx18-driver.c
@@ -237,6 +237,7 @@ MODULE_AUTHOR("Hans Verkuil");
 MODULE_DESCRIPTION("CX23418 driver");
 MODULE_SUPPORTED_DEVICE("CX23418 MPEG2 encoder");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(XC2028_DEFAULT_FIRMWARE);
 
 MODULE_VERSION(CX18_VERSION);
 
diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index f4f046c..fe8331a 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -956,6 +956,9 @@ static int dvb_register(struct cx23885_tsport *port)
 	return ret;
 }
 
+MODULE_FIRMWARE(XC2028_DEFAULT_FIRMWARE);
+MODULE_FIRMWARE(XC3028L_DEFAULT_FIRMWARE);
+
 int cx23885_dvb_register(struct cx23885_tsport *port)
 {
 
diff --git a/drivers/media/video/cx88/cx88-cards.c b/drivers/media/video/cx88/cx88-cards.c
index 7330a2d..4a91dd9 100644
--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -3080,6 +3080,8 @@ void cx88_setup_xc3028(struct cx88_core *core, struct xc2028_ctrl *ctl)
 }
 EXPORT_SYMBOL_GPL(cx88_setup_xc3028);
 
+MODULE_FIRMWARE(XC2028_DEFAULT_FIRMWARE);
+
 static void cx88_card_setup(struct cx88_core *core)
 {
 	static u8 eeprom[256];
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 4fd91f5..8c2048b 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2090,6 +2090,9 @@ static void em28xx_setup_xc3028(struct em28xx *dev, struct xc2028_ctrl *ctl)
 	}
 }
 
+MODULE_FIRMWARE(XC2028_DEFAULT_FIRMWARE);
+MODULE_FIRMWARE(XC3028L_DEFAULT_FIRMWARE);
+
 static void em28xx_tuner_setup(struct em28xx *dev)
 {
 	struct tuner_setup           tun_setup;
diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
index 7cdbc1a..4c74142 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -254,6 +254,7 @@ MODULE_SUPPORTED_DEVICE
     ("CX23415/CX23416 MPEG2 encoder (WinTV PVR-150/250/350/500,\n"
 		"\t\t\tYuan MPG series and similar)");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(XC2028_DEFAULT_FIRMWARE);
 
 MODULE_VERSION(IVTV_VERSION);
 
diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index 7e40d6d..e137203 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -7029,6 +7029,8 @@ static void saa7134_tuner_setup(struct saa7134_dev *dev)
 	}
 }
 
+MODULE_FIRMWARE(XC2028_DEFAULT_FIRMWARE);
+
 /* stuff which needs working i2c */
 int saa7134_board_init2(struct saa7134_dev *dev)
 {
-- 
1.6.5.2



