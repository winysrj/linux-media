Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:45602 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725198AbeIOEGk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 00:06:40 -0400
From: Luis Oliveira <Luis.Oliveira@synopsys.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: all-jpinto-org-pt02@synopsys.com,
        Luis Oliveira <Luis.Oliveira@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Luis Oliveira <luis.oliveira@synopsys.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 0/5]  platform: dwc: Add of DesignWare MIPI CSI-2 Host
Date: Sat, 15 Sep 2018 00:48:36 +0200
Message-Id: <20180914224849.27173-1-lolivei@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds support for Synopsys MIPI CSI-2 Host and MIPI D-PHY.
The patch series include support for initialization/configuration of the
DW MIPI CSI-2 controller and DW MIPI D-PHY and both include a reference
platform driver.

This will enable future SoCs to use this standard approach and possibly
create a more clean environment.

This series also documents the dt-bindings needed for the platform
drivers.

This was applied in: https://git.linuxtv.org/media_tree.git

Luis Oliveira (5):
  media: platform: Add DesignWare MIPI CSI2 Host placeholder
  Documentation: dt-bindings: Document the Synopsys MIPI DPHY Rx
    bindings
  media: platform: dwc: Add DW MIPI DPHY core and platform
  Documentation: dt-bindings: Document bindings for DW MIPI CSI-2 Host
  media: platform: dwc: Add MIPI CSI-2 controller driver

 .../devicetree/bindings/media/snps,dw-csi-plat.txt |  74 +++
 .../devicetree/bindings/phy/snps,dphy-rx.txt       |  36 ++
 MAINTAINERS                                        |  10 +
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/Makefile                    |   3 +
 drivers/media/platform/dwc/Kconfig                 |  42 ++
 drivers/media/platform/dwc/Makefile                |   4 +
 drivers/media/platform/dwc/dw-csi-plat.c           | 508 ++++++++++++++++++
 drivers/media/platform/dwc/dw-csi-plat.h           |  76 +++
 drivers/media/platform/dwc/dw-dphy-plat.c          | 365 +++++++++++++
 drivers/media/platform/dwc/dw-dphy-rx.c            | 592 +++++++++++++++++++++
 drivers/media/platform/dwc/dw-dphy-rx.h            | 176 ++++++
 drivers/media/platform/dwc/dw-mipi-csi.c           | 491 +++++++++++++++++
 drivers/media/platform/dwc/dw-mipi-csi.h           | 202 +++++++
 include/media/dwc/dw-mipi-csi-pltfrm.h             | 101 ++++
 15 files changed, 2681 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/snps,dw-csi-plat.txt
 create mode 100644 Documentation/devicetree/bindings/phy/snps,dphy-rx.txt
 create mode 100644 drivers/media/platform/dwc/Kconfig
 create mode 100644 drivers/media/platform/dwc/Makefile
 create mode 100644 drivers/media/platform/dwc/dw-csi-plat.c
 create mode 100644 drivers/media/platform/dwc/dw-csi-plat.h
 create mode 100644 drivers/media/platform/dwc/dw-dphy-plat.c
 create mode 100644 drivers/media/platform/dwc/dw-dphy-rx.c
 create mode 100644 drivers/media/platform/dwc/dw-dphy-rx.h
 create mode 100644 drivers/media/platform/dwc/dw-mipi-csi.c
 create mode 100644 drivers/media/platform/dwc/dw-mipi-csi.h
 create mode 100644 include/media/dwc/dw-mipi-csi-pltfrm.h

-- 
2.9.3
