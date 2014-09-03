Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44414 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165AbaICUdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 23/46] [media] au0828-dvb: use true/false for boolean vars
Date: Wed,  3 Sep 2014 17:32:55 -0300
Message-Id: <93ece0fa7c5d5fa11c35a5508dfef38a1a78d3e2.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using 0 or 1 for boolean, use the true/false
defines.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index 4bd9d687d2d6..00ab1563d142 100644
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -630,7 +630,7 @@ void au0828_dvb_suspend(struct au0828_dev *dev)
 			stop_urb_transfer(dev);
 			au0828_stop_transport(dev, 1);
 			mutex_unlock(&dvb->lock);
-			dev->need_urb_start = 1;
+			dev->need_urb_start = true;
 		}
 		/* suspend frontend - does tuner and fe to sleep */
 		rc = dvb_frontend_suspend(dvb->frontend);
-- 
1.9.3

