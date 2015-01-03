Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46675 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbbACOtZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Jan 2015 09:49:25 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Changbing Xiong <cb.xiong@samsung.com>
Subject: [PATCHv2 5/9] dvb core: add support for demux/dvr nodes at media controller
Date: Sat,  3 Jan 2015 12:49:07 -0200
Message-Id: <bdfebc426bab35918a19d91c07706b7bfc53ce7e.1420294938.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420294938.git.mchehab@osg.samsung.com>
References: <cover.1420294938.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420294938.git.mchehab@osg.samsung.com>
References: <cover.1420294938.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the dvb core demux support aware of the media controller and
register the corresponding devices.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index abff803ad69a..9071636534db 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -1136,13 +1136,6 @@ static const struct file_operations dvb_demux_fops = {
 	.llseek = default_llseek,
 };
 
-static struct dvb_device dvbdev_demux = {
-	.priv = NULL,
-	.users = 1,
-	.writers = 1,
-	.fops = &dvb_demux_fops
-};
-
 static int dvb_dvr_do_ioctl(struct file *file,
 			    unsigned int cmd, void *parg)
 {
@@ -1209,16 +1202,29 @@ static const struct file_operations dvb_dvr_fops = {
 	.llseek = default_llseek,
 };
 
-static struct dvb_device dvbdev_dvr = {
-	.priv = NULL,
-	.readers = 1,
-	.users = 1,
-	.fops = &dvb_dvr_fops
-};
-
 int dvb_dmxdev_init(struct dmxdev *dmxdev, struct dvb_adapter *dvb_adapter)
 {
 	int i;
+	struct dvb_device dvbdev_demux = {
+		.priv = NULL,
+		.users = 1,
+		.writers = 1,
+		.fops = &dvb_demux_fops,
+#if defined(CONFIG_MEDIA_CONTROLLER)
+		.mdev = dmxdev->mdev,
+		.name = "demux",
+#endif
+	};
+	struct dvb_device dvbdev_dvr = {
+		.priv = NULL,
+		.readers = 1,
+		.users = 1,
+		.fops = &dvb_dvr_fops,
+#if defined(CONFIG_MEDIA_CONTROLLER)
+		.mdev = dmxdev->mdev,
+		.name = "dvr",
+#endif
+	};
 
 	if (dmxdev->demux->open(dmxdev->demux) < 0)
 		return -EUSERS;
diff --git a/drivers/media/dvb-core/dmxdev.h b/drivers/media/dvb-core/dmxdev.h
index 48c6cf92ab99..09832a8e6956 100644
--- a/drivers/media/dvb-core/dmxdev.h
+++ b/drivers/media/dvb-core/dmxdev.h
@@ -36,6 +36,8 @@
 
 #include <linux/dvb/dmx.h>
 
+#include <media/media-device.h>
+
 #include "dvbdev.h"
 #include "demux.h"
 #include "dvb_ringbuffer.h"
@@ -110,6 +112,10 @@ struct dmxdev {
 
 	struct mutex mutex;
 	spinlock_t lock;
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_device *mdev;
+#endif
 };
 
 
-- 
2.1.0

