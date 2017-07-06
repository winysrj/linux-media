Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751952AbdGFLBX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Jul 2017 07:01:23 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com,
        niklas.soderlund@ragnatech.se, hans.verkuil@cisco.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v7 0/3] ADV748x HDMI/Analog video receiver
Date: Thu,  6 Jul 2017 12:01:14 +0100
Message-Id: <cover.f44897c9f4c2d4555dfa156cc24a755477e409bf.1499336175.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

This is a driver for the Analog Devices ADV748x device, and follows on from a
previous posting by Niklas Söderlund [0] of an earlier incarnation of this
driver, and earlier versions posted by myself.

ADV748x
=======
The ADV7481 and ADV7482 support two video pipelines which can run independently
of each other, with each pipeline terminating in a CSI-2 output: TXA (4-Lane)
and TXB (1-Lane)

The ADV7480 (Not included here), ADV7481, and ADV7482 are all derivatives,
with the following features

            Analog   HDMI  MHL  4-Lane  1-Lane
              In      In         CSI     CSI
 ADV7480               X    X     X
 ADV7481      X        X    X     X       X
 ADV7482      X        X          X       X

Implementation
==============

This driver creates 4 entities. AFE (CVBS/Analog In), HDMI, TXA and TXB.  At
probe time, the DT is parsed to identify the endpoints for each of these nodes,
and those are used for async matching of the CSI2 (TXA/TXB) entities in the
master driver. The HDMI and AFE entities are then registered after a successful
registration of both the CSI2 entities.

HDMI is statically linked to the TXA entity, while the AFE is statically linked
to the TXB entity. Routing the AFE through TXA is not supported.

Support for setting the EDID on HDMI is provided

(Known) Future Todo's
=====================

Further potential development areas include:
 - ADV7480 Support (No AFE)
 - MHL support (Not present on ADV7482)
 - CEC Support
 - Configurable I2C addressing
 - Interrupt handling for format changes and hotplug detect.

However, this driver is functional without the above, and these developments
can be written when required.

References
==========
[0] http://www.mail-archive.com/linux-renesas-soc@vger.kernel.org/msg05196.html

v1/RFC:
 - Initial posting

v2:
 - Reworked DT parsing and entities

v3:
 - Refreshed with lots of fixups from Sakari's review comments

v4:
 - Many changes all round, following Laurent's review and extensive development
 - Now uses regmap
 - AFE port numbering has been changed to match the entity pads

v5:
 - DT is now based on the latest salvator-common.dtsi
 - Entities are linked with immutable connections

v6:
 - EDID support added to HDMI
 - AFE no longer autodetects input format by default.

v7:
 - Comments from Hans addressed
 - AFE now uses FIELD_ALTERNATE
 - HDMI interlaced support removed (it's untested)

Kieran Bingham (3):
  media: adv748x: Add adv7481, adv7482 bindings
  media: i2c: adv748x: add adv748x driver
  MAINTAINERS: Add ADV748x driver

 Documentation/devicetree/bindings/media/i2c/adv748x.txt |  95 +-
 MAINTAINERS                                             |   6 +-
 drivers/media/i2c/Kconfig                               |  12 +-
 drivers/media/i2c/Makefile                              |   1 +-
 drivers/media/i2c/adv748x/Makefile                      |   7 +-
 drivers/media/i2c/adv748x/adv748x-afe.c                 | 552 ++++++-
 drivers/media/i2c/adv748x/adv748x-core.c                | 832 +++++++++-
 drivers/media/i2c/adv748x/adv748x-csi2.c                | 327 ++++-
 drivers/media/i2c/adv748x/adv748x-hdmi.c                | 768 ++++++++-
 drivers/media/i2c/adv748x/adv748x.h                     | 425 +++++-
 10 files changed, 3025 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/adv748x.txt
 create mode 100644 drivers/media/i2c/adv748x/Makefile
 create mode 100644 drivers/media/i2c/adv748x/adv748x-afe.c
 create mode 100644 drivers/media/i2c/adv748x/adv748x-core.c
 create mode 100644 drivers/media/i2c/adv748x/adv748x-csi2.c
 create mode 100644 drivers/media/i2c/adv748x/adv748x-hdmi.c
 create mode 100644 drivers/media/i2c/adv748x/adv748x.h

base-commit: 2748e76ddb2967c4030171342ebdd3faa6a5e8e8
-- 
git-series 0.9.1
