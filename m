Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33041 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbaFLRGq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:06:46 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH 21/26] [media] v4l2-subdev.h: Add lock status notification
Date: Thu, 12 Jun 2014 19:06:35 +0200
Message-Id: <1402592800-2925-22-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This notification type can be used by ADC converters with their
own interrupt handler to notify the bridge or capture interface
driver about the signal lock status.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 include/media/v4l2-subdev.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 28f4d8c..0af5e08 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -40,6 +40,9 @@
 #define V4L2_SUBDEV_IR_TX_NOTIFY		_IOW('v', 1, u32)
 #define V4L2_SUBDEV_IR_TX_FIFO_SERVICE_REQ	0x00000001
 
+#define V4L2_SUBDEV_SYNC_LOCK_NOTIFY		_IOW('v', 2, u32)
+#define V4L2_SUBDEV_SYNC_LOCK			0x00000001
+
 struct v4l2_device;
 struct v4l2_ctrl_handler;
 struct v4l2_event_subscription;
-- 
2.0.0.rc2

