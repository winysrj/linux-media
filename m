Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C735C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D60EE2085A
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 21:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbfCSV7P (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 17:59:15 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:46373 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727766AbfCSV6E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 17:58:04 -0400
X-Originating-IP: 90.89.68.76
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 5700B1BF207;
        Tue, 19 Mar 2019 21:57:59 +0000 (UTC)
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
Subject: [RFC PATCH 12/20] drm/ipuv3: Convert to generic image format library
Date:   Tue, 19 Mar 2019 22:57:17 +0100
Message-Id: <56da0cae4bd0477930b355a5ddc511a570a587ee.1553032382.git-series.maxime.ripard@bootlin.com>
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
 drivers/gpu/ipu-v3/ipu-pre.c | 3 ++-
 drivers/gpu/ipu-v3/ipu-prg.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-pre.c b/drivers/gpu/ipu-v3/ipu-pre.c
index 4a28f3fbb0a2..d561295abee0 100644
--- a/drivers/gpu/ipu-v3/ipu-pre.c
+++ b/drivers/gpu/ipu-v3/ipu-pre.c
@@ -15,6 +15,7 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/genalloc.h>
+#include <linux/image-formats.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
@@ -174,7 +175,7 @@ void ipu_pre_configure(struct ipu_pre *pre, unsigned int width,
 		       unsigned int height, unsigned int stride, u32 format,
 		       uint64_t modifier, unsigned int bufaddr)
 {
-	const struct drm_format_info *info = drm_format_info(format);
+	const struct image_format_info *info = image_format_drm_lookup(format);
 	u32 active_bpp = info->cpp[0] >> 1;
 	u32 val;
 
diff --git a/drivers/gpu/ipu-v3/ipu-prg.c b/drivers/gpu/ipu-v3/ipu-prg.c
index 38a3a9764e49..608a9213025d 100644
--- a/drivers/gpu/ipu-v3/ipu-prg.c
+++ b/drivers/gpu/ipu-v3/ipu-prg.c
@@ -14,6 +14,7 @@
 #include <drm/drm_fourcc.h>
 #include <linux/clk.h>
 #include <linux/err.h>
+#include <linux/image-formats.h>
 #include <linux/iopoll.h>
 #include <linux/mfd/syscon.h>
 #include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
@@ -132,7 +133,7 @@ EXPORT_SYMBOL_GPL(ipu_prg_present);
 bool ipu_prg_format_supported(struct ipu_soc *ipu, uint32_t format,
 			      uint64_t modifier)
 {
-	const struct drm_format_info *info = drm_format_info(format);
+	const struct image_format_info *info = image_format_drm_lookup(format);
 
 	if (info->num_planes != 1)
 		return false;
-- 
git-series 0.9.1
