Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59108 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757006AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sean Young <sean@mess.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Alejandro Torrado <aletorrado@gmail.com>,
        Nicolas Sugino <nsugino@3way.com.ar>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Olli Salonen <olli.salonen@iki.fi>,
        Jonathan McDowell <noodles@earth.li>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 37/57] [media] dvb-usb: don't break long lines
Date: Fri, 14 Oct 2016 17:20:25 -0300
Message-Id: <4f8e20ec8f685dc29e5c695857115c2e6c85547d.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/dvb-usb/cinergyT2-core.c   |  6 ++----
 drivers/media/usb/dvb-usb/dib0700_core.c     |  5 +----
 drivers/media/usb/dvb-usb/dib0700_devices.c  |  3 +--
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c      |  3 +--
 drivers/media/usb/dvb-usb/dvb-usb-firmware.c |  6 ++----
 drivers/media/usb/dvb-usb/dw2102.c           | 10 ++--------
 drivers/media/usb/dvb-usb/friio.c            |  3 +--
 drivers/media/usb/dvb-usb/gp8psk.c           |  3 +--
 drivers/media/usb/dvb-usb/opera1.c           |  3 +--
 drivers/media/usb/dvb-usb/technisat-usb2.c   |  3 +--
 10 files changed, 13 insertions(+), 32 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/cinergyT2-core.c b/drivers/media/usb/dvb-usb/cinergyT2-core.c
index 9fd1527494eb..f4d9122245ac 100644
--- a/drivers/media/usb/dvb-usb/cinergyT2-core.c
+++ b/drivers/media/usb/dvb-usb/cinergyT2-core.c
@@ -34,8 +34,7 @@
 int dvb_usb_cinergyt2_debug;
 
 module_param_named(debug, dvb_usb_cinergyt2_debug, int, 0644);
-MODULE_PARM_DESC(debug, "set debugging level (1=info, xfer=2, rc=4 "
-		"(or-able)).");
+MODULE_PARM_DESC(debug, "set debugging level (1=info, xfer=2, rc=4 (or-able)).");
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
@@ -74,8 +73,7 @@ static int cinergyt2_frontend_attach(struct dvb_usb_adapter *adap)
 	ret = dvb_usb_generic_rw(adap->dev, query, sizeof(query), state,
 				sizeof(state), 0);
 	if (ret < 0) {
-		deb_rc("cinergyt2_power_ctrl() Failed to retrieve sleep "
-			"state info\n");
+		deb_rc("cinergyt2_power_ctrl() Failed to retrieve sleep state info\n");
 	}
 
 	/* Copy this pointer as we are gonna need it in the release phase */
diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index f3196658fb70..855cfc7bf309 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -16,10 +16,7 @@ MODULE_PARM_DESC(debug, "set debugging level (1=info,2=fw,4=fwdata,8=data (or-ab
 static int nb_packet_buffer_size = 21;
 module_param(nb_packet_buffer_size, int, 0644);
 MODULE_PARM_DESC(nb_packet_buffer_size,
-	"Set the dib0700 driver data buffer size. This parameter "
-	"corresponds to the number of TS packets. The actual size of "
-	"the data buffer corresponds to this parameter "
-	"multiplied by 188 (default: 21)");
+	"Set the dib0700 driver data buffer size. This parameter corresponds to the number of TS packets. The actual size of the data buffer corresponds to this parameter multiplied by 188 (default: 21)");
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 0857b56e652c..5668d8d69917 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -26,8 +26,7 @@
 
 static int force_lna_activation;
 module_param(force_lna_activation, int, 0644);
