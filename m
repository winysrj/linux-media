Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:52210 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752324AbeBENP4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Feb 2018 08:15:56 -0500
Received: by mail-wm0-f67.google.com with SMTP id r71so26193152wmd.1
        for <linux-media@vger.kernel.org>; Mon, 05 Feb 2018 05:15:55 -0800 (PST)
From: Alona <al.solnts@gmail.com>
To: alan@linux.intel.com, linux-media@vger.kernel.org
Cc: rfried@qti.qualcomm.com, Alona Solntseva <al.solnts@gmail.com>
Subject: [PATCH] drivers: staging: media: atomisp: pci: atomisp2: css2400: fix misspellings
Date: Mon,  5 Feb 2018 15:14:52 +0200
Message-Id: <1517836492-4272-1-git-send-email-al.solnts@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alona Solntseva <al.solnts@gmail.com>

Misspelled words are fixed in several places.

Signed-off-by: Alona Solntseva <al.solnts@gmail.com>
---
 .../staging/media/atomisp/pci/atomisp2/css2400/sh_css.c  | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 322bb3d..de712fa 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -194,7 +194,7 @@ sh_css_pipe_start(struct ia_css_stream *stream);
  * @param[in] stream	Point to the target "ia_css_stream" instance.
  *
  * @return
- * - IA_CSS_SUCCESS, if the "stop" requests have been sucessfully sent out.
+ * - IA_CSS_SUCCESS, if the "stop" requests have been successfully sent out.
  * - CSS error code, otherwise.
  *
  *
@@ -1054,7 +1054,7 @@ sh_css_config_input_network(struct ia_css_stream *stream)
 		if (stream->last_pipe->config.mode == IA_CSS_PIPE_MODE_CAPTURE) {
 			/*
 			 * We need to poll the ISYS HW in capture_indication itself
-			 * for "non-continous" capture usecase for getting accurate
+			 * for "non-continuous" capture usecase for getting accurate
 			 * isys frame capture timestamps.
 			 * This is because the capturepipe propcessing takes longer
 			 * to execute than the input system frame capture.
@@ -3657,7 +3657,7 @@ static enum ia_css_err create_host_video_pipeline(struct ia_css_pipe *pipe)
 		in_frame = me->stages->args.out_frame[0];
 	} else if (pipe->stream->config.continuous) {
 #ifdef USE_INPUT_SYSTEM_VERSION_2401
-		/* When continous is enabled, configure in_frame with the
+		/* When continuous is enabled, configure in_frame with the
 		 * last pipe, which is the copy pipe.
 		 */
 		in_frame = pipe->stream->last_pipe->continuous_frames[0];
@@ -3854,7 +3854,7 @@ create_host_preview_pipeline(struct ia_css_pipe *pipe)
 	 * - Direct Sensor Mode Online Preview
 	 * - Buffered Sensor Mode Online Preview
 	 * - Direct Sensor Mode Continuous Preview
-	 * - Buffered Sensor Mode Continous Preview
+	 * - Buffered Sensor Mode Continuous Preview
 	 */
 	sensor = (pipe->stream->config.mode == IA_CSS_INPUT_MODE_SENSOR);
 	buffered_sensor = (pipe->stream->config.mode == IA_CSS_INPUT_MODE_BUFFERED_SENSOR);
@@ -4715,7 +4715,7 @@ ia_css_dequeue_psys_event(struct ia_css_event *event)
 			event->timer_subcode = payload[2];
 		}
 		/* It's a non timer event. So clear first half of the timer event data.
-		* If the second part of the TIMER event is not recieved, we discard
+		* If the second part of the TIMER event is not received, we discard
 		* the first half of the timer data and process the non timer event without
 		* affecting the flow. So the non timer event falls through
 		* the code. */
@@ -7610,7 +7610,7 @@ create_host_yuvpp_pipeline(struct ia_css_pipe *pipe)
 	 * except for the following:
 	 * - Direct Sensor Mode Online Capture
 	 * - Direct Sensor Mode Continuous Capture
-	 * - Buffered Sensor Mode Continous Capture
+	 * - Buffered Sensor Mode Continuous Capture
 	 */
 	sensor = pipe->stream->config.mode == IA_CSS_INPUT_MODE_SENSOR;
 	buffered_sensor = pipe->stream->config.mode == IA_CSS_INPUT_MODE_BUFFERED_SENSOR;
@@ -7950,7 +7950,7 @@ create_host_regular_capture_pipeline(struct ia_css_pipe *pipe)
 	 * - Direct Sensor Mode Online Capture
 	 * - Direct Sensor Mode Online Capture
 	 * - Direct Sensor Mode Continuous Capture
-	 * - Buffered Sensor Mode Continous Capture
+	 * - Buffered Sensor Mode Continuous Capture
 	 */
 	sensor = (pipe->stream->config.mode == IA_CSS_INPUT_MODE_SENSOR);
 	buffered_sensor = (pipe->stream->config.mode == IA_CSS_INPUT_MODE_BUFFERED_SENSOR);
@@ -8915,7 +8915,7 @@ ia_css_pipe_create(const struct ia_css_pipe_config *config,
 	err = ia_css_pipe_create_extra(config, NULL, pipe);
 
 	if(err == IA_CSS_SUCCESS) {
-		IA_CSS_LOG("pipe created successfuly = %p", *pipe);
+		IA_CSS_LOG("pipe created successfully = %p", *pipe);
 	}
 
 	IA_CSS_LEAVE_ERR_PRIVATE(err);
-- 
2.7.4
