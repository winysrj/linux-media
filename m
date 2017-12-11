Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:60124 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdLKRmA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 12:42:00 -0500
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [PATCH v10 0/4] Synopsys DesignWare HDMI Video Capture Controller + PHY
Date: Mon, 11 Dec 2017 17:41:17 +0000
Message-Id: <cover.1513013948.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Synopsys DesignWare HDMI RX controller is an HDMI receiver controller that
is responsible to process digital data that comes from a phy. The final result
is a stream of RAW video data that can then be connected to a video DMA, for
example, and transfered into RAM so that it can be displayed.

The controller + phy available in this series natively support all HDMI 1.4 and
HDMI 2.0 modes, including deep color. Although, the driver is quite in its
initial stage and unfortunatelly only non deep color modes are supported. Also,
audio is not yet supported in the driver (the controller has several audio
output interfaces).

Version 10 addresses review comments from Hans Verkuil and from Philippe
Ombredanne.

This series was tested in a FPGA platform using an embedded platform called
ARC AXS101.

Jose Abreu (4):
  dt-bindings: media: Document Synopsys DesignWare HDMI RX
  MAINTAINERS: Add entry for Synopsys DesignWare HDMI drivers
  [media] platform: Add Synopsys DesignWare HDMI RX PHY e405 Driver
  [media] platform: Add Synopsys DesignWare HDMI RX Controller Driver

 .../devicetree/bindings/media/snps,dw-hdmi-rx.txt  |   58 +
 MAINTAINERS                                        |    7 +
 drivers/media/platform/Kconfig                     |    2 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/dwc/Kconfig                 |   23 +
 drivers/media/platform/dwc/Makefile                |    2 +
 drivers/media/platform/dwc/dw-hdmi-phy-e405.c      |  822 +++++++++
 drivers/media/platform/dwc/dw-hdmi-phy-e405.h      |   41 +
 drivers/media/platform/dwc/dw-hdmi-rx.c            | 1840 ++++++++++++++++++++
 drivers/media/platform/dwc/dw-hdmi-rx.h            |  419 +++++
 include/media/dwc/dw-hdmi-phy-pdata.h              |  106 ++
 include/media/dwc/dw-hdmi-rx-pdata.h               |   48 +
 12 files changed, 3370 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/snps,dw-hdmi-rx.txt
 create mode 100644 drivers/media/platform/dwc/Kconfig
 create mode 100644 drivers/media/platform/dwc/Makefile
 create mode 100644 drivers/media/platform/dwc/dw-hdmi-phy-e405.c
 create mode 100644 drivers/media/platform/dwc/dw-hdmi-phy-e405.h
 create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.c
 create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.h
 create mode 100644 include/media/dwc/dw-hdmi-phy-pdata.h
 create mode 100644 include/media/dwc/dw-hdmi-rx-pdata.h

-- 
1.9.1
