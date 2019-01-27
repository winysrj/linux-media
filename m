Return-Path: <SRS0=npIJ=QD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 580D1C282CC
	for <linux-media@archiver.kernel.org>; Sun, 27 Jan 2019 16:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C8972148D
	for <linux-media@archiver.kernel.org>; Sun, 27 Jan 2019 16:54:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rl+2Zemw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfA0Qyw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 27 Jan 2019 11:54:52 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38009 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfA0Qyw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Jan 2019 11:54:52 -0500
Received: by mail-pl1-f195.google.com with SMTP id e5so6686153plb.5;
        Sun, 27 Jan 2019 08:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tyVLRKF1kD9mBidj4DYOd218eTpOewd1kOFgD1w4iqw=;
        b=Rl+2ZemwPoR1U9FW/k4zmEVS+lYCpv5JoCYDt2O0hcNWgdnwXEO9PGlsHV/QK9ZJxX
         J0coqMsrbpN8hDwK/BhObLCDaIrx5ovI9zNrNSy5Q5ZeB42Sx391oEMQTwDSCesj14gk
         nD578ZXefNgf7+EigfPfVQAAFLj12GVm8+JtVhYK6PmYZw9mxrhHWJ3RzNvEO9PdsOii
         udv3n7h6OwbL8f4rMqe7EjdzpndUA6qJhK17yGYCsoHs94d3NMy1cmf+4qvSakvF9qaY
         U6KrjJXfInXXDyxicPbPjwFozhgl0jlUFnTPPM4lQkmc8oy4wH0aC7lbOWdgJbPCCd/k
         HNYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tyVLRKF1kD9mBidj4DYOd218eTpOewd1kOFgD1w4iqw=;
        b=VtIOSEPPUx+FssYJv4g0Pp+3MX5gXc7G5KEXoBuuWSybK/mUAJ1VYA/Q3hJEsDeoi0
         Bb2JUECA/gizs+YavF/FZb88B9xQ7sVhExQRPe4ENOa2qI/saGcU1nwcR41q7vRaReOu
         OD/l+s1QIlJFLrZCn+aATN4jBrCSyHZvun+8kHOI95HGBBvq0bWBNsdZ+FJMvJqHfxd8
         07/PAM/SOgZq8S+ehD4DBWi2oWcKR8JO9jLTGBSbHDklRRPAa+QI0mmcBFri2ioYPaFQ
         2hW9I0DDb/EFLtBN/oP/uu5sIEi7Omw+hoirWn7afvQ6380sFzKOvn6MHdVwUO8SeIni
         fp9w==
X-Gm-Message-State: AJcUukdwZcx/PEZ3OaDaZsQQybhVOMTNRMkKh0yDeKNgwKZVcSv76AYo
        W/4h3M2dodHIIfT8PCWrXAw=
X-Google-Smtp-Source: ALg8bN4pwc119PSd3mwJ+heRYx2+Vv2Tgjqe3k8sw+aKDVfgO7+Wf4fa3OWAwzcepe+Wj/1m2raanA==
X-Received: by 2002:a17:902:8f97:: with SMTP id z23mr18864698plo.283.1548608090752;
        Sun, 27 Jan 2019 08:54:50 -0800 (PST)
Received: from localhost.localdomain ([150.129.88.181])
        by smtp.gmail.com with ESMTPSA id l22sm52313028pfj.179.2019.01.27.08.54.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Jan 2019 08:54:50 -0800 (PST)
From:   Prashantha SP <prashanth.sp98@gmail.com>
To:     sakari.ailus@linux.intel.com
Cc:     mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Prashantha SP <prashanth.sp98@gmail.com>
Subject: [PATCH 3/3] Staging: media: ipu3: fixed max charecter style issue
Date:   Sun, 27 Jan 2019 22:24:16 +0530
Message-Id: <20190127165416.13287-1-prashanth.sp98@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

fixed coding style issue.

