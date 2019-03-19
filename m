Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4DEC43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:58:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAA32217F9
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfCSV6b (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 17:58:31 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:44625 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727936AbfCSV61 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 17:58:27 -0400
X-Originating-IP: 90.89.68.76
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 30364240003;
        Tue, 19 Mar 2019 21:58:24 +0000 (UTC)
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
Subject: [RFC PATCH 14/20] drm/omap: Convert to generic image format library
Date:   Tue, 19 Mar 2019 22:57:19 +0100
Message-Id: <49fd5e9fe1712ca4c6aee2e376ffda2cec11bc13.1553032382.git-series.maxime.ripard@bootlin.com>
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
 drivers/gpu/drm/omapdrm/dss/dispc.c |  9 +++++----
 drivers/gpu/drm/omapdrm/omap_fb.c   |  7 ++++---
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/dispc.c b/drivers/gpu/drm/omapdrm/dss/dispc.c
index ba82d916719c..bf60d49ad6ca 100644
--- a/drivers/gpu/drm/omapdrm/dss/dispc.c
+++ b/drivers/gpu/drm/omapdrm/dss/dispc.c
@@ -25,6 +25,7 @@
 #include <linux/vmalloc.h>
 #include <linux/export.h>
 #include <linux/clk.h>
+#include <linux/image-formats.h>
 #include <linux/io.h>
 #include <linux/jiffies.h>
 #include <linux/seq_file.h>
@@ -1898,9 +1899,9 @@ static void dispc_ovl_set_scaling_uv(struct dispc_device *dispc,
 	int scale_x = out_width != orig_width;
 	int scale_y = out_height != orig_height;
 	bool chroma_upscale = plane != OMAP_DSS_WB;
-	const struct drm_format_info *info;
+	const struct image_format_info *info;
 
-	info = drm_format_info(fourcc);
+	info = image_format_drm_lookup(fourcc);
 
 	if (!dispc_has_feature(dispc, FEAT_HANDLE_UV_SEPARATE))
 		return;
@@ -2623,9 +2624,9 @@ static int dispc_ovl_setup_common(struct dispc_device *dispc,
 	bool ilace = !!(vm->flags & DISPLAY_FLAGS_INTERLACED);
 	unsigned long pclk = dispc_plane_pclk_rate(dispc, plane);
 	unsigned long lclk = dispc_plane_lclk_rate(dispc, plane);
-	const struct drm_format_info *info;
+	const struct image_format_info *info;
 
-	info = drm_format_info(fourcc);
+	info = image_format_drm_lookup(fourcc);
 
 	/* when setting up WB, dispc_plane_pclk_rate() returns 0 */
 	if (plane == OMAP_DSS_WB)
diff --git a/drivers/gpu/drm/omapdrm/omap_fb.c b/drivers/gpu/drm/omapdrm/omap_fb.c
index 1d4143adf829..8caecfc8d1db 100644
--- a/drivers/gpu/drm/omapdrm/omap_fb.c
+++ b/drivers/gpu/drm/omapdrm/omap_fb.c
@@ -15,6 +15,7 @@
  * this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/image-formats.h>
 #include <linux/seq_file.h>
 
 #include <drm/drm_crtc.h>
@@ -60,7 +61,7 @@ struct plane {
 struct omap_framebuffer {
 	struct drm_framebuffer base;
 	int pin_count;
-	const struct drm_format_info *format;
+	const struct image_format_info *format;
 	struct plane planes[2];
 	/* lock for pinning (pin_count and planes.dma_addr) */
 	struct mutex lock;
@@ -72,7 +73,7 @@ static const struct drm_framebuffer_funcs omap_framebuffer_funcs = {
 };
 
 static u32 get_linear_addr(struct drm_framebuffer *fb,
-		const struct drm_format_info *format, int n, int x, int y)
+		const struct image_format_info *format, int n, int x, int y)
 {
 	struct omap_framebuffer *omap_fb = to_omap_framebuffer(fb);
 	struct plane *plane = &omap_fb->planes[n];
@@ -126,7 +127,7 @@ void omap_framebuffer_update_scanout(struct drm_framebuffer *fb,
 		struct drm_plane_state *state, struct omap_overlay_info *info)
 {
 	struct omap_framebuffer *omap_fb = to_omap_framebuffer(fb);
-	const struct drm_format_info *format = omap_fb->format;
+	const struct image_format_info *format = omap_fb->format;
 	struct plane *plane = &omap_fb->planes[0];
 	u32 x, y, orient = 0;
 
-- 
git-series 0.9.1
