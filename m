Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47380 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752311AbdHHM4R (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Aug 2017 08:56:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, Jim Lin <jilin@nvidia.com>
Subject: [PATCH 1/5] uvcvideo: Fix incorrect timeout for Get Request
Date: Tue,  8 Aug 2017 15:56:20 +0300
Message-Id: <20170808125624.11328-2-laurent.pinchart@ideasonboard.com>
In-Reply-To: <20170808125624.11328-1-laurent.pinchart@ideasonboard.com>
References: <20170808125624.11328-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jim Lin <jilin@nvidia.com>

Section 9.2.6.4 of USB 2.0/3.x specification describes that
"device must be able to return the first data packet to host within
500 ms of receipt of the request. For subsequent data packet, if any,
the device must be able to return them within 500 ms".

This is to fix incorrect timeout and change it from 300 ms to 500 ms
to meet the timing specified by specification for Get Request.

Signed-off-by: Jim Lin <jilin@nvidia.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvcvideo.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 15e415e32c7f..296b69bb3fb2 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -166,7 +166,7 @@
 /* Maximum status buffer size in bytes of interrupt URB. */
 #define UVC_MAX_STATUS_SIZE	16
 
-#define UVC_CTRL_CONTROL_TIMEOUT	300
+#define UVC_CTRL_CONTROL_TIMEOUT	500
 #define UVC_CTRL_STREAMING_TIMEOUT	5000
 
 /* Maximum allowed number of control mappings per device */
-- 
Regards,

Laurent Pinchart
