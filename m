Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52490 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbbL3Nti (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 08:49:38 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/6] [media] dvbdev: remove two dead functions if !CONFIG_MEDIA_CONTROLLER_DVB
Date: Wed, 30 Dec 2015 11:48:51 -0200
Message-Id: <c3121f173c2130efec49d0daa0c1dc1ff55df532.1451482760.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1451482760.git.mchehab@osg.samsung.com>
References: <cover.1451482760.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1451482760.git.mchehab@osg.samsung.com>
References: <cover.1451482760.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those functions are used only if CONFIG_MEDIA_CONTROLLER_DVB.
Without that, if !CONFIG_MEDIA_CONTROLLER_DVB, it would produce
two warnings:

drivers/media/dvb-core/dvbdev.c:219:12: warning: 'dvb_create_tsout_entity' defined but not used [-Wunused-function]
 static int dvb_create_tsout_entity(struct dvb_device *dvbdev,
            ^
drivers/media/dvb-core/dvbdev.c:264:12: warning: 'dvb_create_media_entity' defined but not used [-Wunused-function]
 static int dvb_create_media_entity(struct dvb_device *dvbdev,
            ^

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/dvbdev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

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
-- 
2.5.0


