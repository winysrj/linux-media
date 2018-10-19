Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:50568 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727011AbeJSU6r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 16:58:47 -0400
From: Luis Oliveira <luis.oliveira@synopsys.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: joao.pinto@synopsys.com, festevam@gmail.com,
        Luis Oliveira <luis.oliveira@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Luis Oliveira <luis.oliveira@synopsys.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Todor Tomov <todor.tomov@linaro.org>
Subject: [V3, 0/4] platform: dwc: Add of DesignWare MIPI CSI-2 Host
Date: Fri, 19 Oct 2018 14:52:22 +0200
Message-Id: <1539953556-35762-1-git-send-email-lolivei@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds support for Synopsys MIPI CSI-2 Host and MIPI D-PHY.
The patch series include support for initialization/configuration of the
DW MIPI CSI-2 controller and DW MIPI D-PHY and both include a reference
platform driver. This way the future PCI integration will be clean.

This will enable future SoCs to use this standard approach and possibly
create a more clean environment.

This series also documents the dt-bindings needed for the platform drivers.

This was applied in: https://git.linuxtv.org/media_tree.git

Luis Oliveira (4):
  Documentation: dt-bindings: phy: Document the Synopsys MIPI DPHY Rx
    bindings
  media: platform: dwc: Add DW MIPI DPHY Rx platform
  Documentation: dt-bindings: media: Document bindings for DW MIPI CSI-2
    Host
  media: platform: dwc: Add MIPI CSI-2 controller driver

 .../devicetree/bindings/media/snps,dw-csi-plat.txt |  52 ++
 .../devicetree/bindings/phy/snps,dphy-rx.txt       |  28 +
 MAINTAINERS                                        |  11 +
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/Makefile                    |   3 +
 drivers/media/platform/dwc/Kconfig                 |  52 ++
 drivers/media/platform/dwc/Makefile                |   4 +
 drivers/media/platform/dwc/dw-csi-plat.c           | 699 +++++++++++++++++++++
 drivers/media/platform/dwc/dw-csi-plat.h           |  77 +++
 drivers/media/platform/dwc/dw-dphy-plat.c          | 347 ++++++++++
 drivers/media/platform/dwc/dw-dphy-rx.c            | 596 ++++++++++++++++++
 drivers/media/platform/dwc/dw-dphy-rx.h            | 181 ++++++
 drivers/media/platform/dwc/dw-mipi-csi.c           | 494 +++++++++++++++
 drivers/media/platform/dwc/dw-mipi-csi.h           | 202 ++++++
 include/media/dwc/dw-mipi-csi-pltfrm.h             | 102 +++
 15 files changed, 2849 insertions(+)
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
2.7.4
