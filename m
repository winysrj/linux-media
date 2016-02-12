Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34826 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbcBLJqb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 04:46:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 07/11] [media] em28xx-dvb: create RF connector on DVB-only mode
Date: Fri, 12 Feb 2016 07:45:02 -0200
Message-Id: <b7dff6d1f91cdaa9102f7002e3ada0359e48cb3a.1455269986.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1455269986.git.mchehab@osg.samsung.com>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1455269986.git.mchehab@osg.samsung.com>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When in analog mode, the RF connector will be created by
em28xx-video. However, when the device is in digital mode only,
the RF connector is not shown. In this case, let the DVB
core to create it for us.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/em28xx/em28xx-dvb.c   | 7 ++++++-
 drivers/media/usb/em28xx/em28xx-video.c | 3 ++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index ea80541d58f0..7ca2fbd3b14a 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -905,6 +905,7 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
 			       struct em28xx *dev, struct device *device)
 {
 	int result;
+	bool create_rf_connector = false;
 
 	mutex_init(&dvb->lock);
 
@@ -998,7 +999,11 @@ static int em28xx_register_dvb(struct em28xx_dvb *dvb, struct module *module,
 	/* register network adapter */
 	dvb_net_init(&dvb->adapter, &dvb->net, &dvb->demux.dmx);
 
-	result = dvb_create_media_graph(&dvb->adapter, false);
+	/* If the analog part won't create RF connectors, DVB will do it */
+	if (!dev->has_video || (dev->tuner_type == TUNER_ABSENT))
+		create_rf_connector = true;
+
+	result = dvb_create_media_graph(&dvb->adapter, create_rf_connector);
 	if (result < 0)
 		goto fail_create_graph;
 
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index e7fd0bac4a08..f772e2612608 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -990,7 +990,8 @@ static void em28xx_v4l2_create_entities(struct em28xx *dev)
 			ent->function = MEDIA_ENT_F_CONN_SVIDEO;
 			break;
 		default: /* EM28XX_VMUX_TELEVISION or EM28XX_RADIO */
-			ent->function = MEDIA_ENT_F_CONN_RF;
+			if (dev->tuner_type != TUNER_ABSENT)
+				ent->function = MEDIA_ENT_F_CONN_RF;
 			break;
 		}
 
-- 
2.5.0


