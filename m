Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49132 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752738AbcJDQXh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Oct 2016 12:23:37 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 0/2] R-Car DU: Add support for LVDS mode selection
Date: Tue,  4 Oct 2016 19:23:28 +0300
Message-Id: <1475598210-26857-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series adds support for LVDS mode selection in the R-Car DU driver.

Patch 1/2 defines a new DT binding for LVDS panel. Compared to the existing
DPI panel bindings that are currently abused by the driver for LVDS panel,
this new binding specifies the LVDS more explicitly. Patch 2/2 then adds
support for the new bindings to the driver, retrieving the mode from DT and
configuring the hardware accordingly.

The LVDS panel DT bindings are based on the relevant standards I have been
able to find, as well as on existing LVDS-related code and DT bindings
available in the mainline kernel. Those include

- the LVDS formats MEDIA_BUS_FMT_RGB666_1X7X3_SPWG,
  MEDIA_BUS_FMT_RGB888_1X7X4_SPWG and MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA
  (Documentation/media/uapi/v4l/subdev-formats.rst)
- iMX display DT bindings available in
  (Documentation/devicetree/bindings/display/imx/ldb.txt)
- the drivers/gpu/drm/imx/ driver

In addition to the three modes specified in the LVDS panel DT bindings, the
Renesas R-Car DU also supports the following two modes.

Slot       0       1       2       3       4       5       6
       ________________                         _________________
Clock                  \_______________________/
         ______  ______  ______  ______  ______  ______  ______
DATA0  ><_CTL0_><__R7__><__R6__><__R5__><__R4__><__R3__><__R2__><
DATA1  ><_CTL1_><__G7__><__G6__><__G5__><__G4__><__G3__><__G2__><
DATA2  ><_CTL2_><__B7__><__B6__><__B5__><__B4__><__B3__><__B2__><
DATA3  ><_CTL3_><__B1__><__B0__><__G1__><__G0__><__R1__><__R0__><
         ______  ______  ______  ______  ______  ______  ______
DATA0  ><_CTL0_><__R5__><__R4__><__R3__><__R2__><__R1__><__R0__><
DATA1  ><_CTL1_><__G5__><__G4__><__G3__><__G2__><__G1__><__G0__><
DATA2  ><_CTL2_><__B5__><__B4__><__B3__><__B2__><__B1__><__B0__><
DATA3  ><_CTL3_><__B7__><__B6__><__G7__><__G6__><__R7__><__R6__><

and their mirrored version.

I haven't been able to find any standard defining those data mappings, nor any
panel using them. The control signals positions correspond to DC-balanced LVDS
(see figure 18 on page 19 of http://www.ti.com/lit/ds/symlink/ds90cf388.pdf),
but the R-Car DU doesn't support DC-balanced LVDS as far as I can tell, so
it's not a match. If anyone knows of other devices supporting these data
mappings or of standards defining them I would appreciate the information and
will update the bindings accordingly.


Laurent Pinchart (2):
  devicetree/bindings: display: Add bindings for LVDS panels
  drm: rcar-du: Add support for LVDS mode selection

 .../bindings/display/panel/panel-lvds.txt          | 119 +++++++++++++++++++++
 drivers/gpu/drm/rcar-du/rcar_du_lvdscon.c          |  29 +++++
 drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c          |  11 +-
 drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.h          |  13 +++
 4 files changed, 170 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/display/panel/panel-lvds.txt

-- 
Regards,

Laurent Pinchart

