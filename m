Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB3KmM54024193
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 15:48:22 -0500
Received: from psychosis.jim.sh (a.jim.sh [75.150.123.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB3Km8vM010723
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 15:48:09 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <61c8d2959dd6ad1b45e0.1228337222@hypnosis.jim>
In-Reply-To: <patchbomb.1228337219@hypnosis.jim>
Date: Wed, 03 Dec 2008 15:47:02 -0500
From: Jim Paris <jim@jtan.com>
To: video4linux-list@redhat.com
Cc: 
Subject: [PATCH 3 of 4] ov534: Fix frame size so we don't miss the last pixel
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

# HG changeset patch
# User jim@jtan.com
# Date 1228334850 18000
# Node ID 61c8d2959dd6ad1b45e0d8bf12b3d5748fc6a568
# Parent  893107a5df87228bb6766f26226fcef8069e3fc8
ov534: Fix frame size so we don't miss the last pixel

The frame size is too small, so we lose the last YUYV pixel.
Fix the setup and remove the last_pixel hack.

Signed-off-by: Jim Paris <jim@jtan.com>

diff -r 893107a5df87 -r 61c8d2959dd6 linux/drivers/media/video/gspca/ov534.c
--- a/linux/drivers/media/video/gspca/ov534.c	Wed Dec 03 15:06:54 2008 -0500
+++ b/linux/drivers/media/video/gspca/ov534.c	Wed Dec 03 15:07:30 2008 -0500
@@ -198,9 +198,9 @@
 	{ 0x1d, 0x40 },
 	{ 0x1d, 0x02 },
 	{ 0x1d, 0x00 },
-	{ 0x1d, 0x02 },
-	{ 0x1d, 0x57 },
-	{ 0x1d, 0xff },
+	{ 0x1d, 0x02 }, /* frame size 0x025800 * 4 = 614400 */
+	{ 0x1d, 0x58 }, /* frame size */
+	{ 0x1d, 0x00 }, /* frame size */
 
 	{ 0x8d, 0x1c },
 	{ 0x8e, 0x80 },
@@ -398,19 +398,12 @@
 static void sd_pkt_scan(struct gspca_dev *gspca_dev, struct gspca_frame *frame,
 			__u8 *data, int len)
 {
-	/*
-	 * The current camera setup doesn't stream the last pixel, so we set it
-	 * to a dummy value
-	 */
-	__u8 last_pixel[4] = { 0, 0, 0, 0 };
 	int framesize = gspca_dev->cam.bulk_size;
 
-	if (len == framesize - 4) {
-		frame =
-		    gspca_frame_add(gspca_dev, FIRST_PACKET, frame, data, len);
-		frame =
-		    gspca_frame_add(gspca_dev, LAST_PACKET, frame, last_pixel,
-				    4);
+	if (len == framesize) {
+		frame = gspca_frame_add(gspca_dev, FIRST_PACKET, frame,
+					data, len);
+		frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame, data, 0);
 	} else
 		PDEBUG(D_PACK, "packet len = %d, framesize = %d", len,
 		       framesize);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
