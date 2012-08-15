Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44145 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab2HOCVx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 22:21:53 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/6] dvb_usb_v2: implement power-management for suspend
Date: Wed, 15 Aug 2012 05:21:05 +0300
Message-Id: <1344997269-20338-3-git-send-email-crope@iki.fi>
In-Reply-To: <1344997269-20338-1-git-send-email-crope@iki.fi>
References: <1344997269-20338-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Put device full sleep on suspend, wake-up it on resume and acquire
retune in order to return same television channel.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 83 ++++++++++++++++++++++-------
 1 file changed, 63 insertions(+), 20 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index a72f9c7..7ce8ffe 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -486,7 +486,6 @@ static int dvb_usb_fe_init(struct dvb_frontend *fe)
 	int ret;
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
 	struct dvb_usb_device *d = adap_to_d(adap);
-	mutex_lock(&adap->sync_mutex);
 	dev_dbg(&d->udev->dev, "%s: adap=%d fe=%d\n", __func__, adap->id,
 			fe->id);
 
@@ -506,22 +505,30 @@ static int dvb_usb_fe_init(struct dvb_frontend *fe)
 			goto err;
 	}
 
-	adap->active_fe = fe->id;
-	mutex_unlock(&adap->sync_mutex);
-
 	return 0;
 err:
-	mutex_unlock(&adap->sync_mutex);
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
+static int dvb_usb_fe_init_lock(struct dvb_frontend *fe)
+{
+	int ret;
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	mutex_lock(&adap->sync_mutex);
+
+	ret = dvb_usb_fe_init(fe);
+	adap->active_fe = fe->id;
+
+	mutex_unlock(&adap->sync_mutex);
+	return ret;
+}
+
 static int dvb_usb_fe_sleep(struct dvb_frontend *fe)
 {
 	int ret;
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
 	struct dvb_usb_device *d = adap_to_d(adap);
-	mutex_lock(&adap->sync_mutex);
 	dev_dbg(&d->udev->dev, "%s: adap=%d fe=%d\n", __func__, adap->id,
 			fe->id);
 
@@ -541,16 +548,25 @@ static int dvb_usb_fe_sleep(struct dvb_frontend *fe)
 	if (ret < 0)
 		goto err;
 
-	adap->active_fe = -1;
-	mutex_unlock(&adap->sync_mutex);
-
 	return 0;
 err:
-	mutex_unlock(&adap->sync_mutex);
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
+static int dvb_usb_fe_sleep_lock(struct dvb_frontend *fe)
+{
+	int ret;
+	struct dvb_usb_adapter *adap = fe->dvb->priv;
+	mutex_lock(&adap->sync_mutex);
+
+	ret = dvb_usb_fe_sleep(fe);
+	adap->active_fe = -1;
+
+	mutex_unlock(&adap->sync_mutex);
+	return ret;
+}
+
 int dvb_usbv2_adapter_frontend_init(struct dvb_usb_adapter *adap)
 {
 	int ret, i, count_registered = 0;
@@ -578,9 +594,9 @@ int dvb_usbv2_adapter_frontend_init(struct dvb_usb_adapter *adap)
 		adap->fe[i]->id = i;
 		/* re-assign sleep and wakeup functions */
 		adap->fe_init[i] = adap->fe[i]->ops.init;
-		adap->fe[i]->ops.init = dvb_usb_fe_init;
+		adap->fe[i]->ops.init = dvb_usb_fe_init_lock;
 		adap->fe_sleep[i] = adap->fe[i]->ops.sleep;
-		adap->fe[i]->ops.sleep = dvb_usb_fe_sleep;
+		adap->fe[i]->ops.sleep = dvb_usb_fe_sleep_lock;
 
 		ret = dvb_register_frontend(&adap->dvb_adap, adap->fe[i]);
 		if (ret < 0) {
@@ -950,18 +966,30 @@ EXPORT_SYMBOL(dvb_usbv2_disconnect);
 int dvb_usbv2_suspend(struct usb_interface *intf, pm_message_t msg)
 {
 	struct dvb_usb_device *d = usb_get_intfdata(intf);
-	int i;
+	int i, active_fe;
+	struct dvb_frontend *fe;
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	/* stop remote controller poll */
 	if (d->rc.query && !d->rc.bulk_mode)
 		cancel_delayed_work_sync(&d->rc_query_work);
 
-	/* stop streaming */
 	for (i = MAX_NO_OF_ADAPTER_PER_DEVICE - 1; i >= 0; i--) {
-		if (d->adapter[i].dvb_adap.priv &&
-				d->adapter[i].active_fe != -1)
+		active_fe = d->adapter[i].active_fe;
+		if (d->adapter[i].dvb_adap.priv && active_fe != -1) {
+			fe = d->adapter[i].fe[active_fe];
+
+			if (d->props->streaming_ctrl)
+				d->props->streaming_ctrl(fe, 0);
+
+			/* stop usb streaming */
 			usb_urb_killv2(&d->adapter[i].stream);
+
+			if (fe->ops.tuner_ops.sleep)
+				fe->ops.tuner_ops.sleep(fe);
+
+			dvb_usb_fe_sleep(fe);
+		}
 	}
 
 	return 0;
@@ -971,14 +999,29 @@ EXPORT_SYMBOL(dvb_usbv2_suspend);
 int dvb_usbv2_resume(struct usb_interface *intf)
 {
 	struct dvb_usb_device *d = usb_get_intfdata(intf);
-	int i;
+	int i, active_fe;
+	struct dvb_frontend *fe;
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
-	/* start streaming */
 	for (i = 0; i < MAX_NO_OF_ADAPTER_PER_DEVICE; i++) {
-		if (d->adapter[i].dvb_adap.priv &&
-				d->adapter[i].active_fe != -1)
+		active_fe = d->adapter[i].active_fe;
+		if (d->adapter[i].dvb_adap.priv && active_fe != -1) {
+			fe = d->adapter[i].fe[active_fe];
+
+			dvb_usb_fe_init(fe);
+
+			if (fe->ops.tuner_ops.init)
+				fe->ops.tuner_ops.init(fe);
+
+			/* acquire dvb-core perform retune */
+			dvb_frontend_retune(fe);
+
+			/* resume usb streaming */
 			usb_urb_submitv2(&d->adapter[i].stream, NULL);
+
+			if (d->props->streaming_ctrl)
+				d->props->streaming_ctrl(fe, 1);
+		}
 	}
 
 	/* start remote controller poll */
-- 
1.7.11.2

