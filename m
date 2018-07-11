Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:60924 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732287AbeGKMc3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 08:32:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, ville.syrjala@linux.intel.com,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv9 2/3] drm-kms-helpers.rst: document the DP CEC helpers
Date: Wed, 11 Jul 2018 14:28:18 +0200
Message-Id: <20180711122819.80457-3-hverkuil@xs4all.nl>
In-Reply-To: <20180711122819.80457-1-hverkuil@xs4all.nl>
References: <20180711122819.80457-1-hverkuil@xs4all.nl>
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
