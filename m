Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38596 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730561AbeG0QDj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 12:03:39 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 6B8CD634C7F
        for <linux-media@vger.kernel.org>; Fri, 27 Jul 2018 17:41:24 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1fj3vo-0000FQ-84
        for linux-media@vger.kernel.org; Fri, 27 Jul 2018 17:41:24 +0300
Date: Fri, 27 Jul 2018 17:41:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.19] New sensor drivers, cropping support for imx274,
 dw9807 VCM driver rename
Message-ID: <20180727144124.4csqzy7d64td7vky@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are two new sensor drivers; the ov2680 driver now has a MAINTAINERS
entry and there's a driver for mt9v111 sensor driver from Jacopo. Included
is also a dw9807 VCM driver rename --- this is just VCM part --- to avoid
extra Kconfig churn.

Please pull.


The following changes since commit 8601494e0ec0a7697230b2abca25d786b793341b:

  media: media-ioc-enum-entities.rst/-g-topology.rst: clarify ID/name usage (2018-07-25 08:05:06 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.19-4.1

for you to fetch changes up to 314cf29fa5cf10660e6c5353ccb8645c69dfdad1:

  media: imx274: add cropping support via SELECTION API (2018-07-27 16:23:37 +0300)

----------------------------------------------------------------
Jacopo Mondi (2):
      dt-bindings: media: i2c: Document MT9V111 bindings
      media: i2c: Add driver for Aptina MT9V111

Jia-Ju Bai (1):
      media: i2c: vs6624: Replace mdelay() with msleep() and usleep_range() in vs6624_probe()

Luca Ceresoli (2):
      media: imx274: use regmap_bulk_write to write multybyte registers
      media: imx274: add cropping support via SELECTION API

Rui Miguel Silva (2):
      media: ov2680: dt: Add bindings for OV2680
      media: ov2680: Add Omnivision OV2680 sensor driver

Sakari Ailus (1):
      dw9807-vcm: Recognise this is just the VCM bit of the device

 .../bindings/media/i2c/aptina,mt9v111.txt          |   46 +
 .../devicetree/bindings/media/i2c/ov2680.txt       |   46 +
 MAINTAINERS                                        |   16 +
 drivers/media/i2c/Kconfig                          |   25 +-
 drivers/media/i2c/Makefile                         |    4 +-
 drivers/media/i2c/{dw9807.c => dw9807-vcm.c}       |    0
 drivers/media/i2c/imx274.c                         |  568 ++++++---
 drivers/media/i2c/mt9v111.c                        | 1298 ++++++++++++++++++++
 drivers/media/i2c/ov2680.c                         | 1186 ++++++++++++++++++
 drivers/media/i2c/vs6624.c                         |    4 +-
 10 files changed, 3035 insertions(+), 158 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/aptina,mt9v111.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2680.txt
 rename drivers/media/i2c/{dw9807.c => dw9807-vcm.c} (100%)
 create mode 100644 drivers/media/i2c/mt9v111.c
 create mode 100644 drivers/media/i2c/ov2680.c

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
