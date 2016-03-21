Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:33195 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756129AbcCUNak (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 09:30:40 -0400
Subject: [PATCH 3/6] drivers/media/media-devnode: clear private_data before
 put_device()
From: Max Kellermann <max@duempel.org>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Date: Mon, 21 Mar 2016 14:30:28 +0100
Message-ID: <145856702799.21117.16071591313990261661.stgit@woodpecker.blarg.de>
In-Reply-To: <145856701730.21117.7759662061999658129.stgit@woodpecker.blarg.de>
References: <145856701730.21117.7759662061999658129.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Callbacks invoked from put_device() may free the struct media_devnode
pointer, so any cleanup needs to be done before put_device().

Signed-off-by: Max Kellermann <max@duempel.org>
---
 drivers/media/media-devnode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 4d7e8dd..e263816 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -196,10 +196,11 @@ static int media_release(struct inode *inode, struct file *filp)
 	if (mdev->fops->release)
 		mdev->fops->release(filp);
 
+	filp->private_data = NULL;
+
 	/* decrease the refcount unconditionally since the release()
 	   return value is ignored. */
 	put_device(&mdev->dev);
-	filp->private_data = NULL;
 	return 0;
 }
 

