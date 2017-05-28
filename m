Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:50732 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750989AbdE1Ja4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 05:30:56 -0400
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-renesas-soc@vger.kernel.org
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        devicetree@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 0/7] tree-wide: use proper 'R-Car' product name
Date: Sun, 28 May 2017 11:30:43 +0200
Message-Id: <20170528093051.11816-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Small series to get the R-Car product name proper. Based on
renesas-drivers/master, but can be applied to current linus/master as well.
Except for the MMC patch, which depends on mmc/next.

Please apply.

Wolfram Sang (7):
  dmaengine: use proper name for the R-Car SoC
  i2c: use proper name for the R-Car SoC
  iio: use proper name for the R-Car SoC
  mmc: use proper name for the R-Car SoC
  pci: use proper name for the R-Car SoC
  [media] soc_camera: rcar_vin: use proper name for the R-Car SoC
  [media] v4l: rcar_fdp1: use proper name for the R-Car SoC

 Documentation/devicetree/bindings/dma/shdma.txt               | 2 +-
 Documentation/devicetree/bindings/iio/adc/renesas,gyroadc.txt | 2 +-
 Documentation/devicetree/bindings/media/rcar_vin.txt          | 4 ++--
 Documentation/devicetree/bindings/pci/rcar-pci.txt            | 2 +-
 drivers/i2c/busses/i2c-rcar.c                                 | 2 +-
 drivers/media/platform/rcar_fdp1.c                            | 2 +-
 drivers/mmc/host/renesas_sdhi_core.c                          | 2 +-
 include/linux/mfd/tmio.h                                      | 2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

-- 
2.11.0
