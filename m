Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:39085 "HELO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752613AbZLMLlP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2009 06:41:15 -0500
Date: Sun, 13 Dec 2009 12:41:12 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/9] drivers/media: Correct code taking the size of a pointer
Message-ID: <Pine.LNX.4.64.0912131240560.24267@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

sizeof(print_buf) is just the size of the pointer.  Change it to the size
used in the allocation of print_buf earlier in the same function.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *x;
expression f;
type T;
@@

*f(...,(T)x,...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/video/hdpvr/hdpvr-core.c         |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/hdpvr/hdpvr-core.c b/drivers/media/video/hdpvr/hdpvr-core.c
index e280eb1..51f393d 100644
--- a/drivers/media/video/hdpvr/hdpvr-core.c
+++ b/drivers/media/video/hdpvr/hdpvr-core.c
@@ -145,7 +145,7 @@ static int device_authorization(struct hdpvr_device *dev)
 #ifdef HDPVR_DEBUG
 	else {
 		hex_dump_to_buffer(dev->usbc_buf, 46, 16, 1, print_buf,
-				   sizeof(print_buf), 0);
+				   5*buf_size+1, 0);
 		v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
 			 "Status request returned, len %d: %s\n",
 			 ret, print_buf);
@@ -168,13 +168,13 @@ static int device_authorization(struct hdpvr_device *dev)
 
 	response = dev->usbc_buf+38;
 #ifdef HDPVR_DEBUG
-	hex_dump_to_buffer(response, 8, 16, 1, print_buf, sizeof(print_buf), 0);
+	hex_dump_to_buffer(response, 8, 16, 1, print_buf, 5*buf_size+1, 0);
 	v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev, "challenge: %s\n",
 		 print_buf);
 #endif
 	challenge(response);
 #ifdef HDPVR_DEBUG
-	hex_dump_to_buffer(response, 8, 16, 1, print_buf, sizeof(print_buf), 0);
+	hex_dump_to_buffer(response, 8, 16, 1, print_buf, 5*buf_size+1, 0);
 	v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev, " response: %s\n",
 		 print_buf);
 #endif
