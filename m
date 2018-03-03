Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56675 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752298AbeCCUvT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Mar 2018 15:51:19 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 04/11] media: em28xx-audio: fix coding style issues
Date: Sat,  3 Mar 2018 17:51:05 -0300
Message-Id: <8f10a53f758b09c8bbe31bc969961bf701689ca6.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a number of coding style issues at em28xx-audio.
Fix them, by using checkpatch in strict mode to point for it.
Automatic fixes with --fix-inplace were complemented by manual
work.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 70 +++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 30 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index f8854b570f0d..8e799ae1df69 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -103,7 +103,7 @@ static void em28xx_audio_isocirq(struct urb *urb)
 	case -ESHUTDOWN:
 		return;
 	default:            /* error */
-		dprintk("urb completition error %d.\n", urb->status);
+		dprintk("urb completion error %d.\n", urb->status);
 		break;
 	}
 
@@ -165,12 +165,11 @@ static void em28xx_audio_isocirq(struct urb *urb)
 		dev_err(&dev->intf->dev,
 			"resubmit of audio urb failed (error=%i)\n",
 			status);
-	return;
 }
 
 static int em28xx_init_audio_isoc(struct em28xx *dev)
 {
-	int       i, errCode;
+	int       i, err;
 
 	dprintk("Starting isoc transfers\n");
 
@@ -179,16 +178,15 @@ static int em28xx_init_audio_isoc(struct em28xx *dev)
 		memset(dev->adev.transfer_buffer[i], 0x80,
 		       dev->adev.urb[i]->transfer_buffer_length);
 
-		errCode = usb_submit_urb(dev->adev.urb[i], GFP_ATOMIC);
-		if (errCode) {
+		err = usb_submit_urb(dev->adev.urb[i], GFP_ATOMIC);
+		if (err) {
 			dev_err(&dev->intf->dev,
 				"submit of audio urb failed (error=%i)\n",
-				errCode);
+				err);
 			em28xx_deinit_isoc_audio(dev);
 			atomic_set(&dev->adev.stream_started, 0);
-			return errCode;
+			return err;
 		}
-
 	}
 
 	return 0;
