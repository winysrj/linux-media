Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50689 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754182AbaDLNYQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Apr 2014 09:24:16 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [yavta PATCH v3 04/11] Make struct for buffer type and name mapping usable elsewhere
Date: Sat, 12 Apr 2014 16:23:56 +0300
Message-Id: <1397309043-8322-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
References: <1397309043-8322-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 yavta.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/yavta.c b/yavta.c
index 02a7403..01f61d2 100644
--- a/yavta.c
+++ b/yavta.c
@@ -97,24 +97,24 @@ static bool video_is_output(struct device *dev)
 	       dev->type == V4L2_BUF_TYPE_VIDEO_OUTPUT;
 }
 
+static struct {
+ 	enum v4l2_buf_type type;
+	const char *name;
+} buf_types[] = {
+	{ V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE, "Video capture mplanes", },
+	{ V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE, "Video output", },
+	{ V4L2_BUF_TYPE_VIDEO_CAPTURE, "Video capture" },
+	{ V4L2_BUF_TYPE_VIDEO_OUTPUT, "Video output mplanes" },
+	{ V4L2_BUF_TYPE_VIDEO_OVERLAY, "Video overlay" },
+};
+
 static const char *v4l2_buf_type_name(enum v4l2_buf_type type)
 {
-	static struct {
-		enum v4l2_buf_type type;
-		const char *name;
-	} names[] = {
-		{ V4L2_BUF_TYPE_VIDEO_CAPTURE, "Video capture" },
-		{ V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE, "Video capture mplanes" },
-		{ V4L2_BUF_TYPE_VIDEO_OUTPUT, "Video output" },
-		{ V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE, "Video output mplanes" },
-		{ V4L2_BUF_TYPE_VIDEO_OVERLAY, "Video overlay" },
-	};
-
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(names); ++i) {
-		if (names[i].type == type)
-			return names[i].name;
+	for (i = 0; i < ARRAY_SIZE(buf_types); ++i) {
+		if (buf_types[i].type == type)
+			return buf_types[i].name;
 	}
 
 	if (type & V4L2_BUF_TYPE_PRIVATE)
-- 
1.7.10.4

