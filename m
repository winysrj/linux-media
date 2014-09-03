Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44313 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001AbaICUd3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:29 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 46/46] [media] cx231xx: just return 0 instead of using a var
Date: Wed,  3 Sep 2014 17:33:18 -0300
Message-Id: <548182d6e44729dbff257d48299c911955fe9e0d.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of allocating a var to store 0 and just return it,
change the code to return 0 directly.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 2adfecf70236..6c7b5e250eed 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -403,8 +403,6 @@ static int attach_xc5000(u8 addr, struct cx231xx *dev)
 
 int cx231xx_set_analog_freq(struct cx231xx *dev, u32 freq)
 {
-	int status = 0;
-
 	if ((dev->dvb != NULL) && (dev->dvb->frontend != NULL)) {
 
 		struct dvb_tuner_ops *dops = &dev->dvb->frontend->ops.tuner_ops;
@@ -423,7 +421,7 @@ int cx231xx_set_analog_freq(struct cx231xx *dev, u32 freq)
 
 	}
 
-	return status;
+	return 0;
 }
 
 int cx231xx_reset_analog_tuner(struct cx231xx *dev)
-- 
1.9.3

