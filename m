Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37048 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab2CVMs0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Mar 2012 08:48:26 -0400
Received: by eekc41 with SMTP id c41so677305eek.19
        for <linux-media@vger.kernel.org>; Thu, 22 Mar 2012 05:48:25 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: crope@iki.fi, Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] em28xx-dvb: stop URBs when stopping the streaming
Date: Thu, 22 Mar 2012 13:48:17 +0100
Message-Id: <1332420497-16352-1-git-send-email-gennarone@gmail.com>
In-Reply-To: <4F6B0CF9.2030608@gmail.com>
References: <4F6B0CF9.2030608@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stop the URBs in em28xx_stop_streaming(), so that em28xx_irq_callback()
cannot be called after the streaming has stopped.

This should eliminate the crashes reported by Antti Palosaari and the warnings
reported by Andy Furniss.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/video/em28xx/em28xx-core.c |   26 +++++++++++++++++++++++++-
 drivers/media/video/em28xx/em28xx-dvb.c  |    2 +-
 drivers/media/video/em28xx/em28xx.h      |    1 +
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index 53a9fb9..cbbe399 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -666,7 +666,6 @@ int em28xx_capture_start(struct em28xx *dev, int start)
 
 	return rc;
 }
-EXPORT_SYMBOL_GPL(em28xx_capture_start);
 
 int em28xx_vbi_supported(struct em28xx *dev)
 {
@@ -1008,6 +1007,31 @@ void em28xx_uninit_isoc(struct em28xx *dev, enum em28xx_mode mode)
 EXPORT_SYMBOL_GPL(em28xx_uninit_isoc);
 
 /*
+ * Stop URBs
+ */
+void em28xx_stop_urbs(struct em28xx *dev)
+{
+	int i;
+	struct urb *urb;
+	struct em28xx_usb_isoc_bufs *isoc_bufs = &dev->isoc_ctl.digital_bufs;
+
+	em28xx_isocdbg("em28xx: called em28xx_stop_urbs\n");
+
+	for (i = 0; i < isoc_bufs->num_bufs; i++) {
+		urb = isoc_bufs->urb[i];
+		if (urb) {
+			if (!irqs_disabled())
+				usb_kill_urb(urb);
+			else
+				usb_unlink_urb(urb);
+		}
+	}
+
+	em28xx_capture_start(dev, 0);
+}
+EXPORT_SYMBOL_GPL(em28xx_stop_urbs);
+
+/*
  * Allocate URBs
  */
 int em28xx_alloc_isoc(struct em28xx *dev, enum em28xx_mode mode,
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index 503a8d5..2d73ee2 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -183,7 +183,7 @@ static int em28xx_stop_streaming(struct em28xx_dvb *dvb)
 {
 	struct em28xx *dev = dvb->adapter.priv;
 
-	em28xx_capture_start(dev, 0);
+	em28xx_stop_urbs(dev);
 
 	em28xx_set_mode(dev, EM28XX_SUSPEND);
 
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 2868b19..286b9f8 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -695,6 +695,7 @@ int em28xx_init_isoc(struct em28xx *dev, enum em28xx_mode mode,
 		     int max_packets, int num_bufs, int max_pkt_size,
 		     int (*isoc_copy) (struct em28xx *dev, struct urb *urb));
 void em28xx_uninit_isoc(struct em28xx *dev, enum em28xx_mode mode);
+void em28xx_stop_urbs(struct em28xx *dev);
 int em28xx_isoc_dvb_max_packetsize(struct em28xx *dev);
 int em28xx_set_mode(struct em28xx *dev, enum em28xx_mode set_mode);
 int em28xx_gpio_set(struct em28xx *dev, struct em28xx_reg_seq *gpio);
-- 
1.7.0.4

