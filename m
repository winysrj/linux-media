Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:60889 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933953AbeEIMkP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 May 2018 08:40:15 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Antti Palosaari <crope@iki.fi>,
        Andy Walls <awalls@md.metrocast.net>,
        Daniel Scheller <d.scheller@gmx.net>,
        Jasmin Jessich <jasmin@anw.at>,
        Masayuki Yamamoto <Masayuki.Yamamoto@sony.com>,
        Yasunari Takiguchi <Yasunari.Takiguchi@sony.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Brad Love <brad@nextdimension.cc>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Colin Ian King <colin.king@canonical.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Enrico Mioso <mrkiko.rs@gmail.com>,
        Anton Vasilyev <vasilyev@ispras.ru>,
        Bhumika Goyal <bhumirks@gmail.com>, Sean Young <sean@mess.org>
Subject: [PATCH 1/3] media: dvb: fix location of get_dvb_firmware script
Date: Wed,  9 May 2018 09:40:05 -0300
Message-Id: <d805b8f0265652f5b9dfc8f8f276a490a1fdba5f.1525869503.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This script was moved out of Documentation/dvb, but the
links weren't updated.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-frontends/Kconfig          | 18 +++++++++---------
 drivers/media/dvb-frontends/nxt200x.c        |  4 ++--
 drivers/media/dvb-frontends/or51211.c        |  2 +-
 drivers/media/dvb-frontends/sp8870.c         |  2 +-
 drivers/media/dvb-frontends/sp887x.c         |  2 +-
 drivers/media/dvb-frontends/tda1004x.c       |  4 ++--
 drivers/media/dvb-frontends/tda10071.c       |  2 +-
 drivers/media/pci/cx18/cx18-dvb.c            |  2 +-
 drivers/media/pci/cx23885/cx23885-cards.c    |  2 +-
 drivers/media/pci/ttpci/Kconfig              |  2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c  |  2 +-
 drivers/media/usb/dvb-usb/dvb-usb-firmware.c |  2 +-
 drivers/media/usb/dvb-usb/dw2102.c           |  4 +---
 drivers/media/usb/dvb-usb/gp8psk.c           |  2 +-
 drivers/media/usb/dvb-usb/opera1.c           |  2 +-
 drivers/media/usb/ttusb-dec/Kconfig          |  6 +++---
 16 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 55e36a4f5215..9ecaa9d0744a 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -324,7 +324,7 @@ config DVB_SP8870
 	  A DVB-T tuner module. Say Y when you want to support this frontend.
 
 	  This driver needs external firmware. Please use the command
-	  "<kerneldir>/Documentation/dvb/get_dvb_firmware sp8870" to
+	  "<kerneldir>/scripts/get_dvb_firmware sp8870" to
 	  download/extract it, and then copy it to /usr/lib/hotplug/firmware
 	  or /lib/firmware (depending on configuration of firmware hotplug).
 
@@ -336,7 +336,7 @@ config DVB_SP887X
 	  A DVB-T tuner module. Say Y when you want to support this frontend.
 
 	  This driver needs external firmware. Please use the command
-	  "<kerneldir>/Documentation/dvb/get_dvb_firmware sp887x" to
+	  "<kerneldir>/scripts/get_dvb_firmware sp887x" to
 	  download/extract it, and then copy it to /usr/lib/hotplug/firmware
 	  or /lib/firmware (depending on configuration of firmware hotplug).
 
@@ -387,8 +387,8 @@ config DVB_TDA1004X
 	  A DVB-T tuner module. Say Y when you want to support this frontend.
 
 	  This driver needs external firmware. Please use the commands
-	  "<kerneldir>/Documentation/dvb/get_dvb_firmware tda10045",
-	  "<kerneldir>/Documentation/dvb/get_dvb_firmware tda10046" to
+	  "<kerneldir>/scripts/get_dvb_firmware tda10045",
+	  "<kerneldir>/scripts/get_dvb_firmware tda10046" to
 	  download/extract them, and then copy them to /usr/lib/hotplug/firmware
 	  or /lib/firmware (depending on configuration of firmware hotplug).
 
@@ -591,8 +591,8 @@ config DVB_NXT200X
 	  to support this frontend.
 
 	  This driver needs external firmware. Please use the commands
