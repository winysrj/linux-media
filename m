Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44048 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaIXXiL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 19:38:11 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Satoshi Nagahama <sattnag@aim.com>
Subject: [PATCH 3/3] [media] usb drivers: use %zu instead of %zd
Date: Wed, 24 Sep 2014 20:37:44 -0300
Message-Id: <efa13619097895bf5130bdc22d3b97d7a76cf912.1411601849.git.mchehab@osg.samsung.com>
In-Reply-To: <2d1780eb72dac499b9d44aa38961b8716e8857b3.1411601849.git.mchehab@osg.samsung.com>
References: <2d1780eb72dac499b9d44aa38961b8716e8857b3.1411601849.git.mchehab@osg.samsung.com>
In-Reply-To: <2d1780eb72dac499b9d44aa38961b8716e8857b3.1411601849.git.mchehab@osg.samsung.com>
References: <2d1780eb72dac499b9d44aa38961b8716e8857b3.1411601849.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

size_t is unsigned.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 51872b9f75a1..40a69879fc0a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -1595,7 +1595,7 @@ void cx231xx_set_DIF_bandpass(struct cx231xx *dev, u32 if_freq,
 		if_freq = 16000000;
 	}
 
-	cx231xx_info("Enter IF=%zd\n",
+	cx231xx_info("Enter IF=%zu\n",
 			ARRAY_SIZE(Dif_set_array));
 	for (i = 0; i < ARRAY_SIZE(Dif_set_array); i++) {
 		if (Dif_set_array[i].if_freq == if_freq) {
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 3284de99fc99..0ce816352d51 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -481,7 +481,7 @@ static void em28xx_copy_video(struct em28xx *dev,
 	lencopy = lencopy > remain ? remain : lencopy;
 
 	if ((char *)startwrite + lencopy > (char *)buf->vb_buf + buf->length) {
-		em28xx_isocdbg("Overflow of %zi bytes past buffer end (1)\n",
+		em28xx_isocdbg("Overflow of %zu bytes past buffer end (1)\n",
 			      ((char *)startwrite + lencopy) -
 			      ((char *)buf->vb_buf + buf->length));
 		remain = (char *)buf->vb_buf + buf->length -
@@ -507,7 +507,7 @@ static void em28xx_copy_video(struct em28xx *dev,
 
 		if ((char *)startwrite + lencopy > (char *)buf->vb_buf +
 		    buf->length) {
-			em28xx_isocdbg("Overflow of %zi bytes past buffer end"
+			em28xx_isocdbg("Overflow of %zu bytes past buffer end"
 				       "(2)\n",
 				       ((char *)startwrite + lencopy) -
 				       ((char *)buf->vb_buf + buf->length));
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 89c86ee2b225..94e10b10b66e 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -277,14 +277,14 @@ static int smsusb1_load_firmware(struct usb_device *udev, int id, int board_id)
 		rc = usb_bulk_msg(udev, usb_sndbulkpipe(udev, 2),
 				  fw_buffer, fw->size, &dummy, 1000);
 
-		sms_info("sent %zd(%d) bytes, rc %d", fw->size, dummy, rc);
+		sms_info("sent %zu(%d) bytes, rc %d", fw->size, dummy, rc);
 
 		kfree(fw_buffer);
 	} else {
 		sms_err("failed to allocate firmware buffer");
 		rc = -ENOMEM;
 	}
-	sms_info("read FW %s, size=%zd", fw_filename, fw->size);
+	sms_info("read FW %s, size=%zu", fw_filename, fw->size);
 
 	release_firmware(fw);
 
-- 
1.9.3

