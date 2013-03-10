Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:32967 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab3CJBnq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 20:43:46 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 1/5] dvb_usb_v2: replace Kernel userspace lock with wait queue
Date: Sun, 10 Mar 2013 03:42:31 +0200
Message-Id: <1362879755-4839-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was sync mutex which was held over userspace. That is very
wrong and could cause deadlock if different userspace process is
used to "unlock". Wait queue seems to be correct solution for
that kind of synchronizing issue so use it instead.

lock debug gives following bug report:
================================================
[ BUG: lock held when returning to user space! ]
3.9.0-rc1+ #38 Tainted: G           O
------------------------------------------------
tzap/4614 is leaving the kernel with locks still held!
1 lock held by tzap/4614:

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb.h      |  5 ++-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 53 ++++++++++++++++++++---------
 2 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb.h b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
index 3cac8bd..ac1f145 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb.h
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb.h
@@ -329,13 +329,16 @@ struct dvb_usb_adapter {
 	u8 feed_count;
 	u8 max_feed_count;
 	s8 active_fe;
+#define ADAP_INIT                0
+#define ADAP_SLEEP               1
+#define ADAP_STREAMING           2
+	unsigned long state_bits;
 
 	/* dvb */
 	struct dvb_adapter   dvb_adap;
 	struct dmxdev        dmxdev;
 	struct dvb_demux     demux;
 	struct dvb_net       dvb_net;
-	struct mutex         sync_mutex;
 
 	struct dvb_frontend *fe[MAX_NO_OF_FE_PER_ADAP];
 	int (*fe_init[MAX_NO_OF_FE_PER_ADAP]) (struct dvb_frontend *);
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 0867920..c91da3c 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -253,6 +253,13 @@ static int dvb_usbv2_adapter_stream_exit(struct dvb_usb_adapter *adap)
 	return usb_urb_exitv2(&adap->stream);
 }
 
+static int wait_schedule(void *ptr)
+{
+	schedule();
+
+	return 0;
+}
+
 static inline int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed,
 		int count)
 {
@@ -266,6 +273,9 @@ static inline int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed,
 			dvbdmxfeed->pid, dvbdmxfeed->index,
 			(count == 1) ? "on" : "off");
 
+	wait_on_bit(&adap->state_bits, ADAP_INIT, wait_schedule,
+			TASK_UNINTERRUPTIBLE);
+
 	if (adap->active_fe == -1)
 		return -EINVAL;
 
@@ -283,11 +293,14 @@ static inline int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed,
 						"failed=%d\n", KBUILD_MODNAME,
 						ret);
 				usb_urb_killv2(&adap->stream);
-				goto err_mutex_unlock;
+				goto err_clear_wait;
 			}
 		}
 		usb_urb_killv2(&adap->stream);
-		mutex_unlock(&adap->sync_mutex);
+
+		clear_bit(ADAP_STREAMING, &adap->state_bits);
+		smp_mb__after_clear_bit();
+		wake_up_bit(&adap->state_bits, ADAP_STREAMING);
 	}
 
 	/* activate the pid on the device pid filter */
@@ -303,7 +316,7 @@ static inline int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed,
 	/* start feeding if it is first pid */
 	if (adap->feed_count == 1 && count == 1) {
 		struct usb_data_stream_properties stream_props;
-		mutex_lock(&adap->sync_mutex);
+		set_bit(ADAP_STREAMING, &adap->state_bits);
 		dev_dbg(&d->udev->dev, "%s: start feeding\n", __func__);
 
 		/* resolve input and output streaming paramters */
@@ -314,7 +327,7 @@ static inline int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed,
 					adap->fe[adap->active_fe],
 					&adap->ts_type, &stream_props);
 			if (ret < 0)
-				goto err_mutex_unlock;
+				goto err_clear_wait;
 		} else {
 			stream_props = adap->props->stream;
 		}
@@ -344,7 +357,7 @@ static inline int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed,
 				dev_err(&d->udev->dev, "%s: " \
 						"pid_filter_ctrl() failed=%d\n",
 						KBUILD_MODNAME, ret);
-				goto err_mutex_unlock;
+				goto err_clear_wait;
 			}
 		}
 
@@ -355,14 +368,16 @@ static inline int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed,
 				dev_err(&d->udev->dev, "%s: streaming_ctrl() " \
 						"failed=%d\n", KBUILD_MODNAME,
 						ret);
-				goto err_mutex_unlock;
+				goto err_clear_wait;
 			}
 		}
 	}
 
 	return 0;
-err_mutex_unlock:
-	mutex_unlock(&adap->sync_mutex);
+err_clear_wait:
+	clear_bit(ADAP_STREAMING, &adap->state_bits);
+	smp_mb__after_clear_bit();
+	wake_up_bit(&adap->state_bits, ADAP_STREAMING);
 	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
@@ -435,8 +450,6 @@ static int dvb_usbv2_adapter_dvb_init(struct dvb_usb_adapter *adap)
 		goto err_dvb_net_init;
 	}
 
-	mutex_init(&adap->sync_mutex);
-
 	return 0;
 err_dvb_net_init:
 	dvb_dmxdev_release(&adap->dmxdev);
@@ -500,7 +513,7 @@ static int dvb_usb_fe_init(struct dvb_frontend *fe)
 
 	if (!adap->suspend_resume_active) {
 		adap->active_fe = fe->id;
-		mutex_lock(&adap->sync_mutex);
+		set_bit(ADAP_INIT, &adap->state_bits);
 	}
 
 	ret = dvb_usbv2_device_power_ctrl(d, 1);
@@ -519,8 +532,11 @@ static int dvb_usb_fe_init(struct dvb_frontend *fe)
 			goto err;
 	}
 err:
-	if (!adap->suspend_resume_active)
-		mutex_unlock(&adap->sync_mutex);
+	if (!adap->suspend_resume_active) {
+		clear_bit(ADAP_INIT, &adap->state_bits);
+		smp_mb__after_clear_bit();
+		wake_up_bit(&adap->state_bits, ADAP_INIT);
+	}
 
 	dev_dbg(&d->udev->dev, "%s: ret=%d\n", __func__, ret);
 	return ret;
@@ -534,8 +550,11 @@ static int dvb_usb_fe_sleep(struct dvb_frontend *fe)
 	dev_dbg(&d->udev->dev, "%s: adap=%d fe=%d\n", __func__, adap->id,
 			fe->id);
 
-	if (!adap->suspend_resume_active)
-		mutex_lock(&adap->sync_mutex);
+	if (!adap->suspend_resume_active) {
+		set_bit(ADAP_SLEEP, &adap->state_bits);
+		wait_on_bit(&adap->state_bits, ADAP_STREAMING, wait_schedule,
+				TASK_UNINTERRUPTIBLE);
+	}
 
 	if (adap->fe_sleep[fe->id]) {
 		ret = adap->fe_sleep[fe->id](fe);
@@ -555,7 +574,9 @@ static int dvb_usb_fe_sleep(struct dvb_frontend *fe)
 err:
 	if (!adap->suspend_resume_active) {
 		adap->active_fe = -1;
-		mutex_unlock(&adap->sync_mutex);
+		clear_bit(ADAP_SLEEP, &adap->state_bits);
+		smp_mb__after_clear_bit();
+		wake_up_bit(&adap->state_bits, ADAP_SLEEP);
 	}
 
 	dev_dbg(&d->udev->dev, "%s: ret=%d\n", __func__, ret);
-- 
1.7.11.7

