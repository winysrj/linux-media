Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:54904 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751481AbcKNOVf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 09:21:35 -0500
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
Subject: [PATCH 0/2] Add support for the DW IP Prototyping Kits for MIPI CSI-2 Host
Date: Mon, 14 Nov 2016 14:20:21 +0000
Message-Id: <cover.1479132355.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset adds basic support for the DW CSI-2 Host IPK. There are 
some parts of the kit that aren't currently supported by this media 
platform driver but will be in the future.

Ramiro Oliveira (2):
  Add Documentation for Media Device, Video Device, and Synopsys DW MIPI
    CSI-2 Host
  Add basic support for DW CSI-2 Host IPK

 .../devicetree/bindings/media/snps,dw-mipi-csi.txt |  27 +
 .../devicetree/bindings/media/snps,plat-ipk.txt    |   9 +
 .../bindings/media/snps,video-device.txt           |  12 +
 MAINTAINERS                                        |   7 +
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/dwc/Kconfig                 |  36 +
 drivers/media/platform/dwc/Makefile                |   3 +
 drivers/media/platform/dwc/dw_mipi_csi.c           | 687 +++++++++++++++++
 drivers/media/platform/dwc/dw_mipi_csi.h           | 179 +++++
 drivers/media/platform/dwc/plat_ipk.c              | 835 +++++++++++++++++++++
 drivers/media/platform/dwc/plat_ipk.h              |  97 +++
 drivers/media/platform/dwc/plat_ipk_video.h        |  97 +++
 drivers/media/platform/dwc/video_device.c          | 741 ++++++++++++++++++
 drivers/media/platform/dwc/video_device.h          | 101 +++
 15 files changed, 2834 insertions(+)
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


