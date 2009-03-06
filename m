Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:47032 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbZCFVKJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Mar 2009 16:10:09 -0500
Date: Fri, 6 Mar 2009 15:22:27 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: Hans de Goede <hdegoede@redhat.com>
cc: Kyle Guinn <elyk03@gmail.com>, linux-media@vger.kernel.org,
	Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [PATCH] for the file gspca/mr97310a.c (revisions)
In-Reply-To: <49B0DAF4.50408@redhat.com>
Message-ID: <alpine.LNX.2.00.0903061520190.6997@banach.math.auburn.edu>
References: <alpine.LNX.2.00.0903052031490.28557@banach.math.auburn.edu> <200903052258.48365.elyk03@gmail.com> <alpine.LNX.2.00.0903052317070.28734@banach.math.auburn.edu> <49B0DAF4.50408@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Here is a revised version of the patch to the file gspca/mr97310a.c

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

