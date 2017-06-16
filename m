Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:47137 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753243AbdFPKIN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 06:08:13 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v2 0/4] Synopsys Designware HDMI Video Capture Controller + PHY
Date: Fri, 16 Jun 2017 11:07:39 +0100
Message-Id: <cover.1497607315.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Synopsys Designware HDMI RX controller is an HDMI receiver controller that
is responsible to process digital data that comes from a phy. The final result
is a stream of raw video data that can then be connected to a video DMA, for
example, and transfered into RAM so that it can be displayed.

The controller + phy available in this series natively support all HDMI 1.4 and
HDMI 2.0 modes, including deep color. Although, the driver is quite in its
initial stage and unfortunatelly only non deep color modes are supported. Also,
audio is not yet supported in the driver (the controller has several audio
output interfaces).

Version 2 is just a respin of the previous version with some minor bug fixes in
the controller driver and I also added CEC support.

This series was tested in a FPGA platform.

Jose Abreu (4):
  [media] platform: Add Synopsys Designware HDMI RX PHY e405 Driver
  [media] platform: Add Synopsys Designware HDMI RX Controller Driver
  MAINTAINERS: Add entry for Synopsys Designware HDMI drivers
  dt-bindings: media: Document Synopsys Designware HDMI RX

Cc: Carlos Palminha <palminha@synopsys.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>

 .../devicetree/bindings/media/snps,dw-hdmi-rx.txt  |   41 +
 MAINTAINERS                                        |    7 +
 drivers/media/platform/Kconfig                     |    2 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/dwc/Kconfig                 |   18 +
 drivers/media/platform/dwc/Makefile                |    2 +
 drivers/media/platform/dwc/dw-hdmi-phy-e405.c      |  783 +++++++++
 drivers/media/platform/dwc/dw-hdmi-phy-e405.h      |   63 +
 drivers/media/platform/dwc/dw-hdmi-rx.c            | 1764 ++++++++++++++++++++
 drivers/media/platform/dwc/dw-hdmi-rx.h            |  435 +++++
 include/media/dwc/dw-hdmi-phy-pdata.h              |  131 ++
 include/media/dwc/dw-hdmi-rx-pdata.h               |   63 +
 12 files changed, 3311 insertions(+)
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
