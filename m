Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:34856 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753296AbcJKXut (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 19:50:49 -0400
Received: by mail-pf0-f174.google.com with SMTP id s8so9420546pfj.2
        for <linux-media@vger.kernel.org>; Tue, 11 Oct 2016 16:50:49 -0700 (PDT)
From: Ruchi Kandoi <kandoiruchi@google.com>
To: kandoiruchi@google.com, gregkh@linuxfoundation.org,
        arve@android.com, riandrews@android.com, sumit.semwal@linaro.org,
        arnd@arndb.de, labbott@redhat.com, viro@zeniv.linux.org.uk,
        jlayton@poochiereds.net, bfields@fieldses.org, mingo@redhat.com,
        peterz@infradead.org, akpm@linux-foundation.org,
        keescook@chromium.org, mhocko@suse.com, oleg@redhat.com,
        john.stultz@linaro.org, mguzik@redhat.com, jdanis@google.com,
        adobriyan@gmail.com, ghackmann@google.com,
        kirill.shutemov@linux.intel.com, vbabka@suse.cz,
        dave.hansen@linux.intel.com, dan.j.williams@intel.com,
        hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, luto@kernel.org,
        tj@kernel.org, vdavydov.dev@gmail.com, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC 6/6] drivers: staging: ion: add ION_IOC_TAG ioctl
Date: Tue, 11 Oct 2016 16:50:10 -0700
Message-Id: <1476229810-26570-7-git-send-email-kandoiruchi@google.com>
In-Reply-To: <1476229810-26570-1-git-send-email-kandoiruchi@google.com>
References: <1476229810-26570-1-git-send-email-kandoiruchi@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Greg Hackmann <ghackmann@google.com>

ION_IOC_TAG provides a userspace interface for tagging buffers with
their memtrack usage after allocation.

Signed-off-by: Ruchi Kandoi <kandoiruchi@google.com>
---
 drivers/staging/android/ion/ion-ioctl.c | 17 +++++++++++++++++
 drivers/staging/android/uapi/ion.h      | 25 +++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/drivers/staging/android/ion/ion-ioctl.c b/drivers/staging/android/ion/ion-ioctl.c
index 7e7431d..8745a85 100644
--- a/drivers/staging/android/ion/ion-ioctl.c
+++ b/drivers/staging/android/ion/ion-ioctl.c
@@ -28,6 +28,7 @@ union ion_ioctl_arg {
 	struct ion_handle_data handle;
 	struct ion_custom_data custom;
 	struct ion_heap_query query;
+	struct ion_tag_data tag;
 };
 
 static int validate_ioctl_arg(unsigned int cmd, union ion_ioctl_arg *arg)
@@ -162,6 +163,22 @@ long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case ION_IOC_HEAP_QUERY:
 		ret = ion_query_heaps(client, &data.query);
 		break;
+	case ION_IOC_TAG:
+	{
+#ifdef CONFIG_MEMTRACK
+		struct ion_handle *handle;
+
+		handle = ion_handle_get_by_id(client, data.tag.handle);
+		if (IS_ERR(handle))
+			return PTR_ERR(handle);
+		data.tag.tag[sizeof(data.tag.tag) - 1] = 0;
+		memtrack_buffer_set_tag(&handle->buffer->memtrack_buffer,
+					data.tag.tag);
+#else
+		ret = -ENOTTY;
+#endif
+		break;
+	}
 	default:
 		return -ENOTTY;
 	}
diff --git a/drivers/staging/android/uapi/ion.h b/drivers/staging/android/uapi/ion.h
index 14cd873..4c26196 100644
--- a/drivers/staging/android/uapi/ion.h
+++ b/drivers/staging/android/uapi/ion.h
@@ -115,6 +115,22 @@ struct ion_handle_data {
 	ion_user_handle_t handle;
 };
 
+#define ION_MAX_TAG_LEN 32
+
+/**
+ * struct ion_fd_data - metadata passed from userspace for a handle
+ * @handle:	a handle
+ * @tag: a string describing the buffer
+ *
+ * For ION_IOC_TAG userspace populates the handle field with
+ * the handle returned from ion alloc and type contains the memtrack_type which
+ * accurately describes the usage for the memory.
+ */
+struct ion_tag_data {
+	ion_user_handle_t handle;
+	char tag[ION_MAX_TAG_LEN];
+};
+
 /**
  * struct ion_custom_data - metadata passed to/from userspace for a custom ioctl
  * @cmd:	the custom ioctl function to call
@@ -217,6 +233,15 @@ struct ion_heap_query {
 #define ION_IOC_SYNC		_IOWR(ION_IOC_MAGIC, 7, struct ion_fd_data)
 
 /**
+ * DOC: ION_IOC_TAG - adds a memtrack descriptor tag to memory
+ *
+ * Takes an ion_tag_data struct with the type field populated with a
+ * memtrack_type and handle populated with a valid opaque handle. The
+ * memtrack_type should accurately define the usage for the memory.
+ */
+#define ION_IOC_TAG		_IOWR(ION_IOC_MAGIC, 8, struct ion_tag_data)
+
+/**
  * DOC: ION_IOC_CUSTOM - call architecture specific ion ioctl
  *
  * Takes the argument of the architecture specific ioctl to call and
-- 
2.8.0.rc3.226.g39d4020

