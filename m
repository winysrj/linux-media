Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:38567 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab2FMW1V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 18:27:21 -0400
Received: by weyu7 with SMTP id u7so816701wey.19
        for <linux-media@vger.kernel.org>; Wed, 13 Jun 2012 15:27:20 -0700 (PDT)
Message-ID: <1339626433.2421.76.camel@Route3278>
Subject: [PATCH] dvb_usb_v2 [RFC] draft use delayed work.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Wed, 13 Jun 2012 23:27:13 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvb_usb_v2 [RFC] use delayed work.

The problem with an ordinary work queue it executes immediately.

changes made
1. Three extra states added DVB_USB_STATE_PROBE, DVB_USB_STATE_COLD
	and DVB_USB_STATE_WARM.
2. Initialise of priv moved to probe this shouldn't really be done in the
	work queue.
3. The initial delay 200ms waits for the probe to clear.
4. State DVB_USB_STATE_PROBE checks for interface to be BOUND then calls the 
	identify_state(possibly extra timeout signals needed if binding fails).
5. The next schedule time now increases to 500ms execution following as before
	with state changing accordingly.
6. DVB_USB_STATE_INIT uses the value of 0x7 so clears the other states.

The work queue then dies forever. However, it could continue on as the remote work.


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/media/dvb/dvb-usb/dvb_usb.h      |   13 ++--
 drivers/media/dvb/dvb-usb/dvb_usb_init.c |  117 ++++++++++++++++--------------
 2 files changed, 69 insertions(+), 61 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb_usb.h b/drivers/media/dvb/dvb-usb/dvb_usb.h
