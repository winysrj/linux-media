Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:37893 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751483AbdHMIzH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Aug 2017 04:55:07 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: crope@iki.fi, mchehab@kernel.org, ezequiel@vanguardiasur.com.ar,
        laurent.pinchart@ideasonboard.com, royale@zerezo.com,
        sean@mess.org, klimov.linux@gmail.com, hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] [media] usb: constify usb_device_id
Date: Sun, 13 Aug 2017 14:24:43 +0530
Message-Id: <1502614485-2150-2-git-send-email-arvind.yadav.cs@gmail.com>
In-Reply-To: <1502614485-2150-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1502614485-2150-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

usb_device_id are not supposed to change at runtime. All functions
working with usb_device_id provided by <linux/usb.h> work with
const usb_device_id. So mark the non-const structs as const.

'drivers/media/usb/b2c2/flexcop-usb.c' Fix checkpatch.pl error:
ERROR: space prohibited before open square bracket '['.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/usb/airspy/airspy.c                 | 2 +-
 drivers/media/usb/as102/as102_usb_drv.c           | 2 +-
 drivers/media/usb/b2c2/flexcop-usb.c              | 2 +-
 drivers/media/usb/cpia2/cpia2_usb.c               | 2 +-
 drivers/media/usb/dvb-usb-v2/az6007.c             | 2 +-
 drivers/media/usb/hackrf/hackrf.c                 | 2 +-
 drivers/media/usb/hdpvr/hdpvr-core.c              | 2 +-
 drivers/media/usb/msi2500/msi2500.c               | 2 +-
 drivers/media/usb/s2255/s2255drv.c                | 2 +-
 drivers/media/usb/stk1160/stk1160-core.c          | 2 +-
 drivers/media/usb/stkwebcam/stk-webcam.c          | 2 +-
 drivers/media/usb/tm6000/tm6000-cards.c           | 2 +-
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c | 2 +-
 drivers/media/usb/ttusb-dec/ttusb_dec.c           | 2 +-
 drivers/media/usb/usbtv/usbtv-core.c              | 2 +-
 drivers/media/usb/uvc/uvc_driver.c                | 2 +-
 drivers/media/usb/zr364xx/zr364xx.c               | 2 +-
 17 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index 8251942..07f3f4e 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -1087,7 +1087,7 @@ static int airspy_probe(struct usb_interface *intf,
 }
 
 /* USB device ID list */
