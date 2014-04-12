Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50683 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751605AbaDLNYP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Apr 2014 09:24:15 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH v3 01/11] Separate device object initialisation and opening
Date: Sat, 12 Apr 2014 16:23:53 +0300
Message-Id: <1397309043-8322-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
References: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/yavta.c b/yavta.c
index 739463d..c7ad7b4 100644
--- a/yavta.c
+++ b/yavta.c
@@ -220,17 +220,20 @@ static const char *v4l2_format_name(unsigned int fourcc)
 	return name;
 }
 
-static int video_open(struct device *dev, const char *devname, int no_query)
+static void video_init(struct device *dev)
 {
-	struct v4l2_capability cap;
-	unsigned int capabilities;
-	int ret;
-
 	memset(dev, 0, sizeof *dev);
 	dev->fd = -1;
 	dev->memtype = V4L2_MEMORY_MMAP;
 	dev->buffers = NULL;
 	dev->type = (enum v4l2_buf_type)-1;
+}
+
+static int video_open(struct device *dev, const char *devname, int no_query)
+{
+	struct v4l2_capability cap;
+	unsigned int capabilities;
+	int ret;
 
 	dev->fd = open(devname, O_RDWR);
 	if (dev->fd < 0) {
@@ -1599,6 +1602,8 @@ int main(int argc, char *argv[])
 
 	unsigned int rt_priority = 1;
 
+	video_init(&dev);
+
 	opterr = 0;
 	while ((c = getopt_long(argc, argv, "c::Cd:f:F::hi:Iln:pq:r:R::s:t:uw:", opts, NULL)) != -1) {
 
-- 
1.7.10.4

