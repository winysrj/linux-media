Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:58289 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab0ASRdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 12:33:39 -0500
Received: by ywh12 with SMTP id 12so2669601ywh.21
        for <linux-media@vger.kernel.org>; Tue, 19 Jan 2010 09:33:39 -0800 (PST)
Date: Tue, 19 Jan 2010 15:33:35 -0200
From: Nicolau Werneck <nwerneck@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] Support for LT168G sensor on t613 webcam driver
Message-ID: <20100119173335.GA18065@pathfinder.pcs.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch to support this sensor, with id code 0x0802, on the t613
driver. I just sniffed the values from the driver that came with mine,
and made the proper extensions to the original code.

Signed-off-by: Nicolau Werneck <nwerneck@gmail.com>
diff -Nru gspca-54a57b75f98c/linux/drivers/media/video/gspca/t613.c gspca-54a57b75f98c-dev/linux/drivers/media/video/gspca/t613.c
--- gspca-54a57b75f98c/linux/drivers/media/video/gspca/t613.c	2009-12-30 02:53:07.000000000 -0500
+++ gspca-54a57b75f98c-dev/linux/drivers/media/video/gspca/t613.c	2009-12-30 10:52:47.000000000 -0500
@@ -52,6 +52,7 @@
 #define SENSOR_OM6802 0
 #define SENSOR_OTHER 1
 #define SENSOR_TAS5130A 2
+#define SENSOR_LT168G 3     /* must verify if this is the actual model */
 };
 
 /* V4L2 controls supported by the driver */
@@ -306,6 +307,17 @@
 	0xbe, 0x36, 0xbf, 0xff, 0xc2, 0x88, 0xc5, 0xc8,
 	0xc6, 0xda
 };
+static const u8 n4_lt168g[] = {
+	0x66, 0x01, 0x7f, 0x00, 0x80, 0x7c, 0x81, 0x28,
+	0x83, 0x44, 0x84, 0x20, 0x86, 0x20, 0x8a, 0x70,
+	0x8b, 0x58, 0x8c, 0x88, 0x8d, 0xa0, 0x8e, 0xb3,
+	0x8f, 0x24, 0xa1, 0xb0, 0xa2, 0x38, 0xa5, 0x20,
+	0xa6, 0x4a, 0xa8, 0xe8, 0xaf, 0x38, 0xb0, 0x68,
+	0xb1, 0x44, 0xb2, 0x88, 0xbb, 0x86, 0xbd, 0x40,
+	0xbe, 0x26, 0xc1, 0x05, 0xc2, 0x88, 0xc5, 0xc0,
+	0xda, 0x8e, 0xdb, 0xca, 0xdc, 0xa8, 0xdd, 0x8c,
+	0xde, 0x44, 0xdf, 0x0c, 0xe9, 0x80
+};
 
 static const struct additional_sensor_data sensor_data[] = {
     {				/* 0: OM6802 */
@@ -422,6 +434,23 @@
 	.stream =
 		{0x0b, 0x04, 0x0a, 0x40},
     },
+    {				/* 3: LT168G */
+	.n3 = {0x61, 0xc2, 0x65, 0x68, 0x60, 0x00},
+	.n4 = n4_lt168g,
+	.n4sz = sizeof n4_lt168g,
+	.reg80 = 0x7c,
+	.reg8e = 0xb3,
+	.nset8 = {0xa8, 0xf0, 0xc6, 0xba, 0xc0, 0x00},
+	.data1 = {0xc0, 0x38, 0x08, 0x10, 0xc0, 0x30, 0x10, 0x40,
+		 0xb0, 0xf4},
+	.data2 = {0x40, 0x80, 0xc0, 0x50, 0xa0, 0xf0, 0x53, 0xa6,
+		 0xff},
+	.data3 = {0x40, 0x80, 0xc0, 0x50, 0xa0, 0xf0, 0x53, 0xa6,
+		 0xff},
+	.data4 = {0x66, 0x41, 0xa8, 0xf0},
+	.data5 = {0x0c, 0x03, 0xab, 0x4b, 0x81, 0x2b},
+	.stream = {0x0b, 0x04, 0x0a, 0x28},
+    },
 };
 
 #define MAX_EFFECTS 7
@@ -758,6 +787,10 @@
 		PDEBUG(D_PROBE, "sensor tas5130a");
 		sd->sensor = SENSOR_TAS5130A;
 		break;
+	case 0x0802:
+		PDEBUG(D_PROBE, "sensor lt168g");
+		sd->sensor = SENSOR_LT168G;
+		break;
 	case 0x0803:
 		PDEBUG(D_PROBE, "sensor 'other'");
 		sd->sensor = SENSOR_OTHER;
@@ -800,6 +833,13 @@
 	reg_w_buf(gspca_dev, sensor->n3, sizeof sensor->n3);
 	reg_w_buf(gspca_dev, sensor->n4, sensor->n4sz);
 
+	if (sd->sensor == SENSOR_LT168G) {
+		test_byte = reg_r(gspca_dev, 0x80);
+		PDEBUG(D_STREAM, "Reg 0x%02x = 0x%02x", 0x80,
+		       test_byte);
+		reg_w(gspca_dev, 0x6c80);
+	}
+
 	reg_w_ixbuf(gspca_dev, 0xd0, sensor->data1, sizeof sensor->data1);
 	reg_w_ixbuf(gspca_dev, 0xc7, sensor->data2, sizeof sensor->data2);
 	reg_w_ixbuf(gspca_dev, 0xe0, sensor->data3, sizeof sensor->data3);
@@ -824,6 +864,13 @@
 	reg_w_buf(gspca_dev, sensor->nset8, sizeof sensor->nset8);
 	reg_w_buf(gspca_dev, sensor->stream, sizeof sensor->stream);
 
+	if (sd->sensor == SENSOR_LT168G) {
+		test_byte = reg_r(gspca_dev, 0x80);
+		PDEBUG(D_STREAM, "Reg 0x%02x = 0x%02x", 0x80,
+		       test_byte);
+		reg_w(gspca_dev, 0x6c80);
+	}
+
 	reg_w_ixbuf(gspca_dev, 0xd0, sensor->data1, sizeof sensor->data1);
 	reg_w_ixbuf(gspca_dev, 0xc7, sensor->data2, sizeof sensor->data2);
 	reg_w_ixbuf(gspca_dev, 0xe0, sensor->data3, sizeof sensor->data3);
@@ -930,6 +977,8 @@
 	case SENSOR_OM6802:
 		om6802_sensor_init(gspca_dev);
 		break;
+	case SENSOR_LT168G:
+		break;
 	case SENSOR_OTHER:
 		break;
 	default:

