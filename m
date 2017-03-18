Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:34927 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751037AbdCRB5m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 21:57:42 -0400
Received: by mail-qk0-f176.google.com with SMTP id v127so77858918qkb.2
        for <linux-media@vger.kernel.org>; Fri, 17 Mar 2017 18:57:41 -0700 (PDT)
From: Laura Abbott <labbott@redhat.com>
To: Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>, arve@android.com
Cc: Laura Abbott <labbott@redhat.com>, romlem@google.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Brian Starkey <brian.starkey@arm.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-mm@kvack.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC PATCHv2 11/21] staging: android: ion: Remove duplicate ION_IOC_MAP
Date: Fri, 17 Mar 2017 17:54:43 -0700
Message-Id: <1489798493-16600-12-git-send-email-labbott@redhat.com>
In-Reply-To: <1489798493-16600-1-git-send-email-labbott@redhat.com>
References: <1489798493-16600-1-git-send-email-labbott@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


ION_IOC_MAP is the same as ION_IOC_SHARE. We really don't need two
identical interfaces. Remove it.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 drivers/staging/android/ion/compat_ion.c |  1 -
 drivers/staging/android/ion/ion-ioctl.c  |  1 -
 drivers/staging/android/uapi/ion.h       | 10 ----------
 3 files changed, 12 deletions(-)

diff --git a/drivers/staging/android/ion/compat_ion.c b/drivers/staging/android/ion/compat_ion.c
index ae1ffc3..5037ddd 100644
--- a/drivers/staging/android/ion/compat_ion.c
+++ b/drivers/staging/android/ion/compat_ion.c
@@ -144,7 +144,6 @@ long compat_ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 							(unsigned long)data);
 	}
 	case ION_IOC_SHARE:
-	case ION_IOC_MAP:
 		return filp->f_op->unlocked_ioctl(filp, cmd,
 						(unsigned long)compat_ptr(arg));
 	default:
diff --git a/drivers/staging/android/ion/ion-ioctl.c b/drivers/staging/android/ion/ion-ioctl.c
index 7b54eea..a361724 100644
--- a/drivers/staging/android/ion/ion-ioctl.c
+++ b/drivers/staging/android/ion/ion-ioctl.c
@@ -118,7 +118,6 @@ long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		break;
 	}
 	case ION_IOC_SHARE:
-	case ION_IOC_MAP:
 	{
 		struct ion_handle *handle;
 
diff --git a/drivers/staging/android/uapi/ion.h b/drivers/staging/android/uapi/ion.h
index 3a59044..abd72fd 100644
--- a/drivers/staging/android/uapi/ion.h
+++ b/drivers/staging/android/uapi/ion.h
@@ -164,16 +164,6 @@ struct ion_heap_query {
 #define ION_IOC_FREE		_IOWR(ION_IOC_MAGIC, 1, struct ion_handle_data)
 
 /**
- * DOC: ION_IOC_MAP - get a file descriptor to mmap
- *
- * Takes an ion_fd_data struct with the handle field populated with a valid
- * opaque handle.  Returns the struct with the fd field set to a file
- * descriptor open in the current address space.  This file descriptor
- * can then be used as an argument to mmap.
- */
-#define ION_IOC_MAP		_IOWR(ION_IOC_MAGIC, 2, struct ion_fd_data)
-
-/**
  * DOC: ION_IOC_SHARE - creates a file descriptor to use to share an allocation
  *
  * Takes an ion_fd_data struct with the handle field populated with a valid
-- 
2.7.4
