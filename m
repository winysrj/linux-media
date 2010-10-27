Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:57699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761151Ab0J0Mbp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 08:31:45 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Lee Jones <lee.jones@canonical.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6/7] gspca_xirlink_cit: Add support camera button
Date: Wed, 27 Oct 2010 14:35:25 +0200
Message-Id: <1288182926-25400-7-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1288182926-25400-1-git-send-email-hdegoede@redhat.com>
References: <1288182926-25400-1-git-send-email-hdegoede@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/xirlink_cit.c |  117 ++++++++++++++++++++++---------
 1 files changed, 84 insertions(+), 33 deletions(-)

diff --git a/drivers/media/video/gspca/xirlink_cit.c b/drivers/media/video/gspca/xirlink_cit.c
index ea73377..f884727 100644
--- a/drivers/media/video/gspca/xirlink_cit.c
+++ b/drivers/media/video/gspca/xirlink_cit.c
@@ -29,6 +29,7 @@
 
 #define MODULE_NAME "xirlink-cit"
 
+#include <linux/input.h>
 #include "gspca.h"
 
 MODULE_AUTHOR("Hans de Goede <hdegoede@redhat.com>");
@@ -58,6 +59,7 @@ struct sd {
 #define CIT_MODEL4 4
 #define CIT_IBM_NETCAM_PRO 5
 	u8 input_index;
+	u8 button_state;
 	u8 stop_on_control_change;
 	u8 sof_read;
 	u8 sof_len;
@@ -804,7 +806,7 @@ static int cit_write_reg(struct gspca_dev *gspca_dev, u16 value, u16 index)
 	return 0;
 }
 
-static int cit_read_reg(struct gspca_dev *gspca_dev, u16 index)
+static int cit_read_reg(struct gspca_dev *gspca_dev, u16 index, int verbose)
 {
 	struct usb_device *udev = gspca_dev->dev;
 	__u8 *buf = gspca_dev->usb_buf;
@@ -819,10 +821,8 @@ static int cit_read_reg(struct gspca_dev *gspca_dev, u16 index)
 		return res;
 	}
 
-	PDEBUG(D_PROBE,
-	       "Register %04x value: %02x %02x %02x %02x %02x %02x %02x %02x",
-	       index,
-	       buf[0], buf[1], buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
+	if (verbose)
+		PDEBUG(D_PROBE, "Register %04x value: %02x", index, buf[0]);
 
 	return 0;
 }
@@ -907,7 +907,7 @@ static void cit_Packet_Format1(struct gspca_dev *gspca_dev, u16 fkey, u16 val)
 	cit_send_x_00_05(gspca_dev, 0x0089);
 	cit_send_x_00(gspca_dev, fkey);
 	cit_send_00_04_06(gspca_dev);
-	cit_read_reg(gspca_dev, 0x0126);
+	cit_read_reg(gspca_dev, 0x0126, 0);
 	cit_send_FF_04_02(gspca_dev);
 }
 
