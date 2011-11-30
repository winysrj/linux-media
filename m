Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab1K3SuG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 13:50:06 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAUIo5uj032510
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 30 Nov 2011 13:50:05 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 1/2] [media] tm6000: automatically load alsa and dvb modules
Date: Wed, 30 Nov 2011 16:49:59 -0200
Message-Id: <1322679000-26453-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All devices should support alsa module. Devices with DVB will
auto-load the dvb module. This way, tm6000-based devices should
now have hot plugin.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/tm6000/tm6000-cards.c |   31 +++++++++++++++++++++++++++++
 drivers/media/video/tm6000/tm6000.h       |    3 ++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/tm6000/tm6000-cards.c b/drivers/media/video/tm6000/tm6000-cards.c
index 3873ce4..6b74259 100644
--- a/drivers/media/video/tm6000/tm6000-cards.c
+++ b/drivers/media/video/tm6000/tm6000-cards.c
@@ -1052,6 +1052,33 @@ static void use_alternative_detection_method(struct tm6000_core *dev)
 	       tm6000_boards[model].name, model);
 }
 
+#if defined(CONFIG_MODULES) && defined(MODULE)
+static void request_module_async(struct work_struct *work)
+{
+	struct tm6000_core *dev = container_of(work, struct tm6000_core,
+					       request_module_wk);
+
+	request_module("tm6000-alsa");
+
+	if (dev->caps.has_dvb)
+		request_module("tm6000-dvb");
+}
+
+static void request_modules(struct tm6000_core *dev)
+{
+	INIT_WORK(&dev->request_module_wk, request_module_async);
+	schedule_work(&dev->request_module_wk);
+}
+
+static void flush_request_modules(struct tm6000_core *dev)
+{
+	flush_work_sync(&dev->request_module_wk);
+}
+#else
+#define request_modules(dev)
+#define flush_request_modules(dev)
+#endif /* CONFIG_MODULES */
+
 static int tm6000_init_dev(struct tm6000_core *dev)
 {
 	struct v4l2_frequency f;
@@ -1114,6 +1141,8 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 
 	tm6000_ir_init(dev);
 
+	request_modules(dev);
+
 	mutex_unlock(&dev->lock);
 	return 0;
 
@@ -1326,6 +1355,8 @@ static void tm6000_usb_disconnect(struct usb_interface *interface)
 
 	printk(KERN_INFO "tm6000: disconnecting %s\n", dev->name);
 
+	flush_request_modules(dev);
+
 	tm6000_ir_fini(dev);
 
 	if (dev->gpio.power_led) {
diff --git a/drivers/media/video/tm6000/tm6000.h b/drivers/media/video/tm6000/tm6000.h
index 2777e51..27ba659 100644
--- a/drivers/media/video/tm6000/tm6000.h
+++ b/drivers/media/video/tm6000/tm6000.h
@@ -188,6 +188,9 @@ struct tm6000_core {
 	/* Device Capabilities*/
 	struct tm6000_capabilities	caps;
 
+	/* Used to load alsa/dvb */
+        struct work_struct		request_module_wk;
+
 	/* Tuner configuration */
 	int				tuner_type;		/* type of the tuner */
 	int				tuner_addr;		/* tuner address */
-- 
1.7.7.3

