Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60755 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750947AbeECQlY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 12:41:24 -0400
From: Jan Luebbe <jlu@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Jan Luebbe <jlu@pengutronix.de>, slongerbeam@gmail.com,
        p.zabel@pengutronix.de
Subject: [PATCH 0/2] media: imx: add capture support for RGB565_2X8 on parallel bus
Date: Thu,  3 May 2018 18:41:18 +0200
Message-Id: <20180503164120.9912-1-jlu@pengutronix.de>
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

Jan Luebbe (2):
  media: imx: capture: refactor enum_/try_fmt
  media: imx: add support for RGB565_2X8 on parallel bus

 drivers/staging/media/imx/imx-media-capture.c | 38 +++++++--------
 drivers/staging/media/imx/imx-media-csi.c     | 47 +++++++++++++++++--
 drivers/staging/media/imx/imx-media-utils.c   |  1 +
 drivers/staging/media/imx/imx-media.h         |  2 +
 4 files changed, 63 insertions(+), 25 deletions(-)

-- 
2.17.0
