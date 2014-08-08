Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:4380 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaHHH5a (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Aug 2014 03:57:30 -0400
From: matrandg@cisco.com
To: linux-media@vger.kernel.org
Cc: matrandg@cisco.com
Subject: [PATCH] v4l2-ioctl: The result of VIDIOC_S_EDID should always be returned
Date: Fri,  8 Aug 2014 09:47:41 +0200
Message-Id: <1407484061-26651-1-git-send-email-matrandg@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

VIDIOC_S_EDID can return error and valid result

Documentation/DocBook/media/v4l/vidioc-g-edid.xml:
"If there are more EDID blocks than the hardware can handle then
the EDID is not written, but instead the error code E2BIG is set
and blocks is set to the maximum that the hardware supports."
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index d15e167..f36c018 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2554,9 +2554,9 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 			err = -EFAULT;
 		goto out_array_args;
 	}
-	/* VIDIOC_QUERY_DV_TIMINGS can return an error, but still have valid
-	   results that must be returned. */
-	if (err < 0 && cmd != VIDIOC_QUERY_DV_TIMINGS)
+	/* VIDIOC_QUERY_DV_TIMINGS and VIDIOC_S_EDID can return an error, but
+	   still have valid results that must be returned. */
+	if (err < 0 && cmd != VIDIOC_QUERY_DV_TIMINGS && cmd != VIDIOC_S_EDID)
 		goto out;
 
 out_array_args:
-- 
1.8.4.5

