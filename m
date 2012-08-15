Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50117 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab2HOCVz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 22:21:55 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/6] dvb_frontend: implement suspend / resume
Date: Wed, 15 Aug 2012 05:21:06 +0300
Message-Id: <1344997269-20338-4-git-send-email-crope@iki.fi>
In-Reply-To: <1344997269-20338-1-git-send-email-crope@iki.fi>
References: <1344997269-20338-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move initial suspend / resume support from dvb_usb_v2 to dvb_frontend
as it is dvb general feature that could be used all dvb devices.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-core/dvb_frontend.c       | 47 ++++++++++++++++----
 drivers/media/dvb-core/dvb_frontend.h       |  3 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb.h      |  3 ++
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 66 ++++++++++-------------------
 4 files changed, 66 insertions(+), 53 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 5fb19ea..aa4d4d8 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -307,15 +307,6 @@ void dvb_frontend_reinitialise(struct dvb_frontend *fe)
 }
 EXPORT_SYMBOL(dvb_frontend_reinitialise);
 
-void dvb_frontend_retune(struct dvb_frontend *fe)
-{
-	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-
-	fepriv->state = FESTATE_RETUNE;
-	dvb_frontend_wakeup(fe);
-}
-EXPORT_SYMBOL(dvb_frontend_retune);
-
 static void dvb_frontend_swzigzag_update_delay(struct dvb_frontend_private *fepriv, int locked)
 {
 	int q2;
@@ -2448,6 +2439,44 @@ static const struct file_operations dvb_frontend_fops = {
 	.llseek		= noop_llseek,
 };
 
+int dvb_frontend_suspend(struct dvb_frontend *fe)
+{
+	int ret = 0;
+
+	dev_dbg(fe->dvb->device, "%s: adap=%d fe=%d\n", __func__, fe->dvb->num,
+			fe->id);
+
+	if (fe->ops.tuner_ops.sleep)
+		ret = fe->ops.tuner_ops.sleep(fe);
+
+	if (fe->ops.sleep)
+		ret = fe->ops.sleep(fe);
+
+	return ret;
+}
+EXPORT_SYMBOL(dvb_frontend_suspend);
+
+int dvb_frontend_resume(struct dvb_frontend *fe)
+{
+	struct dvb_frontend_private *fepriv = fe->frontend_priv;
+	int ret = 0;
+
+	dev_dbg(fe->dvb->device, "%s: adap=%d fe=%d\n", __func__, fe->dvb->num,
+			fe->id);
+
+	if (fe->ops.init)
+		ret = fe->ops.init(fe);
+
+	if (fe->ops.tuner_ops.init)
+		ret = fe->ops.tuner_ops.init(fe);
+
+	fepriv->state = FESTATE_RETUNE;
+	dvb_frontend_wakeup(fe);
+
+	return ret;
+}
+EXPORT_SYMBOL(dvb_frontend_resume);
+
 int dvb_register_frontend(struct dvb_adapter* dvb,
 			  struct dvb_frontend* fe)
 {
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 58f6b4c..db309db 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -418,7 +418,8 @@ extern int dvb_unregister_frontend(struct dvb_frontend *fe);
 extern void dvb_frontend_detach(struct dvb_frontend *fe);
 
 extern void dvb_frontend_reinitialise(struct dvb_frontend *fe);
-extern void dvb_frontend_retune(struct dvb_frontend *fe);
+extern int dvb_frontend_suspend(struct dvb_frontend *fe);
+extern int dvb_frontend_resume(struct dvb_frontend *fe);
 
 extern void dvb_frontend_sleep_until(struct timeval *waketime, u32 add_usec);
 extern s32 timeval_usec_diff(struct timeval lasttime, struct timeval curtime);
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
index 79b3b8b..63fc275 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
@@ -295,6 +295,7 @@ struct usb_data_stream {
  * @stream: adapter the usb data stream
  * @id: index of this adapter (starting with 0)
  * @ts_type: transport stream, input stream, type
+ * @suspend_resume_active: set when there is ongoing suspend / resume
  * @pid_filtering: is hardware pid_filtering used or not
  * @feed_count: current feed count
  * @max_feed_count: maimum feed count device can handle
@@ -312,6 +313,7 @@ struct dvb_usb_adapter {
 	struct usb_data_stream stream;
 	u8 id;
 	u8 ts_type;
+	bool suspend_resume_active;
 	bool pid_filtering;
 	u8 feed_count;
 	u8 max_feed_count;
@@ -381,6 +383,7 @@ extern int dvb_usbv2_probe(struct usb_interface *,
 extern void dvb_usbv2_disconnect(struct usb_interface *);
 extern int dvb_usbv2_suspend(struct usb_interface *, pm_message_t);
 extern int dvb_usbv2_resume(struct usb_interface *);
+#define dvb_usbv2_reset_resume dvb_usbv2_resume
 
 /* the generic read/write method for device control */
 extern int dvb_usbv2_generic_rw(struct dvb_usb_device *, u8 *, u16, u8 *, u16);
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 7ce8ffe..a0e70e9 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -489,6 +489,11 @@ static int dvb_usb_fe_init(struct dvb_frontend *fe)
 	dev_dbg(&d->udev->dev, "%s: adap=%d fe=%d\n", __func__, adap->id,
 			fe->id);
 
+	if (!adap->suspend_resume_active) {
+		adap->active_fe = fe->id;
+		mutex_lock(&adap->sync_mutex);
+	}
+
 	ret = dvb_usbv2_device_power_ctrl(d, 1);
 	if (ret < 0)
 		goto err;
@@ -504,23 +509,11 @@ static int dvb_usb_fe_init(struct dvb_frontend *fe)
 		if (ret < 0)
 			goto err;
 	}
-
-	return 0;
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
-	return ret;
-}
-
-static int dvb_usb_fe_init_lock(struct dvb_frontend *fe)
-{
-	int ret;
-	struct dvb_usb_adapter *adap = fe->dvb->priv;
-	mutex_lock(&adap->sync_mutex);
-
-	ret = dvb_usb_fe_init(fe);
-	adap->active_fe = fe->id;
+	if (!adap->suspend_resume_active)
+		mutex_unlock(&adap->sync_mutex);
 
-	mutex_unlock(&adap->sync_mutex);
+	dev_dbg(&d->udev->dev, "%s: ret=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -532,6 +525,9 @@ static int dvb_usb_fe_sleep(struct dvb_frontend *fe)
 	dev_dbg(&d->udev->dev, "%s: adap=%d fe=%d\n", __func__, adap->id,
 			fe->id);
 
+	if (!adap->suspend_resume_active)
+		mutex_lock(&adap->sync_mutex);
+
 	if (adap->fe_sleep[fe->id]) {
 		ret = adap->fe_sleep[fe->id](fe);
 		if (ret < 0)
@@ -547,23 +543,13 @@ static int dvb_usb_fe_sleep(struct dvb_frontend *fe)
 	ret = dvb_usbv2_device_power_ctrl(d, 0);
 	if (ret < 0)
 		goto err;
-
-	return 0;
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
-	return ret;
-}
-
-static int dvb_usb_fe_sleep_lock(struct dvb_frontend *fe)
-{
-	int ret;
-	struct dvb_usb_adapter *adap = fe->dvb->priv;
-	mutex_lock(&adap->sync_mutex);
-
-	ret = dvb_usb_fe_sleep(fe);
-	adap->active_fe = -1;
+	if (!adap->suspend_resume_active) {
+		adap->active_fe = -1;
+		mutex_unlock(&adap->sync_mutex);
+	}
 
-	mutex_unlock(&adap->sync_mutex);
+	dev_dbg(&d->udev->dev, "%s: ret=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -594,9 +580,9 @@ int dvb_usbv2_adapter_frontend_init(struct dvb_usb_adapter *adap)
 		adap->fe[i]->id = i;
 		/* re-assign sleep and wakeup functions */
 		adap->fe_init[i] = adap->fe[i]->ops.init;
-		adap->fe[i]->ops.init = dvb_usb_fe_init_lock;
+		adap->fe[i]->ops.init = dvb_usb_fe_init;
 		adap->fe_sleep[i] = adap->fe[i]->ops.sleep;
-		adap->fe[i]->ops.sleep = dvb_usb_fe_sleep_lock;
+		adap->fe[i]->ops.sleep = dvb_usb_fe_sleep;
 
 		ret = dvb_register_frontend(&adap->dvb_adap, adap->fe[i]);
 		if (ret < 0) {
@@ -978,6 +964,7 @@ int dvb_usbv2_suspend(struct usb_interface *intf, pm_message_t msg)
 		active_fe = d->adapter[i].active_fe;
 		if (d->adapter[i].dvb_adap.priv && active_fe != -1) {
 			fe = d->adapter[i].fe[active_fe];
+			d->adapter[i].suspend_resume_active = true;
 
 			if (d->props->streaming_ctrl)
 				d->props->streaming_ctrl(fe, 0);
@@ -985,10 +972,7 @@ int dvb_usbv2_suspend(struct usb_interface *intf, pm_message_t msg)
 			/* stop usb streaming */
 			usb_urb_killv2(&d->adapter[i].stream);
 
-			if (fe->ops.tuner_ops.sleep)
-				fe->ops.tuner_ops.sleep(fe);
-
-			dvb_usb_fe_sleep(fe);
+			dvb_frontend_suspend(fe);
 		}
 	}
 
@@ -1008,19 +992,15 @@ int dvb_usbv2_resume(struct usb_interface *intf)
 		if (d->adapter[i].dvb_adap.priv && active_fe != -1) {
 			fe = d->adapter[i].fe[active_fe];
 
-			dvb_usb_fe_init(fe);
-
-			if (fe->ops.tuner_ops.init)
-				fe->ops.tuner_ops.init(fe);
-
-			/* acquire dvb-core perform retune */
-			dvb_frontend_retune(fe);
+			dvb_frontend_resume(fe);
 
 			/* resume usb streaming */
 			usb_urb_submitv2(&d->adapter[i].stream, NULL);
 
 			if (d->props->streaming_ctrl)
 				d->props->streaming_ctrl(fe, 1);
+
+			d->adapter[i].suspend_resume_active = false;
 		}
 	}
 
-- 
1.7.11.2

