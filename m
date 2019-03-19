Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD592C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:59:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9402320828
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfCSV6v (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 17:58:51 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:58579 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727847AbfCSV6O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 17:58:14 -0400
X-Originating-IP: 90.89.68.76
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 702C0C0007;
        Tue, 19 Mar 2019 21:58:10 +0000 (UTC)
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
Subject: [RFC PATCH 16/20] drm/tegra: Convert to generic image format library
Date:   Tue, 19 Mar 2019 22:57:21 +0100
Message-Id: <ce7a9b4291a8aa09c4506f7c329434c86e00e470.1553032382.git-series.maxime.ripard@bootlin.com>
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
 drivers/gpu/drm/tegra/plane.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tegra/plane.c b/drivers/gpu/drm/tegra/plane.c
index d068e8aa3553..e1d82cbdabe8 100644
--- a/drivers/gpu/drm/tegra/plane.c
+++ b/drivers/gpu/drm/tegra/plane.c
@@ -6,6 +6,8 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/image-formats.h>
+
 #include <drm/drm_atomic.h>
 #include <drm/drm_atomic_helper.h>
 #include <drm/drm_plane_helper.h>
@@ -76,7 +78,7 @@ static bool tegra_plane_format_mod_supported(struct drm_plane *plane,
 					     uint32_t format,
 					     uint64_t modifier)
 {
-	const struct drm_format_info *info = drm_format_info(format);
+	const struct image_format_info *info = image_format_drm_lookup(format);
 
 	if (modifier == DRM_FORMAT_MOD_LINEAR)
 		return true;
-- 
git-series 0.9.1
