Return-path: <linux-media-owner@vger.kernel.org>
Received: from scing.com ([217.160.110.58]:60456 "EHLO scing.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932658Ab2BBRlr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Feb 2012 12:41:47 -0500
From: Janne Grunau <j@jannau.net>
To: linux-media@vger.kernel.org
Cc: Joerg Desch <vvd.joede@googlemail.com>, stable@kernel.org
Subject: [PATCH 1/1] [media] hdpvr: fix race conditon during start of streaming
Date: Thu,  2 Feb 2012 18:35:21 +0100
Message-Id: <1328204121-7207-1-git-send-email-j@jannau.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

status has to be set to STREAMING before the streaming worker is
queued. hdpvr_transmit_buffers() will exit immediately otherwise.

Reported-by: Joerg Desch <vvd.joede@googlemail.com>
CC: stable@kernel.org
---
 drivers/media/video/hdpvr/hdpvr-video.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/hdpvr/hdpvr-video.c b/drivers/media/video/hdpvr/hdpvr-video.c
index 087f7c0..41fd57b 100644
--- a/drivers/media/video/hdpvr/hdpvr-video.c
+++ b/drivers/media/video/hdpvr/hdpvr-video.c
@@ -283,12 +283,13 @@ static int hdpvr_start_streaming(struct hdpvr_device *dev)
 
 		hdpvr_config_call(dev, CTRL_START_STREAMING_VALUE, 0x00);
 
+		dev->status = STATUS_STREAMING;
+
 		INIT_WORK(&dev->worker, hdpvr_transmit_buffers);
 		queue_work(dev->workqueue, &dev->worker);
 
 		v4l2_dbg(MSG_BUFFER, hdpvr_debug, &dev->v4l2_dev,
 			 "streaming started\n");
-		dev->status = STATUS_STREAMING;
 
 		return 0;
 	}
-- 
1.7.8.4

