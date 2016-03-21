Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:54597 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409AbcCUNal (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 09:30:41 -0400
Subject: [PATCH 5/6] drivers/media/media-device: add "release" callback
From: Max Kellermann <max@duempel.org>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Date: Mon, 21 Mar 2016 14:30:38 +0100
Message-ID: <145856703865.21117.13877102672522214541.stgit@woodpecker.blarg.de>
In-Reply-To: <145856701730.21117.7759662061999658129.stgit@woodpecker.blarg.de>
References: <145856701730.21117.7759662061999658129.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow the client to free its data structures only after all files have
been closed (fixing use-after-free bugs).

Signed-off-by: Max Kellermann <max@duempel.org>
---
 drivers/media/media-device.c |    9 +++++++--
 include/media/media-device.h |    2 ++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 5c4669c..a3901f9 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -551,9 +551,14 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
  * Registration/unregistration
  */
 
-static void media_device_release(struct media_devnode *mdev)
+static void media_device_release(struct media_devnode *devnode)
 {
-	dev_dbg(mdev->parent, "Media device released\n");
+	struct media_device *mdev = to_media_device(devnode);
+
+	dev_dbg(devnode->parent, "Media device released\n");
+
+	if (mdev->release)
+		mdev->release(mdev);
 }
 
 /**
diff --git a/include/media/media-device.h b/include/media/media-device.h
index d385589..d184d0c 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -326,6 +326,8 @@ struct media_device {
 
 	int (*link_notify)(struct media_link *link, u32 flags,
 			   unsigned int notification);
+
+	void (*release)(struct media_device *mdev);
 };
 
 #ifdef CONFIG_MEDIA_CONTROLLER

