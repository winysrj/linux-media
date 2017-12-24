Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:42253 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751323AbdLXKnY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Dec 2017 05:43:24 -0500
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: Added missing get_user_pages_longterm
Date: Sun, 24 Dec 2017 11:43:03 +0000
Message-Id: <1514115783-12306-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Also fixed v4.8_user_pages_flag.patch.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 backports/v4.8_user_pages_flag.patch |  5 +++--
 v4l/compat.h                         | 13 +++++++++++++
 v4l/scripts/make_config_compat.pl    |  1 +
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/backports/v4.8_user_pages_flag.patch b/backports/v4.8_user_pages_flag.patch
index 82ecea2..7216626 100644
--- a/backports/v4.8_user_pages_flag.patch
+++ b/backports/v4.8_user_pages_flag.patch
@@ -33,7 +33,7 @@ index 44936d6..a61f632 100644
  
  	if (y_pages != y_dma.page_count || uv_pages != uv_dma.page_count) {
 diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
-index 1db0af6..f300f06 100644
+index f412429..323ae3a 100644
 --- a/drivers/media/v4l2-core/videobuf-dma-sg.c
 +++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
 @@ -156,7 +156,6 @@ static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
@@ -54,8 +54,9 @@ index 1db0af6..f300f06 100644
  	dprintk(1, "init user [0x%lx+0x%lx => %d pages]\n",
  		data, size, dma->nr_pages);
  
- 	err = get_user_pages(data & PAGE_MASK, dma->nr_pages,
+-	err = get_user_pages_longterm(data & PAGE_MASK, dma->nr_pages,
 -			     flags, dma->pages, NULL);
++	err = get_user_pages(data & PAGE_MASK, dma->nr_pages,
 +			     rw == READ, 1, /* force */
 +			     dma->pages, NULL);
  
diff --git a/v4l/compat.h b/v4l/compat.h
index c50e74d..c5680c3 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -2301,4 +2301,17 @@ static inline int usb_urb_ep_type_check(void *urb)
 }
 #endif
 
+/* prototype of get_user_pages changed in Kernel 4.6. For older Kernels
+ * this will not compile */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4, 6, 0)
+#ifdef NEED_GET_USER_PAGES_LONGTERM
+static inline long get_user_pages_longterm(unsigned long start,
+                unsigned long nr_pages, unsigned int gup_flags,
+                struct page **pages, struct vm_area_struct **vmas)
+{
+        return get_user_pages(start, nr_pages, gup_flags, pages, vmas);
+}
+#endif
+#endif
+
 #endif /*  _COMPAT_H */
diff --git a/v4l/scripts/make_config_compat.pl b/v4l/scripts/make_config_compat.pl
index 9e2055a..5be868a 100644
--- a/v4l/scripts/make_config_compat.pl
+++ b/v4l/scripts/make_config_compat.pl
@@ -715,6 +715,7 @@ sub check_other_dependencies()
 	check_files_for_func("time64_to_tm", "NEED_TIME64_TO_TM", "include/linux/time.h");
 	check_files_for_func("READ_ONCE", "NEED_READ_ONCE", "include/linux/compiler.h");
 	check_files_for_func("usb_urb_ep_type_check", "NEED_USB_EP_CHECK", "include/linux/usb.h");
+	check_files_for_func("get_user_pages_longterm", "NEED_GET_USER_PAGES_LONGTERM", "include/linux/mm.h");
 
 	# For tests for uapi-dependent logic
 	check_files_for_func_uapi("usb_endpoint_maxp", "NEED_USB_ENDPOINT_MAXP", "usb/ch9.h");
-- 
2.7.4
