Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:30895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab0IPA5I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 20:57:08 -0400
Date: Wed, 15 Sep 2010 21:56:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Tobias Lorenz <tobias.lorenz@gmx.net>,
	Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH 1/8] V4L/DVB: radio-si470x: remove the BKL lock used
 internally at the driver
Message-ID: <20100915215635.7471a5f6@pedra>
In-Reply-To: <cover.1284597566.git.mchehab@redhat.com>
References: <cover.1284597566.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 5ec13e5..392e84f 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -517,7 +517,7 @@ int si470x_fops_open(struct file *file)
 	struct si470x_device *radio = video_drvdata(file);
 	int retval;
 
-	lock_kernel();
+	mutex_lock(&radio->lock);
 	radio->users++;
 
 	retval = usb_autopm_get_interface(radio->intf);
@@ -558,7 +558,7 @@ int si470x_fops_open(struct file *file)
 	}
 
 done:
-	unlock_kernel();
+	mutex_unlock(&radio->lock);
 	return retval;
 }
 
@@ -577,7 +577,7 @@ int si470x_fops_release(struct file *file)
 		goto done;
 	}
 
-	mutex_lock(&radio->disconnect_lock);
+	mutex_lock(&radio->lock);
 	radio->users--;
 	if (radio->users == 0) {
 		/* shutdown interrupt handler */
@@ -591,7 +591,7 @@ int si470x_fops_release(struct file *file)
 			video_unregister_device(radio->videodev);
 			kfree(radio->int_in_buffer);
 			kfree(radio->buffer);
-			mutex_unlock(&radio->disconnect_lock);
+			mutex_unlock(&radio->lock);
 			kfree(radio);
 			goto done;
 		}
@@ -603,7 +603,7 @@ int si470x_fops_release(struct file *file)
 		retval = si470x_stop(radio);
 		usb_autopm_put_interface(radio->intf);
 	}
-	mutex_unlock(&radio->disconnect_lock);
+	mutex_unlock(&radio->lock);
 done:
 	return retval;
 }
@@ -661,7 +661,6 @@ static int si470x_usb_driver_probe(struct usb_interface *intf,
 	radio->disconnected = 0;
 	radio->usbdev = interface_to_usbdev(intf);
 	radio->intf = intf;
-	mutex_init(&radio->disconnect_lock);
 	mutex_init(&radio->lock);
 
 	iface_desc = intf->cur_altsetting;
@@ -830,7 +829,7 @@ static void si470x_usb_driver_disconnect(struct usb_interface *intf)
 {
 	struct si470x_device *radio = usb_get_intfdata(intf);
 
-	mutex_lock(&radio->disconnect_lock);
+	mutex_lock(&radio->lock);
 	radio->disconnected = 1;
 	usb_set_intfdata(intf, NULL);
 	if (radio->users == 0) {
@@ -843,10 +842,10 @@ static void si470x_usb_driver_disconnect(struct usb_interface *intf)
 		kfree(radio->int_in_buffer);
 		video_unregister_device(radio->videodev);
 		kfree(radio->buffer);
-		mutex_unlock(&radio->disconnect_lock);
+		mutex_unlock(&radio->lock);
 		kfree(radio);
 	} else {
-		mutex_unlock(&radio->disconnect_lock);
+		mutex_unlock(&radio->lock);
 	}
 }
 
diff --git a/drivers/media/radio/si470x/radio-si470x.h b/drivers/media/radio/si470x/radio-si470x.h
index 3cd0a29..d3d86ba 100644
--- a/drivers/media/radio/si470x/radio-si470x.h
+++ b/drivers/media/radio/si470x/radio-si470x.h
@@ -177,7 +177,6 @@ struct si470x_device {
 
 	/* driver management */
 	unsigned char disconnected;
-	struct mutex disconnect_lock;
 #endif
 
 #if defined(CONFIG_I2C_SI470X) || defined(CONFIG_I2C_SI470X_MODULE)
-- 
1.7.1


