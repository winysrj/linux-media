Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:65358 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab1HDHO3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 03:14:29 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 15/21] [staging] tm6000: Execute lightweight reset on close.
Date: Thu,  4 Aug 2011 09:14:13 +0200
Message-Id: <1312442059-23935-16-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the last user closes the device, perform a lightweight reset of the
device to bring it into a well-known state.

Note that this is not always enough with the TM6010, which sometimes
needs a hard reset to get into a working state again.
---
 drivers/staging/tm6000/tm6000-core.c  |   43 +++++++++++++++++++++++++++++++++
 drivers/staging/tm6000/tm6000-video.c |    8 +++++-
 drivers/staging/tm6000/tm6000.h       |    1 +
 3 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 317ab7e..58c1399 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -597,6 +597,49 @@ int tm6000_init(struct tm6000_core *dev)
 	return rc;
 }
 
+int tm6000_reset(struct tm6000_core *dev)
+{
+	int pipe;
+	int err;
+
+	msleep(500);
+
+	err = usb_set_interface(dev->udev, dev->isoc_in.bInterfaceNumber, 0);
+	if (err < 0) {
+		tm6000_err("failed to select interface %d, alt. setting 0\n",
+				dev->isoc_in.bInterfaceNumber);
+		return err;
+	}
+
+	err = usb_reset_configuration(dev->udev);
+	if (err < 0) {
+		tm6000_err("failed to reset configuration\n");
+		return err;
+	}
+
+	msleep(5);
+
+	err = usb_set_interface(dev->udev, dev->isoc_in.bInterfaceNumber, 2);
+	if (err < 0) {
+		tm6000_err("failed to select interface %d, alt. setting 2\n",
+				dev->isoc_in.bInterfaceNumber);
+		return err;
+	}
+
+	msleep(5);
+
+	pipe = usb_rcvintpipe(dev->udev,
+			dev->int_in.endp->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
+
+	err = usb_clear_halt(dev->udev, pipe);
+	if (err < 0) {
+		tm6000_err("usb_clear_halt failed: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
 int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate)
 {
 	int val = 0;
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index 492ec73..70fc19e 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -1503,7 +1503,6 @@ static int tm6000_open(struct file *file)
 	tm6000_get_std_res(dev);
 
 	file->private_data = fh;
-	fh->vdev = vdev;
 	fh->dev = dev;
 	fh->radio = radio;
 	fh->type = type;
@@ -1606,9 +1605,16 @@ static int tm6000_release(struct file *file)
 	dev->users--;
 
 	res_free(dev, fh);
+
 	if (!dev->users) {
+		int err;
+
 		tm6000_uninit_isoc(dev);
 		videobuf_mmap_free(&fh->vb_vidq);
+
+		err = tm6000_reset(dev);
+		if (err < 0)
+			dev_err(&vdev->dev, "reset failed: %d\n", err);
 	}
 
 	kfree(fh);
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index cf57e1e..dac2063 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -311,6 +311,7 @@ int tm6000_set_reg_mask(struct tm6000_core *dev, u8 req, u16 value,
 						u16 index, u16 mask);
 int tm6000_i2c_reset(struct tm6000_core *dev, u16 tsleep);
 int tm6000_init(struct tm6000_core *dev);
+int tm6000_reset(struct tm6000_core *dev);
 
 int tm6000_init_analog_mode(struct tm6000_core *dev);
 int tm6000_init_digital_mode(struct tm6000_core *dev);
-- 
1.7.6

