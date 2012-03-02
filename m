Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:60725 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183Ab2CBRcx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Mar 2012 12:32:53 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v4 05/34] v4l: vdev_to_v4l2_subdev() should have return type "struct v4l2_subdev *"
Date: Fri,  2 Mar 2012 19:30:13 +0200
Message-Id: <1330709442-16654-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120302173219.GA15695@valkosipuli.localdomain>
References: <20120302173219.GA15695@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vdev_to_v4l2_subdev() should return struct v4l2_subdev *, not void *. Fix
this.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/v4l2-subdev.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index feab950..bcaf6b8 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -545,7 +545,7 @@ struct v4l2_subdev {
 #define media_entity_to_v4l2_subdev(ent) \
 	container_of(ent, struct v4l2_subdev, entity)
 #define vdev_to_v4l2_subdev(vdev) \
-	video_get_drvdata(vdev)
+	((struct v4l2_subdev *)video_get_drvdata(vdev))
 
 /*
  * Used for storing subdev information per file handle
-- 
1.7.2.5

