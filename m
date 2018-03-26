Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:46216 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752066AbeCZVLB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:11:01 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Aishwarya Pant <aishpant@gmail.com>,
        Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org
Subject: [PATCH 05/18] media: staging: atomisp: get rid of stupid statements
Date: Mon, 26 Mar 2018 17:10:38 -0400
Message-Id: <e140318e3069cf889abf68713f5d1546abc13f19.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It makes no sense to have a do nothing statement like:

	(void)stage;

Fix those warnings:
	drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c:3808 sh_css_param_update_isp_params() error: uninitialized symbol 'stage'.
	drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c:1444 sh_css_update_host2sp_offline_frame() error: uninitialized symbol 'HIVE_ADDR_host_sp_com'.
	drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c:1475 sh_css_update_host2sp_mipi_frame() error: uninitialized symbol 'HIVE_ADDR_host_sp_com'.
	drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c:1502 sh_css_update_host2sp_mipi_metadata() error: uninitialized symbol 'HIVE_ADDR_host_sp_com'.
	drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c:1522 sh_css_update_host2sp_num_mipi_frames() error: uninitialized symbol 'HIVE_ADDR_host_sp_com'.
	drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c:1541 sh_css_update_host2sp_cont_num_raw_frames() error: uninitialized symbol 'HIVE_ADDR_host_sp_com'.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../staging/media/atomisp/pci/atomisp2/css2400/sh_css.c  |  1 -
 .../media/atomisp/pci/atomisp2/css2400/sh_css_params.c   |  1 -
 .../media/atomisp/pci/atomisp2/css2400/sh_css_sp.c       | 16 +++-------------
 3 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 034437f8ca07..9958b275bd50 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -8082,7 +8082,6 @@ create_host_regular_capture_pipeline(struct ia_css_pipe *pipe)
 				return err;
 			}
 		}
-		(void)frm;
 		/* If we use copy iso primary,
 		   the input must be yuv iso raw */
 		current_stage->args.copy_vf =
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
index 3c0e8f66f59a..ba2b96e330d0 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
@@ -3805,7 +3805,6 @@ sh_css_param_update_isp_params(struct ia_css_pipe *curr_pipe,
 
 		enum sh_css_queue_id queue_id;
 
-		(void)stage;
 		pipe = curr_pipe->stream->pipes[i];
 		pipeline = ia_css_pipe_get_pipeline(pipe);
 		pipe_num = ia_css_pipe_get_pipe_num(pipe);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
index 9c6330783358..bb297184ba3a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
@@ -71,7 +71,7 @@
 struct sh_css_sp_group		sh_css_sp_group;
 struct sh_css_sp_stage		sh_css_sp_stage;
 struct sh_css_isp_stage		sh_css_isp_stage;
-struct sh_css_sp_output		sh_css_sp_output;
+static struct sh_css_sp_output		sh_css_sp_output;
 static struct sh_css_sp_per_frame_data per_frame_data;
 
 /* true if SP supports frame loop and host2sp_commands */
@@ -117,9 +117,9 @@ copy_isp_stage_to_sp_stage(void)
 	*/
 	sh_css_sp_stage.enable.sdis = sh_css_isp_stage.binary_info.enable.dis;
 	sh_css_sp_stage.enable.s3a = sh_css_isp_stage.binary_info.enable.s3a;
-#ifdef ISP2401	
+#ifdef ISP2401
 	sh_css_sp_stage.enable.lace_stats = sh_css_isp_stage.binary_info.enable.lace_stats;
-#endif	
+#endif
 }
 
 void
@@ -1441,8 +1441,6 @@ sh_css_update_host2sp_offline_frame(
 	unsigned int HIVE_ADDR_host_sp_com;
 	unsigned int offset;
 
-	(void)HIVE_ADDR_host_sp_com; /* Suppres warnings in CRUN */
-
 	assert(frame_num < NUM_CONTINUOUS_FRAMES);
 
 	/* Write new frame data into SP DMEM */
@@ -1472,8 +1470,6 @@ sh_css_update_host2sp_mipi_frame(
 	unsigned int HIVE_ADDR_host_sp_com;
 	unsigned int offset;
 
-	(void)HIVE_ADDR_host_sp_com; /* Suppres warnings in CRUN */
-
 	/* MIPI buffers are dedicated to port, so now there are more of them. */
 	assert(frame_num < (N_CSI_PORTS * NUM_MIPI_FRAMES_PER_STREAM));
 
@@ -1499,8 +1495,6 @@ sh_css_update_host2sp_mipi_metadata(
 	unsigned int HIVE_ADDR_host_sp_com;
 	unsigned int o;
 
-	(void)HIVE_ADDR_host_sp_com; /* Suppres warnings in CRUN */
-
 	/* MIPI buffers are dedicated to port, so now there are more of them. */
 	assert(frame_num < (N_CSI_PORTS * NUM_MIPI_FRAMES_PER_STREAM));
 
@@ -1519,8 +1513,6 @@ sh_css_update_host2sp_num_mipi_frames(unsigned num_frames)
 	unsigned int HIVE_ADDR_host_sp_com;
 	unsigned int offset;
 
-	(void)HIVE_ADDR_host_sp_com; /* Suppres warnings in CRUN */
-
 	/* Write new frame data into SP DMEM */
 	HIVE_ADDR_host_sp_com = sh_css_sp_fw.info.sp.host_sp_com;
 	offset = (unsigned int)offsetof(struct host_sp_communication, host2sp_num_mipi_frames)
@@ -1538,8 +1530,6 @@ sh_css_update_host2sp_cont_num_raw_frames(unsigned num_frames, bool set_avail)
 	unsigned int extra_num_frames, avail_num_frames;
 	unsigned int offset, offset_extra;
 
-	(void)HIVE_ADDR_host_sp_com; /* Suppres warnings in CRUN */
-
 	/* Write new frame data into SP DMEM */
 	fw = &sh_css_sp_fw;
 	HIVE_ADDR_host_sp_com = fw->info.sp.host_sp_com;
-- 
2.14.3
