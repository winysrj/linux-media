Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:40167 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732469AbeGKNdd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 09:33:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, ville.syrjala@linux.intel.com
Subject: [PATCHv10 0/3] drm/i915: add DisplayPort CEC-Tunneling-over-AUX support
Date: Wed, 11 Jul 2018 15:29:06 +0200
Message-Id: <20180711132909.25409-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds support for the DisplayPort CEC-Tunneling-over-AUX
feature. This patch series is based on top of drm-intel-next.

The v10 is identical to v9, except it is rebased to drm-intel-next (v9
didn't apply cleanly) and two alignment warnings have been fixed.

The cover letter of v8 can be found here:

https://www.spinics.net/lists/dri-devel/msg181688.html

Regards,

	Hans

Hans Verkuil (3):
  drm: add support for DisplayPort CEC-Tunneling-over-AUX
  drm-kms-helpers.rst: document the DP CEC helpers
  drm/i915: add DisplayPort CEC-Tunneling-over-AUX support

 Documentation/gpu/drm-kms-helpers.rst |   9 +
 drivers/gpu/drm/Kconfig               |  10 +
 drivers/gpu/drm/Makefile              |   1 +
 drivers/gpu/drm/drm_dp_cec.c          | 428 ++++++++++++++++++++++++++
 drivers/gpu/drm/drm_dp_helper.c       |   1 +
 drivers/gpu/drm/i915/intel_dp.c       |  17 +-
 include/drm/drm_dp_helper.h           |  56 ++++
 7 files changed, 520 insertions(+), 2 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_dp_cec.c

-- 
2.18.0
