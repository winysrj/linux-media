Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:39536 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab2L0XCg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Dec 2012 18:02:36 -0500
Received: by mail-ee0-f54.google.com with SMTP id c13so5046907eek.41
        for <linux-media@vger.kernel.org>; Thu, 27 Dec 2012 15:02:35 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/6] em28xx: simplify device state tracking
Date: Fri, 28 Dec 2012 00:02:43 +0100
Message-Id: <1356649368-5426-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1356649368-5426-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1356649368-5426-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DEV_INITIALIZED of enum em28xx_dev_state state is used nowhere and there is no
need for DEV_MISCONFIGURED, so remove this enum and use a boolean field
'disconnected' in the device struct instead.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    5 ++---
 drivers/media/usb/em28xx/em28xx-core.c  |    4 ++--
 drivers/media/usb/em28xx/em28xx-dvb.c   |    4 ++--
 drivers/media/usb/em28xx/em28xx-video.c |   12 +++---------
 drivers/media/usb/em28xx/em28xx.h       |   12 ++----------
 5 Dateien geändert, 11 Zeilen hinzugefügt(+), 26 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index f5cac47..8496a06 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3501,11 +3501,10 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
 		     "deallocation are deferred on close.\n",
 		     video_device_node_name(dev->vdev));
 
-		dev->state |= DEV_MISCONFIGURED;
 		em28xx_uninit_usb_xfer(dev, dev->mode);
-		dev->state |= DEV_DISCONNECTED;
+		dev->disconnected = 1;
 	} else {
-		dev->state |= DEV_DISCONNECTED;
+		dev->disconnected = 1;
 		em28xx_release_resources(dev);
 	}
 
diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index b10d959..6916e87 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -77,7 +77,7 @@ int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
 	int ret;
 	int pipe = usb_rcvctrlpipe(dev->udev, 0);
 
-	if (dev->state & DEV_DISCONNECTED)
+	if (dev->disconnected)
 		return -ENODEV;
 
 	if (len > URB_MAX_CTRL_SIZE)
@@ -153,7 +153,7 @@ int em28xx_write_regs_req(struct em28xx *dev, u8 req, u16 reg, char *buf,
 	int ret;
 	int pipe = usb_sndctrlpipe(dev->udev, 0);
 
-	if (dev->state & DEV_DISCONNECTED)
+	if (dev->disconnected)
 		return -ENODEV;
 
 	if ((len < 1) || (len > URB_MAX_CTRL_SIZE))
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index a70b19e..e206c2b 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -133,7 +133,7 @@ static inline int em28xx_dvb_urb_data_copy(struct em28xx *dev, struct urb *urb)
 	if (!dev)
 		return 0;
 
-	if ((dev->state & DEV_DISCONNECTED) || (dev->state & DEV_MISCONFIGURED))
+	if (dev->disconnected)
 		return 0;
 
 	if (urb->status < 0)
@@ -1320,7 +1320,7 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 	if (dev->dvb) {
 		struct em28xx_dvb *dvb = dev->dvb;
 
-		if (dev->state & DEV_DISCONNECTED) {
+		if (dev->disconnected) {
 			/* We cannot tell the device to sleep
 			 * once it has been unplugged. */
 			if (dvb->fe[0])
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 4c1726d..824f298 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -442,7 +442,7 @@ static inline int em28xx_urb_data_copy(struct em28xx *dev, struct urb *urb)
 	if (!dev)
 		return 0;
 
-	if ((dev->state & DEV_DISCONNECTED) || (dev->state & DEV_MISCONFIGURED))
+	if (dev->disconnected)
 		return 0;
 
 	if (urb->status < 0)
@@ -790,16 +790,10 @@ handle:
 
 static int check_dev(struct em28xx *dev)
 {
-	if (dev->state & DEV_DISCONNECTED) {
+	if (dev->disconnected) {
 		em28xx_errdev("v4l2 ioctl: device not present\n");
 		return -ENODEV;
 	}
-
-	if (dev->state & DEV_MISCONFIGURED) {
-		em28xx_errdev("v4l2 ioctl: device is misconfigured; "
-			      "close and open it again\n");
-		return -EIO;
-	}
 	return 0;
 }
 
@@ -2068,7 +2062,7 @@ static int em28xx_v4l2_close(struct file *filp)
 	if (dev->users == 1) {
 		/* the device is already disconnect,
 		   free the remaining resources */
-		if (dev->state & DEV_DISCONNECTED) {
+		if (dev->disconnected) {
 			em28xx_release_resources(dev);
 			kfree(dev->alt_max_pkt_size_isoc);
 			mutex_unlock(&dev->lock);
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 062841e..7a40b92 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -437,13 +437,6 @@ struct em28xx_eeprom {
 	u8 string_idx_table;
 };
 
-/* device states */
-enum em28xx_dev_state {
-	DEV_INITIALIZED = 0x01,
-	DEV_DISCONNECTED = 0x02,
-	DEV_MISCONFIGURED = 0x04,
-};
-
 #define EM28XX_AUDIO_BUFS 5
 #define EM28XX_NUM_AUDIO_PACKETS 64
 #define EM28XX_AUDIO_MAX_PACKET_SIZE 196 /* static value */
@@ -494,6 +487,8 @@ struct em28xx {
 	int devno;		/* marks the number of this device */
 	enum em28xx_chip_id chip_id;
 
+	unsigned char disconnected:1;	/* device has been diconnected */
+
 	int audio_ifnum;
 
 	struct v4l2_device v4l2_dev;
@@ -561,9 +556,6 @@ struct em28xx {
 
 	struct em28xx_audio adev;
 
-	/* states */
-	enum em28xx_dev_state state;
-
 	/* capture state tracking */
 	int capture_type;
 	unsigned char top_field:1;
-- 
1.7.10.4

