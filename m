Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:38382 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1763965AbdEZP00 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 11:26:26 -0400
Subject: [PATCH 04/12] atomisp2: tidy up confused ifdefs
From: Alan Cox <alan@llwyncelyn.cymru>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Date: Fri, 26 May 2017 16:26:22 +0100
Message-ID: <149581237345.17406.9846252735067789399.stgit@builder>
In-Reply-To: <149581234670.17406.8086980349538517529.stgit@builder>
References: <149581234670.17406.8086980349538517529.stgit@builder>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The two drivers were machine merged and in this case the machine output was to
say the least not optimal.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |   26 ++++----------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 231c3f8..8d44608 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -1469,30 +1469,17 @@ static void start_pipe(
 				copy_ovrd,
 				input_mode,
 				&me->stream->config.metadata_config,
-#ifndef ISP2401
 				&me->stream->info.metadata_info
-#else
-				&me->stream->info.metadata_info,
-#endif
 #if !defined(HAS_NO_INPUT_SYSTEM)
-#ifndef ISP2401
-				, (input_mode==IA_CSS_INPUT_MODE_MEMORY)?
-#else
-				(input_mode == IA_CSS_INPUT_MODE_MEMORY) ?
-#endif
+				,(input_mode==IA_CSS_INPUT_MODE_MEMORY) ?
 					(mipi_port_ID_t)0 :
-#ifndef ISP2401
 					me->stream->config.source.port.port
-#else
-					me->stream->config.source.port.port,
 #endif
+#ifdef ISP2401
+				,&me->config.internal_frame_origin_bqs_on_sctbl,
+				me->stream->isp_params_configs
 #endif
-#ifndef ISP2401
-				);
-#else
-				&me->config.internal_frame_origin_bqs_on_sctbl,
-				me->stream->isp_params_configs);
-#endif
+			);
 
 	if (me->config.mode != IA_CSS_PIPE_MODE_COPY) {
 		struct ia_css_pipeline_stage *stage;
@@ -9815,9 +9802,6 @@ ia_css_stream_create(const struct ia_css_stream_config *stream_config,
 		/* take over effective info */
 
 		effective_res = curr_pipe->config.input_effective_res;
-#endif
-
-#ifndef ISP2401
 		err = ia_css_util_check_res(
 					effective_res.width,
 					effective_res.height);