-	  "<kerneldir>/Documentation/dvb/get_dvb_firmware nxt2002" and
-	  "<kerneldir>/Documentation/dvb/get_dvb_firmware nxt2004" to
+	  "<kerneldir>/scripts/get_dvb_firmware nxt2002" and
+	  "<kerneldir>/scripts/get_dvb_firmware nxt2004" to
 	  download/extract them, and then copy them to /usr/lib/hotplug/firmware
 	  or /lib/firmware (depending on configuration of firmware hotplug).
 
@@ -604,7 +604,7 @@ config DVB_OR51211
 	  An ATSC 8VSB tuner module. Say Y when you want to support this frontend.
 
 	  This driver needs external firmware. Please use the command
-	  "<kerneldir>/Documentation/dvb/get_dvb_firmware or51211" to
+	  "<kerneldir>/scripts/get_dvb_firmware or51211" to
 	  download it, and then copy it to /usr/lib/hotplug/firmware
 	  or /lib/firmware (depending on configuration of firmware hotplug).
 
@@ -617,8 +617,8 @@ config DVB_OR51132
 	  to support this frontend.
 
 	  This driver needs external firmware. Please use the commands
-	  "<kerneldir>/Documentation/dvb/get_dvb_firmware or51132_vsb" and/or
-	  "<kerneldir>/Documentation/dvb/get_dvb_firmware or51132_qam" to
+	  "<kerneldir>/scripts/get_dvb_firmware or51132_vsb" and/or
+	  "<kerneldir>/scripts/get_dvb_firmware or51132_qam" to
 	  download firmwares for 8VSB and QAM64/256, respectively. Copy them to
 	  /usr/lib/hotplug/firmware or /lib/firmware (depending on
 	  configuration of firmware hotplug).
diff --git a/drivers/media/dvb-frontends/nxt200x.c b/drivers/media/dvb-frontends/nxt200x.c
index 7aa74403648e..a6cc4952eb74 100644
--- a/drivers/media/dvb-frontends/nxt200x.c
+++ b/drivers/media/dvb-frontends/nxt200x.c
@@ -27,8 +27,8 @@
  *   ATI HDTV Wonder (NXT2004)
  *
  * This driver needs external firmware. Please use the command
- * "<kerneldir>/Documentation/dvb/get_dvb_firmware nxt2002" or
- * "<kerneldir>/Documentation/dvb/get_dvb_firmware nxt2004" to
+ * "<kerneldir>/scripts/get_dvb_firmware nxt2002" or
+ * "<kerneldir>/scripts/get_dvb_firmware nxt2004" to
  * download/extract the appropriate firmware, and then copy it to
  * /usr/lib/hotplug/firmware/ or /lib/firmware/
  * (depending on configuration of firmware hotplug).
diff --git a/drivers/media/dvb-frontends/or51211.c b/drivers/media/dvb-frontends/or51211.c
index a1b7c301828f..b65ba34fd00a 100644
--- a/drivers/media/dvb-frontends/or51211.c
+++ b/drivers/media/dvb-frontends/or51211.c
@@ -22,7 +22,7 @@
 
 /*
  * This driver needs external firmware. Please use the command
- * "<kerneldir>/Documentation/dvb/get_dvb_firmware or51211" to
+ * "<kerneldir>/scripts/get_dvb_firmware or51211" to
  * download/extract it, and then copy it to /usr/lib/hotplug/firmware
  * or /lib/firmware (depending on configuration of firmware hotplug).
  */
diff --git a/drivers/media/dvb-frontends/sp8870.c b/drivers/media/dvb-frontends/sp8870.c
index 9a726f3a4896..1d57a20093fc 100644
--- a/drivers/media/dvb-frontends/sp8870.c
+++ b/drivers/media/dvb-frontends/sp8870.c
@@ -21,7 +21,7 @@
 */
 /*
  * This driver needs external firmware. Please use the command
- * "<kerneldir>/Documentation/dvb/get_dvb_firmware alps_tdlb7" to
+ * "<kerneldir>/scripts/get_dvb_firmware alps_tdlb7" to
  * download/extract it, and then copy it to /usr/lib/hotplug/firmware
  * or /lib/firmware (depending on configuration of firmware hotplug).
  */
diff --git a/drivers/media/dvb-frontends/sp887x.c b/drivers/media/dvb-frontends/sp887x.c
index f39d566d7d1d..57a0d0ae2b48 100644
--- a/drivers/media/dvb-frontends/sp887x.c
+++ b/drivers/media/dvb-frontends/sp887x.c
@@ -4,7 +4,7 @@
 
 /*
  * This driver needs external firmware. Please use the command
- * "<kerneldir>/Documentation/dvb/get_dvb_firmware sp887x" to
+ * "<kerneldir>/scripts/get_dvb_firmware sp887x" to
  * download/extract it, and then copy it to /usr/lib/hotplug/firmware
  * or /lib/firmware (depending on configuration of firmware hotplug).
  */
