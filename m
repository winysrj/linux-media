Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:48343 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752442AbdGGLIo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 07:08:44 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
Subject: [PATCH v7 0/6] Synopsys Designware HDMI Video Capture Controller + PHY
Date: Fri,  7 Jul 2017 12:08:03 +0100
Message-Id: <cover.1499425271.git.joabreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

Version 7 addresses review comments from Sylwester Nawrocki regarding device tree
bindings and also makes edid-phandle property look for parent node if no node is
specified in the bindings.

I also added two patches for cec.h and cec-notifier.h which are needed to fix build
errors/warnings. At 1/6 we add a stub for cec_register_cec_notifier() and at 2/6
we forward the declaration of cec_notifier structure before including cec.h.

This series depends on the patch at [1].

This series was tested in a FPGA platform using an embedded platform called
ARC AXS101.

Jose Abreu (6):
  [media] cec.h: Add stub function for cec_register_cec_notifier()
  [media] cec-notifier.h: Prevent build warnings using forward
    declaration
  dt-bindings: media: Document Synopsys Designware HDMI RX
  MAINTAINERS: Add entry for Synopsys Designware HDMI drivers
  [media] platform: Add Synopsys Designware HDMI RX PHY e405 Driver
  [media] platform: Add Synopsys Designware HDMI RX Controller Driver

Cc: Carlos Palminha <palminha@synopsys.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Sylwester Nawrocki <snawrocki@kernel.org>

[1] https://patchwork.linuxtv.org/patch/41834/

 .../devicetree/bindings/media/snps,dw-hdmi-rx.txt  |   74 +
 MAINTAINERS                                        |    7 +
 drivers/media/platform/Kconfig                     |    2 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/dwc/Kconfig                 |   23 +
 drivers/media/platform/dwc/Makefile                |    2 +
 drivers/media/platform/dwc/dw-hdmi-phy-e405.c      |  844 +++++++++
 drivers/media/platform/dwc/dw-hdmi-phy-e405.h      |   63 +
 drivers/media/platform/dwc/dw-hdmi-rx.c            | 1823 ++++++++++++++++++++
 drivers/media/platform/dwc/dw-hdmi-rx.h            |  441 +++++
 include/media/cec-notifier.h                       |    6 +-
 include/media/cec.h                                |    7 +
 include/media/dwc/dw-hdmi-phy-pdata.h              |  128 ++
 include/media/dwc/dw-hdmi-rx-pdata.h               |   70 +
 14 files changed, 3489 insertions(+), 3 deletions(-)
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
