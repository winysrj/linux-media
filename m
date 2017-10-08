Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33389 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753231AbdJHJXl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 8 Oct 2017 05:23:41 -0400
Date: Sun, 8 Oct 2017 14:53:34 +0530
From: Aishwarya Pant <aishpant@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: outreachy-kernel@googlegroups.com
Subject: [PATCH 1/2] staging: atomisp2: cleanup null check on memory
 allocation
Message-ID: <35e972912620b2ac4bdbde17bb0e0e8cb40f4f70.1507454423.git.aishpant@gmail.com>
References: <cover.1507454423.git.aishpant@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1507454423.git.aishpant@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For memory allocation functions that fail with a NULL return value, it
is preferred to use the (!x) test in place of (x == NULL).

Changes in atomisp2/css2400/sh_css.c were done by hand.

Done with the help of the following cocci script:

@@
type T;
T* p;
statement s,s1;
@@

p =
  \(devm_kzalloc\|devm_ioremap\|usb_alloc_urb\|alloc_netdev\|dev_alloc_skb\|
   kmalloc\|kmalloc_array\|kzalloc\|kcalloc\|kmem_cache_alloc\|kmem_cache_zalloc\|
   kmem_cache_alloc_node\|kmalloc_node\|kzalloc_node\|devm_kzalloc\)(...)
...when != p

if (
- p == NULL
+ !p
 ) s
 else s1

Signed-off-by: Aishwarya Pant <aishpant@gmail.com>

--
Changes in atomisp2/css2400/sh_css.c were done by hand, the above script
was not able to match the pattern if (a->b != null).
---
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    | 36 +++++++++++-----------
 .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c |  6 ++--
 .../pci/atomisp2/css2400/sh_css_param_shading.c    |  2 +-
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index e882b5596813..56de641d8848 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -5607,13 +5607,13 @@ static enum ia_css_err load_video_binaries(struct ia_css_pipe *pipe)
 		mycs->num_yuv_scaler = cas_scaler_descr.num_stage;
 		mycs->yuv_scaler_binary = kzalloc(cas_scaler_descr.num_stage *
 			sizeof(struct ia_css_binary), GFP_KERNEL);
