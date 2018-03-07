Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:20238 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751072AbeCGIso (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 03:48:44 -0500
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id 836772074C
        for <linux-media@vger.kernel.org>; Wed,  7 Mar 2018 10:48:42 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] staging: media: atomisp: Remove v4l2_buffer.reserved2 field hack
Date: Wed,  7 Mar 2018 10:48:16 +0200
Message-Id: <1520412496-6913-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The atomisp driver used to use the reserved2 field in struct v4l2_buffer
for picking a particular ISP configuration for the buffer. As reserved2
field will have new use soon, remove this hack.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 .../staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c  | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
index 5c84dd6..182bb70 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
@@ -1283,16 +1283,7 @@ static int atomisp_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 	if (!((buf->flags & NOFLUSH_FLAGS) == NOFLUSH_FLAGS))
 		wbinvd();
 
-	if (!atomisp_is_vf_pipe(pipe) &&
-	    (buf->reserved2 & ATOMISP_BUFFER_HAS_PER_FRAME_SETTING)) {
-		/* this buffer will have a per-frame parameter */
-		pipe->frame_request_config_id[buf->index] = buf->reserved2 &
-					~ATOMISP_BUFFER_HAS_PER_FRAME_SETTING;
-		dev_dbg(isp->dev, "This buffer requires per_frame setting which has isp_config_id %d\n",
-			pipe->frame_request_config_id[buf->index]);
-	} else {
-		pipe->frame_request_config_id[buf->index] = 0;
-	}
+	pipe->frame_request_config_id[buf->index] = 0;
 
 	pipe->frame_params[buf->index] = NULL;
 
@@ -1470,12 +1461,10 @@ static int atomisp_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 	buf->reserved &= 0x0000ffff;
 	if (!(buf->flags & V4L2_BUF_FLAG_ERROR))
 		buf->reserved |= __get_frame_exp_id(pipe, buf) << 16;
-	buf->reserved2 = pipe->frame_config_id[buf->index];
 	rt_mutex_unlock(&isp->mutex);
 
-	dev_dbg(isp->dev, "dqbuf buffer %d (%s) for asd%d with exp_id %d, isp_config_id %d\n",
-		buf->index, vdev->name, asd->index, buf->reserved >> 16,
-		buf->reserved2);
+	dev_dbg(isp->dev, "dqbuf buffer %d (%s) for asd%d with exp_id %d\n",
+		buf->index, vdev->name, asd->index, buf->reserved >> 16);
 	return 0;
 }
 
-- 
2.7.4
