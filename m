Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:32775 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbbKGVXo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2015 16:23:44 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [v4l-utils PATCH 1/2] libv4l2subdev: Add a forward definition for missing struct media_device
Date: Sat,  7 Nov 2015 23:22:20 +0200
Message-Id: <1446931341-29254-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1446931341-29254-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1446931341-29254-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This avoids a compiler warning if mediactl.h isn't included.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 utils/media-ctl/v4l2subdev.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
index 1cb53ff..4961308 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -24,6 +24,7 @@
 
 #include <linux/v4l2-subdev.h>
 
+struct media_device;
 struct media_entity;
 
 /**
-- 
2.1.0.231.g7484e3b

