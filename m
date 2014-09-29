Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48680 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbaI2CXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Sep 2014 22:23:50 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Johannes Stezenbach <js@linuxtv.org>
Subject: [PATCH 3/6] [media] em28xx-dvb: remove unused mfe_sharing
Date: Sun, 28 Sep 2014 23:23:20 -0300
Message-Id: <48e124cd8b260ce902c9aa377fe9f856bf9577b0.1411956856.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1411956856.git.mchehab@osg.samsung.com>
References: <cover.1411956856.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1411956856.git.mchehab@osg.samsung.com>
References: <cover.1411956856.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This field is not used on this driver anymore. Remove it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 9682c52d67d1..65a456d2f454 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1047,7 +1047,7 @@ static void em28xx_unregister_dvb(struct em28xx_dvb *dvb)
 
 static int em28xx_dvb_init(struct em28xx *dev)
 {
-	int result = 0, mfe_shared = 0;
+	int result = 0;
 	struct em28xx_dvb *dvb;
 
 	if (dev->is_audio_only) {
@@ -1624,9 +1624,6 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	if (result < 0)
 		goto out_free;
 
-	/* MFE lock */
-	dvb->adapter.mfe_shared = mfe_shared;
-
 	em28xx_info("DVB extension successfully initialized\n");
 
 	kref_get(&dev->ref);
-- 
1.9.3

