Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:39941 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427Ab3AIMeg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2013 07:34:36 -0500
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: mchehab@redhat.com
Cc: schulz@macnetix.de, dhowells@redhat.com, peter.senna@gmail.com,
	mkrufky@linuxtv.org, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH 2/3] pci/ttpci/av7110.c: use IS_ENABLED() macro
Date: Wed,  9 Jan 2013 10:32:13 -0200
Message-Id: <1357734734-2856-2-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1357734734-2856-1-git-send-email-peter.senna@gmail.com>
References: <1357734734-2856-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

replace:
 #if defined(CONFIG_INPUT_EVDEV) || defined(CONFIG_INPUT_EVDEV_MODULE)
with:
 #if IS_ENABLED(CONFIG_INPUT_EVDEV)

This change was made for: CONFIG_INPUT_EVDEV, CONFIG_DVB_SP8870

Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/pci/ttpci/av7110.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index 2f54e2b..fc9e7e5 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -235,7 +235,7 @@ static void recover_arm(struct av7110 *av7110)
 
 	restart_feeds(av7110);
 
-#if defined(CONFIG_INPUT_EVDEV) || defined(CONFIG_INPUT_EVDEV_MODULE)
+#if IS_ENABLED(CONFIG_INPUT_EVDEV)
 	av7110_check_ir_config(av7110, true);
 #endif
 }
@@ -268,7 +268,7 @@ static int arm_thread(void *data)
 		if (!av7110->arm_ready)
 			continue;
 
-#if defined(CONFIG_INPUT_EVDEV) || defined(CONFIG_INPUT_EVDEV_MODULE)
+#if IS_ENABLED(CONFIG_INPUT_EVDEV)
 		av7110_check_ir_config(av7110, false);
 #endif
 
@@ -1730,7 +1730,7 @@ static int alps_tdlb7_tuner_set_params(struct dvb_frontend *fe)
 
 static int alps_tdlb7_request_firmware(struct dvb_frontend* fe, const struct firmware **fw, char* name)
 {
-#if defined(CONFIG_DVB_SP8870) || defined(CONFIG_DVB_SP8870_MODULE)
+#if IS_ENABLED(CONFIG_DVB_SP8870)
 	struct av7110* av7110 = fe->dvb->priv;
 
 	return request_firmware(fw, name, &av7110->dev->pci->dev);
@@ -2725,7 +2725,7 @@ static int __devinit av7110_attach(struct saa7146_dev* dev,
 
 	mutex_init(&av7110->ioctl_mutex);
 
-#if defined(CONFIG_INPUT_EVDEV) || defined(CONFIG_INPUT_EVDEV_MODULE)
+#if IS_ENABLED(CONFIG_INPUT_EVDEV)
 	av7110_ir_init(av7110);
 #endif
 	printk(KERN_INFO "dvb-ttpci: found av7110-%d.\n", av7110_num);
@@ -2768,7 +2768,7 @@ static int __devexit av7110_detach(struct saa7146_dev* saa)
 	struct av7110 *av7110 = saa->ext_priv;
 	dprintk(4, "%p\n", av7110);
 
-#if defined(CONFIG_INPUT_EVDEV) || defined(CONFIG_INPUT_EVDEV_MODULE)
+#if IS_ENABLED(CONFIG_INPUT_EVDEV)
 	av7110_ir_exit(av7110);
 #endif
 	if (budgetpatch || av7110->full_ts) {
-- 
1.7.11.7

