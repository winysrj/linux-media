Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam02on0042.outbound.protection.outlook.com ([104.47.36.42]:55596
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751338AbeBUXAo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 18:00:44 -0500
From: Rohit Athavale <rohit.athavale@xilinx.com>
To: <devel@driverdev.osuosl.org>
CC: <gregkh@linuxfoundation.org>, <linux-media@vger.kernel.org>,
        <rohit.athavale@xilinx.com>
Subject: [PATCH v2 0/3] Initial driver support for Xilinx M2M Video Scaler
Date: Wed, 21 Feb 2018 14:43:13 -0800
Message-ID: <1519252996-787-1-git-send-email-rohit.athavale@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series has three commits :
 - Driver support for the Xilinx M2M Video Scaler IP
 - TODO document
 - DT binding doc

Changes in HW register map is expected as the IP undergoes changes.
This is a first attempt at the driver as an early prototype.

This is a M2M Video Scaler IP that uses polyphases filters to perform
video scaling. The driver will be used by an application like a
gstreamer plugin.

Change Log:

v2 
 - Cc'ing linux-media mailing list as suggested by Dan Carpenter.
   Dan wanted to see if someone from linux-media can review the 
   driver interface in xm2m_vscale.c to see if it makes sense.
 - Another question would be the right place to keep the driver,
   in drivers/staging/media or drivers/staging/ 
 - Dropped empty mmap_open, mmap_close ops.
 - Removed incorrect DMA_SHARED_BUFFER select from Kconfig
v1 - Initial version


Rohit Athavale (3):
  staging: xm2mvscale: Driver support for Xilinx M2M Video Scaler
  staging: xm2mvscale: Add TODO for the driver
  Documentation: devicetree: bindings: Add DT binding doc for xm2mvsc
    driver

 drivers/staging/Kconfig                            |   2 +
 drivers/staging/Makefile                           |   1 +
 .../devicetree/bindings/xm2mvscaler.txt            |  25 +
 drivers/staging/xm2mvscale/Kconfig                 |  11 +
 drivers/staging/xm2mvscale/Makefile                |   3 +
 drivers/staging/xm2mvscale/TODO                    |  18 +
 drivers/staging/xm2mvscale/ioctl_xm2mvsc.h         | 134 +++
 drivers/staging/xm2mvscale/scaler_hw_xm2m.c        | 945 +++++++++++++++++++++
 drivers/staging/xm2mvscale/scaler_hw_xm2m.h        | 152 ++++
 drivers/staging/xm2mvscale/xm2m_vscale.c           | 768 +++++++++++++++++
 drivers/staging/xm2mvscale/xvm2mvsc_hw_regs.h      | 204 +++++
 11 files changed, 2263 insertions(+)
 create mode 100644 drivers/staging/xm2mvscale/Documentation/devicetree/bindings/xm2mvscaler.txt
 create mode 100644 drivers/staging/xm2mvscale/Kconfig
 create mode 100644 drivers/staging/xm2mvscale/Makefile
 create mode 100644 drivers/staging/xm2mvscale/TODO
 create mode 100644 drivers/staging/xm2mvscale/ioctl_xm2mvsc.h
 create mode 100644 drivers/staging/xm2mvscale/scaler_hw_xm2m.c
 create mode 100644 drivers/staging/xm2mvscale/scaler_hw_xm2m.h
 create mode 100644 drivers/staging/xm2mvscale/xm2m_vscale.c
 create mode 100644 drivers/staging/xm2mvscale/xvm2mvsc_hw_regs.h

-- 
1.9.1
