Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56272 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750735AbeELMf6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 May 2018 08:35:58 -0400
Date: Sat, 12 May 2018 15:35:55 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, maxime.ripard@bootlin.com
Subject: [GIT PULL v2 for 4.18] Cadence CSI-2 TX and RX drivers
Message-ID: <20180512123555.dbfypr27q4jqho3s@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are the drivers for Cadence CSI-2 TX and RX hardware blocks.

since v1:

- Add a patch to fix a compiler warning (which is effectively two bugs).

Please pull.


The following changes since commit 2a5f2705c97625aa1a4e1dd4d584eaa05392e060:

  media: lgdt330x.h: fix compiler warning (2018-05-11 11:40:09 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.18-4.1

for you to fetch changes up to 308aa1e7dcb79d9fb321bac8e45ed9dc36c5354a:

  cadence: csi2rx: Fix csi2rx_start error handling (2018-05-12 15:09:51 +0300)

----------------------------------------------------------------
Maxime Ripard (4):
      dt-bindings: media: Add Cadence MIPI-CSI2 RX Device Tree bindings
      v4l: cadence: Add Cadence MIPI-CSI2 RX driver
      dt-bindings: media: Add Cadence MIPI-CSI2 TX Device Tree bindings
      v4l: cadence: Add Cadence MIPI-CSI2 TX driver

Sakari Ailus (1):
      cadence: csi2rx: Fix csi2rx_start error handling

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
