Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B010EC43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 08:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BE772186A
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 08:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727418AbfCAITq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 03:19:46 -0500
Received: from mga04.intel.com ([192.55.52.120]:53525 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726226AbfCAITp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 03:19:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Mar 2019 00:19:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,426,1544515200"; 
   d="scan'208";a="130339902"
Received: from genxfsim-shark-bay-client-platform.iind.intel.com ([10.223.25.3])
  by orsmga003.jf.intel.com with ESMTP; 01 Mar 2019 00:19:41 -0800
From:   swati2.sharma@intel.com
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        narmstrong@baylibre.com, clinton.a.taylor@intel.com,
        ayaka@soulik.info, ayan.halder@arm.com, maxime.ripard@bootlin.com,
        daniel@fooishbar.org, juhapekka.heikkila@gmail.com,
        maarten.lankhorst@linux.intel.com, stanislav.lisovskiy@intel.com,
        daniel.vetter@ffwll.ch, ville.syrjala@linux.intel.com,
        Swati Sharma <swati2.sharma@intel.com>
Subject: [PATCH 1/6] drm/i915: Add P010, P012, P016 plane control definitions
Date:   Fri,  1 Mar 2019 13:46:22 +0530
Message-Id: <1551428187-12535-2-git-send-email-swati2.sharma@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1551428187-12535-1-git-send-email-swati2.sharma@intel.com>
References: <1551428187-12535-1-git-send-email-swati2.sharma@intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>

Add needed plane control flag definitions for P010, P012 and
P016 formats.

Signed-off-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Signed-off-by: Swati Sharma <swati2.sharma@intel.com>
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
---
 drivers/gpu/drm/i915/i915_reg.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index c9b482b..ce4ad20 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -6602,8 +6602,11 @@ enum {
 #define   PLANE_CTL_FORMAT_YUV422		(0 << 24)
 #define   PLANE_CTL_FORMAT_NV12			(1 << 24)
 #define   PLANE_CTL_FORMAT_XRGB_2101010		(2 << 24)
+#define   PLANE_CTL_FORMAT_P010			(3 << 24)
 #define   PLANE_CTL_FORMAT_XRGB_8888		(4 << 24)
+#define   PLANE_CTL_FORMAT_P012			(5 << 24)
 #define   PLANE_CTL_FORMAT_XRGB_16161616F	(6 << 24)
+#define   PLANE_CTL_FORMAT_P016			(7 << 24)
 #define   PLANE_CTL_FORMAT_AYUV			(8 << 24)
 #define   PLANE_CTL_FORMAT_INDEXED		(12 << 24)
 #define   PLANE_CTL_FORMAT_RGB_565		(14 << 24)
-- 
1.9.1

