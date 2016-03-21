Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:33485 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076AbcCUM3L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 08:29:11 -0400
Subject: [PATCH] drivers/media/media-devnode: add missing mutex lock in
 error handler
From: Max Kellermann <max@duempel.org>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Date: Mon, 21 Mar 2016 13:29:08 +0100
Message-ID: <145856334891.11327.2502114310098245295.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All accesses to media_devnode_nums must be protected with
media_devnode_lock.  The error code path in media_devnode_register()
did not do this, however.

Signed-off-by: Max Kellermann <max@duempel.org>
---
 drivers/media/media-devnode.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index cea35bf..4d7e8dd 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -266,8 +266,11 @@ int __must_check media_devnode_register(struct media_devnode *mdev,
 	return 0;
 
 error:
+	mutex_lock(&media_devnode_lock);
 	cdev_del(&mdev->cdev);
 	clear_bit(mdev->minor, media_devnode_nums);
+	mutex_unlock(&media_devnode_lock);
+
 	return ret;
 }
 

