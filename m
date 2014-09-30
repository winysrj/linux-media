Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbaI3OFO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 10:05:14 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 1/3] libv4l2: Fix restoring of original dest-fmt after a VIDIOC_S_DV_TIMING
Date: Tue, 30 Sep 2014 16:04:59 +0200
Message-Id: <1412085901-18528-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Read the original pixelformat from dest_fmt, before overwriting dest_fmt with
the new src_fmt.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 lib/libv4l2/libv4l2.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
index fe513d7..22ed984 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -1245,6 +1245,8 @@ no_capture_request:
 	case VIDIOC_S_INPUT:
 	case VIDIOC_S_DV_TIMINGS: {
 		struct v4l2_format src_fmt = { 0 };
+		unsigned int orig_dest_pixelformat =
+			devices[index].dest_fmt.fmt.pix.pixelformat;
 
 		result = devices[index].dev_ops->ioctl(
 				devices[index].dev_ops_priv,
@@ -1274,8 +1276,7 @@ no_capture_request:
 		devices[index].src_fmt  = src_fmt;
 		devices[index].dest_fmt = src_fmt;
 		/* and try to restore the last set destination pixelformat. */
-		src_fmt.fmt.pix.pixelformat =
-			devices[index].dest_fmt.fmt.pix.pixelformat;
+		src_fmt.fmt.pix.pixelformat = orig_dest_pixelformat;
 		result = v4l2_s_fmt(index, &src_fmt);
 		if (result) {
 			V4L2_LOG_WARN("restoring destination pixelformat after %s failed\n",
-- 
2.1.0

