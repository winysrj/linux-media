Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:51492 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbbLRPOY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 10:14:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH] [media] dvbdev: avoid unused functions
Date: Fri, 18 Dec 2015 16:14:06 +0100
Message-ID: <1622537.sJciORk4kT@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvb_create_tsout_entity and dvb_create_media_entity
functions are only called if CONFIG_MEDIA_CONTROLLER_DVB is
enabled, otherwise we get a compiler warning:

dvb-core/dvbdev.c:219:12: warning: 'dvb_create_tsout_entity' defined but not used [-Wunused-function]
dvb-core/dvbdev.c:264:12: warning: 'dvb_create_media_entity' defined but not used [-Wunused-function]

This moves the #ifdef inside of the two functions to the
outside, to avoid the two warnings.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index b56e00817d3f..860dd7d06b60 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -216,10 +216,10 @@ static void dvb_media_device_free(struct dvb_device *dvbdev)
 #endif
 }
 
+#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
 static int dvb_create_tsout_entity(struct dvb_device *dvbdev,
 				    const char *name, int npads)
 {
-#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
 	int i, ret = 0;
 
 	dvbdev->tsout_pads = kcalloc(npads, sizeof(*dvbdev->tsout_pads),
@@ -254,7 +254,6 @@ static int dvb_create_tsout_entity(struct dvb_device *dvbdev,
 		if (ret < 0)
 			return ret;
 	}
-#endif
 	return 0;
 }
 
@@ -264,7 +263,6 @@ static int dvb_create_tsout_entity(struct dvb_device *dvbdev,
 static int dvb_create_media_entity(struct dvb_device *dvbdev,
 				   int type, int demux_sink_pads)
 {
-#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
 	int i, ret, npads;
 
 	switch (type) {
@@ -352,9 +350,9 @@ static int dvb_create_media_entity(struct dvb_device *dvbdev,
 	printk(KERN_DEBUG "%s: media entity '%s' registered.\n",
 		__func__, dvbdev->entity->name);
 
-#endif
 	return 0;
 }
+#endif
 
 static int dvb_register_media_device(struct dvb_device *dvbdev,
 				     int type, int minor,

