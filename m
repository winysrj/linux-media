Return-path: <linux-media-owner@vger.kernel.org>
Received: from m1plsmtpa01-08.prod.mesa1.secureserver.net ([64.202.165.187]:41659
	"EHLO m1plsmtpa01-08.prod.mesa1.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820Ab3EMLS2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 07:18:28 -0400
From: Leonid Kegulskiy <leo@lumanate.com>
To: hverkuil@xs4all.nl
Cc: Leonid Kegulskiy <leo@lumanate.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/4] [media] hdpvr: Added some error handling in hdpvr_start_streaming()
Date: Mon, 13 May 2013 04:10:43 -0700
Message-Id: <1368443444-12492-3-git-send-email-leo@lumanate.com>
In-Reply-To: <1368443444-12492-1-git-send-email-leo@lumanate.com>
References: <1368443444-12492-1-git-send-email-leo@lumanate.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Leonid Kegulskiy <leo@lumanate.com>
---
 drivers/media/usb/hdpvr/hdpvr-video.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index d9eb8e1..2d02b49 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -297,8 +297,12 @@ static int hdpvr_start_streaming(struct hdpvr_device *dev)
 				      0xb8, 0x38, 0x1, 0, NULL, 0, 8000);
 		v4l2_dbg(MSG_BUFFER, hdpvr_debug, &dev->v4l2_dev,
 			 "encoder start control request returned %d\n", ret);
+		if (ret < 0)
+			return ret;
 
-		hdpvr_config_call(dev, CTRL_START_STREAMING_VALUE, 0x00);
+		ret = hdpvr_config_call(dev, CTRL_START_STREAMING_VALUE, 0x00);
+		if (ret)
+			return ret;
 
 		dev->status = STATUS_STREAMING;
 
-- 
1.7.9.5

