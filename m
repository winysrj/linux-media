Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37864 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751968AbeEGMfp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 May 2018 08:35:45 -0400
Date: Mon, 7 May 2018 15:35:43 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [GIT PULL for 4.18] Cadence CSI-2 TX and RX drivers
Message-ID: <20180507123543.nlcrl62nids2rirh@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are the drivers for Cadence CSI-2 TX and RX hardware blocks.

Please pull.


The following changes since commit f10379aad39e9da8bc7d1822e251b5f0673067ef:

  media: include/video/omapfb_dss.h: use IS_ENABLED() (2018-05-05 11:45:51 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.18-4

for you to fetch changes up to b2c23eb3e5f8ab0a54fc4aad875d12d127508f85:

  v4l: cadence: Add Cadence MIPI-CSI2 TX driver (2018-05-07 12:52:50 +0300)

----------------------------------------------------------------
Maxime Ripard (4):
      dt-bindings: media: Add Cadence MIPI-CSI2 RX Device Tree bindings
      v4l: cadence: Add Cadence MIPI-CSI2 RX driver
      dt-bindings: media: Add Cadence MIPI-CSI2 TX Device Tree bindings
      v4l: cadence: Add Cadence MIPI-CSI2 TX driver

 .../devicetree/bindings/media/cdns,csi2rx.txt      | 100 ++++
 .../devicetree/bindings/media/cdns,csi2tx.txt      |  98 ++++
 MAINTAINERS                                        |   7 +
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/Makefile                    |   1 +
 drivers/media/platform/cadence/Kconfig             |  34 ++
 drivers/media/platform/cadence/Makefile            |   4 +
 drivers/media/platform/cadence/cdns-csi2rx.c       | 498 ++++++++++++++++++
 drivers/media/platform/cadence/cdns-csi2tx.c       | 563 +++++++++++++++++++++
 9 files changed, 1306 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/cdns,csi2rx.txt
 create mode 100644 Documentation/devicetree/bindings/media/cdns,csi2tx.txt
 create mode 100644 drivers/media/platform/cadence/Kconfig
 create mode 100644 drivers/media/platform/cadence/Makefile
 create mode 100644 drivers/media/platform/cadence/cdns-csi2rx.c
 create mode 100644 drivers/media/platform/cadence/cdns-csi2tx.c

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
