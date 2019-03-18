Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC971C10F00
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 14:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE5B02087E
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 14:31:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="V6NLIDff"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfCRObu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 10:31:50 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:59242 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727854AbfCRObt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 10:31:49 -0400
Received: from pendragon.bb.dnainternet.fi (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 81B961AA6;
        Mon, 18 Mar 2019 15:31:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552919500;
        bh=rpLinvgwPr2/ewb0WIu3TadMwtSdEkUY5fxl2AVhxxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6NLIDffSRE8TMtOwfzfl7a/CiFwyp2CoFi193zVDvsJ9pe7D2nq5id2/wYKaAw1x
         zPQ+AWasyp9Ky0OIIabXWTawbbqrW1y0ifvw4VMx/E1Nxi/QXygrEXfHikiekK/zsf
         zGOgxJX96om1GEAU7Am4picLa6KkgB/skWCWdxjw=
From:   Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH v7 16/18] drm: rcar-du: Store V4L2 fourcc in rcar_du_format_info structure
Date:   Mon, 18 Mar 2019 16:31:19 +0200
Message-Id: <20190318143121.29561-17-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190318143121.29561-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20190318143121.29561-1-laurent.pinchart+renesas@ideasonboard.com>
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
index 3b7d50a8fb9b..3a5e719a6b66 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
@@ -34,60 +34,70 @@
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
@@ -99,62 +109,77 @@ static const struct rcar_du_format_info rcar_du_format_infos[] = {
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
index 520929389666..ddfe4de64915 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
@@ -110,8 +110,7 @@ void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc)
 	vsp1_du_atomic_flush(crtc->vsp->vsp, crtc->vsp_pipe, &cfg);
 }
 
-/* Keep the two tables in sync. */
-static const u32 formats_kms[] = {
+static const u32 rcar_du_vsp_formats[] = {
 	DRM_FORMAT_RGB332,
 	DRM_FORMAT_ARGB4444,
 	DRM_FORMAT_XRGB4444,
@@ -139,40 +138,13 @@ static const u32 formats_kms[] = {
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
@@ -195,12 +167,8 @@ static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
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
@@ -395,8 +363,8 @@ int rcar_du_vsp_init(struct rcar_du_vsp *vsp, struct device_node *np,
 
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

