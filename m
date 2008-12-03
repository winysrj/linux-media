Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB3KmPro024232
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 15:48:25 -0500
Received: from psychosis.jim.sh (a.jim.sh [75.150.123.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB3KmBeP010753
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 15:48:11 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <ede2dd835a2086131584.1228337223@hypnosis.jim>
In-Reply-To: <patchbomb.1228337219@hypnosis.jim>
Date: Wed, 03 Dec 2008 15:47:03 -0500
From: Jim Paris <jim@jtan.com>
To: video4linux-list@redhat.com
Cc: 
Subject: [PATCH 4 of 4] ov534: frame transfer improvements
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
# Date 1228335450 18000
# Node ID ede2dd835a2086131584558f5ccb1e2170135b07
# Parent  61c8d2959dd6ad1b45e0d8bf12b3d5748fc6a568
ov534: frame transfer improvements

The indirect registers at 0x1c/0x1d control frame settings.  If we
leave the values at 0x0a and 0x0b at their reset-time defaults, frame
data from the camera matches the UVC payload format.  This lets us
better reassemble the data into frames and know when data was lost.

This also lets us relax the bulk_size requirement from 600K to 2K,
which should help systems on with limited RAM (like the PS3).

Signed-off-by: Jim Paris <jim@jtan.com>

diff -r 61c8d2959dd6 -r ede2dd835a20 linux/drivers/media/video/gspca/ov534.c
--- a/linux/drivers/media/video/gspca/ov534.c	Wed Dec 03 15:07:30 2008 -0500
+++ b/linux/drivers/media/video/gspca/ov534.c	Wed Dec 03 15:17:30 2008 -0500
@@ -166,10 +166,6 @@
 	{ 0xe2, 0x00 },
 	{ 0xe7, 0x3e },
 
-	{ 0x1c, 0x0a },
-	{ 0x1d, 0x22 },
-	{ 0x1d, 0x06 },
-
 	{ 0x96, 0x00 },
 
 	{ 0x97, 0x20 },
@@ -328,10 +324,8 @@
 	cam->cam_mode = vga_mode;
 	cam->nmodes = ARRAY_SIZE(vga_mode);
 
-	cam->bulk_size = vga_mode[0].sizeimage;
+	cam->bulk_size = 2048;
 	cam->bulk_nurbs = 2;
-
-	PDEBUG(D_PROBE, "bulk_size = %d", cam->bulk_size);
 
 	return 0;
 }
@@ -379,8 +373,6 @@
 	PDEBUG(D_PROBE, "width = %d, height = %d",
 	       gspca_dev->width, gspca_dev->height);
 
-	gspca_dev->cam.bulk_size = gspca_dev->width * gspca_dev->height * 2;
-
 	/* start streaming data */
 	ov534_set_led(gspca_dev->dev, 1);
 	ov534_reg_write(gspca_dev->dev, 0xe0, 0x00);
@@ -395,18 +387,80 @@
 	ov534_set_led(gspca_dev->dev, 0);
 }
 
+/* Values for bmHeaderInfo (Video and Still Image Payload Headers, 2.4.3.3) */
+#define UVC_STREAM_EOH	(1 << 7)
+#define UVC_STREAM_ERR	(1 << 6)
+#define UVC_STREAM_STI	(1 << 5)
+#define UVC_STREAM_RES	(1 << 4)
+#define UVC_STREAM_SCR	(1 << 3)
+#define UVC_STREAM_PTS	(1 << 2)
+#define UVC_STREAM_EOF	(1 << 1)
+#define UVC_STREAM_FID	(1 << 0)
+
 static void sd_pkt_scan(struct gspca_dev *gspca_dev, struct gspca_frame *frame,
 			__u8 *data, int len)
 {
-	int framesize = gspca_dev->cam.bulk_size;
+	static __u32 last_pts;
+	__u32 this_pts;
+	static int last_fid;
+	int this_fid;
 
-	if (len == framesize) {
-		frame = gspca_frame_add(gspca_dev, FIRST_PACKET, frame,
-					data, len);
-		frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame, data, 0);
-	} else
-		PDEBUG(D_PACK, "packet len = %d, framesize = %d", len,
-		       framesize);
+	/* Payloads are prefixed with a the UVC-style header.  We
+	   consider a frame to start when the FID toggles, or the PTS
+	   changes.  A frame ends when EOF is set, and we've received
+	   the correct number of bytes. */
+
+	/* Verify UVC header.  Header length is always 12 */
+	if (data[0] != 12 || len < 12) {
+		PDEBUG(D_PACK, "bad header");
+		goto discard;
+	}
+
+	/* Check errors */
+	if (data[1] & UVC_STREAM_ERR) {
+		PDEBUG(D_PACK, "payload error");
+		goto discard;
+	}
+
+	/* Extract PTS and FID */
+	if (!(data[1] & UVC_STREAM_PTS)) {
+		PDEBUG(D_PACK, "PTS not present");
+		goto discard;
+	}
+	this_pts = (data[5] << 24) | (data[4] << 16) | (data[3] << 8) | data[2];
+	this_fid = (data[1] & UVC_STREAM_FID) ? 1 : 0;
+
+	/* If PTS or FID has changed, start a new frame. */
+	if (this_pts != last_pts || this_fid != last_fid) {
+		frame = gspca_frame_add(gspca_dev, FIRST_PACKET, frame, NULL, 0);
+		last_pts = this_pts;
+		last_fid = this_fid;
+	}
+
+	/* Add the data from this payload */
+	frame = gspca_frame_add(gspca_dev, INTER_PACKET, frame,
+				data + 12, len - 12);
+
+	/* If this packet is marked as EOF, end the frame */
+	if (data[1] & UVC_STREAM_EOF) {
+		last_pts = 0;
+
+		if ((frame->data_end - frame->data) !=
+		    (gspca_dev->width * gspca_dev->height * 2)) {
+			PDEBUG(D_PACK, "short frame");
+			goto discard;
+		}
+
+		gspca_frame_add(gspca_dev, LAST_PACKET, frame, NULL, 0);
+	}
+
+	/* Done */
+	return;
+
+discard:
+	/* Discard data until a new frame starts. */
+	gspca_frame_add(gspca_dev, DISCARD_PACKET, frame, NULL, 0);
+	return;
 }
 
 /* sub-driver description */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
