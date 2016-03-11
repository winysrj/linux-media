Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:38903 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbcCKUph (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 15:45:37 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [v4l-utils PATCH 1/1] libv4l2subdev: Allow extra spaces between format strings
Date: Fri, 11 Mar 2016 22:43:18 +0200
Message-Id: <1457728998-11906-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's possible to pass more than one format string (and entity) to
v4l2_subdev_parse_setup_formats(), yet v4l2_subdev_parse_pad_format() does
not parse the string until the next non-space character.
v4l2_subdev_parse_setup_formats() expects to find a comma right after that
leading spaces before the comma to produce an error.

Seek until no spaces are seen.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/media-ctl/libv4l2subdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 1f5fca4..3dcf943 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -723,6 +723,7 @@ int v4l2_subdev_parse_setup_formats(struct media_device *media, const char *p)
 		if (ret < 0)
 			return ret;
 
+		for (; isspace(*end); end++);
 		p = end + 1;
 	} while (*end == ',');
 
-- 
2.1.0.231.g7484e3b

