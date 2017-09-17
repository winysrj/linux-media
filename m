Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:59042 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751451AbdIQB1N (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Sep 2017 21:27:13 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, rjkm@metzlerbros.de, d.scheller@gmx.net,
        jasmin@anw.at
Subject: [PATCH 1/2] Store device structure in dvb_register_device
Date: Sun, 17 Sep 2017 03:27:21 +0200
Message-Id: <1505611642-6552-2-git-send-email-jasmin@anw.at>
In-Reply-To: <1505611642-6552-1-git-send-email-jasmin@anw.at>
References: <1505611642-6552-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

The device created by device_create in dvb_register_device was not
available for DVB device drivers.
Added "struct device *dev" to "struct dvb_device" and store the created
device.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvbdev.c | 1 +
 drivers/media/dvb-core/dvbdev.h | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 41aad0f..fef9d7c 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -516,6 +516,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 		       __func__, adap->num, dnames[type], id, PTR_ERR(clsdev));
 		return PTR_ERR(clsdev);
 	}
+	dvbdev->dev = clsdev;
 	dprintk("DVB: register adapter%d/%s%d @ minor: %i (0x%02x)\n",
 		adap->num, dnames[type], id, minor, minor);
 
diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index 4918939..94667c8 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -126,10 +126,11 @@ struct dvb_adapter {
  * @tsout_num_entities: Number of Transport Stream output entities
  * @tsout_entity: array with MC entities associated to each TS output node
  * @tsout_pads: array with the source pads for each @tsout_entity
+ * @dev:	pointer to struct device that is associated with the dvb device
  *
  * This structure is used by the DVB core (frontend, CA, net, demux) in
  * order to create the device nodes. Usually, driver should not initialize
- * this struct diretly.
+ * this struct directly.
  */
 struct dvb_device {
 	struct list_head list_head;
@@ -162,6 +163,7 @@ struct dvb_device {
 #endif
 
 	void *priv;
+	struct device *dev;
 };
 
 /**
-- 
2.7.4
