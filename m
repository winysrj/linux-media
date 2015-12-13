Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38522 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbbLMLB7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2015 06:01:59 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 4/4] [media] media-devnode.h: document the remaining struct/functions
Date: Sun, 13 Dec 2015 09:01:43 -0200
Message-Id: <02e019793f749882df5a691ca1cd32e996561387.1450004500.git.mchehab@osg.samsung.com>
In-Reply-To: <fdbcf0a3ea104306c7532b304c71edc606def019.1450004500.git.mchehab@osg.samsung.com>
References: <fdbcf0a3ea104306c7532b304c71edc606def019.1450004500.git.mchehab@osg.samsung.com>
In-Reply-To: <fdbcf0a3ea104306c7532b304c71edc606def019.1450004500.git.mchehab@osg.samsung.com>
References: <fdbcf0a3ea104306c7532b304c71edc606def019.1450004500.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is one struct and two functions that were not documented.
Add the corresponding kernel-doc documentation for them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 include/media/media-devnode.h | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
index 77e9d3159be8..fe42f08e72bd 100644
--- a/include/media/media-devnode.h
+++ b/include/media/media-devnode.h
@@ -40,6 +40,20 @@
  */
 #define MEDIA_FLAG_REGISTERED	0
 
+/**
+ * struct media_file_operations - Media device file operations
+ *
+ * @owner: should be filled with %THIS_MODULE
+ * @read: pointer to the function that implements read() syscall
+ * @write: pointer to the function that implements write() syscall
+ * @poll: pointer to the function that implements poll() syscall
+ * @ioctl: pointer to the function that implements ioctl() syscall
+ * @compat_ioctl: pointer to the function that will handle 32 bits userspace
+ *	calls to the the ioctl() syscall on a Kernel compiled with 64 bits.
+ * @open: pointer to the function that implements open() syscall
+ * @release: pointer to the function that will release the resources allocated
+ *	by the @open function.
+ */
 struct media_file_operations {
 	struct module *owner;
 	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
@@ -53,7 +67,7 @@ struct media_file_operations {
 
 /**
  * struct media_devnode - Media device node
- * @fops:	pointer to struct media_file_operations with media device ops
+ * @fops:	pointer to struct &media_file_operations with media device ops
  * @dev:	struct device pointer for the media controller device
  * @cdev:	struct cdev pointer character device
  * @parent:	parent device
@@ -117,11 +131,22 @@ int __must_check media_devnode_register(struct media_devnode *mdev,
  */
 void media_devnode_unregister(struct media_devnode *mdev);
 
+/**
+ * media_devnode_data - returns a pointer to the &media_devnode
+ *
+ * @filp: pointer to struct &file
+ */
 static inline struct media_devnode *media_devnode_data(struct file *filp)
 {
 	return filp->private_data;
 }
 
+/**
+ * media_devnode_is_registered - returns true if &media_devnode is registered;
+ *	false otherwise.
+ *
+ * @mdev: pointer to struct &media_devnode.
+ */
 static inline int media_devnode_is_registered(struct media_devnode *mdev)
 {
 	return test_bit(MEDIA_FLAG_REGISTERED, &mdev->flags);
-- 
2.5.0

