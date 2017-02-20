Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60920 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753745AbdBTPWa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 10:22:30 -0500
Received: from lanttu.localdomain (unknown [192.168.15.166])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 85180600A4
        for <linux-media@vger.kernel.org>; Mon, 20 Feb 2017 17:22:26 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/6] omap3isp: Remove misleading comment
Date: Mon, 20 Feb 2017 17:22:19 +0200
Message-Id: <1487604142-27610-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1487604142-27610-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1487604142-27610-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The intent of the check the comment is related to is to ensure we are
streaming --- still. Not that streaming wouldn't be enabled yet. Remove
it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 9e9b18c..a3ca2a4 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1205,7 +1205,6 @@ isp_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	mutex_lock(&video->stream_lock);
 
-	/* Make sure we're not streaming yet. */
 	mutex_lock(&video->queue_lock);
 	streaming = vb2_is_streaming(&vfh->queue);
 	mutex_unlock(&video->queue_lock);
-- 
2.1.4
