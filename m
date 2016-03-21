Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:53333 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127AbcCUNak (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 09:30:40 -0400
Subject: [PATCH 4/6] drivers/media/media-device: move debug log before
 _devnode_unregister()
From: Max Kellermann <max@duempel.org>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Date: Mon, 21 Mar 2016 14:30:33 +0100
Message-ID: <145856703332.21117.15459001708073729441.stgit@woodpecker.blarg.de>
In-Reply-To: <145856701730.21117.7759662061999658129.stgit@woodpecker.blarg.de>
References: <145856701730.21117.7759662061999658129.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After media_devnode_unregister(), the struct media_device may be freed
already, and dereferencing it may crash.

Signed-off-by: Max Kellermann <max@duempel.org>
---
 drivers/media/media-device.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index e9219f5..5c4669c 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -745,9 +745,8 @@ void media_device_unregister(struct media_device *mdev)
 	spin_unlock(&mdev->lock);
 
 	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
+	dev_dbg(mdev->dev, "Media device unregistering\n");
 	media_devnode_unregister(&mdev->devnode);
-
-	dev_dbg(mdev->dev, "Media device unregistered\n");
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
 