Signed-off-by: Prashantha SP <prashanth.sp98@gmail.com>
---
 drivers/staging/media/ipu3/ipu3-css.c | 178 ++++++++++++++------------
 1 file changed, 94 insertions(+), 84 deletions(-)

diff --git a/drivers/staging/media/ipu3/ipu3-css.c b/drivers/staging/media/ipu3/ipu3-css.c
index 44c55639389a..466a1a8cc422 100644
--- a/drivers/staging/media/ipu3/ipu3-css.c
+++ b/drivers/staging/media/ipu3/ipu3-css.c
@@ -186,7 +186,8 @@ static bool ipu3_css_queue_enabled(struct ipu3_css_queue *q)
 /******************* css hw *******************/
 
 /* In the style of writesl() defined in include/asm-generic/io.h */
-static inline void writes(const void *mem, ssize_t count, void __iomem *addr)
+static inline void writes(const void *mem, ssize_t count,
+			  void __iomem *addr)
 {
 	if (count >= 4) {
 		const u32 *buf = mem;
@@ -671,8 +672,9 @@ static void ipu3_css_pipeline_cleanup(struct ipu3_css *css, unsigned int pipe)
 	ipu3_css_pool_cleanup(imgu, &css->pipes[pipe].pool.obgrid);
 
 	for (i = 0; i < IMGU_ABI_NUM_MEMORIES; i++)
-		ipu3_css_pool_cleanup(imgu,
-				      &css->pipes[pipe].pool.binary_params_p[i]);
+		ipu3_css_pool_cleanup
+			(imgu,
+			&css->pipes[pipe].pool.binary_params_p[i]);
 }
 
 /*
@@ -732,43 +734,44 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 		goto bad_firmware;
 
 	cfg_iter->input_info.res.width =
-				css_pipe->queue[IPU3_CSS_QUEUE_IN].fmt.mpix.width;
+			css_pipe->queue[IPU3_CSS_QUEUE_IN].fmt.mpix.width;
 	cfg_iter->input_info.res.height =
-				css_pipe->queue[IPU3_CSS_QUEUE_IN].fmt.mpix.height;
+			css_pipe->queue[IPU3_CSS_QUEUE_IN].fmt.mpix.height;
 	cfg_iter->input_info.padded_width =
 				css_pipe->queue[IPU3_CSS_QUEUE_IN].width_pad;
 	cfg_iter->input_info.format =
-			css_pipe->queue[IPU3_CSS_QUEUE_IN].css_fmt->frame_format;
+		css_pipe->queue[IPU3_CSS_QUEUE_IN].css_fmt->frame_format;
 	cfg_iter->input_info.raw_bit_depth =
 			css_pipe->queue[IPU3_CSS_QUEUE_IN].css_fmt->bit_depth;
 	cfg_iter->input_info.raw_bayer_order =
 			css_pipe->queue[IPU3_CSS_QUEUE_IN].css_fmt->bayer_order;
 	cfg_iter->input_info.raw_type = IMGU_ABI_RAW_TYPE_BAYER;
 
-	cfg_iter->internal_info.res.width = css_pipe->rect[IPU3_CSS_RECT_BDS].width;
+	cfg_iter->internal_info.res.width =
+		css_pipe->rect[IPU3_CSS_RECT_BDS].width;
 	cfg_iter->internal_info.res.height =
-					css_pipe->rect[IPU3_CSS_RECT_BDS].height;
+				css_pipe->rect[IPU3_CSS_RECT_BDS].height;
 	cfg_iter->internal_info.padded_width = bds_width_pad;
 	cfg_iter->internal_info.format =
-			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->frame_format;
+		css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->frame_format;
 	cfg_iter->internal_info.raw_bit_depth =
 			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bit_depth;
 	cfg_iter->internal_info.raw_bayer_order =
-			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bayer_order;
+		css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bayer_order;
 	cfg_iter->internal_info.raw_type = IMGU_ABI_RAW_TYPE_BAYER;
 
 	cfg_iter->output_info.res.width =
-				css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.width;
+			css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.width;
 	cfg_iter->output_info.res.height =
-				css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
+			css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
 	cfg_iter->output_info.padded_width =
 				css_pipe->queue[IPU3_CSS_QUEUE_OUT].width_pad;
 	cfg_iter->output_info.format =
-			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->frame_format;
+		css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->frame_format;
 	cfg_iter->output_info.raw_bit_depth =
-			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bit_depth;
+		css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bit_depth;
 	cfg_iter->output_info.raw_bayer_order =
-			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bayer_order;
+		css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bayer_order;
 	cfg_iter->output_info.raw_type = IMGU_ABI_RAW_TYPE_BAYER;
 
 	cfg_iter->vf_info.res.width =
@@ -778,14 +781,15 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 	cfg_iter->vf_info.padded_width =
 			css_pipe->queue[IPU3_CSS_QUEUE_VF].width_pad;
 	cfg_iter->vf_info.format =
-			css_pipe->queue[IPU3_CSS_QUEUE_VF].css_fmt->frame_format;
+		css_pipe->queue[IPU3_CSS_QUEUE_VF].css_fmt->frame_format;
 	cfg_iter->vf_info.raw_bit_depth =
-			css_pipe->queue[IPU3_CSS_QUEUE_VF].css_fmt->bit_depth;
+		css_pipe->queue[IPU3_CSS_QUEUE_VF].css_fmt->bit_depth;
 	cfg_iter->vf_info.raw_bayer_order =
-			css_pipe->queue[IPU3_CSS_QUEUE_VF].css_fmt->bayer_order;
+		css_pipe->queue[IPU3_CSS_QUEUE_VF].css_fmt->bayer_order;
 	cfg_iter->vf_info.raw_type = IMGU_ABI_RAW_TYPE_BAYER;
 
-	cfg_iter->dvs_envelope.width = css_pipe->rect[IPU3_CSS_RECT_ENVELOPE].width;
+	cfg_iter->dvs_envelope.width =
+		css_pipe->rect[IPU3_CSS_RECT_ENVELOPE].width;
 	cfg_iter->dvs_envelope.height =
 				css_pipe->rect[IPU3_CSS_RECT_ENVELOPE].height;
 
@@ -808,11 +812,11 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 	cfg_ref->dvs_frame_delay = IPU3_CSS_AUX_FRAMES - 1;
 	for (i = 0; i < IPU3_CSS_AUX_FRAMES; i++) {
 		cfg_ref->ref_frame_addr_y[i] =
-			css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].mem[i].daddr;
+		css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].mem[i].daddr;
 		cfg_ref->ref_frame_addr_c[i] =
-			css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].mem[i].daddr +
-			css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].bytesperline *
-			css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].height;
+		css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].mem[i].daddr +
+		css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].bytesperline *
+		css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].height;
 	}
 	for (; i < IMGU_ABI_FRAMES_REF; i++) {
 		cfg_ref->ref_frame_addr_y[i] = 0;
@@ -828,8 +832,8 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 		goto bad_firmware;
 
 	cfg_dvs->num_horizontal_blocks =
-			ALIGN(DIV_ROUND_UP(css_pipe->rect[IPU3_CSS_RECT_GDC].width,
-					   IMGU_DVS_BLOCK_W), 2);
+		ALIGN(DIV_ROUND_UP(css_pipe->rect[IPU3_CSS_RECT_GDC].width,
+				   IMGU_DVS_BLOCK_W), 2);
 	cfg_dvs->num_vertical_blocks =
 			DIV_ROUND_UP(css_pipe->rect[IPU3_CSS_RECT_GDC].height,
 				     IMGU_DVS_BLOCK_H);
@@ -849,7 +853,7 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 		cfg_tnr->port_b.width =
 			css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR].width;
 		cfg_tnr->port_b.stride =
-			css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR].bytesperline;
+		css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR].bytesperline;
 		cfg_tnr->width_a_over_b =
 			IPU3_UAPI_ISP_VEC_ELEMS / cfg_tnr->port_b.elems;
 		cfg_tnr->frame_height =
@@ -909,7 +913,7 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 	for (i = IMGU_ABI_PARAM_CLASS_CONFIG; i < IMGU_ABI_PARAM_CLASS_NUM; i++)
 		for (j = 0; j < IMGU_ABI_NUM_MEMORIES; j++)
 			isp_stage->mem_initializers.params[i][j].address =
-					css_pipe->binary_params_cs[i - 1][j].daddr;
+				css_pipe->binary_params_cs[i - 1][j].daddr;
 
 	/* Configure SP stage */
 
@@ -936,13 +940,13 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 	sp_stage->frames.effective_in_res.height =
 				css_pipe->rect[IPU3_CSS_RECT_EFFECTIVE].height;
 	sp_stage->frames.in.info.res.width =
-				css_pipe->queue[IPU3_CSS_QUEUE_IN].fmt.mpix.width;
+			css_pipe->queue[IPU3_CSS_QUEUE_IN].fmt.mpix.width;
 	sp_stage->frames.in.info.res.height =
-				css_pipe->queue[IPU3_CSS_QUEUE_IN].fmt.mpix.height;
+			css_pipe->queue[IPU3_CSS_QUEUE_IN].fmt.mpix.height;
 	sp_stage->frames.in.info.padded_width =
-					css_pipe->queue[IPU3_CSS_QUEUE_IN].width_pad;
+				css_pipe->queue[IPU3_CSS_QUEUE_IN].width_pad;
 	sp_stage->frames.in.info.format =
-			css_pipe->queue[IPU3_CSS_QUEUE_IN].css_fmt->frame_format;
+		css_pipe->queue[IPU3_CSS_QUEUE_IN].css_fmt->frame_format;
 	sp_stage->frames.in.info.raw_bit_depth =
 			css_pipe->queue[IPU3_CSS_QUEUE_IN].css_fmt->bit_depth;
 	sp_stage->frames.in.info.raw_bayer_order =
@@ -953,21 +957,21 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 					IMGU_ABI_BUFFER_TYPE_INPUT_FRAME;
 
 	sp_stage->frames.out[0].info.res.width =
-				css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.width;
+			css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.width;
 	sp_stage->frames.out[0].info.res.height =
-				css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
+			css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
 	sp_stage->frames.out[0].info.padded_width =
 				css_pipe->queue[IPU3_CSS_QUEUE_OUT].width_pad;
 	sp_stage->frames.out[0].info.format =
-			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->frame_format;
+		css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->frame_format;
 	sp_stage->frames.out[0].info.raw_bit_depth =
 			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bit_depth;
 	sp_stage->frames.out[0].info.raw_bayer_order =
-			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bayer_order;
+		css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bayer_order;
 	sp_stage->frames.out[0].info.raw_type = IMGU_ABI_RAW_TYPE_BAYER;
 	sp_stage->frames.out[0].planes.nv.uv.offset =
-				css_pipe->queue[IPU3_CSS_QUEUE_OUT].width_pad *
-				css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
+			css_pipe->queue[IPU3_CSS_QUEUE_OUT].width_pad *
+			css_pipe->queue[IPU3_CSS_QUEUE_OUT].fmt.mpix.height;
 	sp_stage->frames.out[0].buf_attr.buf_src.queue_id = IMGU_ABI_QUEUE_D_ID;
 	sp_stage->frames.out[0].buf_attr.buf_type =
 					IMGU_ABI_BUFFER_TYPE_OUTPUT_FRAME;
@@ -978,36 +982,36 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 	sp_stage->frames.internal_frame_info.res.width =
 					css_pipe->rect[IPU3_CSS_RECT_BDS].width;
 	sp_stage->frames.internal_frame_info.res.height =
-					css_pipe->rect[IPU3_CSS_RECT_BDS].height;
+				css_pipe->rect[IPU3_CSS_RECT_BDS].height;
 	sp_stage->frames.internal_frame_info.padded_width = bds_width_pad;
 
 	sp_stage->frames.internal_frame_info.format =
-			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->frame_format;
+		css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->frame_format;
 	sp_stage->frames.internal_frame_info.raw_bit_depth =
 			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bit_depth;
 	sp_stage->frames.internal_frame_info.raw_bayer_order =
-			css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bayer_order;
+		css_pipe->queue[IPU3_CSS_QUEUE_OUT].css_fmt->bayer_order;
 	sp_stage->frames.internal_frame_info.raw_type = IMGU_ABI_RAW_TYPE_BAYER;
 
 	sp_stage->frames.out_vf.info.res.width =
-				css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.width;
+			css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.width;
 	sp_stage->frames.out_vf.info.res.height =
-				css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height;
+			css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height;
 	sp_stage->frames.out_vf.info.padded_width =
-					css_pipe->queue[IPU3_CSS_QUEUE_VF].width_pad;
+				css_pipe->queue[IPU3_CSS_QUEUE_VF].width_pad;
 	sp_stage->frames.out_vf.info.format =
-			css_pipe->queue[IPU3_CSS_QUEUE_VF].css_fmt->frame_format;
+		css_pipe->queue[IPU3_CSS_QUEUE_VF].css_fmt->frame_format;
 	sp_stage->frames.out_vf.info.raw_bit_depth =
 			css_pipe->queue[IPU3_CSS_QUEUE_VF].css_fmt->bit_depth;
 	sp_stage->frames.out_vf.info.raw_bayer_order =
 			css_pipe->queue[IPU3_CSS_QUEUE_VF].css_fmt->bayer_order;
 	sp_stage->frames.out_vf.info.raw_type = IMGU_ABI_RAW_TYPE_BAYER;
 	sp_stage->frames.out_vf.planes.yuv.u.offset =
-				css_pipe->queue[IPU3_CSS_QUEUE_VF].width_pad *
-				css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height;
-	sp_stage->frames.out_vf.planes.yuv.v.offset =
 			css_pipe->queue[IPU3_CSS_QUEUE_VF].width_pad *
-			css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height * 5 / 4;
+			css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height;
+	sp_stage->frames.out_vf.planes.yuv.v.offset =
+		css_pipe->queue[IPU3_CSS_QUEUE_VF].width_pad *
+		css_pipe->queue[IPU3_CSS_QUEUE_VF].fmt.mpix.height * 5 / 4;
 	sp_stage->frames.out_vf.buf_attr.buf_src.queue_id = IMGU_ABI_QUEUE_E_ID;
 	sp_stage->frames.out_vf.buf_attr.buf_type =
 					IMGU_ABI_BUFFER_TYPE_VF_OUTPUT_FRAME;
@@ -1018,7 +1022,8 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 	sp_stage->frames.dvs_buf.buf_src.queue_id = IMGU_ABI_QUEUE_G_ID;
 	sp_stage->frames.dvs_buf.buf_type = IMGU_ABI_BUFFER_TYPE_DIS_STATISTICS;
 
-	sp_stage->dvs_envelope.width = css_pipe->rect[IPU3_CSS_RECT_ENVELOPE].width;
+	sp_stage->dvs_envelope.width =
+				css_pipe->rect[IPU3_CSS_RECT_ENVELOPE].width;
 	sp_stage->dvs_envelope.height =
 				css_pipe->rect[IPU3_CSS_RECT_ENVELOPE].height;
 
@@ -1077,8 +1082,8 @@ static int ipu3_css_pipeline_init(struct ipu3_css *css, unsigned int pipe)
 			       3 * cfg_dvs->num_horizontal_blocks / 2 *
 			       cfg_dvs->num_vertical_blocks) ||
 	    ipu3_css_pool_init(imgu, &css_pipe->pool.obgrid,
-			       ipu3_css_fw_obgrid_size(
-			       &css->fwp->binary_header[css_pipe->bindex])))
+			       ipu3_css_fw_obgrid_size
+			       (&css->fwp->binary_header[css_pipe->bindex])))
 		goto out_of_memory;
 
 	for (i = 0; i < IMGU_ABI_NUM_MEMORIES; i++)
