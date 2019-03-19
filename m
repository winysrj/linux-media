Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C93D7C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 970DD2183E
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbfCSV6I (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 17:58:08 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:36313 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbfCSV6H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 17:58:07 -0400
X-Originating-IP: 90.89.68.76
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 1131DFF804;
        Tue, 19 Mar 2019 21:58:02 +0000 (UTC)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [RFC PATCH 13/20] drm/msm: Convert to generic image format library
Date:   Tue, 19 Mar 2019 22:57:18 +0100
Message-Id: <8784fe32eed0682db41a4fa9164d8298c28360ff.1553032382.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Now that we have a generic image format libary, let's convert drivers to
use it so that we can deprecate the old DRM one.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_formats.c |  6 ++++--
 drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c   |  3 ++-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c   |  3 ++-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c  |  9 +++++----
 drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c    |  3 ++-
 5 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_formats.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_formats.c
index 1aed51b49be4..8c3c953b05d9 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_formats.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_formats.c
@@ -12,6 +12,8 @@
 
 #define pr_fmt(fmt)	"[drm:%s:%d] " fmt, __func__, __LINE__
 
+#include <linux/image-formats.h>
+
 #include <uapi/drm/drm_fourcc.h>
 
 #include "msm_media_info.h"
@@ -1040,7 +1042,7 @@ int dpu_format_check_modified_format(
 		const struct drm_mode_fb_cmd2 *cmd,
 		struct drm_gem_object **bos)
 {
-	const struct drm_format_info *info;
+	const struct image_format_info *info;
 	const struct dpu_format *fmt;
 	struct dpu_hw_fmt_layout layout;
 	uint32_t bos_total_size = 0;
@@ -1052,7 +1054,7 @@ int dpu_format_check_modified_format(
 	}
 
 	fmt = to_dpu_format(msm_fmt);
-	info = drm_format_info(fmt->base.pixel_format);
+	info = image_format_drm_lookup(fmt->base.pixel_format);
 	if (!info)
 		return -EINVAL;
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
index a9492c488441..1dfaa306ed4b 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
@@ -20,6 +20,7 @@
 
 #include <linux/debugfs.h>
 #include <linux/dma-buf.h>
+#include <linux/image-formats.h>
 
 #include <drm/drm_atomic_uapi.h>
 
@@ -553,7 +554,7 @@ static void _dpu_plane_setup_scaler(struct dpu_plane *pdpu,
 		struct dpu_plane_state *pstate,
 		const struct dpu_format *fmt, bool color_fill)
 {
-	const struct drm_format_info *info = drm_format_info(fmt->base.pixel_format);
+	const struct image_format_info *info = image_format_drm_lookup(fmt->base.pixel_format);
 
 	/* don't chroma subsample if decimating */
 	/* update scaler. calculate default config for QSEED3 */
diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
index aadae21f8818..542c22c4febe 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
@@ -16,6 +16,7 @@
  * this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/image-formats.h>
 #include <linux/sort.h>
 #include <drm/drm_mode.h>
 #include <drm/drm_crtc.h>
@@ -782,7 +783,7 @@ static void get_roi(struct drm_crtc *crtc, uint32_t *roi_w, uint32_t *roi_h)
 
 static void mdp5_crtc_restore_cursor(struct drm_crtc *crtc)
 {
-	const struct drm_format_info *info = drm_format_info(DRM_FORMAT_ARGB8888);
+	const struct image_format_info *info = image_format_drm_lookup(DRM_FORMAT_ARGB8888);
 	struct mdp5_crtc_state *mdp5_cstate = to_mdp5_crtc_state(crtc->state);
 	struct mdp5_crtc *mdp5_crtc = to_mdp5_crtc(crtc);
 	struct mdp5_kms *mdp5_kms = get_kms(crtc);
diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
index 9d9fb6c5fd68..00091637a00c 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c
@@ -17,6 +17,7 @@
  */
 
 #include <drm/drm_print.h>
+#include <linux/image-formats.h>
 #include "mdp5_kms.h"
 
 struct mdp5_plane {
@@ -650,7 +651,7 @@ static int calc_scalex_steps(struct drm_plane *plane,
 		uint32_t pixel_format, uint32_t src, uint32_t dest,
 		uint32_t phasex_steps[COMP_MAX])
 {
-	const struct drm_format_info *info = drm_format_info(pixel_format);
+	const struct image_format_info *info = image_format_drm_lookup(pixel_format);
 	struct mdp5_kms *mdp5_kms = get_kms(plane);
 	struct device *dev = mdp5_kms->dev->dev;
 	uint32_t phasex_step;
@@ -673,7 +674,7 @@ static int calc_scaley_steps(struct drm_plane *plane,
 		uint32_t pixel_format, uint32_t src, uint32_t dest,
 		uint32_t phasey_steps[COMP_MAX])
 {
-	const struct drm_format_info *info = drm_format_info(pixel_format);
+	const struct image_format_info *info = image_format_drm_lookup(pixel_format);
 	struct mdp5_kms *mdp5_kms = get_kms(plane);
 	struct device *dev = mdp5_kms->dev->dev;
 	uint32_t phasey_step;
@@ -695,7 +696,7 @@ static int calc_scaley_steps(struct drm_plane *plane,
 static uint32_t get_scale_config(const struct mdp_format *format,
 		uint32_t src, uint32_t dst, bool horz)
 {
-	const struct drm_format_info *info = drm_format_info(format->base.pixel_format);
+	const struct image_format_info *info = image_format_drm_lookup(format->base.pixel_format);
 	bool scaling = format->is_yuv ? true : (src != dst);
 	uint32_t sub;
 	uint32_t ya_filter, uv_filter;
@@ -750,7 +751,7 @@ static void mdp5_write_pixel_ext(struct mdp5_kms *mdp5_kms, enum mdp5_pipe pipe,
 	uint32_t src_w, int pe_left[COMP_MAX], int pe_right[COMP_MAX],
 	uint32_t src_h, int pe_top[COMP_MAX], int pe_bottom[COMP_MAX])
 {
-	const struct drm_format_info *info = drm_format_info(format->base.pixel_format);
+	const struct image_format_info *info = image_format_drm_lookup(format->base.pixel_format);
 	uint32_t lr, tb, req;
 	int i;
 
diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
index 03d503d8c3ba..b96ff05d7909 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
@@ -16,6 +16,7 @@
  * this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/image-formats.h>
 #include <drm/drm_util.h>
 
 #include "mdp5_kms.h"
@@ -127,7 +128,7 @@ uint32_t mdp5_smp_calculate(struct mdp5_smp *smp,
 		const struct mdp_format *format,
 		u32 width, bool hdecim)
 {
-	const struct drm_format_info *info = drm_format_info(format->base.pixel_format);
+	const struct image_format_info *info = image_format_drm_lookup(format->base.pixel_format);
 	struct mdp5_kms *mdp5_kms = get_kms(smp);
 	int rev = mdp5_cfg_get_hw_rev(mdp5_kms->cfg);
 	int i, hsub, nplanes, nlines;
-- 
git-series 0.9.1
