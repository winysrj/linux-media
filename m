Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60275 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbACCE4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jan 2015 21:04:56 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Shuah Khan <shuah.kh@samsung.com>,
	Ole Ernst <olebowle@gmx.com>,
	Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH 3/7] dvb core: add media controller support for DVB frontend
Date: Sat,  3 Jan 2015 00:04:36 -0200
Message-Id: <61b7b20a98bcb97b8d35103b55d867804de4c7b5.1420250453.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420250453.git.mchehab@osg.samsung.com>
References: <cover.1420250453.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420250453.git.mchehab@osg.samsung.com>
References: <cover.1420250453.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the dvb core is capable of registering devices via the
media controller, add support for the DVB frontend devices.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 2cf30576bf39..e34c47de1135 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2612,12 +2612,16 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
 			  struct dvb_frontend* fe)
 {
 	struct dvb_frontend_private *fepriv;
-	static const struct dvb_device dvbdev_template = {
+	const struct dvb_device dvbdev_template = {
 		.users = ~0,
 		.writers = 1,
 		.readers = (~0)-1,
 		.fops = &dvb_frontend_fops,
-		.kernel_ioctl = dvb_frontend_ioctl
+		.kernel_ioctl = dvb_frontend_ioctl,
+#if defined(CONFIG_MEDIA_CONTROLLER)
+		.mdev = fe->mdev,
+		.name = fe->ops.info.name,
+#endif
 	};
 
 	dev_dbg(dvb->device, "%s:\n", __func__);
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 816269e5f706..79b79a90d612 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -40,6 +40,8 @@
 
 #include <linux/dvb/frontend.h>
 
+#include <media/media-device.h>
+
 #include "dvbdev.h"
 
 /*
@@ -415,6 +417,11 @@ struct dtv_frontend_properties {
 struct dvb_frontend {
 	struct dvb_frontend_ops ops;
 	struct dvb_adapter *dvb;
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_device *mdev;
+#endif
+
 	void *demodulator_priv;
 	void *tuner_priv;
 	void *frontend_priv;
-- 
2.1.0

