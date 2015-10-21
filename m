Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43478 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbbJUVHb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Oct 2015 17:07:31 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH] hackrf: fix possible null ptr on debug printing
Date: Thu, 22 Oct 2015 00:07:06 +0300
Message-Id: <1445461626-8713-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/hackrf/hackrf.c:1533 hackrf_probe()
error: we previously assumed 'dev' could be null (see line 1366)

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/hackrf/hackrf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index e05bfec..84e8a42 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -1530,7 +1530,7 @@ err_v4l2_ctrl_handler_free_rx:
 err_kfree:
 	kfree(dev);
 err:
-	dev_dbg(dev->dev, "failed=%d\n", ret);
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
-- 
http://palosaari.fi/

