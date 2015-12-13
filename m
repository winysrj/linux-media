Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38525 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbbLMLB7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2015 06:01:59 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 3/4] [media] media-devnode: move kernel-doc documentation to the header
Date: Sun, 13 Dec 2015 09:01:42 -0200
Message-Id: <25e821c6161f23c389980e03c6cc6d9ea4671e78.1450004500.git.mchehab@osg.samsung.com>
In-Reply-To: <fdbcf0a3ea104306c7532b304c71edc606def019.1450004500.git.mchehab@osg.samsung.com>
References: <fdbcf0a3ea104306c7532b304c71edc606def019.1450004500.git.mchehab@osg.samsung.com>
In-Reply-To: <fdbcf0a3ea104306c7532b304c71edc606def019.1450004500.git.mchehab@osg.samsung.com>
References: <fdbcf0a3ea104306c7532b304c71edc606def019.1450004500.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we're using the headers file only for documentation, move the
two kernel-doc macros to the header, and fix it to avoid
warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-devnode.c | 24 ------------------------
 include/media/media-devnode.h | 27 +++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index ebf9626e5ae5..cea35bf20011 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -217,20 +217,6 @@ static const struct file_operations media_devnode_fops = {
 	.llseek = no_llseek,
 };
 
-/**
- * media_devnode_register - register a media device node
- * @mdev: media device node structure we want to register
- *
- * The registration code assigns minor numbers and registers the new device node
- * with the kernel. An error is returned if no free minor number can be found,
- * or if the registration of the device node fails.
- *
- * Zero is returned on success.
- *
- * Note that if the media_devnode_register call fails, the release() callback of
- * the media_devnode structure is *not* called, so the caller is responsible for
- * freeing any data.
- */
 int __must_check media_devnode_register(struct media_devnode *mdev,
 					struct module *owner)
 {
@@ -285,16 +271,6 @@ error:
 	return ret;
 }
 
-/**
- * media_devnode_unregister - unregister a media device node
- * @mdev: the device node to unregister
- *
- * This unregisters the passed device. Future open calls will be met with
- * errors.
- *
- * This function can safely be called if the device node has never been
- * registered or has already been unregistered.
- */
 void media_devnode_unregister(struct media_devnode *mdev)
 {
 	/* Check if mdev was ever registered at all */
diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index 17ddae32060d..77e9d3159be8 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -86,8 +86,35 @@ struct media_devnode {
 /* dev to media_devnode */
 #define to_media_devnode(cd) container_of(cd, struct media_devnode, dev)
 
+/**
+ * media_devnode_register - register a media device node
+ *
+ * @mdev: media device node structure we want to register
+ * @owner: should be filled with %THIS_MODULE
+ *
+ * The registration code assigns minor numbers and registers the new device node
+ * with the kernel. An error is returned if no free minor number can be found,
+ * or if the registration of the device node fails.
+ *
+ * Zero is returned on success.
+ *
+ * Note that if the media_devnode_register call fails, the release() callback of
+ * the media_devnode structure is *not* called, so the caller is responsible for
+ * freeing any data.
+ */
 int __must_check media_devnode_register(struct media_devnode *mdev,
 					struct module *owner);
+
+/**
+ * media_devnode_unregister - unregister a media device node
+ * @mdev: the device node to unregister
+ *
+ * This unregisters the passed device. Future open calls will be met with
+ * errors.
+ *
+ * This function can safely be called if the device node has never been
+ * registered or has already been unregistered.
+ */
 void media_devnode_unregister(struct media_devnode *mdev);
 
 static inline struct media_devnode *media_devnode_data(struct file *filp)
-- 
2.5.0

