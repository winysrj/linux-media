Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37174 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaIXODH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 10:03:07 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Dreissig <mukadr@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Martin Kepplinger <martink@posteo.de>
Subject: [PATCH 1/4] [media] as102_drv.h: added a missing newline
Date: Wed, 24 Sep 2014 11:02:26 -0300
Message-Id: <e64ef973881ac3f5d98ee52f275a0fb9c3d07a56.1411567328.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/as102/as102_drv.h:83:6: warning: no newline at end of file

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/as102/as102_drv.h b/drivers/media/usb/as102/as102_drv.h
index 9430d30163a3..aee2d76e8dfc 100644
--- a/drivers/media/usb/as102/as102_drv.h
+++ b/drivers/media/usb/as102/as102_drv.h
@@ -80,4 +80,4 @@ struct as102_dev_t {
 int as102_dvb_register(struct as102_dev_t *dev);
 void as102_dvb_unregister(struct as102_dev_t *dev);
 
-#endif
\ No newline at end of file
+#endif
-- 
1.9.3

