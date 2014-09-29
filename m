Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48684 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbaI2CXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Sep 2014 22:23:50 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Johannes Stezenbach <js@linuxtv.org>
Subject: [PATCH 4/6] [media] em28xx-dvb: handle to stop/start streaming at PM
Date: Sun, 28 Sep 2014 23:23:21 -0300
Message-Id: <1f09f242137a6685bc83a2bbde5d56215dc9fa02.1411956856.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1411956856.git.mchehab@osg.samsung.com>
References: <cover.1411956856.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1411956856.git.mchehab@osg.samsung.com>
References: <cover.1411956856.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Before suspending, we should be stoping streaming, as it
makes no sense to deliver pending URBs after resume. Also,
we need to properly reinitialize the streaming after resume,
otherwise if suspend happens while streaming, it won't be
returning back.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 65a456d2f454..3d19607bd8f0 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1719,6 +1719,9 @@ static int em28xx_dvb_suspend(struct em28xx *dev)
 	if (dev->dvb) {
 		struct em28xx_dvb *dvb = dev->dvb;
 
+		if (dvb->nfeeds)
+			em28xx_stop_streaming(dvb);
+
 		if (dvb->fe[0]) {
 			ret = dvb_frontend_suspend(dvb->fe[0]);
 			em28xx_info("fe0 suspend %d", ret);
@@ -1755,6 +1758,9 @@ static int em28xx_dvb_resume(struct em28xx *dev)
 			ret = dvb_frontend_resume(dvb->fe[1]);
 			em28xx_info("fe1 resume %d", ret);
 		}
+
+		if (dvb->nfeeds)
+			em28xx_start_streaming(dvb);
 	}
 
 	return 0;
-- 
1.9.3

