Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35080 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753569AbdJaQEa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 12:04:30 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 2/7] media: atomisp: fix spatch warnings at sh_css.c
Date: Tue, 31 Oct 2017 12:04:15 -0400
Message-Id: <05424fd9635d7532aa87a68acd8819da53627889.1509465351.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1509465351.git.mchehab@s-opensource.com>
References: <cover.1509465351.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1509465351.git.mchehab@s-opensource.com>
References: <cover.1509465351.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c:5801:1: error: directive in argument list
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c:5803:1: error: directive in argument list
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c:3795 create_host_acc_pipeline() warn: inconsistent indenting
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c:4343 ia_css_pipe_enqueue_buffer() warn: inconsistent indenting
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c:6029 sh_css_pipe_configure_viewfinder() warn: inconsistent indenting
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c:8693 ia_css_stream_capture() warn: inconsistent indenting
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c:9781 ia_css_stream_create() warn: if statement not indented
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c:9988 ia_css_stream_load() warn: inconsistent indenting
drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c:10525 ia_css_update_continuous_frames() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    | 91 +++++++++++-----------
 1 file changed, 46 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index e61009faff27..f92b6a9f77eb 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -3779,6 +3779,7 @@ static enum ia_css_err
 create_host_acc_pipeline(struct ia_css_pipe *pipe)
 {
 	enum ia_css_err err = IA_CSS_SUCCESS;
+	const struct ia_css_fw_info *fw;
 	unsigned int i;
 
 	IA_CSS_ENTER_PRIVATE("pipe = %p", pipe);
@@ -3792,14 +3793,12 @@ create_host_acc_pipeline(struct ia_css_pipe *pipe)
 	if (pipe->config.acc_extension)
 	   pipe->pipeline.pipe_qos_config = 0;
 
-{
-	const struct ia_css_fw_info *fw = pipe->vf_stage;
+	fw = pipe->vf_stage;
 	for (i = 0; fw; fw = fw->next){
 		err = sh_css_pipeline_add_acc_stage(&pipe->pipeline, fw);
 		if (err != IA_CSS_SUCCESS)
 			goto ERR;
 	}
-}
 
 	for (i=0; i<pipe->config.num_acc_stages; i++) {
 		struct ia_css_fw_info *fw = pipe->config.acc_stages[i];
@@ -4331,12 +4330,13 @@ ia_css_pipe_enqueue_buffer(struct ia_css_pipe *pipe,
 			}
 		}
 	} else if ((buf_type == IA_CSS_BUFFER_TYPE_INPUT_FRAME)
-		|| (buf_type == IA_CSS_BUFFER_TYPE_OUTPUT_FRAME)
-		|| (buf_type == IA_CSS_BUFFER_TYPE_VF_OUTPUT_FRAME)
-		|| (buf_type == IA_CSS_BUFFER_TYPE_SEC_OUTPUT_FRAME)
-		|| (buf_type == IA_CSS_BUFFER_TYPE_SEC_VF_OUTPUT_FRAME)
-		|| (buf_type == IA_CSS_BUFFER_TYPE_METADATA)) {
-			return_err = ia_css_bufq_enqueue_buffer(thread_id,
+		   || (buf_type == IA_CSS_BUFFER_TYPE_OUTPUT_FRAME)
+		   || (buf_type == IA_CSS_BUFFER_TYPE_VF_OUTPUT_FRAME)
+		   || (buf_type == IA_CSS_BUFFER_TYPE_SEC_OUTPUT_FRAME)
+		   || (buf_type == IA_CSS_BUFFER_TYPE_SEC_VF_OUTPUT_FRAME)
+		   || (buf_type == IA_CSS_BUFFER_TYPE_METADATA)) {
+
+		return_err = ia_css_bufq_enqueue_buffer(thread_id,
 							queue_id,
 							(uint32_t)h_vbuf->vptr);
 #if defined(SH_CSS_ENABLE_PER_FRAME_PARAMS)
@@ -5795,13 +5795,15 @@ static enum ia_css_err load_video_binaries(struct ia_css_pipe *pipe)
 
 #endif
 		/* Make tnr reference buffers output block height align */
-		tnr_info.res.height =
 #ifndef ISP2401
+		tnr_info.res.height =
 			CEIL_MUL(tnr_info.res.height,
+				 mycs->video_binary.info->sp.block.output_block_height);
 #else
+		tnr_info.res.height =
 			CEIL_MUL(tnr_height,
+				 mycs->video_binary.info->sp.block.output_block_height);
 #endif
-			 mycs->video_binary.info->sp.block.output_block_height);
 	} else {
 		tnr_info = mycs->video_binary.internal_frame_info;
 	}
