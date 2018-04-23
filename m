Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:55784 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754984AbeDWLCr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 07:02:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] media: em28xx: Don't use ops->resume if NULL
Date: Mon, 23 Apr 2018 07:02:39 -0400
Message-Id: <875ca4eae7623e3f54acb2fd364404491b78951d.1524481357.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changeset  be7fd3c3a8c5 ("media: em28xx: Hauppauge DualHD
second tuner functionality") introduced a potential NULL pointer
dereference, as pointed by Coverity:

CID 1434731 (#1 of 1): Dereference after null check (FORWARD_NULL)16. var_deref_op: Dereferencing null pointer ops->resume.

var_compare_op: Comparing ops->resume to null implies that ops->resume might be null.
1174                if (ops->resume)
1175                        ops->resume(dev);
1176                if (dev->dev_next)
1177                        ops->resume(dev->dev_next);

Fixes: be7fd3c3a8c5 ("media: em28xx: Hauppauge DualHD second tuner functionality")
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 36d341fb65dd..0cefd29184f6 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -1171,8 +1171,9 @@ int em28xx_resume_extension(struct em28xx *dev)
 	dev_info(&dev->intf->dev, "Resuming extensions\n");
 	mutex_lock(&em28xx_devlist_mutex);
 	list_for_each_entry(ops, &em28xx_extension_devlist, next) {
-		if (ops->resume)
-			ops->resume(dev);
+		if (!ops->resume)
+			continue;
+		ops->resume(dev);
 		if (dev->dev_next)
 			ops->resume(dev->dev_next);
 	}
-- 
2.14.3
