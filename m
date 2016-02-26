Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:56838 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbcBZP0H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2016 10:26:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] saa7134: fix warning with !MEDIA_CONTROLLER
Date: Fri, 26 Feb 2016 16:25:17 +0100
Message-Id: <1456500332-2565063-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When CONFIG_MEDIA_CONTROLLER is disabled, we get a warning
about an unused function:

drivers/media/pci/saa7134/saa7134-core.c:832:13: error: 'saa7134_create_entities' defined but not used [-Werror=unused-function]

This moves the #ifdef outside of the function, as it is
never called here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: ac90aa02d5b9 ("[media] saa7134: add media controller support")
---
 drivers/media/pci/saa7134/saa7134-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 42bc4172febd..9c7876bff7c3 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -829,9 +829,9 @@ static void saa7134_media_release(struct saa7134_dev *dev)
 #endif
 }
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
 static void saa7134_create_entities(struct saa7134_dev *dev)
 {
-#if defined(CONFIG_MEDIA_CONTROLLER)
 	int ret, i;
 	struct media_entity *entity;
 	struct media_entity *decoder = NULL;
@@ -950,8 +950,8 @@ static void saa7134_create_entities(struct saa7134_dev *dev)
 		if (ret < 0)
 			pr_err("failed to register input entity %d!\n", i);
 	}
-#endif
 }
+#endif
 
 static struct video_device *vdev_init(struct saa7134_dev *dev,
 				      struct video_device *template,
-- 
2.7.0

