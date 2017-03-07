Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:45022 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755553AbdCGOns (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 09:43:48 -0500
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: CARLOS.PALMINHA@synopsys.com,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Benoit Parrot <bparrot@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        Rick Chang <rick.chang@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH 0/4] Support for Synopsys DW CSI-2 Host 
Date: Tue,  7 Mar 2017 14:37:47 +0000
Message-Id: <cover.1488885081.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds support for the DW CSI-2 Host and also for a video
device associated with it. 

The first 2 patches are only for the DW CSI-2 Host and the last 2 are for
the video device.

Although this patchset is named as v1 there were already two patchsets
previous to this one, but with a different name: "Add support for the DW
IP Prototyping Kits for MIPI CSI-2 Host".

v3:
 - Correct description errors in Documentation
 - Remove empty functions
 - Change device caps and description setting
 - Remove left-over code
 - Add more VB2 io_modes
 - Add support for dma_contig
 - Correct spelling mistakes

v2: 
 - Add more detailed descriptions in the DT documentation
 - Add binding examples to DT documentation
 - Remove unnecessary debug structures
 - Remove unused fields in structures
 - Change variable types
 - Remove unused functions
 - Declare functions as static
 - Remove some prints
 - Add missing newlines.

Ramiro Oliveira (4):
  Documentation: dt: Add bindings documentation for DW MIPI CSI-2 Host
  media: platform: dwc: Support for DW CSI-2 Host
  Documentation: dt: Add bindings documentation for CSI-2 Host Video
    Platform
  media: platform: dwc: Support for CSI-2 Host video platform

 .../devicetree/bindings/media/snps,dw-mipi-csi.txt |  37 +
 .../devicetree/bindings/media/snps,plat-csi2.txt   |  77 ++
 MAINTAINERS                                        |   7 +
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/dwc/Kconfig                 |  45 ++
 drivers/media/platform/dwc/Makefile                |   3 +
 drivers/media/platform/dwc/csi_video_device.c      | 721 ++++++++++++++++++
 drivers/media/platform/dwc/csi_video_device.h      |  83 +++
 drivers/media/platform/dwc/csi_video_plat.c        | 818 +++++++++++++++++++++
 drivers/media/platform/dwc/csi_video_plat.h        | 101 +++
 drivers/media/platform/dwc/dw_mipi_csi.c           | 653 ++++++++++++++++
 drivers/media/platform/dwc/dw_mipi_csi.h           | 181 +++++
 include/media/dwc/csi_host_platform.h              |  97 +++
 14 files changed, 2826 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt
 create mode 100644 Documentation/devicetree/bindings/media/snps,plat-csi2.txt
 create mode 100644 drivers/media/platform/dwc/Kconfig
 create mode 100644 drivers/media/platform/dwc/Makefile
 create mode 100644 drivers/media/platform/dwc/csi_video_device.c
 create mode 100644 drivers/media/platform/dwc/csi_video_device.h
 create mode 100644 drivers/media/platform/dwc/csi_video_plat.c
 create mode 100644 drivers/media/platform/dwc/csi_video_plat.h
 create mode 100644 drivers/media/platform/dwc/dw_mipi_csi.c
 create mode 100644 drivers/media/platform/dwc/dw_mipi_csi.h
 create mode 100644 include/media/dwc/csi_host_platform.h

-- 
2.11.0