-MODULE_PARM_DESC(force_lna_activation, "force the activation of Low-Noise-Amplifyer(s) (LNA), "
-		"if applicable for the device (default: 0=automatic/off).");
+MODULE_PARM_DESC(force_lna_activation, "force the activation of Low-Noise-Amplifyer(s) (LNA), if applicable for the device (default: 0=automatic/off).");
 
 struct dib0700_adapter_state {
 	int (*set_param_save) (struct dvb_frontend *);
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
index a04c0a250625..e5675da286cb 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -277,8 +277,7 @@ int dvb_usb_adapter_frontend_init(struct dvb_usb_adapter *adap)
 	for (i = 0; i < adap->props.num_frontends; i++) {
 
 		if (adap->props.fe[i].frontend_attach == NULL) {
-			err("strange: '%s' #%d,%d "
-			    "doesn't want to attach a frontend.",
+			err("strange: '%s' #%d,%d doesn't want to attach a frontend.",
 			    adap->dev->desc->name, adap->id, i);
 
 			return 0;
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-firmware.c b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
index dd048a7c461c..f0023dbb7276 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-firmware.c
@@ -49,8 +49,7 @@ int usb_cypress_load_firmware(struct usb_device *udev, const struct firmware *fw
 		ret = usb_cypress_writemem(udev,hx.addr,hx.data,hx.len);
 
 		if (ret != hx.len) {
-			err("error while transferring firmware "
-				"(transferred size: %d, block size: %d)",
+			err("error while transferring firmware (transferred size: %d, block size: %d)",
 				ret,hx.len);
 			ret = -EINVAL;
 			break;
@@ -81,8 +80,7 @@ int dvb_usb_download_firmware(struct usb_device *udev, struct dvb_usb_device_pro
 	const struct firmware *fw = NULL;
 
 	if ((ret = request_firmware(&fw, props->firmware, &udev->dev)) != 0) {
-		err("did not find the firmware file. (%s) "
-			"Please see linux/Documentation/dvb/ for more details on firmware-problems. (%d)",
+		err("did not find the firmware file. (%s) Please see linux/Documentation/dvb/ for more details on firmware-problems. (%d)",
 			props->firmware,ret);
 		return ret;
 	}
diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 5fb0c650926e..008d71905f2e 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -86,8 +86,7 @@ MODULE_PARM_DESC(debug, "set debugging level (1=info 2=xfer 4=rc(or-able))."
 /* demod probe */
 static int demod_probe = 1;
 module_param_named(demod, demod_probe, int, 0644);
-MODULE_PARM_DESC(demod, "demod to probe (1=cx24116 2=stv0903+stv6110 "
-			"4=stv0903+stb6100(or-able)).");
+MODULE_PARM_DESC(demod, "demod to probe (1=cx24116 2=stv0903+stv6110 4=stv0903+stb6100(or-able)).");
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
@@ -2343,12 +2342,7 @@ static struct usb_driver dw2102_driver = {
 module_usb_driver(dw2102_driver);
 
 MODULE_AUTHOR("Igor M. Liplianin (c) liplianin@me.by");
-MODULE_DESCRIPTION("Driver for DVBWorld DVB-S 2101, 2102, DVB-S2 2104,"
-			" DVB-C 3101 USB2.0,"
-			" TeVii S421, S480, S482, S600, S630, S632, S650,"
-			" TeVii S660, S662, Prof 1100, 7500 USB2.0,"
-			" Geniatech SU3000, T220,"
-			" TechnoTrend S2-4600, Terratec Cinergy S2 devices");
+MODULE_DESCRIPTION("Driver for DVBWorld DVB-S 2101, 2102, DVB-S2 2104, DVB-C 3101 USB2.0, TeVii S421, S480, S482, S600, S630, S632, S650, TeVii S660, S662, Prof 1100, 7500 USB2.0, Geniatech SU3000, T220, TechnoTrend S2-4600, Terratec Cinergy S2 devices");
 MODULE_VERSION("0.1");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(DW2101_FIRMWARE);
diff --git a/drivers/media/usb/dvb-usb/friio.c b/drivers/media/usb/dvb-usb/friio.c
index 474a17e4db0c..4ab0b04234cd 100644
--- a/drivers/media/usb/dvb-usb/friio.c
+++ b/drivers/media/usb/dvb-usb/friio.c
@@ -320,8 +320,7 @@ static int friio_initialize(struct dvb_usb_device *d)
  */
 	if (rbuf[0] & 0x80) {	/* still in PowerOnReset state? */
 		if (++retry > 3) {
-			deb_info("failed to get the correct"
-				 " FE demod status:0x%02x\n", rbuf[0]);
+			deb_info("failed to get the correct FE demod status:0x%02x\n", rbuf[0]);
 			goto error;
 		}
 		msleep(100);
diff --git a/drivers/media/usb/dvb-usb/gp8psk.c b/drivers/media/usb/dvb-usb/gp8psk.c
index 5d0384dd45b5..1587dc7c4eb3 100644
--- a/drivers/media/usb/dvb-usb/gp8psk.c
+++ b/drivers/media/usb/dvb-usb/gp8psk.c
@@ -117,8 +117,7 @@ static int gp8psk_load_bcm4500fw(struct dvb_usb_device *d)
 	u8 *buf;
 	if ((ret = request_firmware(&fw, bcm4500_firmware,
 					&d->udev->dev)) != 0) {
-		err("did not find the bcm4500 firmware file. (%s) "
-			"Please see linux/Documentation/dvb/ for more details on firmware-problems. (%d)",
+		err("did not find the bcm4500 firmware file. (%s) Please see linux/Documentation/dvb/ for more details on firmware-problems. (%d)",
 			bcm4500_firmware,ret);
 		return ret;
 	}
diff --git a/drivers/media/usb/dvb-usb/opera1.c b/drivers/media/usb/dvb-usb/opera1.c
index 2566d2f1c2ad..946a5ccc8f1a 100644
--- a/drivers/media/usb/dvb-usb/opera1.c
+++ b/drivers/media/usb/dvb-usb/opera1.c
@@ -453,8 +453,7 @@ static int opera1_xilinx_load_firmware(struct usb_device *dev,
 	info("start downloading fpga firmware %s",filename);
 
 	if ((ret = request_firmware(&fw, filename, &dev->dev)) != 0) {
-		err("did not find the firmware file. (%s) "
-			"Please see linux/Documentation/dvb/ for more details on firmware-problems.",
+		err("did not find the firmware file. (%s) Please see linux/Documentation/dvb/ for more details on firmware-problems.",
 			filename);
 		return ret;
 	} else {
diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/usb/dvb-usb/technisat-usb2.c
index d9f3262bf071..fbfcabc52f76 100644
--- a/drivers/media/usb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
@@ -50,8 +50,7 @@ MODULE_PARM_DESC(debug,
 static int disable_led_control;
 module_param(disable_led_control, int, 0444);
 MODULE_PARM_DESC(disable_led_control,
-		"disable LED control of the device "
-		"(default: 0 - LED control is active).");
+		"disable LED control of the device (default: 0 - LED control is active).");
 
 /* device private data */
 struct technisat_usb2_state {
-- 
2.7.4


