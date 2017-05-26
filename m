Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:38418 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1162059AbdEZP27 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 11:28:59 -0400
Subject: [PATCH 07/11] atomisp: unify sh_css_hmm_buffer_record_acquire
From: Alan Cox <alan@llwyncelyn.cymru>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Date: Fri, 26 May 2017 16:28:55 +0100
Message-ID: <149581252725.17585.2685663207522962401.stgit@builder>
In-Reply-To: <149581243155.17585.8164899156710160858.stgit@builder>
References: <149581243155.17585.8164899156710160858.stgit@builder>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ISP2401 version of this function returns a pointer to the buffer, whilst
the ISP2400 version returns a boolean if a slot is found. We can trivially
unify the code to use the ISP2401 version.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |   40 ++------------------
 1 file changed, 3 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 4f3a2ea..8e1cd12 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -375,13 +375,8 @@ sh_css_hmm_buffer_record_uninit(void);
 static void
 sh_css_hmm_buffer_record_reset(struct sh_css_hmm_buffer_record *buffer_record);
 
-#ifndef ISP2401
-static bool
-sh_css_hmm_buffer_record_acquire(struct ia_css_rmgr_vbuf_handle *h_vbuf,
-#else
 static struct sh_css_hmm_buffer_record
 *sh_css_hmm_buffer_record_acquire(struct ia_css_rmgr_vbuf_handle *h_vbuf,
-#endif
 			enum ia_css_buffer_type type,
 			hrt_address kernel_ptr);
 
@@ -4423,21 +4418,9 @@ ia_css_pipe_enqueue_buffer(struct ia_css_pipe *pipe,
 	}
 
 	if (return_err == IA_CSS_SUCCESS) {
-#ifndef ISP2401
-		bool found_record = false;
-		found_record = sh_css_hmm_buffer_record_acquire(
-#else
-		struct sh_css_hmm_buffer_record *hmm_buffer_record = NULL;
-
-		hmm_buffer_record = sh_css_hmm_buffer_record_acquire(
-#endif
-					h_vbuf, buf_type,
-					HOST_ADDRESS(ddr_buffer.kernel_ptr));
-#ifndef ISP2401
-		if (found_record == true) {
-#else
-		if (hmm_buffer_record) {
-#endif
+		if (sh_css_hmm_buffer_record_acquire(
+				h_vbuf, buf_type,
+				HOST_ADDRESS(ddr_buffer.kernel_ptr))) {
 			IA_CSS_LOG("send vbuf=%p", h_vbuf);
 		} else {
 			return_err = IA_CSS_ERR_INTERNAL_ERROR;
@@ -11139,23 +11122,14 @@ sh_css_hmm_buffer_record_reset(struct sh_css_hmm_buffer_record *buffer_record)
 	buffer_record->kernel_ptr = 0;
 }
 
-#ifndef ISP2401
-static bool
-sh_css_hmm_buffer_record_acquire(struct ia_css_rmgr_vbuf_handle *h_vbuf,
-#else
 static struct sh_css_hmm_buffer_record
 *sh_css_hmm_buffer_record_acquire(struct ia_css_rmgr_vbuf_handle *h_vbuf,
-#endif
 			enum ia_css_buffer_type type,
 			hrt_address kernel_ptr)
 {
 	int i;
 	struct sh_css_hmm_buffer_record *buffer_record = NULL;
-#ifndef ISP2401
-	bool found_record = false;
-#else
 	struct sh_css_hmm_buffer_record *out_buffer_record = NULL;
-#endif
 
 	assert(h_vbuf != NULL);
 	assert((type > IA_CSS_BUFFER_TYPE_INVALID) && (type < IA_CSS_NUM_DYNAMIC_BUFFER_TYPE));
@@ -11168,21 +11142,13 @@ static struct sh_css_hmm_buffer_record
 			buffer_record->type = type;
 			buffer_record->h_vbuf = h_vbuf;
 			buffer_record->kernel_ptr = kernel_ptr;
-#ifndef ISP2401
-			found_record = true;
-#else
 			out_buffer_record = buffer_record;
-#endif
 			break;
 		}
 		buffer_record++;
 	}
 
-#ifndef ISP2401
-	return found_record;
-#else
 	return out_buffer_record;
-#endif
 }
 
 static struct sh_css_hmm_buffer_record
