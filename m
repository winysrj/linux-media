Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38837 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbeDSJbZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 05:31:25 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: architt@codeaurora.org, a.hajda@samsung.com,
        Laurent.pinchart@ideasonboard.com, airlied@linux.ie
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, daniel@ffwll.ch,
        peda@axentia.se, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] drm: bridge: Add support for static image formats
Date: Thu, 19 Apr 2018 11:31:01 +0200
Message-Id: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello DRM list,
  cc media-list for the mbus format extension
  cc renesas-soc and devicetree for Eagle DTS patch

This series adds support for static image formats to DRM bridges, mimicking
what display_info.bus_formats represents for DRM connectors.

The main use case of this series is the R-Car DU LVDS encoder. This component
can output LVDS streams compatible with JEIDA or SPWG specification, and so far
it has only been possible to decide which one to output if the next component
in the DRM pipeline was a panel, equipped with a DRM connector where to inspect
the accepted input image format from.

With the introduction of the transparent THC63LVD1024 LVDS decoder driver, the
next component in the pipeline is now a bridge, and the DU LVDS encoder needs
to inspect which media bus image formats it accepts and set its LVDS output
mode accordingly.

The series implements -static- image format supports for bridges. As a result
of the discussion on Peter Rosin's patch series:
[PATCH v2 0/5] allow override of bus format in bridges
https://lkml.org/lkml/2018/3/26/610
my understanding is that the accepted image formats can be 'dynamic' (or
'atomic') if depends on the configured DRM mode, or 'static' as in the
THC63LVD1024 case, where an external pin configuration decides which LVDS
mapping mode the encoder accepts (which implies it comes from DT, as in Peter's
use case).

For dynamic formats Daniel already suggested a possible implementation:
https://lkml.org/lkml/2018/3/28/57
while for static image formats I am proposing an implementation that
copies what we have for connectors at the moment.

One more detail: the DU LVDS encoder supports 'mirroring' of LVDS modes, and
that was handled through a set of flags (DRM_BUS_FLAG_DATA_*) defined for
connectors only, and added for that specific purpose, if I got this right.
Instead of replicating the same flags for bridges, or moving them to some shared
header which I had trouble to identify, I have introduced the _LE version of
mbus formats used to describe LVDS streams. While 'little endian' is not
*technically* exact for those mirrored formats, it is my opinion they represent
a good description anyhow of the reversed component ordering.

As a result, the connector specific DRM_BUS_FLAG_DATA_* have been removed as
all their user have been ported to use the new _LE formats.

The series depends on THC63LVD1024 support, implemented by the following
in-review series:
 [PATCH v9 0/2] drm: Add Thine THC63LVD1024 LVDS decoder bridge
 [PATCH v3 0/5] V3M-Eagle HDMI output enablement

available for the interested at:
git://jmondi.org/linux lvds-bridge/linus-master/v9-eagle-v3

Thanks for comments
   j

Jacopo Mondi (8):
  drm: bridge: Add support for static image formats
  dt-bindings: display: bridge: thc63lvd1024: Add lvds map property
  drm: bridge: thc63lvd1024: Add support for LVDS mode map
  arm64: dts: renesas: eagle: Add thc63 LVDS map
  media: Add LE version of RGB LVDS formats
  drm: rcar-du: rcar-lvds: Add bridge format support
  drm: panel: Use _LE LVDS formats for data mirroring
  drm: connector: Remove DRM_BUS_FLAG_DATA_* flags

 .../bindings/display/bridge/thine,thc63lvd1024.txt |   3 +
 Documentation/media/uapi/v4l/subdev-formats.rst    | 174 +++++++++++++++++++++
 arch/arm64/boot/dts/renesas/r8a77970-eagle.dts     |   1 +
 drivers/gpu/drm/bridge/thc63lvd1024.c              |  41 +++++
 drivers/gpu/drm/drm_bridge.c                       |  30 ++++
 drivers/gpu/drm/panel/panel-lvds.c                 |  21 +--
 drivers/gpu/drm/rcar-du/rcar_lvds.c                |  64 +++++---
 include/drm/drm_bridge.h                           |   8 +
 include/drm/drm_connector.h                        |   4 -
 include/uapi/linux/media-bus-format.h              |   5 +-
 10 files changed, 317 insertions(+), 34 deletions(-)

--
2.7.4
