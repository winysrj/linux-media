Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46466 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751337AbdGMPXw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 11:23:52 -0400
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1001])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 22BE3600C9
        for <linux-media@vger.kernel.org>; Thu, 13 Jul 2017 18:23:49 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 3/6] omap3isp: Remove misleading comment
Date: Thu, 13 Jul 2017 18:23:46 +0300
Message-Id: <20170713152349.14480-4-sakari.ailus@linux.intel.com>
In-Reply-To: <20170713152349.14480-1-sakari.ailus@linux.intel.com>
References: <20170713152349.14480-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The intent of the check the comment is related to is to ensure we are
streaming --- still. Not that streaming wouldn't be enabled yet. Remove
it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 9e9b18c217bd..a3ca2a480d1a 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1205,7 +1205,6 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	mutex_lock(&video->stream_lock);
 
-	/* Make sure we're not streaming yet. */
 	mutex_lock(&video->queue_lock);
 	streaming = vb2_is_streaming(&vfh->queue);
 	mutex_unlock(&video->queue_lock);
-- 
2.11.0
