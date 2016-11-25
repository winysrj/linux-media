Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:51098 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754817AbcKYQtZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 11:49:25 -0500
From: Brian Starkey <brian.starkey@arm.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, daniel@ffwll.ch, gustavo@padovan.org,
        laurent.pinchart@ideasonboard.com, eric@anholt.net,
        ville.syrjala@linux.intel.com, liviu.dudau@arm.com
Subject: [RFC PATCH v3 0/6] Introduce writeback connectors
Date: Fri, 25 Nov 2016 16:48:58 +0000
Message-Id: <1480092544-1725-1-git-send-email-brian.starkey@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is v3 of my series introducing a new connector type:
 DRM_MODE_CONNECTOR_WRITEBACK
See v1 and v2 here: [1] [2]

Writeback connectors are used to expose the memory writeback engines
found in some display controllers, which can write a CRTC's
composition result to a memory buffer.
This is useful e.g. for testing, screen-recording, screenshots,
wireless display, display cloning, memory-to-memory composition.

Writeback connectors are given a WRITEBACK_FB_ID property (which acts
slightly differently to FB_ID, so gets a new name), as well as
a PIXEL_FORMATS blob to list the supported writeback formats, and
OUT_FENCE_PTR to be used for out-fences.

The changes since v2 are in the commit messages of each commit.

The main differences are:
 - Subclass drm_connector as drm_writeback_connector
 - Slight relaxation of core checks, to allow
   (connector->crtc && !connector->fb)
 - Dropped PIXEL_FORMATS_SIZE, which was redundant
 - Reworked the event interface, drivers don't need to deal with the
   fence directly
 - Re-ordered the commits to introduce writeback out-fences up-front.

I've kept RFC on this series because the event reporting (introduction
of drm_writeback_job) is probably up for debate.

v4 will be accompanied by igt tests.

As always, I look forward to any comments.

Thanks,
Brian

[1] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1247574.html
[2] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1258017.html

---

Brian Starkey (5):
  drm: Add writeback connector type
  drm: writeback: Add out-fences for writeback connectors
  drm: mali-dp: Rename malidp_input_format
  drm: mali-dp: Add RGB writeback formats for DP550/DP650
  drm: mali-dp: Add writeback connector

Liviu Dudau (1):
  drm: mali-dp: Add support for writeback on DP550/DP650

 Documentation/gpu/drm-kms.rst       |    9 +
 drivers/gpu/drm/Makefile            |    2 +-
 drivers/gpu/drm/arm/Makefile        |    1 +
 drivers/gpu/drm/arm/malidp_crtc.c   |   21 +++
 drivers/gpu/drm/arm/malidp_drv.c    |   25 ++-
 drivers/gpu/drm/arm/malidp_drv.h    |    3 +
 drivers/gpu/drm/arm/malidp_hw.c     |  111 ++++++++----
 drivers/gpu/drm/arm/malidp_hw.h     |   27 ++-
 drivers/gpu/drm/arm/malidp_mw.c     |  278 ++++++++++++++++++++++++++++++
 drivers/gpu/drm/arm/malidp_mw.h     |   18 ++
 drivers/gpu/drm/arm/malidp_planes.c |    8 +-
 drivers/gpu/drm/arm/malidp_regs.h   |   15 ++
 drivers/gpu/drm/drm_atomic.c        |  226 +++++++++++++++++++++++-
 drivers/gpu/drm/drm_atomic_helper.c |    6 +
 drivers/gpu/drm/drm_connector.c     |    4 +-
 drivers/gpu/drm/drm_writeback.c     |  325 +++++++++++++++++++++++++++++++++++
 include/drm/drm_atomic.h            |   11 ++
 include/drm/drm_connector.h         |   13 ++
 include/drm/drm_mode_config.h       |   14 ++
 include/drm/drm_writeback.h         |  115 +++++++++++++
 include/uapi/drm/drm_mode.h         |    1 +
 21 files changed, 1181 insertions(+), 52 deletions(-)
 create mode 100644 drivers/gpu/drm/arm/malidp_mw.c
 create mode 100644 drivers/gpu/drm/arm/malidp_mw.h
 create mode 100644 drivers/gpu/drm/drm_writeback.c
 create mode 100644 include/drm/drm_writeback.h

-- 
1.7.9.5