-		if (mycs->yuv_scaler_binary == NULL) {
+		if (!mycs->yuv_scaler_binary) {
 			err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 			return err;
 		}
 		mycs->is_output_stage = kzalloc(cas_scaler_descr.num_stage
 					* sizeof(bool), GFP_KERNEL);
-		if (mycs->is_output_stage == NULL) {
+		if (!mycs->is_output_stage) {
 			err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 			return err;
 		}
@@ -6258,14 +6258,14 @@ static enum ia_css_err load_primary_binaries(
 		mycs->num_yuv_scaler = cas_scaler_descr.num_stage;
 		mycs->yuv_scaler_binary = kzalloc(cas_scaler_descr.num_stage *
 			sizeof(struct ia_css_binary), GFP_KERNEL);
-		if (mycs->yuv_scaler_binary == NULL) {
+		if (!mycs->yuv_scaler_binary) {
 			err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 			IA_CSS_LEAVE_ERR_PRIVATE(err);
 			return err;
 		}
 		mycs->is_output_stage = kzalloc(cas_scaler_descr.num_stage *
 			sizeof(bool), GFP_KERNEL);
-		if (mycs->is_output_stage == NULL) {
+		if (!mycs->is_output_stage) {
 			err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 			IA_CSS_LEAVE_ERR_PRIVATE(err);
 			return err;
@@ -6982,27 +6982,27 @@ static enum ia_css_err ia_css_pipe_create_cas_scaler_desc_single_output(
 	}
 
 	descr->in_info = kmalloc(descr->num_stage * sizeof(struct ia_css_frame_info), GFP_KERNEL);
-	if (descr->in_info == NULL) {
+	if (!descr->in_info) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
 	}
 	descr->internal_out_info = kmalloc(descr->num_stage * sizeof(struct ia_css_frame_info), GFP_KERNEL);
-	if (descr->internal_out_info == NULL) {
+	if (!descr->internal_out_info) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
 	}
 	descr->out_info = kmalloc(descr->num_stage * sizeof(struct ia_css_frame_info), GFP_KERNEL);
-	if (descr->out_info == NULL) {
+	if (!descr->out_info) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
 	}
 	descr->vf_info = kmalloc(descr->num_stage * sizeof(struct ia_css_frame_info), GFP_KERNEL);
-	if (descr->vf_info == NULL) {
+	if (!descr->vf_info) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
 	}
 	descr->is_output_stage = kmalloc(descr->num_stage * sizeof(bool), GFP_KERNEL);
-	if (descr->is_output_stage == NULL) {
+	if (!descr->is_output_stage) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
 	}
@@ -7118,22 +7118,22 @@ static enum ia_css_err ia_css_pipe_create_cas_scaler_desc(struct ia_css_pipe *pi
 	descr->num_stage = num_stages;
 
 	descr->in_info = kmalloc(descr->num_stage * sizeof(struct ia_css_frame_info), GFP_KERNEL);
-	if (descr->in_info == NULL) {
+	if (!descr->in_info) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
 	}
 	descr->internal_out_info = kmalloc(descr->num_stage * sizeof(struct ia_css_frame_info), GFP_KERNEL);
-	if (descr->internal_out_info == NULL) {
+	if (!descr->internal_out_info) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
 	}
 	descr->out_info = kmalloc(descr->num_stage * sizeof(struct ia_css_frame_info), GFP_KERNEL);
-	if (descr->out_info == NULL) {
+	if (!descr->out_info) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
 	}
 	descr->vf_info = kmalloc(descr->num_stage * sizeof(struct ia_css_frame_info), GFP_KERNEL);
-	if (descr->vf_info == NULL) {
+	if (!descr->vf_info) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
 	}
@@ -7276,13 +7276,13 @@ load_yuvpp_binaries(struct ia_css_pipe *pipe)
 		mycs->num_yuv_scaler = cas_scaler_descr.num_stage;
 		mycs->yuv_scaler_binary = kzalloc(cas_scaler_descr.num_stage *
 			sizeof(struct ia_css_binary), GFP_KERNEL);
-		if (mycs->yuv_scaler_binary == NULL) {
+		if (!mycs->yuv_scaler_binary) {
 			err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 			goto ERR;
 		}
 		mycs->is_output_stage = kzalloc(cas_scaler_descr.num_stage *
 			sizeof(bool), GFP_KERNEL);
-		if (mycs->is_output_stage == NULL) {
+		if (!mycs->is_output_stage) {
 			err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 			goto ERR;
 		}
@@ -7383,7 +7383,7 @@ load_yuvpp_binaries(struct ia_css_pipe *pipe)
 	}
 	mycs->vf_pp_binary = kzalloc(mycs->num_vf_pp * sizeof(struct ia_css_binary),
 						GFP_KERNEL);
-	if (mycs->vf_pp_binary == NULL) {
+	if (!mycs->vf_pp_binary) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		goto ERR;
 	}
@@ -9445,7 +9445,7 @@ ia_css_stream_create(const struct ia_css_stream_config *stream_config,
 
 	/* allocate the stream instance */
 	curr_stream = kmalloc(sizeof(struct ia_css_stream), GFP_KERNEL);
-	if (curr_stream == NULL) {
+	if (!curr_stream) {
 		err = IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 		IA_CSS_LEAVE_ERR(err);
 		return err;
@@ -9457,7 +9457,7 @@ ia_css_stream_create(const struct ia_css_stream_config *stream_config,
 	/* allocate pipes */
 	curr_stream->num_pipes = num_pipes;
 	curr_stream->pipes = kzalloc(num_pipes * sizeof(struct ia_css_pipe *), GFP_KERNEL);
-	if (curr_stream->pipes == NULL) {
+	if (!curr_stream->pipes) {
 		curr_stream->num_pipes = 0;
 		kfree(curr_stream);
 		curr_stream = NULL;
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
index 53a7891111f9..ec026b8d6756 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
@@ -147,7 +147,7 @@ sh_css_load_blob_info(const char *fw, const struct ia_css_fw_info *bi, struct ia
 
 		char *parambuf = kmalloc(paramstruct_size + configstruct_size + statestruct_size,
 					 GFP_KERNEL);
-		if (parambuf == NULL)
+		if (!parambuf)
 			return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 
 		bd->mem_offsets.array[IA_CSS_PARAM_CLASS_PARAM].ptr = NULL;
@@ -229,14 +229,14 @@ sh_css_load_firmware(const char *fw_data,
 		sh_css_blob_info = kmalloc(
 					(sh_css_num_binaries - NUM_OF_SPS) *
 					sizeof(*sh_css_blob_info), GFP_KERNEL);
-		if (sh_css_blob_info == NULL)
+		if (!sh_css_blob_info)
 			return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 	} else {
 		sh_css_blob_info = NULL;
 	}
 
 	fw_minibuffer = kzalloc(sh_css_num_binaries * sizeof(struct fw_param), GFP_KERNEL);
-	if (fw_minibuffer == NULL)
+	if (!fw_minibuffer)
 		return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 
 	for (i = 0; i < sh_css_num_binaries; i++) {
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_param_shading.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_param_shading.c
index eaf60e7b2dac..48e2e63c2336 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_param_shading.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_param_shading.c
@@ -365,7 +365,7 @@ ia_css_shading_table_alloc(
 	IA_CSS_ENTER("");
 
 	me = kmalloc(sizeof(*me), GFP_KERNEL);
-	if (me == NULL) {
+	if (!me) {
 		IA_CSS_ERROR("out of memory");
 		return me;
 	}
-- 
2.11.0
