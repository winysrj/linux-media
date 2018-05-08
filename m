Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59253 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755133AbeEHOOQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 10:14:16 -0400
From: Jan Luebbe <jlu@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Jan Luebbe <jlu@pengutronix.de>, slongerbeam@gmail.com,
        p.zabel@pengutronix.de, kernel@pengutronix.de
Subject: [PATCH v2 0/2] media: imx: add capture support for RGB565_2X8 on parallel bus
Date: Tue,  8 May 2018 16:14:09 +0200
Message-Id: <20180508141411.26620-1-jlu@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The IPU can only capture RGB565 with two 8-bit cycles in bayer/generic
mode on the parallel bus, compared to a specific mode on MIPI CSI-2.
To handle this, we extend imx_media_pixfmt with a cycles per pixel
field, which is used for generic formats on the parallel bus.

Before actually adding RGB565_2X8 support for the parallel bus, this
series simplifies handing of the the different configurations for RGB565
between parallel and MIPI CSI-2 in imx-media-capture. This avoids having
to explicitly pass on the format in the second patch.

Changes since v1:
  - fixed problems reported the kbuild test robot
  - added helper functions as suggested by Steve Longerbeam
    (is_parallel_bus and requires_passthrough)
  - removed passthough format check in csi_link_validate() (suggested by
    Philipp Zabel during internal review)

Jan Luebbe (2):
  media: imx: capture: refactor enum_/try_fmt
  media: imx: add support for RGB565_2X8 on parallel bus

 drivers/staging/media/imx/imx-media-capture.c | 38 +++++------
 drivers/staging/media/imx/imx-media-csi.c     | 68 ++++++++++++++-----
 drivers/staging/media/imx/imx-media-utils.c   |  1 +
 drivers/staging/media/imx/imx-media.h         |  2 +
 4 files changed, 73 insertions(+), 36 deletions(-)

-- 
2.17.0
