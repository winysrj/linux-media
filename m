Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10811 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727171AbeIUAgu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 20:36:50 -0400
From: Ville Syrjala <ville.syrjala@linux.intel.com>
To: dri-devel@lists.freedesktop.org
Cc: intel-gfx@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 00/18] drm/i915: Infoframe precompute/check
Date: Thu, 20 Sep 2018 21:51:27 +0300
Message-Id: <20180920185145.1912-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Series aimed at precomputing the HDMI infoframes, and we also get
better validation by reading them back out from the hardware and
comparing with the expected data.

Looks like I typed these up about a year ago. Might be time to
get them in before the anniversary ;)

Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org

Ville Syrjälä (18):
  video/hdmi: Constify 'buffer' to the unpack functions
  video/hdmi: Pass buffer size to infoframe unpack functions
  video/hdmi: Constify infoframe passed to the log functions
  video/hdmi: Constify infoframe passed to the pack functions
  video/hdmi: Add an enum for HDMI packet types
  video/hdmi: Handle the MPEG Source infoframe
  video/hdmi: Handle the NTSC VBI infoframe
  drm/i915: Use memmove() for punching the hole into infoframes
  drm/i915: Pass intel_encoder to infoframe functions
  drm/i915: Add the missing HDMI gamut metadata packet stuff
  drm/i915: Return the mask of enabled infoframes from
    ->inforame_enabled()
  drm/i915: Store mask of enabled infoframes in the crtc state
  drm/i915: Precompute HDMI infoframes
  drm/i915: Read out HDMI infoframes
  drm/i915/sdvo: Precompute HDMI infoframes
  drm/i915/sdvo: Read out HDMI infoframes
  drm/i915: Check infoframe state in intel_pipe_config_compare()
  drm/i915: Include infoframes in the crtc state dump

 drivers/gpu/drm/i915/i915_reg.h      |    4 +-
 drivers/gpu/drm/i915/intel_ddi.c     |   27 +-
 drivers/gpu/drm/i915/intel_display.c |   74 ++-
 drivers/gpu/drm/i915/intel_drv.h     |   27 +-
 drivers/gpu/drm/i915/intel_hdmi.c    |  651 ++++++++++++++++-----
 drivers/gpu/drm/i915/intel_psr.c     |    3 +-
 drivers/gpu/drm/i915/intel_sdvo.c    |  150 ++++-
 drivers/media/i2c/adv7511.c          |    2 +-
 drivers/media/i2c/adv7604.c          |    2 +-
 drivers/media/i2c/adv7842.c          |    2 +-
 drivers/media/i2c/tc358743.c         |    2 +-
 drivers/media/i2c/tda1997x.c         |    4 +-
 drivers/video/hdmi.c                 | 1032 ++++++++++++++++++++++++++++++----
 include/linux/hdmi.h                 |   84 ++-
 14 files changed, 1786 insertions(+), 278 deletions(-)

-- 
2.16.4
