Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35683 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752015AbdHGNpC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Aug 2017 09:45:02 -0400
From: Geliang Tang <geliangtang@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Alan Cox <alan@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: atomisp: use kvmalloc/kvzalloc
Date: Mon,  7 Aug 2017 21:44:27 +0800
Message-Id: <6718b1734dc8f657d91b37c7c59f3b709719670c.1502090593.git.geliangtang@gmail.com>
In-Reply-To: <5f901760510d0dc6e6e971d4136c8d2d4e0a13fd.1502103408.git.geliangtang@gmail.com>
References: <5f901760510d0dc6e6e971d4136c8d2d4e0a13fd.1502103408.git.geliangtang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use kvmalloc()/kvzalloc() instead of atomisp_kernel_malloc()
/atomisp_kernel_zalloc().

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_cmd.c       | 31 +---------------------
 .../media/atomisp/pci/atomisp2/atomisp_cmd.h       |  2 --
 .../atomisp/pci/atomisp2/atomisp_compat_css20.c    |  4 +--
 .../media/atomisp/pci/atomisp2/atomisp_internal.h  |  2 --
 4 files changed, 3 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 7bf5dcd..f48bf45 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -83,35 +83,6 @@ union host {
 };
 
 /*
- * atomisp_kernel_malloc: chooses whether kmalloc() or vmalloc() is preferable.
- *
- * It is also a wrap functions to pass into css framework.
- */
-void *atomisp_kernel_malloc(size_t bytes)
-{
-	/* vmalloc() is preferable if allocating more than 1 page */
-	if (bytes > PAGE_SIZE)
-		return vmalloc(bytes);
-
-	return kmalloc(bytes, GFP_KERNEL);
-}
-
-/*
- * atomisp_kernel_zalloc: chooses whether set 0 to the allocated memory.
- *
- * It is also a wrap functions to pass into css framework.
- */
-void *atomisp_kernel_zalloc(size_t bytes, bool zero_mem)
-{
-	void *ptr = atomisp_kernel_malloc(bytes);
-
-	if (ptr && zero_mem)
-		memset(ptr, 0, bytes);
-
-	return ptr;
-}
-
-/*
  * get sensor:dis71430/ov2720 related info from v4l2_subdev->priv data field.
  * subdev->priv is set in mrst.c
  */
@@ -4316,7 +4287,7 @@ int atomisp_set_parameters(struct video_device *vdev,
 		 * are ready, the parameters will be set to CSS.
 		 * per-frame setting only works for the main output frame.
 		 */
-		param = atomisp_kernel_zalloc(sizeof(*param), true);
+		param = kvzalloc(sizeof(*param), GFP_KERNEL);
 		if (!param) {
 			dev_err(asd->isp->dev, "%s: failed to alloc params buffer\n",
 				__func__);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h
index 1ccd911..31ba4e6 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h
@@ -78,8 +78,6 @@ static inline void __iomem *atomisp_get_io_virt_addr(unsigned int address)
 	return ret;
 }
 */
-void *atomisp_kernel_malloc(size_t bytes);
-void *atomisp_kernel_zalloc(size_t bytes, bool zero_mem);
 
 /*
  * Interrupt functions
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
index 36f934d..05897b7 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
@@ -1671,9 +1671,9 @@ int atomisp_alloc_metadata_output_buf(struct atomisp_sub_device *asd)
 	/* We allocate the cpu-side buffer used for communication with user
 	 * space */
 	for (i = 0; i < ATOMISP_METADATA_TYPE_NUM; i++) {
-		asd->params.metadata_user[i] = atomisp_kernel_malloc(
+		asd->params.metadata_user[i] = kvmalloc(
 				asd->stream_env[ATOMISP_INPUT_STREAM_GENERAL].
-				stream_info.metadata_info.size);
+				stream_info.metadata_info.size, GFP_KERNEL);
 		if (!asd->params.metadata_user[i]) {
 			while (--i >= 0) {
 				kvfree(asd->params.metadata_user[i]);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
index 4b03f28..7542a72f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
@@ -301,8 +301,6 @@ struct atomisp_device {
 
 extern struct device *atomisp_dev;
 
-extern void *atomisp_kernel_malloc(size_t bytes);
-
 #define atomisp_is_wdt_running(a) timer_pending(&(a)->wdt)
 #ifdef ISP2401
 extern void atomisp_wdt_refresh_pipe(struct atomisp_video_pipe *pipe,
-- 
2.9.3