@@ -1231,21 +1236,24 @@ static int ipu3_css_binary_preallocate(struct ipu3_css *css, unsigned int pipe)
 	for (j = IMGU_ABI_PARAM_CLASS_CONFIG;
 	     j < IMGU_ABI_PARAM_CLASS_NUM; j++)
 		for (i = 0; i < IMGU_ABI_NUM_MEMORIES; i++)
-			if (!ipu3_dmamap_alloc(imgu,
-					       &css_pipe->binary_params_cs[j - 1][i],
-					       CSS_ABI_SIZE))
+			if (!ipu3_dmamap_alloc
+					(imgu,
+					&css_pipe->binary_params_cs[j - 1][i],
+					CSS_ABI_SIZE))
 				goto out_of_memory;
 
 	for (i = 0; i < IPU3_CSS_AUX_FRAMES; i++)
-		if (!ipu3_dmamap_alloc(imgu,
-				       &css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].
-				       mem[i], CSS_BDS_SIZE))
+		if (!ipu3_dmamap_alloca
+			(imgu,
+			&css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].mem[i],
+			CSS_BDS_SIZE))
 			goto out_of_memory;
 
 	for (i = 0; i < IPU3_CSS_AUX_FRAMES; i++)
-		if (!ipu3_dmamap_alloc(imgu,
-				       &css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR].
-				       mem[i], CSS_GDC_SIZE))
+		if (!ipu3_dmamap_alloc
+			(imgu, &css_pipe->aux_frames
+			 [IPU3_CSS_AUX_FRAME_TNR].mem[i],
+			CSS_GDC_SIZE))
 			goto out_of_memory;
 
 	return 0;
