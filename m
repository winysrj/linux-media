Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40195 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab1LRXzt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Dec 2011 18:55:49 -0500
Received: from localhost.localdomain (unknown [91.178.220.210])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id A0BDF35BA2
	for <linux-media@vger.kernel.org>; Sun, 18 Dec 2011 23:55:47 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [RFC/PATCH 2/3] uvcvideo: Return -ENOTTY in case of unknown ioctl
Date: Mon, 19 Dec 2011 00:55:45 +0100
Message-Id: <1324252546-18437-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1324252546-18437-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1324252546-18437-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-EINVAL is the wrong error code in that case, replace it with -ENOTTY.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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

