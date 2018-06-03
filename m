Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34923 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751159AbeFCWCS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Jun 2018 18:02:18 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?=
        <ville.syrjala@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        dri-devel@lists.freedesktop.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Ben Skeggs <bskeggs@redhat.com>,
        Sinclair Yeh <syeh@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 0/2] drm: Add generic colorkey plane properties
Date: Mon,  4 Jun 2018 01:00:57 +0300
Message-Id: <20180603220059.17670-1-digetx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

In this version I've reduced color keying modes and properties to a bare
minimum because considering several modes and properties at once might take
quite a lot of effort due to a variety of HW capabilities. This allows us to
start easy with the generic colorkey properties support.

For the starter let's implement probably the most common (and simple) color
keying mode - the "green screen" (or "chroma key") mode. More advanced modes
and features could be implemented later on by as needed basis.

Following Ville's Syrjälä review comments to v2, the color key value is now
given in ARGB16161616 format. Drivers have to convert this 16bpc format into
internal color key value representation themselves. This works well for cases
where conversion is done to a non-planar integer formats, but I'm not sure how
drivers are supposed to cope with cases where conversion involves churning with
fixed point math / floating point representation. Comments are welcome.

v2: https://lists.freedesktop.org/archives/dri-devel/2018-May/178408.html
v1: https://lists.freedesktop.org/archives/dri-devel/2017-December/160510.html

Dmitry Osipenko (1):
  drm/tegra: plane: Implement generic colorkey property for older
    Tegra's

Laurent Pinchart (1):
  drm: Add generic colorkey properties for DRM planes

 drivers/gpu/drm/drm_atomic.c  |  12 ++++
 drivers/gpu/drm/drm_blend.c   |  99 +++++++++++++++++++++++++++++++++
 drivers/gpu/drm/tegra/dc.c    |  25 +++++++++
 drivers/gpu/drm/tegra/dc.h    |   7 +++
 drivers/gpu/drm/tegra/plane.c | 102 ++++++++++++++++++++++++++++++++++
 include/drm/drm_blend.h       |   3 +
 include/drm/drm_plane.h       |  53 ++++++++++++++++++
 7 files changed, 301 insertions(+)

-- 
2.17.0
