Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:51731 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbZKAV7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Nov 2009 16:59:46 -0500
Message-ID: <4AEE04D4.1040203@freemail.hu>
Date: Sun, 01 Nov 2009 22:59:48 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 2/3] gspca pac7302/pac7311: extract pac_start_frame
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Creating the start of the frame is done in the same way for pac7302
and for pac7311. Extract this common part to the pac_start_frame()
function.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
diff -uprN b/drivers/media/video/gspca/pac7311.c c/drivers/media/video/gspca/pac7311.c
--- b/drivers/media/video/gspca/pac7311.c	2009-11-01 18:11:22.000000000 +0100
+++ c/drivers/media/video/gspca/pac7311.c	2009-11-01 18:16:41.000000000 +0100
@@ -816,7 +816,7 @@ static void do_autogain(struct gspca_dev
 }

 /* JPEG header, part 1 */
-static const unsigned char pac7311_jpeg_header1[] = {
+static const unsigned char pac_jpeg_header1[] = {
   0xff, 0xd8,		/* SOI: Start of Image */

   0xff, 0xc0,		/* SOF0: Start of Frame (Baseline DCT) */
@@ -827,7 +827,7 @@ static const unsigned char pac7311_jpeg_
 };

 /* JPEG header, continued */
-static const unsigned char pac7311_jpeg_header2[] = {
+static const unsigned char pac_jpeg_header2[] = {
   0x03,			/* Number of image components: 3 */
   0x01, 0x21, 0x00,	/* ID=1, Subsampling 1x1, Quantization table: 0 */
   0x02, 0x11, 0x01,	/* ID=2, Subsampling 2x1, Quantization table: 1 */
@@ -843,6 +843,26 @@ static const unsigned char pac7311_jpeg_
   0x00			/* Successive approximation: 0 */
 };

+static void pac_start_frame(struct gspca_dev *gspca_dev,
+		struct gspca_frame *frame,
+		__u16 lines, __u16 samples_per_line)
+{
+	unsigned char tmpbuf[4];
+
+	gspca_frame_add(gspca_dev, FIRST_PACKET, frame,
+		pac_jpeg_header1, sizeof(pac_jpeg_header1));
+
+	tmpbuf[0] = lines >> 8;
+	tmpbuf[1] = lines & 0xff;
+	tmpbuf[2] = samples_per_line >> 8;
+	tmpbuf[3] = samples_per_line & 0xff;
+
+	gspca_frame_add(gspca_dev, INTER_PACKET, frame,
+		tmpbuf, sizeof(tmpbuf));
+	gspca_frame_add(gspca_dev, INTER_PACKET, frame,
+		pac_jpeg_header2, sizeof(pac_jpeg_header2));
+}
+
 /* this function is run at interrupt level */
 static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 			struct gspca_frame *frame,	/* target */
@@ -854,7 +874,6 @@ static void sd_pkt_scan(struct gspca_dev

 	sof = pac_find_sof(&sd->sof_read, data, len);
 	if (sof) {
-		unsigned char tmpbuf[4];
 		int n, lum_offset, footer_length;

 		if (sd->sensor == SENSOR_PAC7302) {
@@ -896,23 +915,14 @@ static void sd_pkt_scan(struct gspca_dev
 			atomic_set(&sd->avg_lum, -1);

 		/* Start the new frame with the jpeg header */
-		gspca_frame_add(gspca_dev, FIRST_PACKET, frame,
-			pac7311_jpeg_header1, sizeof(pac7311_jpeg_header1));
 		if (sd->sensor == SENSOR_PAC7302) {
 			/* The PAC7302 has the image rotated 90 degrees */
-			tmpbuf[0] = gspca_dev->width >> 8;
-			tmpbuf[1] = gspca_dev->width & 0xff;
-			tmpbuf[2] = gspca_dev->height >> 8;
-			tmpbuf[3] = gspca_dev->height & 0xff;
+			pac_start_frame(gspca_dev, frame,
+				gspca_dev->width, gspca_dev->height);
 		} else {
-			tmpbuf[0] = gspca_dev->height >> 8;
-			tmpbuf[1] = gspca_dev->height & 0xff;
-			tmpbuf[2] = gspca_dev->width >> 8;
-			tmpbuf[3] = gspca_dev->width & 0xff;
+			pac_start_frame(gspca_dev, frame,
+				gspca_dev->height, gspca_dev->width);
 		}
-		gspca_frame_add(gspca_dev, INTER_PACKET, frame, tmpbuf, 4);
-		gspca_frame_add(gspca_dev, INTER_PACKET, frame,
-			pac7311_jpeg_header2, sizeof(pac7311_jpeg_header2));
 	}
 	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
 }
