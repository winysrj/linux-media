Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28660 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbcBUVcH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2016 16:32:07 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 1/4] v4l: libv4lsubdev: Make mbus_formats array const
Date: Sun, 21 Feb 2016 23:29:44 +0200
Message-Id: <1456090187-1191-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1456090187-1191-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1456090187-1191-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The array is already static and may not be modified at runtime. Make it
const.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 utils/media-ctl/libv4l2subdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index dc2cd87..e45834f 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -715,7 +715,7 @@ int v4l2_subdev_parse_setup_formats(struct media_device *media, const char *p)
 	return *end ? -EINVAL : 0;
 }
 
-static struct {
+static const struct {
 	const char *name;
 	enum v4l2_mbus_pixelcode code;
 } mbus_formats[] = {
-- 
2.1.0.231.g7484e3b

