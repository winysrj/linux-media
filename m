Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40442 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbaKEM2G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Nov 2014 07:28:06 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [PATCH] [media] rc-main: Fix rc_type handling
Date: Wed,  5 Nov 2014 10:27:52 -0200
Message-Id: <fb9b1641ba30385e1c142ecef2b631d31a881fd1.1415190468.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/rc/rc-main.c:1426 rc_register_device() warn: should '1 << rc_map->rc_type' be a 64 bit type?

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 296de853a25d..66eabc5dd000 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1423,7 +1423,7 @@ int rc_register_device(struct rc_dev *dev)
 	}
 
 	if (dev->change_protocol) {
-		u64 rc_type = (1 << rc_map->rc_type);
+		u64 rc_type = (1ll << rc_map->rc_type);
 		rc = dev->change_protocol(dev, &rc_type);
 		if (rc < 0)
 			goto out_raw;
-- 
1.9.3

