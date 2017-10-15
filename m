Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:38868 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbdJOUwG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Oct 2017 16:52:06 -0400
Received: by mail-wm0-f65.google.com with SMTP id q124so6147900wmb.5
        for <linux-media@vger.kernel.org>; Sun, 15 Oct 2017 13:52:05 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH 6/8] [media] ddbridge/max: prefix lnb_init_fmode() and fe_attach_mxl5xx()
Date: Sun, 15 Oct 2017 22:51:55 +0200
Message-Id: <20171015205157.14342-7-d.scheller.oss@gmail.com>
In-Reply-To: <20171015205157.14342-1-d.scheller.oss@gmail.com>
References: <20171015205157.14342-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Add a ddb_ prefix to the two functions to better avoid conflicts in the
global namespace, ie. when building everything into the kernel image.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 4 ++--
 drivers/media/pci/ddbridge/ddbridge-max.c  | 6 +++---
 drivers/media/pci/ddbridge/ddbridge-max.h  | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index e2e793b749f2..348cc8b3d1f9 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1442,7 +1442,7 @@ static int dvb_input_attach(struct ddb_input *input)
 	dvb->fe2 = NULL;
 	switch (port->type) {
 	case DDB_TUNER_MXL5XX:
-		if (fe_attach_mxl5xx(input) < 0)
+		if (ddb_fe_attach_mxl5xx(input) < 0)
 			return -ENODEV;
 		break;
 	case DDB_TUNER_DVBS_ST:
@@ -2955,7 +2955,7 @@ static ssize_t fmode_store(struct device *device, struct device_attribute *attr,
 		return -EINVAL;
 	if (val > 3)
 		return -EINVAL;
-	lnb_init_fmode(dev, &dev->link[num], val);
+	ddb_lnb_init_fmode(dev, &dev->link[num], val);
 	return count;
 }
 
diff --git a/drivers/media/pci/ddbridge/ddbridge-max.c b/drivers/media/pci/ddbridge/ddbridge-max.c
index 67ab4e300a36..dc6b81488746 100644
--- a/drivers/media/pci/ddbridge/ddbridge-max.c
+++ b/drivers/media/pci/ddbridge/ddbridge-max.c
@@ -360,7 +360,7 @@ static int mxl_fw_read(void *priv, u8 *buf, u32 len)
 	return ddbridge_flashread(dev, link->nr, buf, 0xc0000, len);
 }
 
-int lnb_init_fmode(struct ddb *dev, struct ddb_link *link, u32 fm)
+int ddb_lnb_init_fmode(struct ddb *dev, struct ddb_link *link, u32 fm)
 {
 	u32 l = link->nr;
 
@@ -404,7 +404,7 @@ static struct mxl5xx_cfg mxl5xx = {
 	.fw_read  = mxl_fw_read,
 };
 
-int fe_attach_mxl5xx(struct ddb_input *input)
+int ddb_fe_attach_mxl5xx(struct ddb_input *input)
 {
 	struct ddb *dev = input->port->dev;
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
@@ -440,7 +440,7 @@ int fe_attach_mxl5xx(struct ddb_input *input)
 		lnb_command(dev, port->lnr, input->nr, LNB_CMD_INIT);
 		lnb_set_voltage(dev, port->lnr, input->nr, SEC_VOLTAGE_OFF);
 	}
-	lnb_init_fmode(dev, link, fmode);
+	ddb_lnb_init_fmode(dev, link, fmode);
 
 	dvb->fe->ops.set_voltage = max_set_voltage;
 	dvb->fe->ops.enable_high_lnb_voltage = max_enable_high_lnb_voltage;
diff --git a/drivers/media/pci/ddbridge/ddbridge-max.h b/drivers/media/pci/ddbridge/ddbridge-max.h
index b1bfbbea4337..bf8bf38739f6 100644
--- a/drivers/media/pci/ddbridge/ddbridge-max.h
+++ b/drivers/media/pci/ddbridge/ddbridge-max.h
@@ -23,7 +23,7 @@
 
 /******************************************************************************/
 
-int lnb_init_fmode(struct ddb *dev, struct ddb_link *link, u32 fm);
-int fe_attach_mxl5xx(struct ddb_input *input);
+int ddb_lnb_init_fmode(struct ddb *dev, struct ddb_link *link, u32 fm);
+int ddb_fe_attach_mxl5xx(struct ddb_input *input);
 
 #endif /* _DDBRIDGE_MAX_H */
-- 
2.13.6
