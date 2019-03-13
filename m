Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4603BC10F0C
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D4E3214AE
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 00:06:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="huYrlFVj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfCMAGB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 20:06:01 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:42062 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727433AbfCMAGB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 20:06:01 -0400
Received: from pendragon.bb.dnainternet.fi (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 7A2449C3;
        Wed, 13 Mar 2019 01:05:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552435555;
        bh=wpJmKqfUIM3L8oEUrliQ0HF1hoZze+33PlEUXb375FU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=huYrlFVjRLf0m54zG3FtclVIlFk2xc1sMZrANxKlDsB6MqCUmRzcziAXilevkT+5l
         g3K7lXgvRXCgs3jh/Vq0CUiaFom5RKSJCH4x4+3m32blnavZLU+kkSN6W8Z/mZwMDh
         I4MqnmkWASDl2vh0fdb92nn+9ZCmhQ4khtod6EL8=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v6 16/18] drm: rcar-du: Store V4L2 fourcc in rcar_du_format_info structure
Date:   Wed, 13 Mar 2019 02:05:30 +0200
Message-Id: <20190313000532.7087-17-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The mapping between DRM and V4L2 fourcc's is stored in two separate
tables in rcar_du_vsp.c. In order to make it reusable to implement
writeback support, move it to the rcar_du_format_info structure.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/rcar_du_kms.c | 25 +++++++++++++++
 drivers/gpu/drm/rcar-du/rcar_du_kms.h |  1 +
 drivers/gpu/drm/rcar-du/rcar_du_vsp.c | 44 ++++-----------------------
 3 files changed, 32 insertions(+), 38 deletions(-)

diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.c b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
index b0c80dffd8b8..999440c7b258 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
@@ -32,60 +32,70 @@
 static const struct rcar_du_format_info rcar_du_format_infos[] = {
 	{
 		.fourcc = DRM_FORMAT_RGB565,
+		.v4l2 = V4L2_PIX_FMT_RGB565,
 		.bpp = 16,
 		.planes = 1,
 		.pnmr = PnMR_SPIM_TP | PnMR_DDDF_16BPP,
 		.edf = PnDDCR4_EDF_NONE,
 	}, {
 		.fourcc = DRM_FORMAT_ARGB1555,
+		.v4l2 = V4L2_PIX_FMT_ARGB555,
 		.bpp = 16,
 		.planes = 1,
 		.pnmr = PnMR_SPIM_ALP | PnMR_DDDF_ARGB,
 		.edf = PnDDCR4_EDF_NONE,
 	}, {
 		.fourcc = DRM_FORMAT_XRGB1555,
+		.v4l2 = V4L2_PIX_FMT_XRGB555,
 		.bpp = 16,
 		.planes = 1,
 		.pnmr = PnMR_SPIM_ALP | PnMR_DDDF_ARGB,
 		.edf = PnDDCR4_EDF_NONE,
 	}, {
 		.fourcc = DRM_FORMAT_XRGB8888,
+		.v4l2 = V4L2_PIX_FMT_XBGR32,
 		.bpp = 32,
 		.planes = 1,
 		.pnmr = PnMR_SPIM_TP | PnMR_DDDF_16BPP,
 		.edf = PnDDCR4_EDF_RGB888,
 	}, {
 		.fourcc = DRM_FORMAT_ARGB8888,
+		.v4l2 = V4L2_PIX_FMT_ABGR32,
 		.bpp = 32,
 		.planes = 1,
 		.pnmr = PnMR_SPIM_ALP | PnMR_DDDF_16BPP,
 		.edf = PnDDCR4_EDF_ARGB8888,
 	}, {
 		.fourcc = DRM_FORMAT_UYVY,
+		.v4l2 = V4L2_PIX_FMT_UYVY,
 		.bpp = 16,
 		.planes = 1,
 		.pnmr = PnMR_SPIM_TP_OFF | PnMR_DDDF_YC,
 		.edf = PnDDCR4_EDF_NONE,
 	}, {
 		.fourcc = DRM_FORMAT_YUYV,
+		.v4l2 = V4L2_PIX_FMT_YUYV,
 		.bpp = 16,
 		.planes = 1,
 		.pnmr = PnMR_SPIM_TP_OFF | PnMR_DDDF_YC,
 		.edf = PnDDCR4_EDF_NONE,
 	}, {
 		.fourcc = DRM_FORMAT_NV12,
+		.v4l2 = V4L2_PIX_FMT_NV12M,
 		.bpp = 12,
 		.planes = 2,
 		.pnmr = PnMR_SPIM_TP_OFF | PnMR_DDDF_YC,
 		.edf = PnDDCR4_EDF_NONE,
 	}, {
 		.fourcc = DRM_FORMAT_NV21,
+		.v4l2 = V4L2_PIX_FMT_NV21M,
 		.bpp = 12,
 		.planes = 2,
 		.pnmr = PnMR_SPIM_TP_OFF | PnMR_DDDF_YC,
 		.edf = PnDDCR4_EDF_NONE,
 	}, {
 		.fourcc = DRM_FORMAT_NV16,
+		.v4l2 = V4L2_PIX_FMT_NV16M,
 		.bpp = 16,
 		.planes = 2,
 		.pnmr = PnMR_SPIM_TP_OFF | PnMR_DDDF_YC,
@@ -97,62 +107,77 @@ static const struct rcar_du_format_info rcar_du_format_infos[] = {
 	 */
 	{
 		.fourcc = DRM_FORMAT_RGB332,
+		.v4l2 = V4L2_PIX_FMT_RGB332,
 		.bpp = 8,
 		.planes = 1,
 	}, {
 		.fourcc = DRM_FORMAT_ARGB4444,
+		.v4l2 = V4L2_PIX_FMT_ARGB444,
 		.bpp = 16,
 		.planes = 1,
 	}, {
 		.fourcc = DRM_FORMAT_XRGB4444,
+		.v4l2 = V4L2_PIX_FMT_XRGB444,
 		.bpp = 16,
 		.planes = 1,
 	}, {
 		.fourcc = DRM_FORMAT_BGR888,
+		.v4l2 = V4L2_PIX_FMT_RGB24,
 		.bpp = 24,
 		.planes = 1,
 	}, {
 		.fourcc = DRM_FORMAT_RGB888,
+		.v4l2 = V4L2_PIX_FMT_BGR24,
 		.bpp = 24,
 		.planes = 1,
 	}, {
 		.fourcc = DRM_FORMAT_BGRA8888,
+		.v4l2 = V4L2_PIX_FMT_ARGB32,
 		.bpp = 32,
 		.planes = 1,
 	}, {
 		.fourcc = DRM_FORMAT_BGRX8888,
+		.v4l2 = V4L2_PIX_FMT_XRGB32,
 		.bpp = 32,
 		.planes = 1,
 	}, {
 		.fourcc = DRM_FORMAT_YVYU,
+		.v4l2 = V4L2_PIX_FMT_YVYU,
 		.bpp = 16,
 		.planes = 1,
 	}, {
 		.fourcc = DRM_FORMAT_NV61,
+		.v4l2 = V4L2_PIX_FMT_NV61M,
 		.bpp = 16,
 		.planes = 2,
 	}, {
 		.fourcc = DRM_FORMAT_YUV420,
+		.v4l2 = V4L2_PIX_FMT_YUV420M,
 		.bpp = 12,
 		.planes = 3,
 	}, {
 		.fourcc = DRM_FORMAT_YVU420,
+		.v4l2 = V4L2_PIX_FMT_YVU420M,
 		.bpp = 12,
 		.planes = 3,
 	}, {
 		.fourcc = DRM_FORMAT_YUV422,
+		.v4l2 = V4L2_PIX_FMT_YUV422M,
 		.bpp = 16,
 		.planes = 3,
 	}, {
 		.fourcc = DRM_FORMAT_YVU422,
+		.v4l2 = V4L2_PIX_FMT_YVU422M,
 		.bpp = 16,
 		.planes = 3,
 	}, {
 		.fourcc = DRM_FORMAT_YUV444,
+		.v4l2 = V4L2_PIX_FMT_YUV444M,
 		.bpp = 24,
 		.planes = 3,
 	}, {
 		.fourcc = DRM_FORMAT_YVU444,
+		.v4l2 = V4L2_PIX_FMT_YVU444M,
 		.bpp = 24,
 		.planes = 3,
 	},
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.h b/drivers/gpu/drm/rcar-du/rcar_du_kms.h
index e171527abdaa..0346504d8c59 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_kms.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.h
@@ -19,6 +19,7 @@ struct rcar_du_device;
 
 struct rcar_du_format_info {
 	u32 fourcc;
+	u32 v4l2;
 	unsigned int bpp;
 	unsigned int planes;
 	unsigned int pnmr;
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
index 28bfeb8c24fb..29a08f7b0761 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -109,8 +109,7 @@ void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc)
 	vsp1_du_atomic_flush(crtc->vsp->vsp, crtc->vsp_pipe, &cfg);
 }
 
-/* Keep the two tables in sync. */
-static const u32 formats_kms[] = {
+static const u32 rcar_du_vsp_formats[] = {
 	DRM_FORMAT_RGB332,
 	DRM_FORMAT_ARGB4444,
 	DRM_FORMAT_XRGB4444,
@@ -138,40 +137,13 @@ static const u32 formats_kms[] = {
 	DRM_FORMAT_YVU444,
 };
 
-static const u32 formats_v4l2[] = {
-	V4L2_PIX_FMT_RGB332,
-	V4L2_PIX_FMT_ARGB444,
-	V4L2_PIX_FMT_XRGB444,
-	V4L2_PIX_FMT_ARGB555,
-	V4L2_PIX_FMT_XRGB555,
-	V4L2_PIX_FMT_RGB565,
-	V4L2_PIX_FMT_RGB24,
-	V4L2_PIX_FMT_BGR24,
-	V4L2_PIX_FMT_ARGB32,
-	V4L2_PIX_FMT_XRGB32,
-	V4L2_PIX_FMT_ABGR32,
-	V4L2_PIX_FMT_XBGR32,
-	V4L2_PIX_FMT_UYVY,
-	V4L2_PIX_FMT_YUYV,
-	V4L2_PIX_FMT_YVYU,
-	V4L2_PIX_FMT_NV12M,
-	V4L2_PIX_FMT_NV21M,
-	V4L2_PIX_FMT_NV16M,
-	V4L2_PIX_FMT_NV61M,
-	V4L2_PIX_FMT_YUV420M,
-	V4L2_PIX_FMT_YVU420M,
-	V4L2_PIX_FMT_YUV422M,
-	V4L2_PIX_FMT_YVU422M,
-	V4L2_PIX_FMT_YUV444M,
-	V4L2_PIX_FMT_YVU444M,
-};
-
 static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
 {
 	struct rcar_du_vsp_plane_state *state =
 		to_rcar_vsp_plane_state(plane->plane.state);
 	struct rcar_du_crtc *crtc = to_rcar_crtc(state->state.crtc);
 	struct drm_framebuffer *fb = plane->plane.state->fb;
+	const struct rcar_du_format_info *format;
 	struct vsp1_du_atomic_config cfg = {
 		.pixelformat = 0,
 		.pitch = fb->pitches[0],
@@ -194,12 +166,8 @@ static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
 		cfg.mem[i] = sg_dma_address(state->sg_tables[i].sgl)
 			   + fb->offsets[i];
 
-	for (i = 0; i < ARRAY_SIZE(formats_kms); ++i) {
-		if (formats_kms[i] == state->format->fourcc) {
-			cfg.pixelformat = formats_v4l2[i];
-			break;
-		}
-	}
+	format = rcar_du_format_info(state->format->fourcc);
+	cfg.pixelformat = format->v4l2;
 
 	vsp1_du_atomic_update(plane->vsp->vsp, crtc->vsp_pipe,
 			      plane->index, &cfg);
@@ -394,8 +362,8 @@ int rcar_du_vsp_init(struct rcar_du_vsp *vsp, struct device_node *np,
 
 		ret = drm_universal_plane_init(rcdu->ddev, &plane->plane, crtcs,
 					       &rcar_du_vsp_plane_funcs,
-					       formats_kms,
-					       ARRAY_SIZE(formats_kms),
+					       rcar_du_vsp_formats,
+					       ARRAY_SIZE(rcar_du_vsp_formats),
 					       NULL, type, NULL);
 		if (ret < 0)
 			return ret;
-- 
Regards,

Laurent Pinchart