diff --git a/drivers/media/dvb-frontends/tda1004x.c b/drivers/media/dvb-frontends/tda1004x.c
index 58e3beff5adc..7dcfb4a4b2d0 100644
--- a/drivers/media/dvb-frontends/tda1004x.c
+++ b/drivers/media/dvb-frontends/tda1004x.c
@@ -21,8 +21,8 @@
    */
 /*
  * This driver needs external firmware. Please use the commands
- * "<kerneldir>/Documentation/dvb/get_dvb_firmware tda10045",
- * "<kerneldir>/Documentation/dvb/get_dvb_firmware tda10046" to
+ * "<kerneldir>/scripts/get_dvb_firmware tda10045",
+ * "<kerneldir>/scripts/get_dvb_firmware tda10046" to
  * download/extract them, and then copy them to /usr/lib/hotplug/firmware
  * or /lib/firmware (depending on configuration of firmware hotplug).
  */
diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index a59f4fd09df6..1ed67c08e699 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -852,7 +852,7 @@ static int tda10071_init(struct dvb_frontend *fe)
 		ret = request_firmware(&fw, fw_file, &client->dev);
 		if (ret) {
 			dev_err(&client->dev,
-				"did not find the firmware file. (%s) Please see linux/Documentation/dvb/ for more details on firmware-problems. (%d)\n",
+				"did not find the firmware file '%s' (status %d). You can use <kernel_dir>/scripts/get_dvb_firmware to get the firmware\n",
 				fw_file, ret);
 			goto error;
 		}
diff --git a/drivers/media/pci/cx18/cx18-dvb.c b/drivers/media/pci/cx18/cx18-dvb.c
index 010f39eafce1..a3a7f7065349 100644
--- a/drivers/media/pci/cx18/cx18-dvb.c
+++ b/drivers/media/pci/cx18/cx18-dvb.c
@@ -152,7 +152,7 @@ static int yuan_mpc718_mt352_reqfw(struct cx18_stream *stream,
 
 	if (ret) {
 		CX18_ERR("The MPC718 board variant with the MT352 DVB-T demodulator will not work without it\n");
-		CX18_ERR("Run 'linux/Documentation/dvb/get_dvb_firmware mpc718' if you need the firmware\n");
+		CX18_ERR("Run 'linux/scripts/get_dvb_firmware mpc718' if you need the firmware\n");
 	}
 	return ret;
 }
diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 3a1c55187b2a..9f50748fdf56 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -2426,7 +2426,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 
 		ret = request_firmware(&fw, filename, &dev->pci->dev);
 		if (ret != 0)
