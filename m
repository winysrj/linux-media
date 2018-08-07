Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40193 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732383AbeHGUWZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 16:22:25 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?=
        <ville.syrjala@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Russell King <linux@armlinux.org.uk>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 0/2] drm: Add generic colorkey plane properties
Date: Tue,  7 Aug 2018 20:22:00 +0300
Message-Id: <20180807172202.1961-1-digetx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes in v4:

1) In response to Ville's Syrjälä review comments:

	- Added new "colorkey.plane_mask" property that specifies which
	  planes shall participate in color key matching operation.

	- Added short glossary-comment to drm_plane_create_colorkey_properties()
	  that clarifies 'destination' / 'source' plane terms.

	- Returned "colorkey.mask" property that was dropped from v3, looks
	  like masking is quite common among different HW and hence makes more
	  sense to have that property by default instead of having additional
	  color keying modes.

	- Changed the color keying mode name to "transparent".

2) In response to Maarten's Lankhorst review comments:

	- Added a drm_colorkey_extract_component() helper which is supposed to
	  commonize color key component value extraction code among DRM drivers.

3) In response to Russell's King review comments:

	- The doc-comment to drm_plane_create_colorkey_properties() now
	  explicitly states that "The converted value shall be *rounded up* to
	  the nearest value". Hence userspace now knows what to expect when
	  plane has a 1bpp format.

Please review, thanks.


v3: https://lists.freedesktop.org/archives/dri-devel/2018-June/179057.html
v2: https://lists.freedesktop.org/archives/dri-devel/2018-May/178408.html
v1: https://lists.freedesktop.org/archives/dri-devel/2017-December/160510.html


Dmitry Osipenko (1):
  drm/tegra: plane: Add generic colorkey properties for older Tegra's

Laurent Pinchart (1):
  drm: Add generic colorkey properties for display planes

 drivers/gpu/drm/drm_atomic.c  |  20 +++++
 drivers/gpu/drm/drm_blend.c   | 150 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/tegra/dc.c    |  25 ++++++
 drivers/gpu/drm/tegra/dc.h    |   7 ++
 drivers/gpu/drm/tegra/plane.c | 156 ++++++++++++++++++++++++++++++++++
 include/drm/drm_blend.h       |   3 +
 include/drm/drm_plane.h       |  91 ++++++++++++++++++++
 7 files changed, 452 insertions(+)

-- 
2.18.0
