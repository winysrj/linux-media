Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:37480 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726843AbeGKMc2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 08:32:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, ville.syrjala@linux.intel.com
Subject: [PATCHv9 0/3] drm/i915: add DisplayPort CEC-Tunneling-over-AUX support
Date: Wed, 11 Jul 2018 14:28:16 +0200
Message-Id: <20180711122819.80457-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds support for the DisplayPort CEC-Tunneling-over-AUX
feature. This patch series is based on the current media master branch
(https://git.linuxtv.org/media_tree.git/log/) but it applies fine on top
of the current mainline tree.

The v9 is identical to v8, the only change is that it is now also CCed to
intel-gfx@lists.freedesktop.org.

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
 drivers/gpu/drm/drm_dp_cec.c          | 427 ++++++++++++++++++++++++++
 drivers/gpu/drm/drm_dp_helper.c       |   1 +
 drivers/gpu/drm/i915/intel_dp.c       |  17 +-
 include/drm/drm_dp_helper.h           |  56 ++++
 7 files changed, 519 insertions(+), 2 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_dp_cec.c

-- 
2.18.0
