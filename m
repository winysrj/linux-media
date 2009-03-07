Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:37152 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbZCGRae (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2009 12:30:34 -0500
Date: Sat, 7 Mar 2009 11:41:44 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Hans de Goede <hdegoede@redhat.com>
cc: Kyle Guinn <elyk03@gmail.com>, linux-media@vger.kernel.org,
	Jean-Francois Moine <moinejf@free.fr>
Subject: [PATCH] for the file gspca/mr97310a.c (Resubmit)
Message-ID: <alpine.LNX.2.00.0903071129420.7903@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is a cleaned-up version of the patch to gspca/mr97310a.c

This patch causes all frame headers in the streaming output of MR97310A 
cameras, instead of being discarded.

Said frame headers contain information which may be useful in processing 
the video output and therefore should be kept and not discarded.

A corresponding patch to the decompression algorithm in 
libv4lconvert/mr97310a.c corrects the change in frame offset.

Signed-off-by: Theodore Kilgore <kilgota@auburn.edu>
----------------------------------------------------------------------------
--- mr97310a.c.orig	2009-02-18 14:40:03.000000000 -0600
+++ mr97310a.c	2009-03-06 15:12:14.000000000 -0600
@@ -29,9 +29,7 @@ MODULE_LICENSE("GPL");
  /* specific webcam descriptor */
  struct sd {
  	struct gspca_dev gspca_dev;  /* !! must be the first item */
-
  	u8 sof_read;
-	u8 header_read;
  };

  /* V4L2 controls supported by the driver */
@@ -285,7 +283,6 @@ static void sd_pkt_scan(struct gspca_dev
  			__u8 *data,                   /* isoc packet */
  			int len)                      /* iso packet length */
  {
-	struct sd *sd = (struct sd *) gspca_dev;
  	unsigned char *sof;

  	sof = pac_find_sof(gspca_dev, data, len);
@@ -300,25 +297,12 @@ static void sd_pkt_scan(struct gspca_dev
  			n = 0;
  		frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame,
  					data, n);
-		sd->header_read = 0;
-		gspca_frame_add(gspca_dev, FIRST_PACKET, frame, NULL, 0);
+		/* Start next frame. */
+		gspca_frame_add(gspca_dev, FIRST_PACKET, frame,
+			pac_sof_marker, sizeof pac_sof_marker);
  		len -= sof - data;
  		data = sof;
  	}
-	if (sd->header_read < 7) {
-		int needed;
-
-		/* skip the rest of the header */
-		needed = 7 - sd->header_read;
-		if (len <= needed) {
-			sd->header_read += len;
-			return;
-		}
-		data += needed;
-		len -= needed;
-		sd->header_read = 7;
-	}
-
  	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
  }

