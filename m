Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:62269 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751295AbdJaQE1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 12:04:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Varsha Rao <rvarsha016@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Srishti Sharma <srishtishar@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guru Das Srinagesh <gurooodas@gmail.com>,
        Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org
Subject: [PATCH 4/7] media: atomisp: fix other inconsistent identing
Date: Tue, 31 Oct 2017 12:04:17 -0400
Message-Id: <c70d4e15517eff4f202d33baf9edd0593d913ab0.1509465351.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1509465351.git.mchehab@s-opensource.com>
References: <cover.1509465351.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1509465351.git.mchehab@s-opensource.com>
References: <cover.1509465351.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:

	drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c:607 pipeline_stage_create() warn: inconsistent indenting
	drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:255 ov2680_write_reg_array() warn: inconsistent indenting
	drivers/staging/media/atomisp/i2c/atomisp-ov2680.c:401 __ov2680_set_exposure() warn: inconsistent indenting
	drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c:4269 sh_css_params_write_to_ddr_internal() warn: inconsistent indenting
	drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c:1008 atomisp_register_entities() warn: inconsistent indenting
	drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c:1709 ia_css_binary_find() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/atomisp/i2c/atomisp-ov2680.c |  8 ++--
 .../media/atomisp/i2c/ov5693/atomisp-ov5693.c      |  4 +-
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |  2 +-
 .../atomisp2/css2400/runtime/binary/src/binary.c   | 12 +++---
 .../css2400/runtime/pipeline/src/pipeline.c        |  2 +-
 .../atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c  |  2 +-
 .../atomisp/pci/atomisp2/css2400/sh_css_params.c   | 48 +++++++++++-----------
 7 files changed, 40 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c b/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
