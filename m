Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34398 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbbKKPGA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2015 10:06:00 -0500
From: Colin King <colin.king@canonical.com>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] hackrf: don't emit dev debug on a kfree'd or null dev
Date: Wed, 11 Nov 2015 15:05:53 +0000
Message-Id: <1447254353-12452-1-git-send-email-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Static analysis with smatch detected a couple of issues:

drivers/media/usb/hackrf/hackrf.c:1533 hackrf_probe()
  error: we previously assumed 'dev' could be null (see line 1366)
drivers/media/usb/hackrf/hackrf.c:1533 hackrf_probe()
  error: dereferencing freed memory 'dev'

A dev_dbg message is being output on a kfree'd dev.  Worse, if dev
is not allocated earlier, on, a null pointer deference on dev->dev
can occur onthe deb_dbg call.  Clean this up by only printing a debug
message if dev is not null and has not been kfree'd.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
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
2.5.0