@@ -1074,12 +1074,12 @@ static int cit_init_model0(struct gspca_dev *gspca_dev)
 
 static int cit_init_ibm_netcam_pro(struct gspca_dev *gspca_dev)
 {
-	cit_read_reg(gspca_dev, 0x128);
+	cit_read_reg(gspca_dev, 0x128, 1);
 	cit_write_reg(gspca_dev, 0x0003, 0x0133);
 	cit_write_reg(gspca_dev, 0x0000, 0x0117);
 	cit_write_reg(gspca_dev, 0x0008, 0x0123);
 	cit_write_reg(gspca_dev, 0x0000, 0x0100);
-	cit_read_reg(gspca_dev, 0x0116);
+	cit_read_reg(gspca_dev, 0x0116, 0);
 	cit_write_reg(gspca_dev, 0x0060, 0x0116);
 	cit_write_reg(gspca_dev, 0x0002, 0x0112);
 	cit_write_reg(gspca_dev, 0x0000, 0x0133);
@@ -1098,7 +1098,7 @@ static int cit_init_ibm_netcam_pro(struct gspca_dev *gspca_dev)
 	cit_write_reg(gspca_dev, 0x00ff, 0x0130);
 	cit_write_reg(gspca_dev, 0xcd41, 0x0124);
 	cit_write_reg(gspca_dev, 0xfffa, 0x0124);
-	cit_read_reg(gspca_dev, 0x0126);
+	cit_read_reg(gspca_dev, 0x0126, 1);
 
 	cit_model3_Packet1(gspca_dev, 0x0000, 0x0000);
 	cit_model3_Packet1(gspca_dev, 0x0000, 0x0001);
@@ -1557,18 +1557,20 @@ static int cit_restart_stream(struct gspca_dev *gspca_dev)
 	switch (sd->model) {
 	case CIT_MODEL0:
 	case CIT_MODEL1:
-	case CIT_MODEL3:
-	case CIT_IBM_NETCAM_PRO:
 		cit_write_reg(gspca_dev, 0x0001, 0x0114);
 		/* Fall through */
 	case CIT_MODEL2:
 	case CIT_MODEL4:
 		cit_write_reg(gspca_dev, 0x00c0, 0x010c); /* Go! */
 		usb_clear_halt(gspca_dev->dev, gspca_dev->urb[0]->pipe);
-		/* This happens repeatedly while streaming with the ibm netcam
-		   pro and the ibmcam driver did it for model3 after changing
-		   settings, but it does not seem to have any effect. */
-		/* cit_write_reg(gspca_dev, 0x0001, 0x0113); */
+		break;
+	case CIT_MODEL3:
+	case CIT_IBM_NETCAM_PRO:
+		cit_write_reg(gspca_dev, 0x0001, 0x0114);
+		cit_write_reg(gspca_dev, 0x00c0, 0x010c); /* Go! */
+		usb_clear_halt(gspca_dev->dev, gspca_dev->urb[0]->pipe);
+		/* Clear button events from while we were not streaming */
+		cit_write_reg(gspca_dev, 0x0001, 0x0113);
 		break;
 	}
 
@@ -1680,23 +1682,23 @@ static int cit_start_model1(struct gspca_dev *gspca_dev)
 	if (clock_div < 0)
 		return clock_div;
 
-	cit_read_reg(gspca_dev, 0x0128);
-	cit_read_reg(gspca_dev, 0x0100);
+	cit_read_reg(gspca_dev, 0x0128, 1);
+	cit_read_reg(gspca_dev, 0x0100, 0);
 	cit_write_reg(gspca_dev, 0x01, 0x0100);	/* LED On  */
-	cit_read_reg(gspca_dev, 0x0100);
+	cit_read_reg(gspca_dev, 0x0100, 0);
 	cit_write_reg(gspca_dev, 0x81, 0x0100);	/* LED Off */
-	cit_read_reg(gspca_dev, 0x0100);
+	cit_read_reg(gspca_dev, 0x0100, 0);
 	cit_write_reg(gspca_dev, 0x01, 0x0100);	/* LED On  */
 	cit_write_reg(gspca_dev, 0x01, 0x0108);
 
 	cit_write_reg(gspca_dev, 0x03, 0x0112);
-	cit_read_reg(gspca_dev, 0x0115);
+	cit_read_reg(gspca_dev, 0x0115, 0);
 	cit_write_reg(gspca_dev, 0x06, 0x0115);
-	cit_read_reg(gspca_dev, 0x0116);
+	cit_read_reg(gspca_dev, 0x0116, 0);
 	cit_write_reg(gspca_dev, 0x44, 0x0116);
-	cit_read_reg(gspca_dev, 0x0116);
+	cit_read_reg(gspca_dev, 0x0116, 0);
 	cit_write_reg(gspca_dev, 0x40, 0x0116);
-	cit_read_reg(gspca_dev, 0x0115);
+	cit_read_reg(gspca_dev, 0x0115, 0);
 	cit_write_reg(gspca_dev, 0x0e, 0x0115);
 	cit_write_reg(gspca_dev, 0x19, 0x012c);
 
@@ -1878,7 +1880,7 @@ static int cit_start_model2(struct gspca_dev *gspca_dev)
 	int clock_div = 0;
 
 	cit_write_reg(gspca_dev, 0x0000, 0x0100);	/* LED on */
-	cit_read_reg(gspca_dev, 0x0116);
+	cit_read_reg(gspca_dev, 0x0116, 0);
 	cit_write_reg(gspca_dev, 0x0060, 0x0116);
 	cit_write_reg(gspca_dev, 0x0002, 0x0112);
 	cit_write_reg(gspca_dev, 0x00bc, 0x012c);
@@ -2070,10 +2072,10 @@ static int cit_start_model3(struct gspca_dev *gspca_dev)
 
 	/* HDG not in ibmcam driver, added to see if it helps with
 	   auto-detecting between model3 and ibm netcamera pro */
-	cit_read_reg(gspca_dev, 0x128);
+	cit_read_reg(gspca_dev, 0x128, 1);
 
 	cit_write_reg(gspca_dev, 0x0000, 0x0100);
-	cit_read_reg(gspca_dev, 0x0116);
+	cit_read_reg(gspca_dev, 0x0116, 0);
 	cit_write_reg(gspca_dev, 0x0060, 0x0116);
 	cit_write_reg(gspca_dev, 0x0002, 0x0112);
 	cit_write_reg(gspca_dev, 0x0000, 0x0123);
@@ -2083,7 +2085,7 @@ static int cit_start_model3(struct gspca_dev *gspca_dev)
 	cit_write_reg(gspca_dev, 0x0060, 0x0116);
 	cit_write_reg(gspca_dev, 0x0002, 0x0115);
 	cit_write_reg(gspca_dev, 0x0003, 0x0115);
-	cit_read_reg(gspca_dev, 0x0115);
+	cit_read_reg(gspca_dev, 0x0115, 0);
 	cit_write_reg(gspca_dev, 0x000b, 0x0115);
 
 	/* TESTME HDG not in ibmcam driver, added to see if it helps with
@@ -2096,7 +2098,7 @@ static int cit_start_model3(struct gspca_dev *gspca_dev)
 		cit_write_reg(gspca_dev, 0x00ff, 0x0130);
 		cit_write_reg(gspca_dev, 0xcd41, 0x0124);
 		cit_write_reg(gspca_dev, 0xfffa, 0x0124);
-		cit_read_reg(gspca_dev, 0x0126);
+		cit_read_reg(gspca_dev, 0x0126, 1);
 	}
 
 	cit_model3_Packet1(gspca_dev, 0x000a, 0x0040);
@@ -2293,7 +2295,7 @@ static int cit_start_model3(struct gspca_dev *gspca_dev)
 	if (rca_input) {
 		for (i = 0; i < ARRAY_SIZE(rca_initdata); i++) {
 			if (rca_initdata[i][0])
-				cit_read_reg(gspca_dev, rca_initdata[i][2]);
+				cit_read_reg(gspca_dev, rca_initdata[i][2], 0);
 			else
 				cit_write_reg(gspca_dev, rca_initdata[i][1],
 					      rca_initdata[i][2]);
@@ -2712,7 +2714,7 @@ static int cit_start_ibm_netcam_pro(struct gspca_dev *gspca_dev)
 	if (rca_input) {
 		for (i = 0; i < ARRAY_SIZE(rca_initdata); i++) {
 			if (rca_initdata[i][0])
-				cit_read_reg(gspca_dev, rca_initdata[i][2]);
+				cit_read_reg(gspca_dev, rca_initdata[i][2], 0);
 			else
 				cit_write_reg(gspca_dev, rca_initdata[i][1],
 					      rca_initdata[i][2]);
@@ -2839,7 +2841,7 @@ static void sd_stop0(struct gspca_dev *gspca_dev)
 		break;
 	case CIT_MODEL1:
 		cit_send_FF_04_02(gspca_dev);
-		cit_read_reg(gspca_dev, 0x0100);
+		cit_read_reg(gspca_dev, 0x0100, 0);
 		cit_write_reg(gspca_dev, 0x81, 0x0100);	/* LED Off */
 		break;
 	case CIT_MODEL2:
@@ -2858,9 +2860,9 @@ static void sd_stop0(struct gspca_dev *gspca_dev)
 	case CIT_MODEL3:
 		cit_write_reg(gspca_dev, 0x0006, 0x012c);
 		cit_model3_Packet1(gspca_dev, 0x0046, 0x0000);
-		cit_read_reg(gspca_dev, 0x0116);
+		cit_read_reg(gspca_dev, 0x0116, 0);
 		cit_write_reg(gspca_dev, 0x0064, 0x0116);
-		cit_read_reg(gspca_dev, 0x0115);
+		cit_read_reg(gspca_dev, 0x0115, 0);
 		cit_write_reg(gspca_dev, 0x0003, 0x0115);
 		cit_write_reg(gspca_dev, 0x0008, 0x0123);
 		cit_write_reg(gspca_dev, 0x0000, 0x0117);
@@ -2885,6 +2887,15 @@ static void sd_stop0(struct gspca_dev *gspca_dev)
 		cit_write_reg(gspca_dev, 0x00c0, 0x0100);
 		break;
 	}
