Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB64BC43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A87AB2085A
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbfCSV5u (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 17:57:50 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:36907 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727601AbfCSV5r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 17:57:47 -0400
X-Originating-IP: 90.89.68.76
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 3A8DC40008;
        Tue, 19 Mar 2019 21:57:43 +0000 (UTC)
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
Subject: [RFC PATCH 05/20] drm: Replace instances of drm_format_info by drm_get_format_info
Date:   Tue, 19 Mar 2019 22:57:10 +0100
Message-Id: <2c4461e827cf9a64326962094f7420bfafc5e13b.1553032382.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

drm_get_format_info directly calls into drm_format_info, but takes directly
a struct drm_mode_fb_cmd2 pointer, instead of the fourcc directly. It's
shorter to not dereference it, and we can customise the behaviour at the
driver level if we want to, so let's switch to it where it makes sense.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/gpu/drm/gma500/framebuffer.c | 2 +-
 drivers/gpu/drm/omapdrm/omap_fb.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/gma500/framebuffer.c b/drivers/gpu/drm/gma500/framebuffer.c
index c934b3df1f81..46f0078f7a91 100644
--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -232,7 +232,7 @@ static int psb_framebuffer_init(struct drm_device *dev,
 	 * Reject unknown formats, YUV formats, and formats with more than
 	 * 4 bytes per pixel.
 	 */
-	info = drm_format_info(mode_cmd->pixel_format);
+	info = drm_get_format_info(dev, mode_cmd);
 	if (!info || !info->depth || info->cpp[0] > 4)
 		return -EINVAL;
 
diff --git a/drivers/gpu/drm/omapdrm/omap_fb.c b/drivers/gpu/drm/omapdrm/omap_fb.c
index cfb641363a32..6557b2d6e16e 100644
--- a/drivers/gpu/drm/omapdrm/omap_fb.c
+++ b/drivers/gpu/drm/omapdrm/omap_fb.c
@@ -339,7 +339,7 @@ struct drm_framebuffer *omap_framebuffer_init(struct drm_device *dev,
 			dev, mode_cmd, mode_cmd->width, mode_cmd->height,
 			(char *)&mode_cmd->pixel_format);
 
-	format = drm_format_info(mode_cmd->pixel_format);
+	format = drm_get_format_info(dev, mode_cmd);
 
 	for (i = 0; i < ARRAY_SIZE(formats); i++) {
 		if (formats[i] == mode_cmd->pixel_format)
-- 
git-series 0.9.1