@@ -1269,10 +1277,10 @@ static int ipu3_css_binary_setup(struct ipu3_css *css, unsigned int pipe)
 
 	for (j = IMGU_ABI_PARAM_CLASS_CONFIG; j < IMGU_ABI_PARAM_CLASS_NUM; j++)
 		for (i = 0; i < IMGU_ABI_NUM_MEMORIES; i++) {
-			if (ipu3_css_dma_buffer_resize(
-			    imgu,
-			    &css_pipe->binary_params_cs[j - 1][i],
-			    bi->info.isp.sp.mem_initializers.params[j][i].size))
+			if (ipu3_css_dma_buffer_resize
+			(imgu,
+			&css_pipe->binary_params_cs[j - 1][i],
+			bi->info.isp.sp.mem_initializers.params[j][i].size))
 				goto out_of_memory;
 		}
 
@@ -1292,8 +1300,8 @@ static int ipu3_css_binary_setup(struct ipu3_css *css, unsigned int pipe)
 		css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].bytesperpixel * w;
 	size = w * h * BYPC + (w / 2) * (h / 2) * BYPC * 2;
 	for (i = 0; i < IPU3_CSS_AUX_FRAMES; i++)
-		if (ipu3_css_dma_buffer_resize(
-			imgu,
+		if (ipu3_css_dma_buffer_resize
+			(imgu,
 			&css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_REF].mem[i],
 			size))
 			goto out_of_memory;
@@ -1313,8 +1321,8 @@ static int ipu3_css_binary_setup(struct ipu3_css *css, unsigned int pipe)
 	h = css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR].height;
 	size = w * ALIGN(h * 3 / 2 + 3, 2);	/* +3 for vf_pp prefetch */
 	for (i = 0; i < IPU3_CSS_AUX_FRAMES; i++)
