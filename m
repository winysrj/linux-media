Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44869 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbaLWVOk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 16:14:40 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 57/66] rtl2832_sdr: refcount to rtl28xxu
Date: Tue, 23 Dec 2014 22:49:50 +0200
Message-Id: <1419367799-14263-57-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We are consumer of DVB frontend provided by rtl28xxu module. Due to
that we must use refcount to ensure none could remove rtl28xxu when
we are alive (or when we are streaming, if more fine-grained
refcounting is wanted).

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832_sdr.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index 62e85a3..3ff8806 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -1310,10 +1310,21 @@ static int rtl2832_sdr_probe(struct platform_device *pdev)
 		ret = -EINVAL;
 		goto err;
 	}
+	if (!pdev->dev.parent->driver) {
+		dev_dbg(&pdev->dev, "No parent device\n");
+		ret = -EINVAL;
+		goto err;
+	}
+	/* try to refcount host drv since we are the consumer */
+	if (!try_module_get(pdev->dev.parent->driver->owner)) {
+		dev_err(&pdev->dev, "Refcount fail");
+		ret = -EINVAL;
+		goto err;
+	}
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
 		ret = -ENOMEM;
-		goto err;
+		goto err_module_put;
 	}
 
 	/* setup the state */
@@ -1426,6 +1437,8 @@ err_v4l2_ctrl_handler_free:
 	v4l2_ctrl_handler_free(&dev->hdl);
 err_kfree:
 	kfree(dev);
+err_module_put:
+	module_put(pdev->dev.parent->driver->owner);
 err:
 	return ret;
 }
@@ -1444,8 +1457,8 @@ static int rtl2832_sdr_remove(struct platform_device *pdev)
 	video_unregister_device(&dev->vdev);
 	mutex_unlock(&dev->v4l2_lock);
 	mutex_unlock(&dev->vb_queue_lock);
-
 	v4l2_device_put(&dev->v4l2_dev);
+	module_put(pdev->dev.parent->driver->owner);
 
 	return 0;
 }
-- 
http://palosaari.fi/

