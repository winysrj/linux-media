Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB9LCvNJ023862
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 16:12:58 -0500
Received: from psychosis.jim.sh (a.jim.sh [75.150.123.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB9LCikq001967
	for <video4linux-list@redhat.com>; Tue, 9 Dec 2008 16:12:45 -0500
Date: Tue, 9 Dec 2008 16:12:28 -0500
From: Jim Paris <jim@jtan.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Message-ID: <20081209211228.GA21038@psychosis.jim.sh>
References: <patchbomb.1228337219@hypnosis.jim>
	<1228378442.1733.17.camel@localhost>
	<20081204130557.85799da0.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204130557.85799da0.ospite@studenti.unina.it>
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH 0 of 4] ov534 patches
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

Antonio Ospite wrote:
> Tested the latest version, I am getting "payload error"s setting
> frame_rate=50, loosing about 50% of frames. I tried raising bulk_size
> but then I get "frame overflow" errors from gspca, I'll investigate
> further.

If bulk_size is bigger, the headers appear every 2048 bytes, not at
the beginning of each bulk packet.  Try the attached patch?

(The layout of sd_pkt_scan gets a bit strange, but the differences are
more clear this way; I can rewrite it a little more clearly)

-jim

--
ov534: improve payload handling

Frame data in bulk transfers is separated into 2048-byte payloads.
Each payload has its own header.

Signed-off-by: Jim Paris <jim@jtan.com>

diff -r ffeb9d2be572 linux/drivers/media/video/gspca/ov534.c
--- a/linux/drivers/media/video/gspca/ov534.c	Mon Dec 08 10:41:04 2008 +0100
+++ b/linux/drivers/media/video/gspca/ov534.c	Tue Dec 09 16:06:07 2008 -0500
@@ -1,6 +1,7 @@
 /*
  * ov534/ov772x gspca driver
  * Copyright (C) 2008 Antonio Ospite <ospite@studenti.unina.it>
+ * Copyright (C) 2008 Jim Paris <jim@jtan.com>
  *
  * Based on a prototype written by Mark Ferrell <majortrips@gmail.com>
  * USB protocol reverse engineered by Jim Paris <jim@jtan.com>
@@ -193,8 +194,8 @@
 
 	{ 0x1c, 0x00 },
 	{ 0x1d, 0x40 },
-	{ 0x1d, 0x02 },
-	{ 0x1d, 0x00 },
+	{ 0x1d, 0x02 }, /* payload size 0x0200 * 4 = 2048 bytes */
+	{ 0x1d, 0x00 }, /* payload size */
 	{ 0x1d, 0x02 }, /* frame size 0x025800 * 4 = 614400 */
 	{ 0x1d, 0x58 }, /* frame size */
 	{ 0x1d, 0x00 }, /* frame size */
@@ -325,7 +326,7 @@
 	cam->cam_mode = vga_mode;
 	cam->nmodes = ARRAY_SIZE(vga_mode);
 
-	cam->bulk_size = 2048;
+	cam->bulk_size = 16384;
 	cam->bulk_nurbs = 2;
 
 	return 0;
@@ -402,6 +403,17 @@
 	struct sd *sd = (struct sd *) gspca_dev;
 	__u32 this_pts;
 	int this_fid;
+	int remaining_len = len;
+	__u8 *next_data = data;
+
+scan_next:
+	if (remaining_len <= 0)
+		return;
+
+	data = next_data;
+	len = min(remaining_len, 2048);
+	remaining_len -= len;
+	next_data += len;
 
 	/* Payloads are prefixed with a the UVC-style header.  We
 	   consider a frame to start when the FID toggles, or the PTS
@@ -452,12 +464,13 @@
 		gspca_frame_add(gspca_dev, LAST_PACKET, frame, NULL, 0);
 	}
 
-	/* Done */
-	return;
+	/* Done this payload */
+	goto scan_next;
 
 discard:
 	/* Discard data until a new frame starts. */
 	gspca_frame_add(gspca_dev, DISCARD_PACKET, frame, NULL, 0);
+	goto scan_next;
 }
 
 /* sub-driver description */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
