Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC8C2C4360F
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0DA92085A
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbfCSV5x (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 17:57:53 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:42919 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727601AbfCSV5w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 17:57:52 -0400
X-Originating-IP: 90.89.68.76
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id A42DE40006;
        Tue, 19 Mar 2019 21:57:48 +0000 (UTC)
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
Subject: [RFC PATCH 08/20] drm/malidp: Convert to generic image format library
Date:   Tue, 19 Mar 2019 22:57:13 +0100
Message-Id: <93737da7ef4ae99082ac8735a7713f68c017c535.1553032382.git-series.maxime.ripard@bootlin.com>
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
 drivers/gpu/drm/arm/malidp_drv.c | 3 ++-
 drivers/gpu/drm/arm/malidp_hw.c  | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/arm/malidp_drv.c b/drivers/gpu/drm/arm/malidp_drv.c
index fec4fe15a71b..1fcbe364a137 100644
--- a/drivers/gpu/drm/arm/malidp_drv.c
+++ b/drivers/gpu/drm/arm/malidp_drv.c
@@ -10,6 +10,7 @@
  * ARM Mali DP500/DP550/DP650 KMS/DRM driver
  */
 
+#include <linux/image-formats.h>
 #include <linux/module.h>
 #include <linux/clk.h>
 #include <linux/component.h>
@@ -314,7 +315,7 @@ malidp_verify_afbc_framebuffer_size(struct drm_device *dev,
 				    const struct drm_mode_fb_cmd2 *mode_cmd)
 {
 	int n_superblocks = 0;
-	const struct drm_format_info *info;
+	const struct image_format_info *info;
 	struct drm_gem_object *objs = NULL;
 	u32 afbc_superblock_size = 0, afbc_superblock_height = 0;
 	u32 afbc_superblock_width = 0, afbc_size = 0;
diff --git a/drivers/gpu/drm/arm/malidp_hw.c b/drivers/gpu/drm/arm/malidp_hw.c
index 07971ad53b29..d25bc4af1bc9 100644
--- a/drivers/gpu/drm/arm/malidp_hw.c
+++ b/drivers/gpu/drm/arm/malidp_hw.c
@@ -326,14 +326,14 @@ static void malidp500_modeset(struct malidp_hw_device *hwdev, struct videomode *
 
 static int malidp500_rotmem_required(struct malidp_hw_device *hwdev, u16 w, u16 h, u32 fmt)
 {
-	const struct drm_format_info *info = drm_format_info(fmt);
+	const struct image_format_info *info = image_format_drm_lookup(fmt);
 
 	/*
 	 * Each layer needs enough rotation memory to fit 8 lines
 	 * worth of pixel data. Required size is then:
 	 *    size = rotated_width * (bpp / 8) * 8;
 	 */
-	return w * drm_format_plane_cpp(info, 0) * 8;
+	return w * image_format_plane_cpp(info, 0) * 8;
 }
 
 static void malidp500_se_write_pp_coefftab(struct malidp_hw_device *hwdev,
-- 
git-series 0.9.1
