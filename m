Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44108 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753706AbaDJWGt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 18:06:49 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 2/9] Zero dev in main()
Date: Fri, 11 Apr 2014 01:06:38 +0300
Message-Id: <1397167605-29956-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1397167605-29956-1-git-send-email-sakari.ailus@iki.fi>
References: <1397167605-29956-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is necessary since video_open() may not be always called soon

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/yavta.c b/yavta.c
index d7bccfd..18e1709 100644
--- a/yavta.c
+++ b/yavta.c
@@ -226,7 +226,6 @@ static int video_open(struct device *dev, const char *devname, int no_query)
 	unsigned int capabilities;
 	int ret;
 
-	memset(dev, 0, sizeof *dev);
 	dev->fd = -1;
 	dev->memtype = V4L2_MEMORY_MMAP;
 	dev->buffers = NULL;
@@ -1562,7 +1561,7 @@ static struct option opts[] = {
 int main(int argc, char *argv[])
 {
 	struct sched_param sched;
-	struct device dev;
+	struct device dev = { 0 };
 	int ret;
 
 	/* Options parsings */
-- 
1.7.10.4