-		if (ipu3_css_dma_buffer_resize(
-			imgu,
+		if (ipu3_css_dma_buffer_resize
+			(imgu,
 			&css_pipe->aux_frames[IPU3_CSS_AUX_FRAME_TNR].mem[i],
 			size))
 			goto out_of_memory;
@@ -1472,15 +1480,14 @@ static int ipu3_css_map_init(struct ipu3_css *css, unsigned int pipe)
 	/* Allocate and map common structures with imgu hardware */
 	for (p = 0; p < IPU3_CSS_PIPE_ID_NUM; p++)
 		for (i = 0; i < IMGU_ABI_MAX_STAGES; i++) {
-			if (!ipu3_dmamap_alloc(imgu,
-					       &css_pipe->
-					       xmem_sp_stage_ptrs[p][i],
-					       sizeof(struct imgu_abi_sp_stage)))
+			if (!ipu3_dmamap_alloc
+					(imgu,
+					&css_pipe->xmem_sp_stage_ptrs[p][i],
+					sizeof(struct imgu_abi_sp_stage)))
 				return -ENOMEM;
-			if (!ipu3_dmamap_alloc(imgu,
-					       &css_pipe->
-					       xmem_isp_stage_ptrs[p][i],
-					       sizeof(struct imgu_abi_isp_stage)))
+			if (!ipu3_dmamap_alloc
+				(imgu, &css_pipe->xmem_isp_stage_ptrs[p][i],
+				sizeof(struct imgu_abi_isp_stage)))
 				return -ENOMEM;
 		}
 
@@ -1955,7 +1962,7 @@ int ipu3_css_buf_queue(struct ipu3_css *css, unsigned int pipe,
 
 	if (b->queue == IPU3_CSS_QUEUE_VF)
 		abi_buf->payload.frame.padded_width =
-					css_pipe->queue[IPU3_CSS_QUEUE_VF].width_pad;
+				css_pipe->queue[IPU3_CSS_QUEUE_VF].width_pad;
 
 	spin_lock(&css_pipe->qlock);
 	list_add_tail(&b->list, &css_pipe->queue[b->queue].bufs);
@@ -2071,7 +2078,8 @@ struct ipu3_css_buffer *ipu3_css_buf_dequeue(struct ipu3_css *css)
 			return ERR_PTR(-EIO);
 		}
 
-		dev_dbg(css->dev, "buffer 0x%8x done from pipe %d\n", daddr, pipe);
+		dev_dbg(css->dev, "buffer 0x%8x done from pipe %d\n",
+			daddr, pipe);
 		b->pipe = pipe;
 		b->state = IPU3_CSS_BUFFER_DONE;
 		list_del(&b->list);
@@ -2203,7 +2211,8 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
 		/* get acc_old */
 		map = ipu3_css_pool_last(&css_pipe->pool.acc, 1);
 		/* user acc */
-		r = ipu3_css_cfg_acc(css, pipe, use, acc, map->vaddr,
+		r = ipu3_css_cfg_acc
+			(css, pipe, use, acc, map->vaddr,
 			set_params ? &set_params->acc_param : NULL);
 		if (r < 0)
 			goto fail;
@@ -2239,7 +2248,8 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
 			ipu3_css_pool_get(&css_pipe->pool.gdc);
 			map = ipu3_css_pool_last(&css_pipe->pool.gdc, 0);
 			gdc = map->vaddr;
-			ipu3_css_cfg_gdc_table(map->vaddr,
+			ipu3_css_cfg_gdc_table
+				(map->vaddr,
 				css_pipe->aux_frames[a].bytesperline /
 				css_pipe->aux_frames[a].bytesperpixel,
 				css_pipe->aux_frames[a].height,
@@ -2334,12 +2344,12 @@ int ipu3_css_set_parameters(struct ipu3_css *css, unsigned int pipe,
 	if (obgrid)
 		ipu3_css_pool_put(&css_pipe->pool.obgrid);
 	if (vmem0)
-		ipu3_css_pool_put(
-			&css_pipe->pool.binary_params_p
+		ipu3_css_pool_put
+			(&css_pipe->pool.binary_params_p
 			[IMGU_ABI_MEM_ISP_VMEM0]);
 	if (dmem0)
-		ipu3_css_pool_put(
-			&css_pipe->pool.binary_params_p
+		ipu3_css_pool_put
+			(&css_pipe->pool.binary_params_p
 			[IMGU_ABI_MEM_ISP_DMEM0]);
 
 fail_no_put:
-- 
2.17.1

