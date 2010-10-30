Return-path: <mchehab@gaivota>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56805 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab0J3St4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Oct 2010 14:49:56 -0400
Received: by pzk3 with SMTP id 3so263310pzk.19
        for <linux-media@vger.kernel.org>; Sat, 30 Oct 2010 11:49:56 -0700 (PDT)
Message-ID: <4CCC68CD.50409@gmail.com>
Date: Sat, 30 Oct 2010 11:49:49 -0700
From: "D. K." <user.vdr@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] dvb-usb-gp8psk: get firmware and fpga versions
Content-Type: multipart/mixed;
 boundary="------------080806060502080404000903"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is a multi-part message in MIME format.
--------------080806060502080404000903
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

 This patch adds retrieval of firmware and FPGA versions of Genpix devices.
That information is useful for users who experience performance differences
with the various firmware versions, and may want to use a specific firmware
that best suits their needs.

Example dmesg output:
gp8psk: FW Version = 2.09.4 (0x20904)  Build 2009/04/02
gp8psk: FPGA Version = 1

Signed-off-by: Derek Kelly <user.vdr@gmail.com>


--------------080806060502080404000903
Content-Type: text/plain;
 name="gp8psk-get_fw_fpga_git.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="gp8psk-get_fw_fpga_git.diff"

diff -pruN v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/gp8psk.c v4l-dvb/linux/drivers/media/dvb/dvb-usb/gp8psk.c
--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/gp8psk.c	2010-10-30 11:20:46.000000000 -0700
+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/gp8psk.c	2010-10-30 11:21:36.000000000 -0700
@@ -24,6 +24,33 @@ MODULE_PARM_DESC(debug, "set debugging l
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
+static int gp8psk_get_fw_version(struct dvb_usb_device *d, u8 *fw_vers)
+{
+	return (gp8psk_usb_in_op(d, GET_FW_VERS, 0, 0, fw_vers, 6));
+}
+
+static int gp8psk_get_fpga_version(struct dvb_usb_device *d, u8 *fpga_vers)
+{
+	return (gp8psk_usb_in_op(d, GET_FPGA_VERS, 0, 0, fpga_vers, 1));
+}
+
+static void gp8psk_info(struct dvb_usb_device *d)
+{
+	u8 fpga_vers, fw_vers[6];
+
+	if (!gp8psk_get_fw_version(d, fw_vers))
+		info("FW Version = %i.%02i.%i (0x%x)  Build %4i/%02i/%02i",
+		fw_vers[2], fw_vers[1], fw_vers[0], GP8PSK_FW_VERS(fw_vers),
+		2000 + fw_vers[5], fw_vers[4], fw_vers[3]);
+	else
+		info("failed to get FW version");
+
+	if (!gp8psk_get_fpga_version(d, &fpga_vers))
+		info("FPGA Version = %i", fpga_vers);
+	else
+		info("failed to get FPGA version");
+}
+
 int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen)
 {
 	int ret = 0,try = 0;
@@ -146,6 +173,7 @@ static int gp8psk_power_ctrl(struct dvb_
 				gp8psk_usb_out_op(d, CW3K_INIT, 1, 0, NULL, 0);
 			if (gp8psk_usb_in_op(d, BOOT_8PSK, 1, 0, &buf, 1))
 				return -EINVAL;
+			gp8psk_info(d);
 		}
 
 		if (gp_product_id == USB_PID_GENPIX_8PSK_REV_1_WARM)
diff -pruN v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/gp8psk.h v4l-dvb/linux/drivers/media/dvb/dvb-usb/gp8psk.h
--- v4l-dvb.orig/linux/drivers/media/dvb/dvb-usb/gp8psk.h	2010-10-30 11:20:46.000000000 -0700
+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/gp8psk.h	2010-10-30 11:24:30.000000000 -0700
@@ -25,7 +25,6 @@ extern int dvb_usb_gp8psk_debug;
 #define deb_xfer(args...) dprintk(dvb_usb_gp8psk_debug,0x02,args)
 #define deb_rc(args...)   dprintk(dvb_usb_gp8psk_debug,0x04,args)
 #define deb_fe(args...)   dprintk(dvb_usb_gp8psk_debug,0x08,args)
-/* gp8psk commands */
 
 /* Twinhan Vendor requests */
 #define TH_COMMAND_IN                     0xC0
@@ -49,8 +48,10 @@ extern int dvb_usb_gp8psk_debug;
 #define SET_DVB_MODE                    0x8E
 #define SET_DN_SWITCH                   0x8F
 #define GET_SIGNAL_LOCK                 0x90    /* in */
+#define GET_FW_VERS			0x92
 #define GET_SERIAL_NUMBER               0x93    /* in */
 #define USE_EXTRA_VOLT                  0x94
+#define GET_FPGA_VERS			0x95
 #define CW3K_INIT			0x9d
 
 /* PSK_configuration bits */
@@ -88,6 +89,11 @@ extern int dvb_usb_gp8psk_debug;
 #define PRODUCT_STRING_READ               0x0D
 #define FW_BCD_VERSION_READ               0x14
 
+/* firmware revision id's */
+#define GP8PSK_FW_REV1			0x020604
+#define GP8PSK_FW_REV2			0x020704
+#define GP8PSK_FW_VERS(_fw_vers)	((_fw_vers)[2]<<0x10 | (_fw_vers)[1]<<0x08 | (_fw_vers)[0])
+
 extern struct dvb_frontend * gp8psk_fe_attach(struct dvb_usb_device *d);
 extern int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen);
 extern int gp8psk_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,

--------------080806060502080404000903--
