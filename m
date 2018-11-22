Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58746 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391655AbeKWCJs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 21:09:48 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH 1/1] Zero dev in main()
Date: Thu, 22 Nov 2018 17:29:56 +0200
Message-Id: <20181122152956.23649-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

This is necessary since video_open() may not be always called soon

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/yavta.c b/yavta.c
index c7986bd..de5376d 100644
--- a/yavta.c
+++ b/yavta.c
@@ -342,7 +342,6 @@ static bool video_has_valid_buf_type(struct device *dev)
 
 static void video_init(struct device *dev)
 {
-	memset(dev, 0, sizeof *dev);
 	dev->fd = -1;
 	dev->memtype = V4L2_MEMORY_MMAP;
 	dev->buffers = NULL;
@@ -1903,7 +1902,7 @@ static struct option opts[] = {
 int main(int argc, char *argv[])
 {
 	struct sched_param sched;
-	struct device dev;
+	struct device dev = { 0 };
 	int ret;
 
 	/* Options parsings */
-- 
2.11.0