+
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+	/* If the last button state is pressed, release it now! */
+	if (sd->button_state) {
+		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 0);
+		input_sync(gspca_dev->input_dev);
+		sd->button_state = 0;
+	}
+#endif
 }
 
 static u8 *cit_find_sof(struct gspca_dev *gspca_dev, u8 *data, int len)
@@ -3178,6 +3189,38 @@ static int sd_gethflip(struct gspca_dev *gspca_dev, __s32 *val)
 	return 0;
 }
 
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+static void cit_check_button(struct gspca_dev *gspca_dev)
+{
+	int new_button_state;
+	struct sd *sd = (struct sd *)gspca_dev;
+
+	switch (sd->model) {
+	case CIT_MODEL3:
+	case CIT_IBM_NETCAM_PRO:
+		break;
+	default: /* TEST ME unknown if this works on other models too */
+		return;
+	}
+
+	/* Read the button state */
+	cit_read_reg(gspca_dev, 0x0113, 0);
+	new_button_state = !gspca_dev->usb_buf[0];
+
+	/* Tell the cam we've seen the button press, notice that this
+	   is a nop (iow the cam keeps reporting pressed) until the
+	   button is actually released. */
+	if (new_button_state)
+		cit_write_reg(gspca_dev, 0x01, 0x0113);
+
+	if (sd->button_state != new_button_state) {
+		input_report_key(gspca_dev->input_dev, KEY_CAMERA,
+				 new_button_state);
+		input_sync(gspca_dev->input_dev);
+		sd->button_state = new_button_state;
+	}
+}
+#endif
 
 /* sub-driver description */
 static const struct sd_desc sd_desc = {
@@ -3190,6 +3233,10 @@ static const struct sd_desc sd_desc = {
 	.stopN = sd_stopN,
 	.stop0 = sd_stop0,
 	.pkt_scan = sd_pkt_scan,
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+	.dq_callback = cit_check_button,
+	.other_input = 1,
+#endif
 };
 
 static const struct sd_desc sd_desc_isoc_nego = {
@@ -3204,6 +3251,10 @@ static const struct sd_desc sd_desc_isoc_nego = {
 	.stopN = sd_stopN,
 	.stop0 = sd_stop0,
 	.pkt_scan = sd_pkt_scan,
+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
+	.dq_callback = cit_check_button,
+	.other_input = 1,
+#endif
 };
 
 /* -- module initialisation -- */
-- 
1.7.3.1

