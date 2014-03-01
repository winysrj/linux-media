Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46242 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752984AbaCAQPT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Mar 2014 11:15:19 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Subject: [yavta PATCH 4/9] Zero dev in main()
Date: Sat,  1 Mar 2014 18:18:05 +0200
Message-Id: <1393690690-5004-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi>
References: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is necessary since video_open() may not be always called soon

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/yavta.c b/yavta.c
index e010252..870682e 100644
--- a/yavta.c
+++ b/yavta.c
@@ -182,11 +182,6 @@ static unsigned int v4l2_format_code(const char *name)
 
 static int video_open(struct device *dev, const char *devname, int no_query)
 {
-	struct v4l2_capability cap;
-	unsigned int capabilities;
-	int ret;
-
-	memset(dev, 0, sizeof *dev);
 	dev->fd = -1;
 	dev->memtype = V4L2_MEMORY_MMAP;
 	dev->buffers = NULL;
@@ -1302,7 +1297,7 @@ static struct option opts[] = {
 int main(int argc, char *argv[])
 {
 	struct sched_param sched;
-	struct device dev;
+	struct device dev = { 0 };
 	int ret;
 
 	/* Options parsings */
-- 
1.7.10.4