-			pr_err("did not find the firmware file. (%s) Please see linux/Documentation/dvb/ for more details on firmware-problems.",
+			pr_err("did not find the firmware file '%s'. You can use <kernel_dir>/scripts/get_dvb_firmware to get the firmware.",
 			       filename);
 		else
 			altera_init(&netup_config, fw);
diff --git a/drivers/media/pci/ttpci/Kconfig b/drivers/media/pci/ttpci/Kconfig
index 7b83151ed6c4..dfba74dd6521 100644
--- a/drivers/media/pci/ttpci/Kconfig
+++ b/drivers/media/pci/ttpci/Kconfig
@@ -24,7 +24,7 @@ config DVB_AV7110
 	  onboard MPEG2 decoder.
 
 	  This driver needs an external firmware. Please use the script
-	  "<kerneldir>/Documentation/dvb/get_dvb_firmware av7110" to
+	  "<kerneldir>/scripts/get_dvb_firmware av7110" to
 	  download/extract it, and then copy it to /usr/lib/hotplug/firmware
 	  or /lib/firmware (depending on configuration of firmware hotplug).
 
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index afdcdbf005e9..955318ab7f5e 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -47,7 +47,7 @@ static int dvb_usbv2_download_firmware(struct dvb_usb_device *d,
 	ret = request_firmware(&fw, name, &d->udev->dev);
 	if (ret < 0) {
 		dev_err(&d->udev->dev,
-				"%s: Did not find the firmware file '%s'. Please see linux/Documentation/dvb/ for more details on firmware-problems. Status %d\n",
+				"%s: Did not find the firmware file '%s' (status %d). You can use <kernel_dir>/scripts/get_dvb_firmware to get the firmware\n",
 				KBUILD_MODNAME, name, ret);
 		goto err;
 	}
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-firmware.c b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
index 15c153e49382..42c207aacbb1 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
@@ -90,7 +90,7 @@ int dvb_usb_download_firmware(struct usb_device *udev, struct dvb_usb_device_pro
 	const struct firmware *fw = NULL;
 
 	if ((ret = request_firmware(&fw, props->firmware, &udev->dev)) != 0) {
-		err("did not find the firmware file. (%s) Please see linux/Documentation/dvb/ for more details on firmware-problems. (%d)",
+		err("did not find the firmware file '%s' (status %d). You can use <kernel_dir>/scripts/get_dvb_firmware to get the firmware",
 			props->firmware,ret);
 		return ret;
 	}
diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 346946f35b1a..716711ecce32 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -61,9 +61,7 @@
 #define P1100_FIRMWARE  "dvb-usb-p1100.fw"
 #define P7500_FIRMWARE  "dvb-usb-p7500.fw"
 
-#define	err_str "did not find the firmware file. (%s) " \
-		"Please see linux/Documentation/dvb/ for more details " \
-		"on firmware-problems."
+#define	err_str "did not find the firmware file '%s'. You can use <kernel_dir>/scripts/get_dvb_firmware to get the firmware"
 
 struct dw2102_state {
 	u8 initialized;
diff --git a/drivers/media/usb/dvb-usb/gp8psk.c b/drivers/media/usb/dvb-usb/gp8psk.c
index 37f062225ed2..84041db97f01 100644
--- a/drivers/media/usb/dvb-usb/gp8psk.c
+++ b/drivers/media/usb/dvb-usb/gp8psk.c
@@ -135,7 +135,7 @@ static int gp8psk_load_bcm4500fw(struct dvb_usb_device *d)
 	u8 *buf;
 	if ((ret = request_firmware(&fw, bcm4500_firmware,
 					&d->udev->dev)) != 0) {
-		err("did not find the bcm4500 firmware file. (%s) Please see linux/Documentation/dvb/ for more details on firmware-problems. (%d)",
+		err("did not find the bcm4500 firmware file '%s' (status %d). You can use <kernel_dir>/scripts/get_dvb_firmware to get the firmware",
 			bcm4500_firmware,ret);
 		return ret;
 	}
diff --git a/drivers/media/usb/dvb-usb/opera1.c b/drivers/media/usb/dvb-usb/opera1.c
index 946a5ccc8f1a..eeafa3cdbbdc 100644
--- a/drivers/media/usb/dvb-usb/opera1.c
+++ b/drivers/media/usb/dvb-usb/opera1.c
@@ -453,7 +453,7 @@ static int opera1_xilinx_load_firmware(struct usb_device *dev,
 	info("start downloading fpga firmware %s",filename);
 
 	if ((ret = request_firmware(&fw, filename, &dev->dev)) != 0) {
-		err("did not find the firmware file. (%s) Please see linux/Documentation/dvb/ for more details on firmware-problems.",
+		err("did not find the firmware file '%s'. You can use <kernel_dir>/scripts/get_dvb_firmware to get the firmware",
 			filename);
 		return ret;
 	} else {
diff --git a/drivers/media/usb/ttusb-dec/Kconfig b/drivers/media/usb/ttusb-dec/Kconfig
index 290254ab06db..b205903a3c61 100644
--- a/drivers/media/usb/ttusb-dec/Kconfig
+++ b/drivers/media/usb/ttusb-dec/Kconfig
@@ -12,9 +12,9 @@ config DVB_TTUSB_DEC
 	  an external software decoder to watch TV on your computer.
 
 	  This driver needs external firmware. Please use the commands
-	  "<kerneldir>/Documentation/dvb/get_dvb_firmware dec2000t",
-	  "<kerneldir>/Documentation/dvb/get_dvb_firmware dec2540t",
-	  "<kerneldir>/Documentation/dvb/get_dvb_firmware dec3000s",
+	  "<kerneldir>/scripts/get_dvb_firmware dec2000t",
+	  "<kerneldir>/scripts/get_dvb_firmware dec2540t",
+	  "<kerneldir>/scripts/get_dvb_firmware dec3000s",
 	  download/extract them, and then copy them to /usr/lib/hotplug/firmware
 	  or /lib/firmware (depending on configuration of firmware hotplug).
 
-- 
2.17.0
