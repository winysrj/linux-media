Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:32798 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbbKFQ5z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Nov 2015 11:57:55 -0500
From: Saurabh Sengar <saurabh.truth@gmail.com>
To: crope@iki.fi, mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Saurabh Sengar <saurabh.truth@gmail.com>
Subject: [PATCH] [media] hackrf: moving pointer reference before kfree
Date: Fri,  6 Nov 2015 22:27:39 +0530
Message-Id: <1446829059-10196-1-git-send-email-saurabh.truth@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

accessing a pointer after free could possible lead to segmentation
fault, hence correcting it

Signed-off-by: Saurabh Sengar <saurabh.truth@gmail.com>
---
 drivers/media/usb/hackrf/hackrf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index e05bfec..faf3670 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -1528,9 +1528,9 @@ err_v4l2_ctrl_handler_free_tx:
 err_v4l2_ctrl_handler_free_rx:
 	v4l2_ctrl_handler_free(&dev->rx_ctrl_handler);
 err_kfree:
+	dev_dbg(dev->dev, "failed=%d\n", ret);
 	kfree(dev);
 err:
-	dev_dbg(dev->dev, "failed=%d\n", ret);
 	return ret;
 }
 
-- 
1.9.1

