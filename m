Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:41701 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752344AbdATOAj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jan 2017 09:00:39 -0500
From: Michael Tretter <m.tretter@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        kernel@pengutronix.de, Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH v4 0/7] Add support for Video Data Order Adapter
Date: Fri, 20 Jan 2017 15:00:18 +0100
Message-Id: <20170120140025.3338-1-m.tretter@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This is v4 of a patch series that adds support for the Video Data Order
Adapter (VDOA) that can be found on Freescale i.MX6. It converts the
macroblock tiled format produced by the CODA 960 video decoder to a
raster-ordered format for scanout.

Changes since v3:

- Patch 2/7: Add my copyright to vdoa copyright header
- Patch 2/7: Fix offset of chroma plane to be page-aligned
- Patch 6/7: Fix oops when releasing the coda driver by destroying vdoa
  context after removing all buffers
- Patch 6/7: Fix missing vdoa disable when switching from tiled to linear
  format

Changes since v2:

- Patch 1/7: Update commit message to include binding change; fix
  spelling/style in binding documentation

Changes since v1:

- Dropped patch 8/9 of v1
- Patch 1/7: Add devicetree binding documentation for fsl-vdoa
- Patch 6/7: I merged patch 5/9 and patch 8/9 of v1 into a single patch
- Patch 6/7: Use dt compatible instead of a phandle to find VDOA device
- Patch 6/7: Always check VDOA availability even if disabled via module
  parameter and do not print a message if VDOA cannot be found
- Patch 6/7: Do not change the CODA context in coda_try_fmt()
- Patch 6/7: Allocate an additional internal frame if the VDOA is in use

Michael Tretter (3):
  [media] coda: fix frame index to returned error
  [media] coda: use VDOA for un-tiling custom macroblock format
  [media] coda: support YUYV output if VDOA is used

Philipp Zabel (4):
  [media] dt-bindings: Add a binding for Video Data Order Adapter
  [media] coda: add i.MX6 VDOA driver
  [media] coda: correctly set capture compose rectangle
  [media] coda: add debug output about tiling

 .../devicetree/bindings/media/fsl-vdoa.txt         |  21 ++
 arch/arm/boot/dts/imx6qdl.dtsi                     |   2 +
 drivers/media/platform/Kconfig                     |   3 +
 drivers/media/platform/coda/Makefile               |   1 +
 drivers/media/platform/coda/coda-bit.c             |  93 ++++--
 drivers/media/platform/coda/coda-common.c          | 175 ++++++++++-
 drivers/media/platform/coda/coda.h                 |   3 +
 drivers/media/platform/coda/imx-vdoa.c             | 338 +++++++++++++++++++++
 drivers/media/platform/coda/imx-vdoa.h             |  58 ++++
 9 files changed, 652 insertions(+), 42 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/fsl-vdoa.txt
 create mode 100644 drivers/media/platform/coda/imx-vdoa.c
 create mode 100644 drivers/media/platform/coda/imx-vdoa.h

-- 
2.11.0

