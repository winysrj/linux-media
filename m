Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7431 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbbLIPQS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2015 10:16:18 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 1/1] v4l: libv4l2subdev: Precisely convert media bus string to code
Date: Wed,  9 Dec 2015 17:14:47 +0200
Message-Id: <1449674087-19122-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The length of the string was ignored, making it possible for the
conversion to fail due to extra characters in the string.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
This patch should be applied before the set "[v4l-utils PATCH v2 0/3] List
supported formats in libv4l2subdev":

<URL:http://www.spinics.net/lists/linux-media/msg95377.html>

 utils/media-ctl/libv4l2subdev.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 33c1ee6..cce527d 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -769,14 +769,12 @@ enum v4l2_mbus_pixelcode v4l2_subdev_string_to_pixelcode(const char *string,
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(mbus_formats); ++i) {
-		if (strncmp(mbus_formats[i].name, string, length) == 0)
-			break;
+		if (strncmp(mbus_formats[i].name, string, length) == 0
+		    && strlen(mbus_formats[i].name) == length)
+			return mbus_formats[i].code;
 	}
 
-	if (i == ARRAY_SIZE(mbus_formats))
-		return (enum v4l2_mbus_pixelcode)-1;
-
-	return mbus_formats[i].code;
+	return (enum v4l2_mbus_pixelcode)-1;
 }
 
 static struct {
-- 
2.1.0.231.g7484e3b

