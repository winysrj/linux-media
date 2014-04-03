Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52690 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbaDCX3a (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 19:29:30 -0400
Received: from avalon.ideasonboard.com (unknown [91.177.168.144])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id C235A359AC
	for <linux-media@vger.kernel.org>; Fri,  4 Apr 2014 01:27:45 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] omap4iss: Add missing white space
Date: Fri,  4 Apr 2014 01:31:30 +0200
Message-Id: <1396567890-32640-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The error was reported by checkpatch.pl. Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_video.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.h b/drivers/staging/media/omap4iss/iss_video.h
index 878e4a3..9dccdb1 100644
--- a/drivers/staging/media/omap4iss/iss_video.h
+++ b/drivers/staging/media/omap4iss/iss_video.h
@@ -140,7 +140,7 @@ enum iss_video_dmaqueue_flags {
  *		if there was no buffer previously queued.
  */
 struct iss_video_operations {
-	int(*queue)(struct iss_video *video, struct iss_buffer *buffer);
+	int (*queue)(struct iss_video *video, struct iss_buffer *buffer);
 };
 
 struct iss_video {
-- 
Regards,

Laurent Pinchart

