Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:34805 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S938407AbeBUPcZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 10:32:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 11/15] media.h: fix confusing typo in comment
Date: Wed, 21 Feb 2018 16:32:14 +0100
Message-Id: <20180221153218.15654-12-hverkuil@xs4all.nl>
In-Reply-To: <20180221153218.15654-1-hverkuil@xs4all.nl>
References: <20180221153218.15654-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Subdevs are initialized with MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN, not
MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/uapi/linux/media.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index b9b9446095e9..573da38a21c3 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -131,7 +131,7 @@ struct media_device_info {
  * with the legacy v1 API.The number range is out of range by purpose:
  * several previously reserved numbers got excluded from this range.
  *
- * Subdevs are initialized with MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN,
+ * Subdevs are initialized with MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN,
  * in order to preserve backward compatibility.
  * Drivers must change to the proper subdev type before
  * registering the entity.
-- 
2.16.1
