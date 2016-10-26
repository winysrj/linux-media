Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:34202 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752243AbcJZI4G (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 04:56:06 -0400
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [RFC PATCH v2 0/9] Introduce writeback connectors
Date: Wed, 26 Oct 2016 09:54:59 +0100
Message-Id: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is an updated RFC series introducing a new connector type:
 DRM_MODE_CONNECTOR_WRITEBACK
See v1 here: [1]

Writeback connectors are used to expose the memory writeback engines
found in some display controllers, which can write a CRTC's
composition result to a memory buffer.
This is useful e.g. for testing, screen-recording, screenshots,
wireless display, display cloning, memory-to-memory composition.

Writeback connectors are given a WRITEBACK_FB_ID property (which acts
slightly differently to FB_ID, so gets a new name), as well as
PIXEL_FORMATS and PIXEL_FORMATS_SIZE to list the supported writeback
formats, and OUT_FENCE_PTR to be used for out-fences.

The semantics of writeback connectors have been changed significantly
since v1, based largely on Daniel's feedback. Now, a writeback
connector can only be attached to a CRTC if it has a framebuffer
attached and vice-versa. The writeback framebuffer applies only to a
single atomic commit, and userspace can never read back the value of
WRITEBACK_FB_ID. This makes writeback a "one-shot" operation, it must
be re-armed every time it is to be used.

Patch 1 introduces the actual connector type and the infrastructure
around it. Patches 2-6 add a writeback connector for mali-dp.

Patches 7-9 add support for writeback out-fences, based on Gustavo
Padovan's v5 series [2] for adding explicit fencing.

As always, I look forward to any comments.

Thanks,
Brian

[1] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1247574.html
[2] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1253822.html

Changes since v1, based on Daniel and Eric's comments:
 - The writeback framebuffer is no longer persistent across commits
 - Removed the client cap, made the connector report disconnected
   instead
 - Added drm_writeback.c for central connector initialization and
   documentation
 - Added support for out-fences
 - Added core checks for writeback connectors, e.g. disallowing
   a framebuffer with no CRTC
 - Mali-DP doesn't require a full modeset to enable/disable the
   writeback connector

---

Brian Starkey (8):
  drm: Add writeback connector type
  drm: mali-dp: Clear CVAL when leaving config mode
  drm: mali-dp: Rename malidp_input_format
  drm: mali-dp: Add RGB writeback formats for DP550/DP650
  drm: mali-dp: Add writeback connector
  drm: atomic: factor out common out-fence operations
  drm: writeback: Add out-fences for writeback connectors
  drm: mali-dp: Add writeback out-fence support

Liviu Dudau (1):
  drm: mali-dp: Add support for writeback on DP550/DP650

 Documentation/gpu/drm-kms.rst       |    9 +
 drivers/gpu/drm/Makefile            |    2 +-
 drivers/gpu/drm/arm/Makefile        |    1 +
 drivers/gpu/drm/arm/malidp_crtc.c   |   21 +++
 drivers/gpu/drm/arm/malidp_drv.c    |   28 +++-
 drivers/gpu/drm/arm/malidp_drv.h    |    7 +
 drivers/gpu/drm/arm/malidp_hw.c     |  149 +++++++++++++----
 drivers/gpu/drm/arm/malidp_hw.h     |   27 ++-
 drivers/gpu/drm/arm/malidp_mw.c     |  313 +++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/arm/malidp_mw.h     |   28 ++++
 drivers/gpu/drm/arm/malidp_planes.c |    8 +-
 drivers/gpu/drm/arm/malidp_regs.h   |   15 ++
 drivers/gpu/drm/drm_atomic.c        |  218 +++++++++++++++++++++---
 drivers/gpu/drm/drm_atomic_helper.c |    8 +
 drivers/gpu/drm/drm_connector.c     |    4 +-
 drivers/gpu/drm/drm_writeback.c     |  237 ++++++++++++++++++++++++++
 include/drm/drm_atomic.h            |    3 +
 include/drm/drm_connector.h         |   26 +++
 include/drm/drm_crtc.h              |   20 +++
 include/drm/drm_writeback.h         |   21 +++
 include/uapi/drm/drm_mode.h         |    1 +
 21 files changed, 1076 insertions(+), 70 deletions(-)
 create mode 100644 drivers/gpu/drm/arm/malidp_mw.c
 create mode 100644 drivers/gpu/drm/arm/malidp_mw.h
 create mode 100644 drivers/gpu/drm/drm_writeback.c
 create mode 100644 include/drm/drm_writeback.h

-- 
1.7.9.5

