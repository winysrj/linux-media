Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:45517 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741AbZIMDWy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 23:22:54 -0400
Received: by qw-out-2122.google.com with SMTP id 9so721299qwb.37
        for <linux-media@vger.kernel.org>; Sat, 12 Sep 2009 20:22:57 -0700 (PDT)
Message-ID: <4AAC6587.7090309@gmail.com>
Date: Sat, 12 Sep 2009 23:22:47 -0400
From: David Ellingsworth <david@identd.dyndns.org>
Reply-To: david@identd.dyndns.org
MIME-Version: 1.0
To: linux-media@vger.kernel.org, klimov.linux@gmail.com
Subject: [RFC/RFT 10/14] radio-mr800: ensure the radio is initialized to a
 consistent state
Content-Type: multipart/mixed;
 boundary="------------020308040907000603080008"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020308040907000603080008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

 From 8c441616f67011244cb15bc1a3dda6fd8706ecd2 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 16:04:44 -0400
Subject: [PATCH 08/14] mr800: fix potential use after free

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c 
b/drivers/media/radio/radio-mr800.c
index 9fd2342..87b58e3 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -274,7 +274,6 @@ static void usb_amradio_disconnect(struct 
usb_interface *intf)
 
     usb_set_intfdata(intf, NULL);
     video_unregister_device(&radio->videodev);
-    v4l2_device_disconnect(&radio->v4l2_dev);
 }
 
 /* vidioc_querycap - query device capabilities */
-- 
1.6.3.3


--------------020308040907000603080008
Content-Type: text/x-diff;
 name="0010-mr800-ensure-the-radio-is-initialized-to-a.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0010-mr800-ensure-the-radio-is-initialized-to-a.patch"

>From 8b5f17aeea6cf394bedd6f9029a57b85555f5815 Mon Sep 17 00:00:00 2001
From: David Ellingsworth <david@identd.dyndns.org>
Date: Sat, 12 Sep 2009 21:59:07 -0400
Subject: [PATCH 10/14] mr800: ensure the radio is initialized to a
 consistent state

Signed-off-by: David Ellingsworth <david@identd.dyndns.org>
---
 drivers/media/radio/radio-mr800.c |   34 ++++++++++++++++++++++++++++++++--
 1 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index df020e8..dbf0dbb 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -85,6 +85,9 @@ MODULE_LICENSE("GPL");
 #define amradio_dev_warn(dev, fmt, arg...)				\
 		dev_warn(dev, MR800_DRIVER_NAME " - " fmt, ##arg)
 
+#define amradio_dev_err(dev, fmt, arg...) \
+		dev_err(dev, MR800_DRIVER_NAME " - " fmt, ##arg)
+
 /* Probably USB_TIMEOUT should be modified in module parameter */
 #define BUFFER_LENGTH 8
 #define USB_TIMEOUT 500
@@ -137,6 +140,7 @@ struct amradio_device {
 	int curfreq;
 	int stereo;
 	int muted;
+	int initialized;
 };
 
 #define vdev_to_amradio(r) container_of(r, struct amradio_device, videodev)
@@ -477,6 +481,31 @@ static int vidioc_s_input(struct file *filp, void *priv, unsigned int i)
 	return 0;
 }
 
+static int usb_amradio_init(struct amradio_device *radio)
+{
+	int retval;
+
+	retval = amradio_set_mute(radio, AMRADIO_STOP);
+	if (retval < 0) {
+		amradio_dev_warn(&radio->videodev.dev, "amradio_stop failed\n");
+		goto out_err;
+	}
+
+	retval = amradio_set_stereo(radio, WANT_STEREO);
+	if (retval < 0) {
+		amradio_dev_warn(&radio->videodev.dev, "set stereo failed\n");
+		goto out_err;
+	}
+
+	radio->initialized = 1;
+	goto out;
+
+out_err:
+	amradio_dev_err(&radio->videodev.dev, "initialization failed\n");
+out:
+	return retval;
+}
+
 /* open device - amradio_start() and amradio_setfreq() */
 static int usb_amradio_open(struct file *file)
 {
@@ -492,6 +521,9 @@ static int usb_amradio_open(struct file *file)
 
 	file->private_data = radio;
 
+	if (unlikely(!radio->initialized))
+		retval = usb_amradio_init(radio);
+
 unlock:
 	mutex_unlock(&radio->lock);
 	return retval;
@@ -640,8 +672,6 @@ static int usb_amradio_probe(struct usb_interface *intf,
 
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->curfreq = 95.16 * FREQ_MUL;
-	radio->stereo = -1;
-	radio->muted = 1;
 
 	mutex_init(&radio->lock);
 
-- 
1.6.3.3


--------------020308040907000603080008--