index 588bc0b15411..cd67d38f183a 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-ov2680.c
@@ -252,8 +252,8 @@ static int ov2680_write_reg_array(struct i2c_client *client,
 			if (!__ov2680_write_reg_is_consecutive(client, &ctrl,
 								next)) {
 				err = __ov2680_flush_reg_array(client, &ctrl);
-			if (err)
-				return err;
+				if (err)
+					return err;
 			}
 			err = __ov2680_buf_reg_array(client, &ctrl, next);
 			if (err) {
@@ -398,7 +398,9 @@ static long __ov2680_set_exposure(struct v4l2_subdev *sd, int coarse_itg,
 	u16 vts,hts;
 	int ret,exp_val;
 
-       dev_dbg(&client->dev, "+++++++__ov2680_set_exposure coarse_itg %d, gain %d, digitgain %d++\n",coarse_itg, gain, digitgain);
+	dev_dbg(&client->dev,
+		"+++++++__ov2680_set_exposure coarse_itg %d, gain %d, digitgain %d++\n",
+		coarse_itg, gain, digitgain);
 
 	hts = ov2680_res[dev->fmt_idx].pixels_per_line;
 	vts = ov2680_res[dev->fmt_idx].lines_per_frame;
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
index 50da7130f9ca..3e7c3851280f 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
@@ -386,8 +386,8 @@ static int ov5693_write_reg_array(struct i2c_client *client,
 			if (!__ov5693_write_reg_is_consecutive(client, &ctrl,
 								next)) {
 				err = __ov5693_flush_reg_array(client, &ctrl);
-			if (err)
-				return err;
+				if (err)
+					return err;
 			}
 			err = __ov5693_buf_reg_array(client, &ctrl, next);
 			if (err) {
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index bdfe8c855b23..3c260f8b52e2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -1004,7 +1004,7 @@ static int atomisp_register_entities(struct atomisp_device *isp)
 	v4l2_device_unregister(&isp->v4l2_dev);
 v4l2_device_failed:
 	media_device_unregister(&isp->media_dev);
-    media_device_cleanup(&isp->media_dev);
+	media_device_cleanup(&isp->media_dev);
 	return ret;
 }
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c
index 9f8a125f0d74..e028e460ae4c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/binary/src/binary.c
@@ -1697,11 +1697,11 @@ ia_css_binary_find(struct ia_css_binary_descr *descr,
 		}
 #endif
 		if (xcandidate->num_output_pins > 1 && /* in case we have a second output pin, */
-		     req_vf_info                   && /* and we need vf output. */
+		    req_vf_info                   && /* and we need vf output. */
 						      /* check if the required vf format
 							 is supported. */
-			!binary_supports_output_format(xcandidate, req_vf_info->format)) {
-				ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE,
+		    !binary_supports_output_format(xcandidate, req_vf_info->format)) {
+			ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE,
 				"ia_css_binary_find() [%d] continue: (%d > %d) && (%p != NULL) && !%d\n",
 				__LINE__, xcandidate->num_output_pins, 1,
 				req_vf_info,
@@ -1711,8 +1711,8 @@ ia_css_binary_find(struct ia_css_binary_descr *descr,
 
 		/* Check if vf_veceven supports the requested vf format */
 		if (xcandidate->num_output_pins == 1 &&
-			req_vf_info && candidate->enable.vf_veceven &&
-			!binary_supports_vf_format(xcandidate, req_vf_info->format)) {
+		    req_vf_info && candidate->enable.vf_veceven &&
+		    !binary_supports_vf_format(xcandidate, req_vf_info->format)) {
 			ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE,
 				"ia_css_binary_find() [%d] continue: (%d == %d) && (%p != NULL) && %d && !%d\n",
 				__LINE__, xcandidate->num_output_pins, 1,
@@ -1723,7 +1723,7 @@ ia_css_binary_find(struct ia_css_binary_descr *descr,
 
 		/* Check if vf_veceven supports the requested vf width */
 		if (xcandidate->num_output_pins == 1 &&
-			req_vf_info && candidate->enable.vf_veceven) { /* and we need vf output. */
+		    req_vf_info && candidate->enable.vf_veceven) { /* and we need vf output. */
 			if (req_vf_info->res.width > candidate->output.max_width) {
 				ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE,
 					"ia_css_binary_find() [%d] continue: (%d < %d)\n",
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c
index 95542fc82217..62d13978475d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/pipeline/src/pipeline.c
@@ -603,7 +603,7 @@ static enum ia_css_err pipeline_stage_create(
 	/* Verify input parameters*/
 	if (!(stage_desc->in_frame) && !(stage_desc->firmware)
 	    && (stage_desc->binary) && !(stage_desc->binary->online)) {
-	    err = IA_CSS_ERR_INTERNAL_ERROR;
+		err = IA_CSS_ERR_INTERNAL_ERROR;
 		goto ERR;
 	}
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c
index fa92d8da8f1c..e56006c07ee8 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/runtime/rmgr/src/rmgr_vbuf.c
@@ -174,7 +174,7 @@ void ia_css_rmgr_uninit_vbuf(struct ia_css_rmgr_vbuf_pool *pool)
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE, "ia_css_rmgr_uninit_vbuf()\n");
 	if (pool == NULL) {
 		ia_css_debug_dtrace(IA_CSS_DEBUG_ERROR, "ia_css_rmgr_uninit_vbuf(): NULL argument\n");
-		 return;
+		return;
 	}
 	if (pool->handles != NULL) {
 		/* free the hmm buffers */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
index 48224370b8bf..fbb36112fe3c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
@@ -4266,33 +4266,33 @@ sh_css_params_write_to_ddr_internal(
 		size_t *virt_size_tetra_y[
 			IA_CSS_MORPH_TABLE_NUM_PLANES];
 
-			virt_addr_tetra_x[0] = &ddr_map->tetra_r_x;
-			virt_addr_tetra_x[1] = &ddr_map->tetra_gr_x;
-			virt_addr_tetra_x[2] = &ddr_map->tetra_gb_x;
-			virt_addr_tetra_x[3] = &ddr_map->tetra_b_x;
-			virt_addr_tetra_x[4] = &ddr_map->tetra_ratb_x;
-			virt_addr_tetra_x[5] = &ddr_map->tetra_batr_x;
+		virt_addr_tetra_x[0] = &ddr_map->tetra_r_x;
+		virt_addr_tetra_x[1] = &ddr_map->tetra_gr_x;
+		virt_addr_tetra_x[2] = &ddr_map->tetra_gb_x;
+		virt_addr_tetra_x[3] = &ddr_map->tetra_b_x;
+		virt_addr_tetra_x[4] = &ddr_map->tetra_ratb_x;
+		virt_addr_tetra_x[5] = &ddr_map->tetra_batr_x;
 
-			virt_size_tetra_x[0] = &ddr_map_size->tetra_r_x;
-			virt_size_tetra_x[1] = &ddr_map_size->tetra_gr_x;
-			virt_size_tetra_x[2] = &ddr_map_size->tetra_gb_x;
-			virt_size_tetra_x[3] = &ddr_map_size->tetra_b_x;
-			virt_size_tetra_x[4] = &ddr_map_size->tetra_ratb_x;
-			virt_size_tetra_x[5] = &ddr_map_size->tetra_batr_x;
+		virt_size_tetra_x[0] = &ddr_map_size->tetra_r_x;
+		virt_size_tetra_x[1] = &ddr_map_size->tetra_gr_x;
+		virt_size_tetra_x[2] = &ddr_map_size->tetra_gb_x;
+		virt_size_tetra_x[3] = &ddr_map_size->tetra_b_x;
+		virt_size_tetra_x[4] = &ddr_map_size->tetra_ratb_x;
+		virt_size_tetra_x[5] = &ddr_map_size->tetra_batr_x;
 
-			virt_addr_tetra_y[0] = &ddr_map->tetra_r_y;
-			virt_addr_tetra_y[1] = &ddr_map->tetra_gr_y;
-			virt_addr_tetra_y[2] = &ddr_map->tetra_gb_y;
-			virt_addr_tetra_y[3] = &ddr_map->tetra_b_y;
-			virt_addr_tetra_y[4] = &ddr_map->tetra_ratb_y;
-			virt_addr_tetra_y[5] = &ddr_map->tetra_batr_y;
+		virt_addr_tetra_y[0] = &ddr_map->tetra_r_y;
+		virt_addr_tetra_y[1] = &ddr_map->tetra_gr_y;
+		virt_addr_tetra_y[2] = &ddr_map->tetra_gb_y;
+		virt_addr_tetra_y[3] = &ddr_map->tetra_b_y;
+		virt_addr_tetra_y[4] = &ddr_map->tetra_ratb_y;
+		virt_addr_tetra_y[5] = &ddr_map->tetra_batr_y;
 
-			virt_size_tetra_y[0] = &ddr_map_size->tetra_r_y;
-			virt_size_tetra_y[1] = &ddr_map_size->tetra_gr_y;
-			virt_size_tetra_y[2] = &ddr_map_size->tetra_gb_y;
-			virt_size_tetra_y[3] = &ddr_map_size->tetra_b_y;
-			virt_size_tetra_y[4] = &ddr_map_size->tetra_ratb_y;
-			virt_size_tetra_y[5] = &ddr_map_size->tetra_batr_y;
+		virt_size_tetra_y[0] = &ddr_map_size->tetra_r_y;
+		virt_size_tetra_y[1] = &ddr_map_size->tetra_gr_y;
+		virt_size_tetra_y[2] = &ddr_map_size->tetra_gb_y;
+		virt_size_tetra_y[3] = &ddr_map_size->tetra_b_y;
+		virt_size_tetra_y[4] = &ddr_map_size->tetra_ratb_y;
+		virt_size_tetra_y[5] = &ddr_map_size->tetra_batr_y;
 
 		buff_realloced = false;
 		for (i = 0; i < IA_CSS_MORPH_TABLE_NUM_PLANES; i++) {
-- 
2.13.6
