Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:53816 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874AbcCULdP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 07:33:15 -0400
Subject: [PATCH] drivers/media/media-devnode: add missing mutex lock in
 error handler
From: Max Kellermann <max@duempel.org>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Date: Mon, 21 Mar 2016 12:33:12 +0100
Message-ID: <145855999281.9224.17355739501867370595.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


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
 

