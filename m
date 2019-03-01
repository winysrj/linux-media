Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E158C43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 08:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E5162186A
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 08:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbfCAIUG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 03:20:06 -0500
Received: from mga05.intel.com ([192.55.52.43]:32905 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727755AbfCAIUF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 03:20:05 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Mar 2019 00:20:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,426,1544515200"; 
   d="scan'208";a="130339991"
Received: from genxfsim-shark-bay-client-platform.iind.intel.com ([10.223.25.3])
  by orsmga003.jf.intel.com with ESMTP; 01 Mar 2019 00:20:00 -0800
From:   swati2.sharma@intel.com
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        narmstrong@baylibre.com, clinton.a.taylor@intel.com,
        ayaka@soulik.info, ayan.halder@arm.com, maxime.ripard@bootlin.com,
        daniel@fooishbar.org, juhapekka.heikkila@gmail.com,
        maarten.lankhorst@linux.intel.com, stanislav.lisovskiy@intel.com,
        daniel.vetter@ffwll.ch, ville.syrjala@linux.intel.com,
        Swati Sharma <swati2.sharma@intel.com>,
        Vidya Srinivas <vidya.srinivas@intel.com>
Subject: [PATCH 5/6] drm/i915/icl: Add Y2xx and Y4xx (xx:10/12/16) plane control definitions
Date:   Fri,  1 Mar 2019 13:46:26 +0530
Message-Id: <1551428187-12535-6-git-send-email-swati2.sharma@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1551428187-12535-1-git-send-email-swati2.sharma@intel.com>
References: <1551428187-12535-1-git-send-email-swati2.sharma@intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Swati Sharma <swati2.sharma@intel.com>

Added needed plane control flag definitions for Y2xx and Y4xx (10, 12 and
16 bits)

Signed-off-by: Swati Sharma <swati2.sharma@intel.com>
Signed-off-by: Vidya Srinivas <vidya.srinivas@intel.com>
Reviewed-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
---
 drivers/gpu/drm/i915/i915_reg.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index ce4ad20..54bba61 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -6612,6 +6612,12 @@ enum {
 #define   PLANE_CTL_FORMAT_RGB_565		(14 << 24)
 #define   ICL_PLANE_CTL_FORMAT_MASK		(0x1f << 23)
 #define   PLANE_CTL_PIPE_CSC_ENABLE		(1 << 23) /* Pre-GLK */
+#define   PLANE_CTL_FORMAT_Y210                 (1 << 23)
+#define   PLANE_CTL_FORMAT_Y212                 (3 << 23)
+#define   PLANE_CTL_FORMAT_Y216                 (5 << 23)
+#define   PLANE_CTL_FORMAT_Y410                 (7 << 23)
+#define   PLANE_CTL_FORMAT_Y412                 (9 << 23)
+#define   PLANE_CTL_FORMAT_Y416                 (0xb << 23)
 #define   PLANE_CTL_KEY_ENABLE_MASK		(0x3 << 21)
 #define   PLANE_CTL_KEY_ENABLE_SOURCE		(1 << 21)
 #define   PLANE_CTL_KEY_ENABLE_DESTINATION	(2 << 21)
-- 
1.9.1

