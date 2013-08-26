Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59671 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756478Ab3HZJQg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Aug 2013 05:16:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] v4l: Fix typo in v4l2_subdev_get_try_crop()
Date: Mon, 26 Aug 2013 11:17:51 +0200
Message-Id: <1377508671-13188-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The helper function is defined by a macro that is erroneously called
with the compose rectangle instead of the crop rectangle. Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/media/v4l2-subdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index bfda0fe..34d9219 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -628,7 +628,7 @@ struct v4l2_subdev_fh {
 	}
 
 __V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, format, try_fmt)
-__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, crop, try_compose)
+__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, crop, try_crop)
 __V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, compose, try_compose)
 #endif
 
-- 
1.8.1.5

