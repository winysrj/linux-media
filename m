Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:52837 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933385AbZJaXQv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:16:51 -0400
Message-ID: <4AECC562.9070301@freemail.hu>
Date: Sun, 01 Nov 2009 00:16:50 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 19/21] gspca pac7302/pac7311: extract pac_start_frame
Content-Type: text/plain; charset=UTF-8
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
diff -uprN s/drivers/media/video/gspca/pac7311.c t/drivers/media/video/gspca/pac7311.c
--- s/drivers/media/video/gspca/pac7311.c	2009-10-31 10:21:55.000000000 +0100
+++ t/drivers/media/video/gspca/pac7311.c	2009-10-31 10:20:49.000000000 +0100
@@ -1028,7 +1028,7 @@ static void pac7311_do_autogain(struct g
 }

 /* JPEG header, part 1 */
-static const unsigned char pac7311_jpeg_header1[] = {
+static const unsigned char pac_jpeg_header1[] = {
   0xff, 0xd8,		/* SOI: Start of Image */

   0xff, 0xc0,		/* SOF0: Start of Frame (Baseline DCT) */
@@ -1039,7 +1039,7 @@ static const unsigned char pac7311_jpeg_
 };

 /* JPEG header, continued */
-static const unsigned char pac7311_jpeg_header2[] = {
+static const unsigned char pac_jpeg_header2[] = {
   0x03,			/* Number of image components: 3 */
   0x01, 0x21, 0x00,	/* ID=1, Subsampling 1x1, Quantization table: 0 */
   0x02, 0x11, 0x01,	/* ID=2, Subsampling 2x1, Quantization table: 1 */
@@ -1055,6 +1055,26 @@ static const unsigned char pac7311_jpeg_
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
 static void pac7302_sd_pkt_scan(struct gspca_dev *gspca_dev,
 			struct gspca_frame *frame,	/* target */
@@ -1066,7 +1086,6 @@ static void pac7302_sd_pkt_scan(struct g

 	sof = pac_find_sof(&sd->sof_read, data, len);
 	if (sof) {
-		unsigned char tmpbuf[4];
 		int n, lum_offset, footer_length;

 		/* 6 bytes after the FF D9 EOF marker a number of lumination
@@ -1103,18 +1122,9 @@ static void pac7302_sd_pkt_scan(struct g
 			atomic_set(&sd->avg_lum, -1);

 		/* Start the new frame with the jpeg header */
-		gspca_frame_add(gspca_dev, FIRST_PACKET, frame,
-			pac7311_jpeg_header1, sizeof(pac7311_jpeg_header1));
-
 		/* The PAC7302 has the image rotated 90 degrees */
-		tmpbuf[0] = gspca_dev->width >> 8;
-		tmpbuf[1] = gspca_dev->width & 0xff;
-		tmpbuf[2] = gspca_dev->height >> 8;
-		tmpbuf[3] = gspca_dev->height & 0xff;
-
-		gspca_frame_add(gspca_dev, INTER_PACKET, frame, tmpbuf, 4);
-		gspca_frame_add(gspca_dev, INTER_PACKET, frame,
-			pac7311_jpeg_header2, sizeof(pac7311_jpeg_header2));
+		pac_start_frame(gspca_dev, frame,
+			gspca_dev->width, gspca_dev->height);
 	}
 	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
 }
@@ -1130,7 +1140,6 @@ static void pac7311_sd_pkt_scan(struct g

 	sof = pac_find_sof(&sd->sof_read, data, len);
 	if (sof) {
-		unsigned char tmpbuf[4];
 		int n, lum_offset, footer_length;

 		/* 6 bytes after the FF D9 EOF marker a number of lumination
@@ -1167,17 +1176,8 @@ static void pac7311_sd_pkt_scan(struct g
 			atomic_set(&sd->avg_lum, -1);

 		/* Start the new frame with the jpeg header */
-		gspca_frame_add(gspca_dev, FIRST_PACKET, frame,
-			pac7311_jpeg_header1, sizeof(pac7311_jpeg_header1));
-
-		tmpbuf[0] = gspca_dev->height >> 8;
-		tmpbuf[1] = gspca_dev->height & 0xff;
-		tmpbuf[2] = gspca_dev->width >> 8;
-		tmpbuf[3] = gspca_dev->width & 0xff;
-
-		gspca_frame_add(gspca_dev, INTER_PACKET, frame, tmpbuf, 4);
-		gspca_frame_add(gspca_dev, INTER_PACKET, frame,
-			pac7311_jpeg_header2, sizeof(pac7311_jpeg_header2));
+		pac_start_frame(gspca_dev, frame,
+			gspca_dev->height, gspca_dev->width);
 	}
 	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
 }
