Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:47344 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751151AbdKTLmW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Nov 2017 06:42:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?=
        <ville.syrjala@linux.intel.com>,
        Carlos Santa <carlos.santa@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv5 2/3] drm-kms-helpers.rst: document the DP CEC helpers
Date: Mon, 20 Nov 2017 12:42:10 +0100
Message-Id: <20171120114211.21825-3-hverkuil@xs4all.nl>
In-Reply-To: <20171120114211.21825-1-hverkuil@xs4all.nl>
References: <20171120114211.21825-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the Display Port CEC helper functions.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
No changes since v4.
---
 Documentation/gpu/drm-kms-helpers.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/gpu/drm-kms-helpers.rst b/Documentation/gpu/drm-kms-helpers.rst
index 13dd237418cc..a8c2f43c6f1a 100644
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
