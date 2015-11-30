Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:35207 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbbK3OqU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2015 09:46:20 -0500
From: Tuukka Toivonen <tuukka.toivonen@intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH] Return proper error code if STREAMON fails
Date: Mon, 30 Nov 2015 16:46:17 +0200
Message-ID: <207011196.fyjkdD1C8L@ttoivone-desk1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the bug causing success to be returned even if VIDIOC_STREAMON
failed. Also check returned error from VIDIOC_STREAMOFF.

Signed-off-by: Tuukka Toivonen <tuukka.toivonen@intel.com>
---
 yavta.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/yavta.c b/yavta.c
index b627725..3ad1c97 100644
--- a/yavta.c
+++ b/yavta.c
@@ -1623,7 +1623,7 @@ static int video_do_capture(struct device *dev, 
unsigned int nframes,
 	unsigned int i;
 	double bps;
 	double fps;
-	int ret;
+	int ret, ret2;
 
 	/* Start streaming. */
 	ret = video_enable(dev, 1);
@@ -1708,7 +1708,9 @@ static int video_do_capture(struct device *dev, 
unsigned int nframes,
 	}
 
 	/* Stop streaming. */
-	video_enable(dev, 0);
+	ret = video_enable(dev, 0);
+	if (ret < 0)
+		goto done;
 
 	if (nframes == 0) {
 		printf("No frames captured.\n");
@@ -1732,7 +1734,11 @@ static int video_do_capture(struct device *dev, 
unsigned int nframes,
 		i, ts.tv_sec, ts.tv_nsec/1000, fps, bps);
 
 done:
-	return video_free_buffers(dev);
+	ret2 = video_free_buffers(dev);
+	if (ret >= 0)
+		ret = ret2;
+
+	return ret;
 }
 
 #define V4L_BUFFERS_DEFAULT	8
-- 
1.9.1


