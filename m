Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:44443 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933971Ab0BEW5u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 17:57:50 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 7/12] tm6000: add tuner callback for dvb frontend
Date: Fri,  5 Feb 2010 23:57:06 +0100
Message-Id: <1265410631-11955-6-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1265410631-11955-5-git-send-email-stefan.ringel@arcor.de>
References: <1265410631-11955-1-git-send-email-stefan.ringel@arcor.de>
 <1265410631-11955-2-git-send-email-stefan.ringel@arcor.de>
 <1265410631-11955-3-git-send-email-stefan.ringel@arcor.de>
 <1265410631-11955-4-git-send-email-stefan.ringel@arcor.de>
 <1265410631-11955-5-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-cards.c |    2 +-
 drivers/staging/tm6000/tm6000-dvb.c   |    3 ++-
 drivers/staging/tm6000/tm6000.h       |    3 +++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 5cf5d58..4592397 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -245,7 +245,7 @@ struct usb_device_id tm6000_id_table [] = {
 
 /* Tuner callback to provide the proper gpio changes needed for xc2028 */
 
-static int tm6000_tuner_callback(void *ptr, int component, int command, int arg)
+int tm6000_tuner_callback(void *ptr, int component, int command, int arg)
 {
 	int rc=0;
 	struct tm6000_core *dev = ptr;
diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
index e900d6d..fdbee30 100644
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -235,7 +235,8 @@ int tm6000_dvb_register(struct tm6000_core *dev)
 			.i2c_adap = &dev->i2c_adap,
 			.i2c_addr = dev->tuner_addr,
 		};
-
+		
+		dvb->frontend->callback = tm6000_tuner_callback;
 		ret = dvb_register_frontend(&dvb->adapter, dvb->frontend);
 		if (ret < 0) {
 			printk(KERN_ERR
diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
index 877cbf6..d713c48 100644
--- a/drivers/staging/tm6000/tm6000.h
+++ b/drivers/staging/tm6000/tm6000.h
@@ -202,6 +202,9 @@ struct tm6000_fh {
 			V4L2_STD_PAL_M|V4L2_STD_PAL_60|V4L2_STD_NTSC_M| \
 			V4L2_STD_NTSC_M_JP|V4L2_STD_SECAM
 
+/* In tm6000-cards.c */
+
+int tm6000_tuner_callback (void *ptr, int component, int command, int arg);
 /* In tm6000-core.c */
 
 int tm6000_read_write_usb (struct tm6000_core *dev, u8 reqtype, u8 req,
-- 
1.6.4.2

