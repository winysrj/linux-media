Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58503 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139Ab2AKPSS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 10:18:18 -0500
Received: from localhost.localdomain (unknown [91.178.113.85])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5905935AA6
	for <linux-media@vger.kernel.org>; Wed, 11 Jan 2012 15:18:16 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 2/3] uvcvideo: Return -ENOTTY in case of unknown ioctl
Date: Wed, 11 Jan 2012 16:18:39 +0100
Message-Id: <1326295120-15391-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1326295120-15391-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1326295120-15391-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-EINVAL is the wrong error code in that case, replace it with -ENOTTY.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/uvc/uvc_v4l2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 2ae4f88..f09ee8b 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -1012,7 +1012,7 @@ static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	default:
 		uvc_trace(UVC_TRACE_IOCTL, "Unknown ioctl 0x%08x\n", cmd);
-		return -EINVAL;
+		return -ENOTTY;
 	}
 
 	return ret;
-- 
1.7.3.4

