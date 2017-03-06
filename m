Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:64295 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753210AbdCFOY4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Mar 2017 09:24:56 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-media@vger.kernel.org, devel@linuxdriverproject.org,
        linux-pci@vger.kernel.org, linux-s390@vger.kernel.org,
        fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, devel@driverdev.osuosl.org,
        target-devel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, peterz@infradead.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Windsor <dwindsor@gmail.com>
Subject: [PATCH 23/29] drivers: convert vme_user_vma_priv.refcnt from atomic_t to refcount_t
Date: Mon,  6 Mar 2017 16:21:10 +0200
Message-Id: <1488810076-3754-24-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
References: <1488810076-3754-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 drivers/staging/vme/devices/vme_user.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 69e9a770..a3d4610 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -17,7 +17,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/cdev.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -118,7 +118,7 @@ static const int type[VME_DEVS] = {	MASTER_MINOR,	MASTER_MINOR,
 
 struct vme_user_vma_priv {
 	unsigned int minor;
-	atomic_t refcnt;
+	refcount_t refcnt;
 };
 
 static ssize_t resource_to_user(int minor, char __user *buf, size_t count,
@@ -430,7 +430,7 @@ static void vme_user_vm_open(struct vm_area_struct *vma)
 {
 	struct vme_user_vma_priv *vma_priv = vma->vm_private_data;
 
-	atomic_inc(&vma_priv->refcnt);
+	refcount_inc(&vma_priv->refcnt);
 }
 
 static void vme_user_vm_close(struct vm_area_struct *vma)
@@ -438,7 +438,7 @@ static void vme_user_vm_close(struct vm_area_struct *vma)
 	struct vme_user_vma_priv *vma_priv = vma->vm_private_data;
 	unsigned int minor = vma_priv->minor;
 
-	if (!atomic_dec_and_test(&vma_priv->refcnt))
+	if (!refcount_dec_and_test(&vma_priv->refcnt))
 		return;
 
 	mutex_lock(&image[minor].mutex);
@@ -473,7 +473,7 @@ static int vme_user_master_mmap(unsigned int minor, struct vm_area_struct *vma)
 	}
 
 	vma_priv->minor = minor;
-	atomic_set(&vma_priv->refcnt, 1);
+	refcount_set(&vma_priv->refcnt, 1);
 	vma->vm_ops = &vme_user_vm_ops;
 	vma->vm_private_data = vma_priv;
 
-- 
2.7.4
