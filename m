Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:35359 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751434AbdIKLZx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 07:25:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Sean Paul <seanpaul@chromium.org>,
        Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?=
        <ville.syrjala@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv3 2/3] drm-kms-helpers.rst: document the DP CEC helpers
Date: Mon, 11 Sep 2017 13:25:46 +0200
Message-Id: <20170911112547.7133-3-hverkuil@xs4all.nl>
In-Reply-To: <20170911112547.7133-1-hverkuil@xs4all.nl>
References: <20170911112547.7133-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the Display Port CEC helper functions.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/gpu/drm-kms-helpers.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/gpu/drm-kms-helpers.rst b/Documentation/gpu/drm-kms-helpers.rst
index 7c5e2549a58a..0d2fa879edd1 100644
--- a/Documentation/gpu/drm-kms-helpers.rst
+++ b/Documentation/gpu/drm-kms-helpers.rst
@@ -175,6 +175,15 @@ Display Port Helper Functions Reference
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
2.14.1
