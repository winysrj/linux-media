Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36858 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754455AbdGJT1O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 15:27:14 -0400
Date: Mon, 10 Jul 2017 15:27:28 -0400
From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: media: atomisp: Use kvfree() instead of
 kfree()/vfree()
Message-ID: <20170710192728.GA12140@amitoj-Inspiron-3542>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Conditionally calling kfree()/vfree() can be replaced by a call to
kvfree() which handles both kmalloced memory and vmalloced memory.
The resulting wrapper function has been replaced with direct calls
to kvfree().

This change was made with the help of the following Coccinelle 
semantic patch:
//<smpl>
@@
expression a;
@@
- if(...) { vfree(a); }
- else { kfree(a); }
+ kvfree(a);
// </smpl>

Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
---
Changes in v2:
	-Remove wrapper function

 .../staging/media/atomisp/pci/atomisp2/atomisp_cmd.c  | 19 +++----------------
 .../staging/media/atomisp/pci/atomisp2/atomisp_cmd.h  |  1 -
 .../media/atomisp/pci/atomisp2/atomisp_compat_css20.c |  4 ++--
 .../media/atomisp/pci/atomisp2/atomisp_internal.h     |  2 --
 4 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 97093ba..7bf5dcd 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -112,19 +112,6 @@ void *atomisp_kernel_zalloc(size_t bytes, bool zero_mem)
 }
 
 /*
- * Free buffer allocated with atomisp_kernel_malloc()/atomisp_kernel_zalloc
- * helper
- */
-void atomisp_kernel_free(void *ptr)
-{
-	/* Verify if buffer was allocated by vmalloc() or kmalloc() */
-	if (is_vmalloc_addr(ptr))
-		vfree(ptr);
-	else
-		kfree(ptr);
-}
-
-/*
  * get sensor:dis71430/ov2720 related info from v4l2_subdev->priv data field.
  * subdev->priv is set in mrst.c
  */
@@ -785,7 +772,7 @@ void atomisp_flush_params_queue(struct atomisp_video_pipe *pipe)
 				   struct atomisp_css_params_with_list, list);
 		list_del(&param->list);
 		atomisp_free_css_parameters(&param->params);
-		atomisp_kernel_free(param);
+		kvfree(param);
 	}
 }
 
@@ -1132,7 +1119,7 @@ void atomisp_buf_done(struct atomisp_sub_device *asd, int error,
 				asd->params.dvs_6axis = NULL;
 			atomisp_free_css_parameters(
 				&pipe->frame_params[vb->i]->params);
-			atomisp_kernel_free(pipe->frame_params[vb->i]);
+			kvfree(pipe->frame_params[vb->i]);
 			pipe->frame_params[vb->i] = NULL;
 		}
 
@@ -4375,7 +4362,7 @@ int atomisp_set_parameters(struct video_device *vdev,
 	if (css_param)
 		atomisp_free_css_parameters(css_param);
 	if (param)
-		atomisp_kernel_free(param);
+		kvfree(param);
 
 	return ret;
 }
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h
index 8e6d9df..1ccd911 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h
@@ -80,7 +80,6 @@ static inline void __iomem *atomisp_get_io_virt_addr(unsigned int address)
 */
 void *atomisp_kernel_malloc(size_t bytes);
 void *atomisp_kernel_zalloc(size_t bytes, bool zero_mem);
-void atomisp_kernel_free(void *ptr);
 
 /*
  * Interrupt functions
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
index b830b24..2b6d7bb 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
@@ -1676,7 +1676,7 @@ int atomisp_alloc_metadata_output_buf(struct atomisp_sub_device *asd)
 				stream_info.metadata_info.size);
 		if (!asd->params.metadata_user[i]) {
 			while (--i >= 0) {
-				atomisp_kernel_free(asd->params.metadata_user[i]);
+				kvfree(asd->params.metadata_user[i]);
 				asd->params.metadata_user[i] = NULL;
 			}
 			return -ENOMEM;
@@ -1692,7 +1692,7 @@ void atomisp_free_metadata_output_buf(struct atomisp_sub_device *asd)
 
 	for (i = 0; i < ATOMISP_METADATA_TYPE_NUM; i++) {
 		if (asd->params.metadata_user[i]) {
-			atomisp_kernel_free(asd->params.metadata_user[i]);
+			kvfree(asd->params.metadata_user[i]);
 			asd->params.metadata_user[i] = NULL;
 		}
 	}
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
index d366713..afced4f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
@@ -312,8 +312,6 @@ extern struct device *atomisp_dev;
 
 extern void *atomisp_kernel_malloc(size_t bytes);
 
-extern void atomisp_kernel_free(void *ptr);
-
 #define atomisp_is_wdt_running(a) timer_pending(&(a)->wdt)
 #ifdef ISP2401
 extern void atomisp_wdt_refresh_pipe(struct atomisp_video_pipe *pipe,
-- 
2.7.4