@@ -268,14 +266,17 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
 	if (nonblock) {
 		if (!mutex_trylock(&dev->lock))
 			return -EAGAIN;
-	} else
+	} else {
 		mutex_lock(&dev->lock);
+	}
 
 	runtime->hw = snd_em28xx_hw_capture;
 
 	if (dev->adev.users == 0) {
-		if (dev->alt == 0 || dev->is_audio_only) {
-			struct usb_device *udev = interface_to_usbdev(dev->intf);
+		if (!dev->alt || dev->is_audio_only) {
+			struct usb_device *udev;
+
+			udev = interface_to_usbdev(dev->intf);
 
 			if (dev->is_audio_only)
 				/* audio is on a separate interface */
@@ -367,9 +368,11 @@ static int snd_em28xx_hw_capture_params(struct snd_pcm_substream *substream,
 	if (ret < 0)
 		return ret;
 #if 0
-	/* TODO: set up em28xx audio chip to deliver the correct audio format,
-	   current default is 48000hz multiplexed => 96000hz mono
-	   which shouldn't matter since analogue TV only supports mono */
+	/*
+	 * TODO: set up em28xx audio chip to deliver the correct audio format,
+	 * current default is 48000hz multiplexed => 96000hz mono
+	 * which shouldn't matter since analogue TV only supports mono
+	 */
 	unsigned int channels, rate, format;
 
 	format = params_format(hw_params);
@@ -513,8 +516,9 @@ static int em28xx_vol_put(struct snd_kcontrol *kcontrol,
 	if (nonblock) {
 		if (!mutex_trylock(&dev->lock))
 			return -EAGAIN;
-	} else
+	} else {
 		mutex_lock(&dev->lock);
+	}
 	rc = em28xx_read_ac97(dev, kcontrol->private_value);
 	if (rc < 0)
 		goto err;
@@ -551,8 +555,9 @@ static int em28xx_vol_get(struct snd_kcontrol *kcontrol,
 	if (nonblock) {
 		if (!mutex_trylock(&dev->lock))
 			return -EAGAIN;
-	} else
+	} else {
 		mutex_lock(&dev->lock);
+	}
 	val = em28xx_read_ac97(dev, kcontrol->private_value);
 	mutex_unlock(&dev->lock);
 	if (val < 0)
@@ -586,8 +591,9 @@ static int em28xx_vol_put_mute(struct snd_kcontrol *kcontrol,
 	if (nonblock) {
 		if (!mutex_trylock(&dev->lock))
 			return -EAGAIN;
-	} else
+	} else {
 		mutex_lock(&dev->lock);
+	}
 	rc = em28xx_read_ac97(dev, kcontrol->private_value);
 	if (rc < 0)
 		goto err;
@@ -627,8 +633,9 @@ static int em28xx_vol_get_mute(struct snd_kcontrol *kcontrol,
 	if (nonblock) {
 		if (!mutex_trylock(&dev->lock))
 			return -EAGAIN;
-	} else
+	} else {
 		mutex_lock(&dev->lock);
+	}
 	val = em28xx_read_ac97(dev, kcontrol->private_value);
 	mutex_unlock(&dev->lock);
 	if (val < 0)
@@ -762,7 +769,7 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 
 	if (intf->num_altsetting <= alt) {
 		dev_err(&dev->intf->dev, "alt %d doesn't exist on interface %d\n",
-			      dev->ifnum, alt);
+			dev->ifnum, alt);
 		return -ENODEV;
 	}
 
@@ -836,9 +843,8 @@ static int em28xx_audio_urb_init(struct em28xx *dev)
 	dev->adev.transfer_buffer = kcalloc(num_urb,
 					    sizeof(*dev->adev.transfer_buffer),
 					    GFP_ATOMIC);
-	if (!dev->adev.transfer_buffer) {
+	if (!dev->adev.transfer_buffer)
 		return -ENOMEM;
-	}
 
 	dev->adev.urb = kcalloc(num_urb, sizeof(*dev->adev.urb), GFP_ATOMIC);
 	if (!dev->adev.urb) {
@@ -899,9 +905,11 @@ static int em28xx_audio_init(struct em28xx *dev)
 	int		    err;
 
 	if (dev->usb_audio_type != EM28XX_USB_AUDIO_VENDOR) {
-		/* This device does not support the extension (in this case
-		   the device is expecting the snd-usb-audio module or
-		   doesn't have analog audio support at all) */
+		/*
+		 * This device does not support the extension (in this case
+		 * the device is expecting the snd-usb-audio module or
+		 * doesn't have analog audio support at all)
+		 */
 		return 0;
 	}
 
@@ -977,13 +985,15 @@ static int em28xx_audio_init(struct em28xx *dev)
 
 static int em28xx_audio_fini(struct em28xx *dev)
 {
-	if (dev == NULL)
+	if (!dev)
 		return 0;
 
 	if (dev->usb_audio_type != EM28XX_USB_AUDIO_VENDOR) {
-		/* This device does not support the extension (in this case
-		   the device is expecting the snd-usb-audio module or
-		   doesn't have analog audio support at all) */
+		/*
+		 * This device does not support the extension (in this case
+		 * the device is expecting the snd-usb-audio module or
+		 * doesn't have analog audio support at all)
+		 */
 		return 0;
 	}
 
@@ -1005,7 +1015,7 @@ static int em28xx_audio_fini(struct em28xx *dev)
 
 static int em28xx_audio_suspend(struct em28xx *dev)
 {
-	if (dev == NULL)
+	if (!dev)
 		return 0;
 
 	if (dev->usb_audio_type != EM28XX_USB_AUDIO_VENDOR)
@@ -1019,7 +1029,7 @@ static int em28xx_audio_suspend(struct em28xx *dev)
 
 static int em28xx_audio_resume(struct em28xx *dev)
 {
-	if (dev == NULL)
+	if (!dev)
 		return 0;
 
 	if (dev->usb_audio_type != EM28XX_USB_AUDIO_VENDOR)
-- 
2.14.3
