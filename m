Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:61315 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933333AbZJaXNq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 19:13:46 -0400
Message-ID: <4AECC4A9.9050209@freemail.hu>
Date: Sun, 01 Nov 2009 00:13:45 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
CC: Thomas Kaiser <thomas@kaiser-linux.li>,
	Theodore Kilgore <kilgota@auburn.edu>,
	Kyle Guinn <elyk03@gmail.com>
Subject: [PATCH 03/21] gspca pac7302/pac7311: separate pkt_scan
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Separate the pkt_scan function. Remove the run-time decision for
PAC7302 and PAC7311 sensors.

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Thomas Kaiser <thomas@kaiser-linux.li>
Cc: Theodore Kilgore <kilgota@auburn.edu>
Cc: Kyle Guinn <elyk03@gmail.com>
---
diff -uprN c/drivers/media/video/gspca/pac7311.c d/drivers/media/video/gspca/pac7311.c
--- c/drivers/media/video/gspca/pac7311.c	2009-10-30 17:05:09.000000000 +0100
+++ d/drivers/media/video/gspca/pac7311.c	2009-10-30 17:15:51.000000000 +0100
@@ -844,7 +844,7 @@ static const unsigned char pac7311_jpeg_
 };

 /* this function is run at interrupt level */
-static void sd_pkt_scan(struct gspca_dev *gspca_dev,
+static void pac7302_sd_pkt_scan(struct gspca_dev *gspca_dev,
 			struct gspca_frame *frame,	/* target */
 			__u8 *data,			/* isoc packet */
 			int len)			/* iso packet length */
@@ -857,17 +857,12 @@ static void sd_pkt_scan(struct gspca_dev
 		unsigned char tmpbuf[4];
 		int n, lum_offset, footer_length;

-		if (sd->sensor == SENSOR_PAC7302) {
-		  /* 6 bytes after the FF D9 EOF marker a number of lumination
-		     bytes are send corresponding to different parts of the
-		     image, the 14th and 15th byte after the EOF seem to
-		     correspond to the center of the image */
-		  lum_offset = 61 + sizeof pac_sof_marker;
-		  footer_length = 74;
-		} else {
-		  lum_offset = 24 + sizeof pac_sof_marker;
-		  footer_length = 26;
-		}
+		/* 6 bytes after the FF D9 EOF marker a number of lumination
+		   bytes are send corresponding to different parts of the
+		   image, the 14th and 15th byte after the EOF seem to
+		   correspond to the center of the image */
+		lum_offset = 61 + sizeof pac_sof_marker;
+		footer_length = 74;

 		/* Finish decoding current frame */
 		n = (sof - data) - (footer_length + sizeof pac_sof_marker);
@@ -898,18 +893,76 @@ static void sd_pkt_scan(struct gspca_dev
 		/* Start the new frame with the jpeg header */
 		gspca_frame_add(gspca_dev, FIRST_PACKET, frame,
 			pac7311_jpeg_header1, sizeof(pac7311_jpeg_header1));
-		if (sd->sensor == SENSOR_PAC7302) {
-			/* The PAC7302 has the image rotated 90 degrees */
-			tmpbuf[0] = gspca_dev->width >> 8;
-			tmpbuf[1] = gspca_dev->width & 0xff;
-			tmpbuf[2] = gspca_dev->height >> 8;
-			tmpbuf[3] = gspca_dev->height & 0xff;
-		} else {
-			tmpbuf[0] = gspca_dev->height >> 8;
-			tmpbuf[1] = gspca_dev->height & 0xff;
-			tmpbuf[2] = gspca_dev->width >> 8;
-			tmpbuf[3] = gspca_dev->width & 0xff;
+
+		/* The PAC7302 has the image rotated 90 degrees */
+		tmpbuf[0] = gspca_dev->width >> 8;
+		tmpbuf[1] = gspca_dev->width & 0xff;
+		tmpbuf[2] = gspca_dev->height >> 8;
+		tmpbuf[3] = gspca_dev->height & 0xff;
+
+		gspca_frame_add(gspca_dev, INTER_PACKET, frame, tmpbuf, 4);
+		gspca_frame_add(gspca_dev, INTER_PACKET, frame,
+			pac7311_jpeg_header2, sizeof(pac7311_jpeg_header2));
+	}
+	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
+}
+
+/* this function is run at interrupt level */
+static void pac7311_sd_pkt_scan(struct gspca_dev *gspca_dev,
+			struct gspca_frame *frame,	/* target */
+			__u8 *data,			/* isoc packet */
+			int len)			/* iso packet length */
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+	unsigned char *sof;
+
+	sof = pac_find_sof(gspca_dev, data, len);
+	if (sof) {
+		unsigned char tmpbuf[4];
+		int n, lum_offset, footer_length;
+
+		/* 6 bytes after the FF D9 EOF marker a number of lumination
+		   bytes are send corresponding to different parts of the
+		   image, the 14th and 15th byte after the EOF seem to
+		   correspond to the center of the image */
+		lum_offset = 24 + sizeof pac_sof_marker;
+		footer_length = 26;
+
+		/* Finish decoding current frame */
+		n = (sof - data) - (footer_length + sizeof pac_sof_marker);
+		if (n < 0) {
+			frame->data_end += n;
+			n = 0;
 		}
+		frame = gspca_frame_add(gspca_dev, INTER_PACKET, frame,
+					data, n);
+		if (gspca_dev->last_packet_type != DISCARD_PACKET &&
+				frame->data_end[-2] == 0xff &&
+				frame->data_end[-1] == 0xd9)
+			frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame,
+						NULL, 0);
+
+		n = sof - data;
+		len -= n;
+		data = sof;
+
+		/* Get average lumination */
+		if (gspca_dev->last_packet_type == LAST_PACKET &&
+				n >= lum_offset)
+			atomic_set(&sd->avg_lum, data[-lum_offset] +
+						data[-lum_offset + 1]);
+		else
+			atomic_set(&sd->avg_lum, -1);
+
+		/* Start the new frame with the jpeg header */
+		gspca_frame_add(gspca_dev, FIRST_PACKET, frame,
+			pac7311_jpeg_header1, sizeof(pac7311_jpeg_header1));
+
+		tmpbuf[0] = gspca_dev->height >> 8;
+		tmpbuf[1] = gspca_dev->height & 0xff;
+		tmpbuf[2] = gspca_dev->width >> 8;
+		tmpbuf[3] = gspca_dev->width & 0xff;
+
 		gspca_frame_add(gspca_dev, INTER_PACKET, frame, tmpbuf, 4);
 		gspca_frame_add(gspca_dev, INTER_PACKET, frame,
 			pac7311_jpeg_header2, sizeof(pac7311_jpeg_header2));
@@ -1088,7 +1141,7 @@ static struct sd_desc pac7302_sd_desc =
 	.start = sd_start,
 	.stopN = sd_stopN,
 	.stop0 = sd_stop0,
-	.pkt_scan = sd_pkt_scan,
+	.pkt_scan = pac7302_sd_pkt_scan,
 	.dq_callback = do_autogain,
 };

@@ -1102,7 +1155,7 @@ static struct sd_desc pac7311_sd_desc =
 	.start = sd_start,
 	.stopN = sd_stopN,
 	.stop0 = sd_stop0,
-	.pkt_scan = sd_pkt_scan,
+	.pkt_scan = pac7311_sd_pkt_scan,
 	.dq_callback = do_autogain,
 };

