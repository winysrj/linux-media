Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:56606 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbcCWPX0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2016 11:23:26 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH] [media] s5p-tv: Fix path in Makefile comment
Date: Wed, 23 Mar 2016 12:23:13 -0300
Message-Id: <1458746593-24427-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The path mentioned in the driver's Makefile is not correct, fix it.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/platform/s5p-tv/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-tv/Makefile b/drivers/media/platform/s5p-tv/Makefile
index 7cd47902e269..39c54f18a2de 100644
--- a/drivers/media/platform/s5p-tv/Makefile
+++ b/drivers/media/platform/s5p-tv/Makefile
@@ -1,4 +1,4 @@
-# drivers/media/platform/samsung/tvout/Makefile
+# drivers/media/platform/s5p-tv/Makefile
 #
 # Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
 #	http://www.samsung.com/
-- 
2.5.0

