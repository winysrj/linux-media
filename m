Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:4231 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753801AbdKMREh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Nov 2017 12:04:37 -0500
From: Ville Syrjala <ville.syrjala@linux.intel.com>
To: dri-devel@lists.freedesktop.org
Cc: intel-gfx@lists.freedesktop.org,
        Akashdeep Sharma <akashdeep.sharma@intel.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Jim Bride <jim.bride@linux.intel.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "Lin, Jia" <lin.a.jia@intel.com>, linux-media@vger.kernel.org,
        Sean Paul <seanpaul@chromium.org>,
        Shashank Sharma <shashank.sharma@intel.com>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 00/10] drm/edid: Infoframe cleanups and fixes
Date: Mon, 13 Nov 2017 19:04:17 +0200
Message-Id: <20171113170427.4150-1-ville.syrjala@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

This series tries to fix some issues with HDMI infoframes. In particular
we can currently send a bogus picture aspect ratio in the infoframe. I
included stuff to to make the infoframe unpakc more robust, evne though
we don't (yet) use it in drm. Additionally I included my earlier "empty"
HDMI infoframe support.

I have further work piled up on top which allows us to precompuet the
infoframes during the atomic check phase. But the series would have
become rather big, so I wanted to post these fixes and cleanups first.

Entire series (with the infoframe precompute) is available here:
git://github.com/vsyrjala/linux.git infoframe_precompute

Cc: Akashdeep Sharma <akashdeep.sharma@intel.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Emil Velikov <emil.l.velikov@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Jim Bride <jim.bride@linux.intel.com>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "Lin, Jia" <lin.a.jia@intel.com>
Cc: linux-media@vger.kernel.org
Cc: Sean Paul <seanpaul@chromium.org>
Cc: Shashank Sharma <shashank.sharma@intel.com>
Cc: Thierry Reding <thierry.reding@gmail.com>

Ville Syrjälä (10):
  video/hdmi: Allow "empty" HDMI infoframes
  drm/edid: Allow HDMI infoframe without VIC or S3D
  drm/modes: Introduce drm_mode_match()
  drm/edid: Use drm_mode_match_no_clocks_no_stereo() for consistentcy
  drm/edid: Fix up edid_cea_modes[] formatting
  drm/edid: Fix cea mode aspect ratio handling
  drm/edid: Don't send bogus aspect ratios in AVI infoframes
  video/hdmi: Reject illegal picture aspect ratios
  video/hdmi: Constify 'buffer' to the unpack functions
  video/hdmi: Pass buffer size to infoframe unpack functions

 drivers/gpu/drm/bridge/sil-sii8620.c      |   3 +-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c |   4 +-
 drivers/gpu/drm/drm_edid.c                | 159 +++++++++++++++++++-----------
 drivers/gpu/drm/drm_modes.c               | 134 +++++++++++++++++++------
 drivers/gpu/drm/exynos/exynos_hdmi.c      |   2 +-
 drivers/gpu/drm/i915/intel_hdmi.c         |  14 +--
 drivers/gpu/drm/mediatek/mtk_hdmi.c       |   3 +-
 drivers/gpu/drm/nouveau/nv50_display.c    |   3 +-
 drivers/gpu/drm/rockchip/inno_hdmi.c      |   1 +
 drivers/gpu/drm/sti/sti_hdmi.c            |   4 +-
 drivers/gpu/drm/zte/zx_hdmi.c             |   1 +
 drivers/media/i2c/adv7511.c               |   2 +-
 drivers/media/i2c/adv7604.c               |   2 +-
 drivers/media/i2c/adv7842.c               |   2 +-
 drivers/media/i2c/tc358743.c              |   2 +-
 drivers/video/hdmi.c                      | 118 ++++++++++++++--------
 include/drm/drm_connector.h               |   5 +
 include/drm/drm_edid.h                    |   1 +
 include/drm/drm_modes.h                   |   9 ++
 include/linux/hdmi.h                      |   3 +-
 20 files changed, 326 insertions(+), 146 deletions(-)

-- 
2.13.6
