Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:40855 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751323AbdHDKl7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 06:41:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/5] adv*/vivid/pulse8/rainshadow: cec: use CEC_CAP_DEFAULTS
Date: Fri,  4 Aug 2017 12:41:52 +0200
Message-Id: <20170804104155.37386-3-hverkuil@xs4all.nl>
In-Reply-To: <20170804104155.37386-1-hverkuil@xs4all.nl>
References: <20170804104155.37386-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use the new CEC_CAP_DEFAULTS define in the adv, vivid, pulse8 and
rainshadow CEC drivers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7511.c                       | 3 +--
 drivers/media/i2c/adv7604.c                       | 3 +--
 drivers/media/i2c/adv7842.c                       | 3 +--
 drivers/media/platform/vivid/vivid-cec.c          | 3 +--
 drivers/media/usb/pulse8-cec/pulse8-cec.c         | 3 +--
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c | 3 +--
 6 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index ec100fbf7c4d..0cdfc2b14121 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -1927,8 +1927,7 @@ static int adv7511_probe(struct i2c_client *client, const struct i2c_device_id *
 
 #if IS_ENABLED(CONFIG_VIDEO_ADV7511_CEC)
 	state->cec_adap = cec_allocate_adapter(&adv7511_cec_adap_ops,
-		state, dev_name(&client->dev), CEC_CAP_TRANSMIT |
-		CEC_CAP_LOG_ADDRS | CEC_CAP_PASSTHROUGH | CEC_CAP_RC,
+		state, dev_name(&client->dev), CEC_CAP_DEFAULTS,
 		ADV7511_MAX_ADDRS);
 	if (IS_ERR(state->cec_adap)) {
 		err = PTR_ERR(state->cec_adap);
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index de0207b3d63d..1430b706cdf1 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -3515,8 +3515,7 @@ static int adv76xx_probe(struct i2c_client *client,
 #if IS_ENABLED(CONFIG_VIDEO_ADV7604_CEC)
 	state->cec_adap = cec_allocate_adapter(&adv76xx_cec_adap_ops,
 		state, dev_name(&client->dev),
-		CEC_CAP_TRANSMIT | CEC_CAP_LOG_ADDRS |
-		CEC_CAP_PASSTHROUGH | CEC_CAP_RC, ADV76XX_MAX_ADDRS);
+		CEC_CAP_DEFAULTS, ADV76XX_MAX_ADDRS);
 	if (IS_ERR(state->cec_adap)) {
 		err = PTR_ERR(state->cec_adap);
 		goto err_entity;
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 6d01f9c82b8f..63ac5a09c587 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -3568,8 +3568,7 @@ static int adv7842_probe(struct i2c_client *client,
 #if IS_ENABLED(CONFIG_VIDEO_ADV7842_CEC)
 	state->cec_adap = cec_allocate_adapter(&adv7842_cec_adap_ops,
 		state, dev_name(&client->dev),
-		CEC_CAP_TRANSMIT | CEC_CAP_LOG_ADDRS |
-		CEC_CAP_PASSTHROUGH | CEC_CAP_RC, ADV7842_MAX_ADDRS);
+		CEC_CAP_DEFAULTS, ADV7842_MAX_ADDRS);
 	if (IS_ERR(state->cec_adap)) {
 		err = PTR_ERR(state->cec_adap);
 		goto err_entity;
diff --git a/drivers/media/platform/vivid/vivid-cec.c b/drivers/media/platform/vivid/vivid-cec.c
index e15705758969..43992fa92a88 100644
--- a/drivers/media/platform/vivid/vivid-cec.c
+++ b/drivers/media/platform/vivid/vivid-cec.c
@@ -219,8 +219,7 @@ struct cec_adapter *vivid_cec_alloc_adap(struct vivid_dev *dev,
 					 bool is_source)
 {
 	char name[sizeof(dev->vid_out_dev.name) + 2];
-	u32 caps = CEC_CAP_TRANSMIT | CEC_CAP_LOG_ADDRS |
-		CEC_CAP_PASSTHROUGH | CEC_CAP_RC | CEC_CAP_MONITOR_ALL;
+	u32 caps = CEC_CAP_DEFAULTS | CEC_CAP_MONITOR_ALL;
 
 	snprintf(name, sizeof(name), "%s%d",
 		 is_source ? dev->vid_out_dev.name : dev->vid_cap_dev.name,
diff --git a/drivers/media/usb/pulse8-cec/pulse8-cec.c b/drivers/media/usb/pulse8-cec/pulse8-cec.c
index 3b0ee8c9bc26..7d880441b0eb 100644
--- a/drivers/media/usb/pulse8-cec/pulse8-cec.c
+++ b/drivers/media/usb/pulse8-cec/pulse8-cec.c
@@ -642,8 +642,7 @@ static const struct cec_adap_ops pulse8_cec_adap_ops = {
 
 static int pulse8_connect(struct serio *serio, struct serio_driver *drv)
 {
-	u32 caps = CEC_CAP_TRANSMIT | CEC_CAP_LOG_ADDRS | CEC_CAP_PHYS_ADDR |
-		CEC_CAP_PASSTHROUGH | CEC_CAP_RC | CEC_CAP_MONITOR_ALL;
+	u32 caps = CEC_CAP_DEFAULTS | CEC_CAP_PHYS_ADDR | CEC_CAP_MONITOR_ALL;
 	struct pulse8 *pulse8;
 	int err = -ENOMEM;
 	struct cec_log_addrs log_addrs = {};
diff --git a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
index c63f318752fd..650eab7e79b2 100644
--- a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
+++ b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
@@ -309,8 +309,7 @@ static const struct cec_adap_ops rain_cec_adap_ops = {
 
 static int rain_connect(struct serio *serio, struct serio_driver *drv)
 {
-	u32 caps = CEC_CAP_TRANSMIT | CEC_CAP_LOG_ADDRS | CEC_CAP_PHYS_ADDR |
-		CEC_CAP_PASSTHROUGH | CEC_CAP_RC | CEC_CAP_MONITOR_ALL;
+	u32 caps = CEC_CAP_DEFAULTS | CEC_CAP_PHYS_ADDR | CEC_CAP_MONITOR_ALL;
 	struct rain *rain;
 	int err = -ENOMEM;
 	struct cec_log_addrs log_addrs = {};
-- 
2.13.2
