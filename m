Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:48887 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751256AbcLLPBC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 10:01:02 -0500
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Cc: davem@davemloft.net, gregkh@linuxfoundation.org,
        geert+renesas@glider.be, akpm@linux-foundation.org,
        linux@roeck-us.net, hverkuil@xs4all.nl,
        laurent.pinchart+renesas@ideasonboard.com, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, tiffany.lin@mediatek.com,
        minghsiu.tsai@mediatek.com, jean-christophe.trotin@st.com,
        andrew-ct.chen@mediatek.com, simon.horman@netronome.com,
        songjun.wu@microchip.com, bparrot@ti.com,
        CARLOS.PALMINHA@synopsys.com, Ramiro.Oliveira@synopsys.com
Subject: [PATCH v2 0/2] Add support for the DW IP Prototyping Kits for MIPI CSI-2 Host
Date: Mon, 12 Dec 2016 15:00:34 +0000
Message-Id: <cover.1481548484.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds support for the DW CSI-2 Host IPK. These kits are intended
to help in the bringup of IP titles developed by Synopsys.

This is the second version of this patchset.

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


Ramiro Oliveira (2):
  Add Documentation for Media Device, Video Device, and Synopsys DW MIPI
    CSI-2 Host
  Support for basic DW CSI-2 Host IPK funcionality

 .../devicetree/bindings/media/snps,dw-mipi-csi.txt |  27 +
 .../devicetree/bindings/media/snps,plat-ipk.txt    |   9 +
 .../bindings/media/snps,video-device.txt           |  12 +
 MAINTAINERS                                        |   7 +
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/dwc/Kconfig                 |  36 +
 drivers/media/platform/dwc/Makefile                |   3 +
 drivers/media/platform/dwc/dw_mipi_csi.c           | 647 ++++++++++++++++
 drivers/media/platform/dwc/dw_mipi_csi.h           | 180 +++++
 drivers/media/platform/dwc/plat_ipk.c              | 818 +++++++++++++++++++++
 drivers/media/platform/dwc/plat_ipk.h              | 101 +++
 drivers/media/platform/dwc/plat_ipk_video.h        |  97 +++
 drivers/media/platform/dwc/video_device.c          | 707 ++++++++++++++++++
 drivers/media/platform/dwc/video_device.h          |  85 +++
 15 files changed, 2732 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/snps,dw-mipi-csi.txt
 create mode 100644 Documentation/devicetree/bindings/media/snps,plat-ipk.txt
 create mode 100644 Documentation/devicetree/bindings/media/snps,video-device.txt
 create mode 100644 drivers/media/platform/dwc/Kconfig
 create mode 100644 drivers/media/platform/dwc/Makefile
 create mode 100644 drivers/media/platform/dwc/dw_mipi_csi.c
 create mode 100644 drivers/media/platform/dwc/dw_mipi_csi.h
 create mode 100644 drivers/media/platform/dwc/plat_ipk.c
 create mode 100644 drivers/media/platform/dwc/plat_ipk.h
 create mode 100644 drivers/media/platform/dwc/plat_ipk_video.h
 create mode 100644 drivers/media/platform/dwc/video_device.c
 create mode 100644 drivers/media/platform/dwc/video_device.h

-- 
2.10.2


