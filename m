Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55299 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaHJArh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 20:47:37 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 07/18] [media] au0828: Add suspend code for DVB
Date: Sat,  9 Aug 2014 21:47:13 -0300
Message-Id: <1407631644-11990-8-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
References: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The scheduled work should be cancelled during suspend.

At resume time, we need to set the frontend again. So,
add such logic to the driver.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c |  2 ++
 drivers/media/usb/au0828/au0828-dvb.c  | 31 ++++++++++++++++++++++++++++++-
 drivers/media/usb/au0828/au0828.h      |  2 ++
 3 files changed, 34 insertions(+), 1 deletion(-)
 mode change 100644 => 100755 drivers/media/usb/au0828/au0828-dvb.c

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 87340a8af7d7..26ec50539dc4 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -290,6 +290,7 @@ static int au0828_suspend(struct usb_interface *interface,
 		return 0;
 
 	au0828_rc_suspend(dev);
+	au0828_dvb_suspend(dev);
 
 	/* FIXME: should suspend also ATV/DTV */
 
@@ -309,6 +310,7 @@ static int au0828_resume(struct usb_interface *interface)
 	au0828_gpio_setup(dev);
 
 	au0828_rc_resume(dev);
+	au0828_dvb_resume(dev);
 
 	/* FIXME: should resume also ATV/DTV */
 
diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
old mode 100644
new mode 100755
index d8b5d9480279..7b6e71065aa4
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -23,7 +23,6 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/device.h>
-#include <linux/suspend.h>
 #include <media/v4l2-common.h>
 #include <media/tuner.h>
 
@@ -618,3 +617,33 @@ int au0828_dvb_register(struct au0828_dev *dev)
 
 	return 0;
 }
+
+void au0828_dvb_suspend(struct au0828_dev *dev)
+{
+	struct au0828_dvb *dvb = &dev->dvb;
+
+	if (dvb && dev->urb_streaming) {
+		cancel_work_sync(&dev->restart_streaming);
+
+		/* Stop transport */
+		mutex_lock(&dvb->lock);
+		stop_urb_transfer(dev);
+		au0828_stop_transport(dev, 1);
+		mutex_unlock(&dvb->lock);
+	}
+}
+
+void au0828_dvb_resume(struct au0828_dev *dev)
+{
+	struct au0828_dvb *dvb = &dev->dvb;
+
+	if (dvb && dev->urb_streaming) {
+		au0828_set_frontend(dvb->frontend);
+
+		/* Start transport */
+		mutex_lock(&dvb->lock);
+		au0828_start_transport(dev);
+		start_urb_transfer(dev);
+		mutex_unlock(&dvb->lock);
+	}
+}
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index fd0916e20323..d32234353096 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -316,6 +316,8 @@ void au0828_analog_unregister(struct au0828_dev *dev);
 /* au0828-dvb.c */
 extern int au0828_dvb_register(struct au0828_dev *dev);
 extern void au0828_dvb_unregister(struct au0828_dev *dev);
+void au0828_dvb_suspend(struct au0828_dev *dev);
+void au0828_dvb_resume(struct au0828_dev *dev);
 
 /* au0828-vbi.c */
 extern struct videobuf_queue_ops au0828_vbi_qops;
-- 
1.9.3

