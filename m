Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49390 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab1AGQAC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 11:00:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/5] uvcvideo: Include linux/types.h in uvcvideo.h
Date: Fri,  7 Jan 2011 17:00:39 +0100
Message-Id: <1294416040-28371-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1294416040-28371-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1294416040-28371-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The header file uses __u* types, linux/types.h must be included in
preparation for its move to include/linux.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvcvideo.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index b98bbd3..e6684c2 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -1,7 +1,7 @@
 #ifndef _USB_VIDEO_H_
 #define _USB_VIDEO_H_
 
-#include <linux/kernel.h>
+#include <linux/types.h>
 #include <linux/videodev2.h>
 
 /*
-- 
1.7.2.2

