Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46663 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbbACOtZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Jan 2015 09:49:25 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv2 6/9] dvb core: add support for CA node at the media controller
Date: Sat,  3 Jan 2015 12:49:08 -0200
Message-Id: <70add6654493cefbb089a4c60772ee5710c4703e.1420294938.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420294938.git.mchehab@osg.samsung.com>
References: <cover.1420294938.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420294938.git.mchehab@osg.samsung.com>
References: <cover.1420294938.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the dvb core CA support aware of the media controller and
register the corresponding devices.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 0aac3096728e..011cb2bc04e1 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -1638,14 +1638,6 @@ static const struct file_operations dvb_ca_fops = {
 	.llseek = noop_llseek,
 };
 
-static struct dvb_device dvbdev_ca = {
-	.priv = NULL,
-	.users = 1,
-	.readers = 1,
-	.writers = 1,
-	.fops = &dvb_ca_fops,
-};
-
 
 /* ******************************************************************************** */
 /* Initialisation/shutdown functions */
@@ -1667,6 +1659,17 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 	int ret;
 	struct dvb_ca_private *ca = NULL;
 	int i;
+	struct dvb_device dvbdev_ca = {
+		.priv = NULL,
+		.users = 1,
+		.readers = 1,
+		.writers = 1,
+		.fops = &dvb_ca_fops,
+#if defined(CONFIG_MEDIA_CONTROLLER)
+		.mdev = pubca->mdev,
+		.name = "ca_en50221",
+#endif
+	};
 
 	dprintk("%s\n", __func__);
 
diff --git a/drivers/media/dvb-core/dvb_ca_en50221.h b/drivers/media/dvb-core/dvb_ca_en50221.h
index 7df2e141187a..c8e69f418eb5 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.h
+++ b/drivers/media/dvb-core/dvb_ca_en50221.h
@@ -24,6 +24,8 @@
 #include <linux/list.h>
 #include <linux/dvb/ca.h>
 
+#include <media/media-device.h>
+
 #include "dvbdev.h"
 
 #define DVB_CA_EN50221_POLL_CAM_PRESENT	1
@@ -74,6 +76,10 @@ struct dvb_ca_en50221 {
 
 	/* Opaque data used by the dvb_ca core. Do not modify! */
 	void* private;
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_device *mdev;
+#endif
 };
 
 
-- 
2.1.0

