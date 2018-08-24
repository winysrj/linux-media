Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:50584 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbeHXULd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 16:11:33 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] media: imx274: miscellaneous improvements
Date: Fri, 24 Aug 2018 18:35:18 +0200
Message-Id: <20180824163525.12694-1-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

here's a series of small improvements to the imx274 sensor
driver.

The patches are mostly unrelated to each other. Patch 3 is a fix to
make the subdev name unique. Patches 2 and 6 are small
optimizations. The remaining patches have no functional effect.

Luca


Luca Ceresoli (7):
  media: imx274: rename IMX274_DEFAULT_MODE to IMX274_DEFAULT_BINNING
  media: imx274: rearrange sensor startup register tables
  media: imx274: don't hard-code the subdev name to DRIVER_NAME
  media: imx274: rename frmfmt and format to "mode"
  media: imx274: fix error in function docs
  media: imx274: add helper to read multibyte registers
  media: imx274: switch to SPDX license identifier

 drivers/media/i2c/imx274.c | 165 ++++++++++++++++---------------------
 1 file changed, 72 insertions(+), 93 deletions(-)

-- 
2.17.1