index b443817..cdd3e7f 100644
--- a/drivers/media/dvb/dvb-usb/dvb_usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb_usb.h
@@ -321,14 +321,17 @@ struct dvb_usb_device {
 	const char *rc_map;
 	struct dvb_usb_rc rc;
 	struct usb_device *udev;
-	struct work_struct probe_work;
+	struct delayed_work probe_work;
 	pid_t work_pid;
 	struct usb_interface *intf;
+#define DVB_USB_STATE_PROBE	0x00
+#define DVB_USB_STATE_COLD	0x01
+#define DVB_USB_STATE_WARM	0x03
+#define DVB_USB_STATE_INIT	0x07
+#define DVB_USB_STATE_I2C	0x08
+#define DVB_USB_STATE_DVB	0x10
+#define DVB_USB_STATE_REMOTE	0x20
 
-#define DVB_USB_STATE_INIT        0x000
-#define DVB_USB_STATE_I2C         0x001
-#define DVB_USB_STATE_DVB         0x002
-#define DVB_USB_STATE_REMOTE      0x004
 	int state;
 
 	int powered;
diff --git a/drivers/media/dvb/dvb-usb/dvb_usb_init.c b/drivers/media/dvb/dvb-usb/dvb_usb_init.c
index b2eb8ac..ddb052d 100644
--- a/drivers/media/dvb/dvb-usb/dvb_usb_init.c
+++ b/drivers/media/dvb/dvb-usb/dvb_usb_init.c
@@ -212,7 +212,7 @@ static int dvb_usb_exit(struct dvb_usb_device *d)
 	dvb_usb_adapter_exit(d);
 	dvb_usb_i2c_exit(d);
 	pr_debug("%s: state should be zero now: %x\n", __func__, d->state);
-	d->state = DVB_USB_STATE_INIT;
+	d->state &= ~DVB_USB_STATE_INIT;
 	kfree(d->priv);
 	kfree(d);
 
@@ -291,61 +291,54 @@ err:
  * and return always success here.
  */
 
+#define INIT_WORK_TIMEOUT 200
+#define CONT_WORK_TIMEOUT 500
+
 static void dvb_usbv2_init_work(struct work_struct *work)
 {
 	int ret;
-	struct dvb_usb_device *d =
-			container_of(work, struct dvb_usb_device, probe_work);
-	bool cold = false;
-
-	d->work_pid = current->pid;
-
-	pr_debug("%s: work_pid=%d\n", __func__, d->work_pid);
-
-	if (d->props.size_of_priv) {
-		d->priv = kzalloc(d->props.size_of_priv, GFP_KERNEL);
-		if (!d->priv) {
-			pr_err("%s: kzalloc() failed\n", KBUILD_MODNAME);
-			ret = -ENOMEM;
-			goto err_usb_driver_release_interface;
+	struct dvb_usb_device *d = container_of(work,
+		struct dvb_usb_device, probe_work.work);
+
+	switch (d->state) {
+	case DVB_USB_STATE_PROBE:
+		if (d->intf->condition != USB_INTERFACE_BOUND) {
+			pr_info("Waiting for Interface\n");
+			break;
 		}
-	}
-
-	if (d->props.identify_state) {
-		ret = d->props.identify_state(d);
-		if (ret == 0) {
-			;
-		} else if (ret == COLD) {
-			cold = true;
-			ret = 0;
-		} else {
-			goto err_usb_driver_release_interface;
-		}
-	}
-
-	if (cold) {
+		if (d->props.identify_state) {
+			ret = d->props.identify_state(d);
+			if (ret == 0)
+				d->state |= DVB_USB_STATE_WARM;
+			else if (ret == COLD)
+				d->state |= DVB_USB_STATE_COLD;
+			else
+				goto err_usb_driver_release_interface;
+		} else
+			d->state = DVB_USB_STATE_WARM;
+		break;
+	case DVB_USB_STATE_COLD:
 		pr_info("%s: found a '%s' in cold state\n",
 				KBUILD_MODNAME, d->name);
 		ret = dvb_usb_download_firmware(d);
-		if (ret == 0) {
-			;
-		} else if (ret == RECONNECTS_USB) {
-			ret = 0;
+		if (ret == 0)
+			d->state |= DVB_USB_STATE_WARM;
+		else if (ret == RECONNECTS_USB)
 			goto exit_usb_driver_release_interface;
-		} else {
+		else
 			goto err_usb_driver_release_interface;
-		}
-	}
-
-	pr_info("%s: found a '%s' in warm state\n", KBUILD_MODNAME, d->name);
-
-	ret = dvb_usb_init(d);
-	if (ret < 0)
-		goto err_usb_driver_release_interface;
-
-	pr_info("%s: '%s' successfully initialized and connected\n",
+	case DVB_USB_STATE_WARM:
+		pr_info("%s: found a '%s' in warm state\n",
 			KBUILD_MODNAME, d->name);
-
+		ret = dvb_usb_init(d);
+		if (ret < 0)
+			goto err_usb_driver_release_interface;
+		pr_info("%s: '%s' successfully initialized and connected\n",
+				KBUILD_MODNAME, d->name);
+		return;
+	}
+	schedule_delayed_work(&d->probe_work,
+		msecs_to_jiffies(CONT_WORK_TIMEOUT));
 	return;
 err_usb_driver_release_interface:
 	pr_info("%s: '%s' error while loading driver (%d)\n", KBUILD_MODNAME,
@@ -354,7 +347,7 @@ exit_usb_driver_release_interface:
 	/* it finally calls .disconnect() which frees mem */
 	usb_driver_release_interface(to_usb_driver(d->intf->dev.driver),
 			d->intf);
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	pr_debug("%s: driver released=%d\n", __func__, ret);
 	return;
 }
 
@@ -402,17 +395,32 @@ int dvb_usbv2_probe(struct usb_interface *intf,
 		}
 	}
 
+	if (d->props.size_of_priv) {
+		d->priv = kzalloc(d->props.size_of_priv, GFP_KERNEL);
+		if (!d->priv) {
+			pr_err("%s: kzalloc() failed\n", KBUILD_MODNAME);
+			ret = -ENOMEM;
+			goto err_pfree;
+		}
+	}
+
+	usb_set_intfdata(intf, d);
+
+	INIT_DELAYED_WORK(&d->probe_work, dvb_usbv2_init_work);
+
 	mutex_init(&d->usb_mutex);
 	mutex_init(&d->i2c_mutex);
-	INIT_WORK(&d->probe_work, dvb_usbv2_init_work);
-	usb_set_intfdata(intf, d);
-	ret = schedule_work(&d->probe_work);
+
+	ret = schedule_delayed_work(&d->probe_work,
+		msecs_to_jiffies(INIT_WORK_TIMEOUT));
 	if (ret < 0) {
-		pr_err("%s: schedule_work() failed\n", KBUILD_MODNAME);
+		pr_err("%s: schedule_delayed_work() failed\n", KBUILD_MODNAME);
 		goto err_kfree;
 	}
 
 	return 0;
+err_pfree:
+	kfree(d->priv);
 err_kfree:
 	kfree(d);
 err:
@@ -426,12 +434,9 @@ void dvb_usbv2_disconnect(struct usb_interface *intf)
 	struct dvb_usb_device *d = usb_get_intfdata(intf);
 	const char *name;
 
-	pr_debug("%s: pid=%d work_pid=%d\n", __func__, current->pid,
-			d->work_pid);
-
 	/* ensure initialization work is finished until release resources */
-	if (d->work_pid != current->pid)
-		cancel_work_sync(&d->probe_work);
+	if (d->state < DVB_USB_STATE_INIT)
+		cancel_delayed_work_sync(&d->probe_work);
 
 	if (d->props.disconnect)
 		d->props.disconnect(d);
-- 
1.7.10










