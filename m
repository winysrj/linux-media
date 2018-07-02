Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:52424 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752612AbeGBPr7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 11:47:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, ville.syrjala@linux.intel.com,
        seanpaul@chromium.org, daniel.vetter@ffwll.ch,
        carlos.santa@intel.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv8 2/3] drm-kms-helpers.rst: document the DP CEC helpers
Date: Mon,  2 Jul 2018 17:47:55 +0200
Message-Id: <20180702154756.117244-3-hverkuil@xs4all.nl>
In-Reply-To: <20180702154756.117244-1-hverkuil@xs4all.nl>
References: <20180702154756.117244-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the Display Port CEC helper functions.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 Documentation/gpu/drm-kms-helpers.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/gpu/drm-kms-helpers.rst b/Documentation/gpu/drm-kms-helpers.rst
index e37557b30f62..62de583e9efe 100644
--- a/Documentation/gpu/drm-kms-helpers.rst
+++ b/Documentation/gpu/drm-kms-helpers.rst
@@ -169,6 +169,15 @@ Display Port Helper Functions Reference
 .. kernel-doc:: drivers/gpu/drm/drm_dp_helper.c
    :export:
 
+Display Port CEC Helper Functions Reference
+===========================================
+
+.. kernel-doc:: drivers/gpu/drm/drm_dp_cec.c
+   :doc: dp cec helpers
+
+.. kernel-doc:: drivers/gpu/drm/drm_dp_cec.c
+   :export:
+
 Display Port Dual Mode Adaptor Helper Functions Reference
 =========================================================
 
-- 
2.18.0