@@ -6025,7 +6027,7 @@ sh_css_pipe_configure_viewfinder(struct ia_css_pipe *pipe, unsigned int width,
 
 	err = ia_css_util_check_res(width, height);
 	if (err != IA_CSS_SUCCESS) {
-	IA_CSS_LEAVE_ERR_PRIVATE(err);
+		IA_CSS_LEAVE_ERR_PRIVATE(err);
 		return err;
 	}
 	if (pipe->vf_output_info[idx].res.width != width ||
@@ -8687,9 +8689,9 @@ enum ia_css_err ia_css_stream_capture(
 
 	/* Check if the tag descriptor is valid */
 	if (num_captures < SH_CSS_MINIMUM_TAG_ID) {
-	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE,
-		"ia_css_stream_capture() leave: return_err=%d\n",
-		IA_CSS_ERR_INVALID_ARGUMENTS);
+		ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE,
+				    "ia_css_stream_capture() leave: return_err=%d\n",
+				    IA_CSS_ERR_INVALID_ARGUMENTS);
 		return IA_CSS_ERR_INVALID_ARGUMENTS;
 	}
 
@@ -9778,23 +9780,22 @@ ia_css_stream_create(const struct ia_css_stream_config *stream_config,
 	if (err == IA_CSS_SUCCESS)
 	{
 		/* working mode: enter into the seed list */
-		if (my_css_save.mode == sh_css_mode_working)
-		for(i = 0; i < MAX_ACTIVE_STREAMS; i++)
-			if (my_css_save.stream_seeds[i].stream == NULL)
-			{
-				IA_CSS_LOG("entered stream into loc=%d", i);
-				my_css_save.stream_seeds[i].orig_stream = stream;
-				my_css_save.stream_seeds[i].stream = curr_stream;
-				my_css_save.stream_seeds[i].num_pipes = num_pipes;
-				my_css_save.stream_seeds[i].stream_config = *stream_config;
-				for(j = 0; j < num_pipes; j++)
-				{
-					my_css_save.stream_seeds[i].pipe_config[j] = pipes[j]->config;
-					my_css_save.stream_seeds[i].pipes[j] = pipes[j];
-					my_css_save.stream_seeds[i].orig_pipes[j] = &pipes[j];
-				}
-				break;
+		if (my_css_save.mode == sh_css_mode_working) {
+			for (i = 0; i < MAX_ACTIVE_STREAMS; i++)
+				if (!my_css_save.stream_seeds[i].stream) {
+					IA_CSS_LOG("entered stream into loc=%d", i);
+					my_css_save.stream_seeds[i].orig_stream = stream;
+					my_css_save.stream_seeds[i].stream = curr_stream;
+					my_css_save.stream_seeds[i].num_pipes = num_pipes;
+					my_css_save.stream_seeds[i].stream_config = *stream_config;
+					for (j = 0; j < num_pipes; j++) {
+						my_css_save.stream_seeds[i].pipe_config[j] = pipes[j]->config;
+						my_css_save.stream_seeds[i].pipes[j] = pipes[j];
+						my_css_save.stream_seeds[i].orig_pipes[j] = &pipes[j];
+					}
+					break;
 			}
+		}
 #else
 	if (err == IA_CSS_SUCCESS) {
 		err = ia_css_save_stream(curr_stream);
@@ -9968,32 +9969,32 @@ ia_css_stream_load(struct ia_css_stream *stream)
 	enum ia_css_err err;
 	assert(stream != NULL);
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE,	"ia_css_stream_load() enter, \n");
-	for(i=0;i<MAX_ACTIVE_STREAMS;i++)
-		if (my_css_save.stream_seeds[i].stream == stream)
-		{
+	for (i = 0; i < MAX_ACTIVE_STREAMS; i++) {
+		if (my_css_save.stream_seeds[i].stream == stream) {
 			int j;
-			for(j=0;j<my_css_save.stream_seeds[i].num_pipes;j++)
-				if ((err = ia_css_pipe_create(&(my_css_save.stream_seeds[i].pipe_config[j]), &my_css_save.stream_seeds[i].pipes[j])) != IA_CSS_SUCCESS)
-				{
-					if (j)
-					{
+			for ( j = 0; j < my_css_save.stream_seeds[i].num_pipes; j++) {
+				if ((err = ia_css_pipe_create(&(my_css_save.stream_seeds[i].pipe_config[j]), &my_css_save.stream_seeds[i].pipes[j])) != IA_CSS_SUCCESS) {
+					if (j) {
 						int k;
 						for(k=0;k<j;k++)
 							ia_css_pipe_destroy(my_css_save.stream_seeds[i].pipes[k]);
 					}
 					return err;
 				}
-			err = ia_css_stream_create(&(my_css_save.stream_seeds[i].stream_config), my_css_save.stream_seeds[i].num_pipes,
-						    my_css_save.stream_seeds[i].pipes, &(my_css_save.stream_seeds[i].stream));
-		    if (err != IA_CSS_SUCCESS)
-			{
+			}
+			err = ia_css_stream_create(&(my_css_save.stream_seeds[i].stream_config),
+						   my_css_save.stream_seeds[i].num_pipes,
+						   my_css_save.stream_seeds[i].pipes,
+						   &(my_css_save.stream_seeds[i].stream));
+			if (err != IA_CSS_SUCCESS) {
 				ia_css_stream_destroy(stream);
-				for(j=0;j<my_css_save.stream_seeds[i].num_pipes;j++)
+				for (j = 0; j < my_css_save.stream_seeds[i].num_pipes; j++)
 					ia_css_pipe_destroy(my_css_save.stream_seeds[i].pipes[j]);
 				return err;
 			}
 			break;
 		}
+	}
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE,	"ia_css_stream_load() exit, \n");
 	return IA_CSS_SUCCESS;
 #else
@@ -10522,7 +10523,7 @@ ia_css_update_continuous_frames(struct ia_css_stream *stream)
 		ia_css_debug_dtrace(
 			IA_CSS_DEBUG_TRACE,
 			"sh_css_update_continuous_frames() leave: invalid stream, return_void\n");
-			return IA_CSS_ERR_INVALID_ARGUMENTS;
+		return IA_CSS_ERR_INVALID_ARGUMENTS;
 	}
 
 	pipe = stream->continuous_pipe;
-- 
2.13.6