-static struct usb_device_id airspy_id_table[] = {
+static const struct usb_device_id airspy_id_table[] = {
 	{ USB_DEVICE(0x1d50, 0x60a1) }, /* AirSpy */
 	{ }
 };
diff --git a/drivers/media/usb/as102/as102_usb_drv.c b/drivers/media/usb/as102/as102_usb_drv.c
index 68c3a80..ea57859 100644
--- a/drivers/media/usb/as102/as102_usb_drv.c
+++ b/drivers/media/usb/as102/as102_usb_drv.c
@@ -33,7 +33,7 @@ static void as102_usb_stop_stream(struct as102_dev_t *dev);
 static int as102_open(struct inode *inode, struct file *file);
 static int as102_release(struct inode *inode, struct file *file);
 
-static struct usb_device_id as102_usb_id_table[] = {
+static const struct usb_device_id as102_usb_id_table[] = {
 	{ USB_DEVICE(AS102_USB_DEVICE_VENDOR_ID, AS102_USB_DEVICE_PID_0001) },
 	{ USB_DEVICE(PCTV_74E_USB_VID, PCTV_74E_USB_PID) },
 	{ USB_DEVICE(ELGATO_EYETV_DTT_USB_VID, ELGATO_EYETV_DTT_USB_PID) },
diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
index 788c738..2fb5a54 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -596,7 +596,7 @@ static void flexcop_usb_disconnect(struct usb_interface *intf)
 	info("%s successfully deinitialized and disconnected.", DRIVER_NAME);
 }
 
-static struct usb_device_id flexcop_usb_table [] = {
+static const struct usb_device_id flexcop_usb_table[] = {
 	{ USB_DEVICE(0x0af7, 0x0101) },
 	{ }
 };
diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index 1c7e16e..6089036 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -60,7 +60,7 @@ static int submit_urbs(struct camera_data *cam);
 static int set_alternate(struct camera_data *cam, unsigned int alt);
 static int configure_transfer_mode(struct camera_data *cam, unsigned int alt);
 
-static struct usb_device_id cpia2_id_table[] = {
+static const struct usb_device_id cpia2_id_table[] = {
 	{USB_DEVICE(0x0553, 0x0100)},
 	{USB_DEVICE(0x0553, 0x0140)},
 	{USB_DEVICE(0x0553, 0x0151)},  /* STV0676 */
diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
index 50c07fe..72f2630 100644
--- a/drivers/media/usb/dvb-usb-v2/az6007.c
+++ b/drivers/media/usb/dvb-usb-v2/az6007.c
@@ -933,7 +933,7 @@ static struct dvb_usb_device_properties az6007_cablestar_hdci_props = {
 	}
 };
 
-static struct usb_device_id az6007_usb_table[] = {
+static const struct usb_device_id az6007_usb_table[] = {
 	{DVB_USB_DEVICE(USB_VID_AZUREWAVE, USB_PID_AZUREWAVE_6007,
 		&az6007_props, "Azurewave 6007", RC_MAP_EMPTY)},
 	{DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_H7,
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index d9a5252..a41b305 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -1545,7 +1545,7 @@ static int hackrf_probe(struct usb_interface *intf,
 }
 
 /* USB device ID list */
-static struct usb_device_id hackrf_id_table[] = {
+static const struct usb_device_id hackrf_id_table[] = {
 	{ USB_DEVICE(0x1d50, 0x6089) }, /* HackRF One */
 	{ }
 };
diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index 15f016a..dbe29c6 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -53,7 +53,7 @@ MODULE_PARM_DESC(boost_audio, "boost the audio signal");
 
 
 /* table of devices that work with this driver */
-static struct usb_device_id hdpvr_table[] = {
+static const struct usb_device_id hdpvr_table[] = {
 	{ USB_DEVICE(HD_PVR_VENDOR_ID, HD_PVR_PRODUCT_ID) },
 	{ USB_DEVICE(HD_PVR_VENDOR_ID, HD_PVR_PRODUCT_ID1) },
 	{ USB_DEVICE(HD_PVR_VENDOR_ID, HD_PVR_PRODUCT_ID2) },
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index bb3d31e..79bfd2d 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -1308,7 +1308,7 @@ static int msi2500_probe(struct usb_interface *intf,
 }
 
 /* USB device ID list */
-static struct usb_device_id msi2500_id_table[] = {
+static const struct usb_device_id msi2500_id_table[] = {
 	{USB_DEVICE(0x1df7, 0x2500)}, /* Mirics MSi3101 SDR Dongle */
 	{USB_DEVICE(0x2040, 0xd300)}, /* Hauppauge WinTV 133559 LF */
 	{}
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 6a88b1d..23f606e 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -381,7 +381,7 @@ MODULE_PARM_DESC(jpeg_enable, "Jpeg enable(1-on 0-off) default 1");
 
 /* USB device table */
 #define USB_SENSORAY_VID	0x1943
-static struct usb_device_id s2255_table[] = {
+static const struct usb_device_id s2255_table[] = {
 	{USB_DEVICE(USB_SENSORAY_VID, 0x2255)},
 	{USB_DEVICE(USB_SENSORAY_VID, 0x2257)}, /*same family as 2255*/
 	{ }			/* Terminating entry */
diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
index c86eb61..bea8bbb 100644
--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -47,7 +47,7 @@ MODULE_AUTHOR("Ezequiel Garcia");
 MODULE_DESCRIPTION("STK1160 driver");
 
 /* Devices supported by this driver */
-static struct usb_device_id stk1160_id_table[] = {
+static const struct usb_device_id stk1160_id_table[] = {
 	{ USB_DEVICE(0x05e1, 0x0408) },
 	{ }
 };
diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index 6e7fc36..064ab3d 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -53,7 +53,7 @@ MODULE_AUTHOR("Jaime Velasco Juan <jsagarribay@gmail.com> and Nicolas VIVIEN");
 MODULE_DESCRIPTION("Syntek DC1125 webcam driver");
 
 /* Some cameras have audio interfaces, we aren't interested in those */
-static struct usb_device_id stkwebcam_table[] = {
+static const struct usb_device_id stkwebcam_table[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x174f, 0xa311, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x05e1, 0x0501, 0xff, 0xff, 0xff) },
 	{ }
diff --git a/drivers/media/usb/tm6000/tm6000-cards.c b/drivers/media/usb/tm6000/tm6000-cards.c
index b293dea..2537643 100644
--- a/drivers/media/usb/tm6000/tm6000-cards.c
+++ b/drivers/media/usb/tm6000/tm6000-cards.c
@@ -613,7 +613,7 @@ static struct tm6000_board tm6000_boards[] = {
 };
 
 /* table of devices that work with this driver */
-static struct usb_device_id tm6000_id_table[] = {
+static const struct usb_device_id tm6000_id_table[] = {
 	{ USB_DEVICE(0x6000, 0x0001), .driver_info = TM5600_BOARD_GENERIC },
 	{ USB_DEVICE(0x6000, 0x0002), .driver_info = TM6010_BOARD_GENERIC },
 	{ USB_DEVICE(0x06e1, 0xf332), .driver_info = TM6000_BOARD_ADSTECH_DUAL_TV },
diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
index 361e40b..3600658 100644
--- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
@@ -1795,7 +1795,7 @@ static void ttusb_disconnect(struct usb_interface *intf)
 	dprintk("%s: TTUSB DVB disconnected\n", __func__);
 }
 
-static struct usb_device_id ttusb_table[] = {
+static const struct usb_device_id ttusb_table[] = {
 	{USB_DEVICE(0xb48, 0x1003)},
 	{USB_DEVICE(0xb48, 0x1004)},
 	{USB_DEVICE(0xb48, 0x1005)},
diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 01c7e6d..cdefb5d 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -1791,7 +1791,7 @@ static void ttusb_dec_set_model(struct ttusb_dec *dec,
 	}
 }
 
-static struct usb_device_id ttusb_dec_table[] = {
+static const struct usb_device_id ttusb_dec_table[] = {
 	{USB_DEVICE(0x0b48, 0x1006)},	/* DEC3000-s */
 	/*{USB_DEVICE(0x0b48, 0x1007)},	   Unconfirmed */
 	{USB_DEVICE(0x0b48, 0x1008)},	/* DEC2000-t */
diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
index ceb953b..f06f09a 100644
--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -142,7 +142,7 @@ static void usbtv_disconnect(struct usb_interface *intf)
 	v4l2_device_put(&usbtv->v4l2_dev);
 }
 
-static struct usb_device_id usbtv_id_table[] = {
+static const struct usb_device_id usbtv_id_table[] = {
 	{ USB_DEVICE(0x1b71, 0x3002) },
 	{}
 };
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 70842c5..268a78f 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2284,7 +2284,7 @@ MODULE_PARM_DESC(timeout, "Streaming control requests timeout");
  * VENDOR_SPEC because they don't announce themselves as UVC devices, even
  * though they are compliant.
  */
-static struct usb_device_id uvc_ids[] = {
+static const struct usb_device_id uvc_ids[] = {
 	/* LogiLink Wireless Webcam */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index efdcd5b..25fa81c 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -93,7 +93,7 @@ MODULE_PARM_DESC(mode, "0 = 320x240, 1 = 160x120, 2 = 640x480");
 
 /* Devices supported by this driver
  * .driver_info contains the init method used by the camera */
-static struct usb_device_id device_table[] = {
+static const struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x08ca, 0x0109), .driver_info = METHOD0 },
 	{USB_DEVICE(0x041e, 0x4024), .driver_info = METHOD0 },
 	{USB_DEVICE(0x0d64, 0x0108), .driver_info = METHOD0 },
-- 
2.7.4
