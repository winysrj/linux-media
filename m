Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97792C282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 13:29:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FD67222B5
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 13:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389174AbfBMN3N (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 08:29:13 -0500
Received: from mga07.intel.com ([134.134.136.100]:2839 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729862AbfBMN3N (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 08:29:13 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Feb 2019 05:29:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,365,1544515200"; 
   d="scan'208";a="318662104"
Received: from genxfsim-shark-bay-client-platform.iind.intel.com ([10.223.25.3])
  by fmsmga006.fm.intel.com with ESMTP; 13 Feb 2019 05:29:08 -0800
From:   Swati Sharma <swati2.sharma@intel.com>
To:     dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        narmstrong@baylibre.com, clinton.a.taylor@intel.com,
        ayaka@soulik.info, ayan.halder@arm.com, maxime.ripard@bootlin.com,
        daniel@fooishbar.org, juhapekka.heikkila@gmail.com,
        maarten.lankhorst@linux.intel.com, stanislav.lisovskiy@intel.com,
        daniel.vetter@ffwll.ch, ville.syrjala@linux.intel.com,
        Swati Sharma <swati2.sharma@intel.com>
Subject: [PATCH 0/6] Enable P0xx (planar), Y2xx/Y4xx (packed) pixel formats
Date:   Wed, 13 Feb 2019 18:55:27 +0530
Message-Id: <1550064333-6168-1-git-send-email-swati2.sharma@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch series is for enabling P0xx, Y2xx and Y4xx pixel formats for
intel's i915 driver.

In this patch series, Juha Pekka's patch series Gen10+ P0xx formats
https://patchwork.freedesktop.org/series/56053/ is combined with Swati's
https://patchwork.freedesktop.org/series/55035/ for Gen11+ pixel formats
(Y2xx and Y4xx).

P0xx pixel formats are enabled from GLK whereas Y2xx and Y4xx are enabled
from ICL platform.

These patches enable planar formats YUV420-P010, P012 and  P016
(Intial 3 patches of Juha) for GLK+ platform and packed format YUV422-Y210,
Y212 and Y216 and YUV444-Y410, Y412, Y416 for 10, 12 and 16 bits for ICL+
platforms.

IGT validating all these pixel formats is written by Maarten Lankhorst 
https://patchwork.freedesktop.org/patch/284508/

IGT needs libraries for pixman and cairo to support more than 8bpc. Need 
cairo >= 1.17.2 and pixman-1 >= 0.36.0.

Tested with custom cairo and pixman. P0xx and Y2xx successfully validated for
HDR planes, SDR planes having CRC mismatch (known bug for all YUV formats).
IGT for Y410 and Y416 is alpha enabled whereas kernel patches are non-alpha;
depending upon review comments will make changes either in IGT or kernel.
TODO: IGT for Y412 yet to be written

Also, need community feedback if Y4xx pixel formats should be renamed to XYUV_2101010/
XYUV_12121212/XYUV16161616.

Juha-Pekka Heikkila (3):
  drm/i915: Add P010, P012, P016 plane control definitions
  drm/i915: Preparations for enabling P010, P012, P016 formats
  drm/i915: Enable P010, P012, P016 formats for primary and sprite
    planes

Swati Sharma (3):
  drm: Add Y2xx and Y4xx (xx:10/12/16) format definitions and fourcc
  drm/i915/icl: Add Y2xx and Y4xx (xx:10/12/16) plane control
    definitions
  drm/i915/icl: Enabling Y2xx and Y4xx (xx:10/12/16) formats for
    universal planes

 drivers/gpu/drm/drm_fourcc.c              |   6 ++
 drivers/gpu/drm/i915/i915_reg.h           |   9 +++
 drivers/gpu/drm/i915/intel_atomic_plane.c |   2 +-
 drivers/gpu/drm/i915/intel_display.c      |  57 ++++++++++++++--
 drivers/gpu/drm/i915/intel_drv.h          |   1 +
 drivers/gpu/drm/i915/intel_pm.c           |  14 ++--
 drivers/gpu/drm/i915/intel_sprite.c       | 108 ++++++++++++++++++++++++++++--
 include/uapi/drm/drm_fourcc.h             |  18 ++++-
 8 files changed, 195 insertions(+), 20 deletions(-)

-- 
1.9.1

