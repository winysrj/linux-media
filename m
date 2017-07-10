Return-path: <linux-media-owner@vger.kernel.org>
Received: from [216.228.121.65] ([216.228.121.65]:19270 "EHLO
        hqemgate16.nvidia.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbdGJGoY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 02:44:24 -0400
From: Jim Lin <jilin@nvidia.com>
To: <laurent.pinchart@ideasonboard.com>, <mchehab@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Jim Lin <jilin@nvidia.com>
Subject: [PATCH 1/1 V2] media: usb: uvc: Fix incorrect timeout for Get Request
Date: Mon, 10 Jul 2017 14:43:49 +0800
Message-ID: <1499669029-3412-1-git-send-email-jilin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Section 9.2.6.4 of USB 2.0/3.x specification describes that
"device must be able to return the first data packet to host within
500 ms of receipt of the request. For subsequent data packet, if any,
the device must be able to return them within 500 ms".

This is to fix incorrect timeout and change it from 300 ms to 500 ms
to meet the timing specified by specification for Get Request.

Signed-off-by: Jim Lin <jilin@nvidia.com>
---
V2: Change patch description

 drivers/media/usb/uvc/uvcvideo.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 15e415e..296b69b 100644
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
2.7.4
