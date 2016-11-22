Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:35327 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752576AbcKVMIR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 07:08:17 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: pass parent device in register, not allocate
Message-ID: <181e7c5b-c322-e70c-3d9b-2b6754f9e264@xs4all.nl>
Date: Tue, 22 Nov 2016 13:08:14 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cec_allocate_adapter function doesn't need the parent device, only the
cec_register_adapter function needs it.

Drop the cec_devnode parent field, since devnode.dev.parent can be used
instead.

This change makes the framework consistent with other frameworks where the
parent device is not used until the device is registered.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/kapi/cec-core.rst 
b/Documentation/media/kapi/cec-core.rst
index 8a88dd4..81c6d8e 100644
--- a/Documentation/media/kapi/cec-core.rst
+++ b/Documentation/media/kapi/cec-core.rst
@@ -37,9 +37,8 @@ The struct cec_adapter represents the CEC adapter 
hardware. It is created by
  calling cec_allocate_adapter() and deleted by calling 
cec_delete_adapter():

  .. c:function::
-   struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
-	       void *priv, const char *name, u32 caps, u8 available_las,
-	       struct device *parent);
+   struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops 
*ops, void *priv,
+   const char *name, u32 caps, u8 available_las);

  .. c:function::
     void cec_delete_adapter(struct cec_adapter *adap);
@@ -66,20 +65,19 @@ available_las:
  	the number of simultaneous logical addresses that this
  	adapter can handle. Must be 1 <= available_las <= CEC_MAX_LOG_ADDRS.

-parent:
-	the parent device.
-

  To register the /dev/cecX device node and the remote control device (if
  CEC_CAP_RC is set) you call:

  .. c:function::
-	int cec_register_adapter(struct cec_adapter \*adap);
+	int cec_register_adapter(struct cec_adapter *adap, struct device *parent);
+
+where parent is the parent device.

  To unregister the devices call:

  .. c:function::
-	void cec_unregister_adapter(struct cec_adapter \*adap);
+	void cec_unregister_adapter(struct cec_adapter *adap);

  Note: if cec_register_adapter() fails, then call cec_delete_adapter() to
  clean up. But if cec_register_adapter() succeeded, then only call
diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index 597fbb6..8950b6c 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -88,7 +88,7 @@ static long cec_adap_g_caps(struct cec_adapter *adap,
  {
  	struct cec_caps caps = {};

-	strlcpy(caps.driver, adap->devnode.parent->driver->name,
+	strlcpy(caps.driver, adap->devnode.dev.parent->driver->name,
  		sizeof(caps.driver));
  	strlcpy(caps.name, adap->name, sizeof(caps.name));
  	caps.available_log_addrs = adap->available_log_addrs;
diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index b0137e2..aca3ab8 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -132,7 +132,6 @@ static int __must_check cec_devnode_register(struct 
cec_devnode *devnode,
  	devnode->dev.bus = &cec_bus_type;
  	devnode->dev.devt = MKDEV(MAJOR(cec_dev_t), minor);
  	devnode->dev.release = cec_devnode_release;
-	devnode->dev.parent = devnode->parent;
  	dev_set_name(&devnode->dev, "cec%d", devnode->minor);
  	device_initialize(&devnode->dev);

@@ -198,13 +197,11 @@ static void cec_devnode_unregister(struct 
cec_devnode *devnode)

  struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
  					 void *priv, const char *name, u32 caps,
-					 u8 available_las, struct device *parent)
+					 u8 available_las)
  {
  	struct cec_adapter *adap;
  	int res;

-	if (WARN_ON(!parent))
-		return ERR_PTR(-EINVAL);
  	if (WARN_ON(!caps))
  		return ERR_PTR(-EINVAL);
  	if (WARN_ON(!ops))
@@ -214,8 +211,6 @@ struct cec_adapter *cec_allocate_adapter(const 
struct cec_adap_ops *ops,
  	adap = kzalloc(sizeof(*adap), GFP_KERNEL);
  	if (!adap)
  		return ERR_PTR(-ENOMEM);
-	adap->owner = parent->driver->owner;
-	adap->devnode.parent = parent;
  	strlcpy(adap->name, name, sizeof(adap->name));
  	adap->phys_addr = CEC_PHYS_ADDR_INVALID;
  	adap->log_addrs.cec_version = CEC_OP_CEC_VERSION_2_0;
@@ -264,7 +259,6 @@ struct cec_adapter *cec_allocate_adapter(const 
struct cec_adap_ops *ops,
  	adap->rc->input_id.vendor = 0;
  	adap->rc->input_id.product = 0;
  	adap->rc->input_id.version = 1;
-	adap->rc->dev.parent = parent;
  	adap->rc->driver_type = RC_DRIVER_SCANCODE;
  	adap->rc->driver_name = CEC_NAME;
  	adap->rc->allowed_protocols = RC_BIT_CEC;
@@ -278,14 +272,22 @@ struct cec_adapter *cec_allocate_adapter(const 
struct cec_adap_ops *ops,
  }
  EXPORT_SYMBOL_GPL(cec_allocate_adapter);

-int cec_register_adapter(struct cec_adapter *adap)
+int cec_register_adapter(struct cec_adapter *adap,
+			 struct device *parent)
  {
  	int res;

  	if (IS_ERR_OR_NULL(adap))
  		return 0;

+	if (WARN_ON(!parent))
+		return -EINVAL;
+
+	adap->owner = parent->driver->owner;
+	adap->devnode.dev.parent = parent;
+
  #if IS_REACHABLE(CONFIG_RC_CORE)
+	adap->rc->dev.parent = parent;
  	if (adap->capabilities & CEC_CAP_RC) {
  		res = rc_register_device(adap->rc);

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 5ba0f21..8c9e289 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -1732,9 +1732,10 @@ static bool adv7511_check_edid_status(struct 
v4l2_subdev *sd)
  static int adv7511_registered(struct v4l2_subdev *sd)
  {
  	struct adv7511_state *state = get_adv7511_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
  	int err;

-	err = cec_register_adapter(state->cec_adap);
+	err = cec_register_adapter(state->cec_adap, &client->dev);
  	if (err)
  		cec_delete_adapter(state->cec_adap);
  	return err;
@@ -1928,7 +1929,7 @@ static int adv7511_probe(struct i2c_client 
*client, const struct i2c_device_id *
  	state->cec_adap = cec_allocate_adapter(&adv7511_cec_adap_ops,
  		state, dev_name(&client->dev), CEC_CAP_TRANSMIT |
  		CEC_CAP_LOG_ADDRS | CEC_CAP_PASSTHROUGH | CEC_CAP_RC,
-		ADV7511_MAX_ADDRS, &client->dev);
+		ADV7511_MAX_ADDRS);
  	err = PTR_ERR_OR_ZERO(state->cec_adap);
  	if (err) {
  		destroy_workqueue(state->work_queue);
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 5630eb2..d0375ca 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2631,9 +2631,10 @@ static int adv76xx_subscribe_event(struct 
v4l2_subdev *sd,
  static int adv76xx_registered(struct v4l2_subdev *sd)
  {
  	struct adv76xx_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
  	int err;

-	err = cec_register_adapter(state->cec_adap);
+	err = cec_register_adapter(state->cec_adap, &client->dev);
  	if (err)
  		cec_delete_adapter(state->cec_adap);
  	return err;
@@ -3511,8 +3512,7 @@ static int adv76xx_probe(struct i2c_client *client,
  	state->cec_adap = cec_allocate_adapter(&adv76xx_cec_adap_ops,
  		state, dev_name(&client->dev),
  		CEC_CAP_TRANSMIT | CEC_CAP_LOG_ADDRS |
-		CEC_CAP_PASSTHROUGH | CEC_CAP_RC, ADV76XX_MAX_ADDRS,
-		&client->dev);
+		CEC_CAP_PASSTHROUGH | CEC_CAP_RC, ADV76XX_MAX_ADDRS);
  	err = PTR_ERR_OR_ZERO(state->cec_adap);
  	if (err)
  		goto err_entity;
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 8c2a52e..2d61f0c 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -3250,9 +3250,10 @@ static int adv7842_subscribe_event(struct 
v4l2_subdev *sd,
  static int adv7842_registered(struct v4l2_subdev *sd)
  {
  	struct adv7842_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
  	int err;

-	err = cec_register_adapter(state->cec_adap);
+	err = cec_register_adapter(state->cec_adap, &client->dev);
  	if (err)
  		cec_delete_adapter(state->cec_adap);
  	return err;
@@ -3568,8 +3569,7 @@ static int adv7842_probe(struct i2c_client *client,
  	state->cec_adap = cec_allocate_adapter(&adv7842_cec_adap_ops,
  		state, dev_name(&client->dev),
  		CEC_CAP_TRANSMIT | CEC_CAP_LOG_ADDRS |
-		CEC_CAP_PASSTHROUGH | CEC_CAP_RC, ADV7842_MAX_ADDRS,
-		&client->dev);
+		CEC_CAP_PASSTHROUGH | CEC_CAP_RC, ADV7842_MAX_ADDRS);
  	err = PTR_ERR_OR_ZERO(state->cec_adap);
  	if (err)
  		goto err_entity;
diff --git a/drivers/media/platform/vivid/vivid-cec.c 
b/drivers/media/platform/vivid/vivid-cec.c
index f9f878b..cb49335 100644
--- a/drivers/media/platform/vivid/vivid-cec.c
+++ b/drivers/media/platform/vivid/vivid-cec.c
@@ -216,7 +216,6 @@ static const struct cec_adap_ops vivid_cec_adap_ops = {

  struct cec_adapter *vivid_cec_alloc_adap(struct vivid_dev *dev,
  					 unsigned int idx,
-					 struct device *parent,
  					 bool is_source)
  {
  	char name[sizeof(dev->vid_out_dev.name) + 2];
@@ -227,5 +226,5 @@ struct cec_adapter *vivid_cec_alloc_adap(struct 
vivid_dev *dev,
  		 is_source ? dev->vid_out_dev.name : dev->vid_cap_dev.name,
  		 idx);
  	return cec_allocate_adapter(&vivid_cec_adap_ops, dev,
-		name, caps, 1, parent);
+		name, caps, 1);
  }
diff --git a/drivers/media/platform/vivid/vivid-cec.h 
b/drivers/media/platform/vivid/vivid-cec.h
index 97892af..3926b14 100644
--- a/drivers/media/platform/vivid/vivid-cec.h
+++ b/drivers/media/platform/vivid/vivid-cec.h
@@ -20,7 +20,6 @@
  #ifdef CONFIG_VIDEO_VIVID_CEC
  struct cec_adapter *vivid_cec_alloc_adap(struct vivid_dev *dev,
  					 unsigned int idx,
-					 struct device *parent,
  					 bool is_source);
  void vivid_cec_bus_free_work(struct vivid_dev *dev);

diff --git a/drivers/media/platform/vivid/vivid-core.c 
b/drivers/media/platform/vivid/vivid-core.c
index 5464fef..6e35321 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -1167,12 +1167,12 @@ static int vivid_create_instance(struct 
platform_device *pdev, int inst)
  		if (in_type_counter[HDMI]) {
  			struct cec_adapter *adap;

-			adap = vivid_cec_alloc_adap(dev, 0, &pdev->dev, false);
+			adap = vivid_cec_alloc_adap(dev, 0, false);
  			ret = PTR_ERR_OR_ZERO(adap);
  			if (ret < 0)
  				goto unreg_dev;
  			dev->cec_rx_adap = adap;
-			ret = cec_register_adapter(adap);
+			ret = cec_register_adapter(adap, &pdev->dev);
  			if (ret < 0) {
  				cec_delete_adapter(adap);
  				dev->cec_rx_adap = NULL;
@@ -1222,13 +1222,12 @@ static int vivid_create_instance(struct 
platform_device *pdev, int inst)
  			if (dev->output_type[i] != HDMI)
  				continue;
  			dev->cec_output2bus_map[i] = bus_cnt;
-			adap = vivid_cec_alloc_adap(dev, bus_cnt,
-						     &pdev->dev, true);
+			adap = vivid_cec_alloc_adap(dev, bus_cnt, true);
  			ret = PTR_ERR_OR_ZERO(adap);
  			if (ret < 0)
  				goto unreg_dev;
  			dev->cec_tx_adap[bus_cnt] = adap;
-			ret = cec_register_adapter(adap);
+			ret = cec_register_adapter(adap, &pdev->dev);
  			if (ret < 0) {
  				cec_delete_adapter(adap);
  				dev->cec_tx_adap[bus_cnt] = NULL;
diff --git a/drivers/media/usb/pulse8-cec/pulse8-cec.c 
b/drivers/media/usb/pulse8-cec/pulse8-cec.c
index 9092494..7c18dae 100644
--- a/drivers/media/usb/pulse8-cec/pulse8-cec.c
+++ b/drivers/media/usb/pulse8-cec/pulse8-cec.c
@@ -659,7 +659,7 @@ static int pulse8_connect(struct serio *serio, 
struct serio_driver *drv)

  	pulse8->serio = serio;
  	pulse8->adap = cec_allocate_adapter(&pulse8_cec_adap_ops, pulse8,
-		"HDMI CEC", caps, 1, &serio->dev);
+		"HDMI CEC", caps, 1);
  	err = PTR_ERR_OR_ZERO(pulse8->adap);
  	if (err < 0)
  		goto free_device;
@@ -679,7 +679,7 @@ static int pulse8_connect(struct serio *serio, 
struct serio_driver *drv)
  	if (err)
  		goto close_serio;

-	err = cec_register_adapter(pulse8->adap);
+	err = cec_register_adapter(pulse8->adap, &serio->dev);
  	if (err < 0)
  		goto close_serio;

diff --git a/drivers/staging/media/s5p-cec/s5p_cec.c 
b/drivers/staging/media/s5p-cec/s5p_cec.c
index 33e4358..2a07968 100644
--- a/drivers/staging/media/s5p-cec/s5p_cec.c
+++ b/drivers/staging/media/s5p-cec/s5p_cec.c
@@ -203,12 +203,11 @@ static int s5p_cec_probe(struct platform_device *pdev)
  	cec->adap = cec_allocate_adapter(&s5p_cec_adap_ops, cec,
  		CEC_NAME,
  		CEC_CAP_PHYS_ADDR | CEC_CAP_LOG_ADDRS | CEC_CAP_TRANSMIT |
-		CEC_CAP_PASSTHROUGH | CEC_CAP_RC,
-		1, &pdev->dev);
+		CEC_CAP_PASSTHROUGH | CEC_CAP_RC, 1);
  	ret = PTR_ERR_OR_ZERO(cec->adap);
  	if (ret)
  		return ret;
-	ret = cec_register_adapter(cec->adap);
+	ret = cec_register_adapter(cec->adap, &pdev->dev);
  	if (ret) {
  		cec_delete_adapter(cec->adap);
  		return ret;
diff --git a/drivers/staging/media/st-cec/stih-cec.c 
b/drivers/staging/media/st-cec/stih-cec.c
index eed1fd6..3c25638 100644
--- a/drivers/staging/media/st-cec/stih-cec.c
+++ b/drivers/staging/media/st-cec/stih-cec.c
@@ -335,13 +335,12 @@ static int stih_cec_probe(struct platform_device 
*pdev)
  	cec->adap = cec_allocate_adapter(&sti_cec_adap_ops, cec,
  			CEC_NAME,
  			CEC_CAP_LOG_ADDRS | CEC_CAP_PASSTHROUGH |
-			CEC_CAP_PHYS_ADDR | CEC_CAP_TRANSMIT,
-			1, &pdev->dev);
+			CEC_CAP_PHYS_ADDR | CEC_CAP_TRANSMIT, 1);
  	ret = PTR_ERR_OR_ZERO(cec->adap);
  	if (ret)
  		return ret;

-	ret = cec_register_adapter(cec->adap);
+	ret = cec_register_adapter(cec->adap, &pdev->dev);
  	if (ret) {
  		cec_delete_adapter(cec->adap);
  		return ret;
diff --git a/include/media/cec.h b/include/media/cec.h
index 717eaf5..96a0aa7 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -35,7 +35,6 @@
   * struct cec_devnode - cec device node
   * @dev:	cec device
   * @cdev:	cec character device
- * @parent:	parent device
   * @minor:	device node minor number
   * @registered:	the device was correctly registered
   * @unregistered: the device was unregistered
@@ -51,7 +50,6 @@ struct cec_devnode {
  	/* sysfs */
  	struct device dev;
  	struct cdev cdev;
-	struct device *parent;

  	/* device info */
  	int minor;
@@ -198,9 +196,8 @@ static inline bool cec_is_sink(const struct 
cec_adapter *adap)

  #if IS_ENABLED(CONFIG_MEDIA_CEC_SUPPORT)
  struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
-		void *priv, const char *name, u32 caps, u8 available_las,
-		struct device *parent);
-int cec_register_adapter(struct cec_adapter *adap);
+		void *priv, const char *name, u32 caps, u8 available_las);
+int cec_register_adapter(struct cec_adapter *adap, struct device *parent);
  void cec_unregister_adapter(struct cec_adapter *adap);
  void cec_delete_adapter(struct cec_adapter *adap);

@@ -218,7 +215,8 @@ void cec_received_msg(struct cec_adapter *adap, 
struct cec_msg *msg);

  #else

-static inline int cec_register_adapter(struct cec_adapter *adap)
+static inline int cec_register_adapter(struct cec_adapter *adap,
+				       struct device *parent)
  {
  	return 0;
  }
