Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13266 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab1IEPZQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Sep 2011 11:25:16 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [media-ctl][PATCHv5 4/5] libmediactl: simplify code by introducing close_and_free inliner
Date: Mon,  5 Sep 2011 18:24:06 +0300
Message-Id: <cbb103fda42ba7212fb45d72177599615c73d122.1315236211.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <6075971b959c2e808cd4ceec6540dc09b101346f.1315236211.git.andriy.shevchenko@linux.intel.com>
References: <201109051657.21646.laurent.pinchart@ideasonboard.com>
 <6075971b959c2e808cd4ceec6540dc09b101346f.1315236211.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <6075971b959c2e808cd4ceec6540dc09b101346f.1315236211.git.andriy.shevchenko@linux.intel.com>
References: <6075971b959c2e808cd4ceec6540dc09b101346f.1315236211.git.andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 src/media.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/src/media.c b/src/media.c
index 657b6c4..6c03369 100644
--- a/src/media.c
+++ b/src/media.c
@@ -403,6 +403,12 @@ static int media_enum_entities(struct media_private *priv)
 	return ret;
 }
 
+static inline void close_and_free(struct media_private *priv)
+{
+	free(priv);
+	media_close(priv->media);
+}
+
 struct media_device *media_open(const char *name, int verbose)
 {
 	struct media_device *media;
@@ -440,8 +446,7 @@ struct media_device *media_open(const char *name, int verbose)
 	ret = media_udev_open(priv);
 	if (ret < 0) {
 		printf("%s: Can't get udev context\n", __func__);
-		free(priv);
-		media_close(media);
+		close_and_free(priv);
 		return NULL;
 	}
 
@@ -457,8 +462,7 @@ struct media_device *media_open(const char *name, int verbose)
 	if (ret < 0) {
 		printf("%s: Unable to enumerate entities for device %s (%s)\n",
 			__func__, name, strerror(-ret));
-		free(priv);
-		media_close(media);
+		close_and_free(priv);
 		return NULL;
 	}
 
@@ -471,8 +475,7 @@ struct media_device *media_open(const char *name, int verbose)
 	if (ret < 0) {
 		printf("%s: Unable to enumerate pads and linksfor device %s\n",
 			__func__, name);
-		free(priv);
-		media_close(media);
+		close_and_free(priv);
 		return NULL;
 	}
 
-- 
1.7.5.4

