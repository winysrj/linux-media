Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55292 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbaHJArh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 20:47:37 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 09/18] [media] au0828: add suspend/resume code for V4L2
Date: Sat,  9 Aug 2014 21:47:15 -0300
Message-Id: <1407631644-11990-10-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
References: <1407631644-11990-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No timers should be enabled during suspend. So,
stop them. At resume time, we should do the proper
initialization for it to keep working.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/au0828/au0828-core.c  |  2 ++
 drivers/media/usb/au0828/au0828-video.c | 59 ++++++++++++++++++++++++++++++++-
 drivers/media/usb/au0828/au0828.h       |  7 ++++
 3 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 26ec50539dc4..5f13888d73a0 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -290,6 +290,7 @@ static int au0828_suspend(struct usb_interface *interface,
 		return 0;
 
 	au0828_rc_suspend(dev);
+	au0828_v4l2_suspend(dev);
 	au0828_dvb_suspend(dev);
 
 	/* FIXME: should suspend also ATV/DTV */
@@ -310,6 +311,7 @@ static int au0828_resume(struct usb_interface *interface)
 	au0828_gpio_setup(dev);
 
 	au0828_rc_resume(dev);
+	au0828_v4l2_resume(dev);
 	au0828_dvb_resume(dev);
 
 	/* FIXME: should resume also ATV/DTV */
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 36ff3b496f87..574a08c7013d 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -32,7 +32,6 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/device.h>
-#include <linux/suspend.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
@@ -1871,6 +1870,64 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 	return rc;
 }
 
+void au0828_v4l2_suspend(struct au0828_dev *dev)
+{
+	struct urb *urb;
+	int i;
+
+	if (dev->stream_state == STREAM_ON) {
+		au0828_analog_stream_disable(dev);
+		/* stop urbs */
+		for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
+			urb = dev->isoc_ctl.urb[i];
+			if (urb) {
+				if (!irqs_disabled())
+					usb_kill_urb(urb);
+				else
+					usb_unlink_urb(urb);
+			}
+		}
+	}
+
+	if (dev->vid_timeout_running)
+		del_timer_sync(&dev->vid_timeout);
+	if (dev->vbi_timeout_running)
+		del_timer_sync(&dev->vbi_timeout);
+}
+
+void au0828_v4l2_resume(struct au0828_dev *dev)
+{
+	int i, rc;
+
+	if (dev->stream_state == STREAM_ON) {
+		au0828_stream_interrupt(dev);
+		au0828_init_tuner(dev);
+	}
+
+	if (dev->vid_timeout_running)
+		mod_timer(&dev->vid_timeout, jiffies + (HZ / 10));
+	if (dev->vbi_timeout_running)
+		mod_timer(&dev->vbi_timeout, jiffies + (HZ / 10));
+
+	/* If we were doing ac97 instead of i2s, it would go here...*/
+	au0828_i2s_init(dev);
+
+	au0828_analog_stream_enable(dev);
+
+	if (!(dev->stream_state == STREAM_ON)) {
+		au0828_analog_stream_reset(dev);
+		/* submit urbs */
+		for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
+			rc = usb_submit_urb(dev->isoc_ctl.urb[i], GFP_ATOMIC);
+			if (rc) {
+				au0828_isocdbg("submit of urb %i failed (error=%i)\n",
+					       i, rc);
+				au0828_uninit_isoc(dev);
+			}
+		}
+	}
+}
+
 static struct v4l2_file_operations au0828_v4l_fops = {
 	.owner      = THIS_MODULE,
 	.open       = au0828_v4l2_open,
diff --git a/drivers/media/usb/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
index d32234353096..0d8cfe5cd264 100644
--- a/drivers/media/usb/au0828/au0828.h
+++ b/drivers/media/usb/au0828/au0828.h
@@ -311,6 +311,13 @@ int au0828_analog_register(struct au0828_dev *dev,
 			   struct usb_interface *interface);
 int au0828_analog_stream_disable(struct au0828_dev *d);
 void au0828_analog_unregister(struct au0828_dev *dev);
+#ifdef CONFIG_VIDEO_AU0828_V4L2
+void au0828_v4l2_suspend(struct au0828_dev *dev);
+void au0828_v4l2_resume(struct au0828_dev *dev);
+#else
+static inline void au0828_v4l2_suspend(struct au0828_dev *dev) { };
+static inline void au0828_v4l2_resume(struct au0828_dev *dev) { };
+#endif
 
 /* ----------------------------------------------------------- */
 /* au0828-dvb.c */
-- 
1.9.3

