Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42442 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726826AbeIQPMG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 11:12:06 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 0F2DC634C7F
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2018 12:45:29 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1g1q5w-0000wK-S2
        for linux-media@vger.kernel.org; Mon, 17 Sep 2018 12:45:28 +0300
Date: Mon, 17 Sep 2018 12:45:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.20] Sensor driver patches for 4.20
Message-ID: <20180917094528.ospm7ec7hcomkjhs@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are cleanups for imx274 as well as more or less random fixes for
ov2680 and sr030pc30 drivers.

Included are patches that add a function in the V4L2 framework to name I²C
sensors in case the framework-provided name is not appropriate. The
function is used in the smiapp driver now.

Please pull.


The following changes since commit 78cf8c842c111df656c63b5d04997ea4e40ef26a:

  media: drxj: fix spelling mistake in fall-through annotations (2018-09-12 11:21:52 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git tags/for-4.20-3-0

for you to fetch changes up to 63c9f5d7a8e1c2b01625370db0591c9b673d38a7:

  media: ov2680: rename ov2680_v4l2_init() to ov2680_v4l2_register() (2018-09-16 01:44:43 +0300)

----------------------------------------------------------------
imx274 cleanups and random sensor driver stuff

----------------------------------------------------------------
Dan Carpenter (1):
      media: sr030pc30: remove NULL in sr030pc30_base_config()

Javier Martinez Canillas (2):
      media: ov2680: don't register the v4l2 subdevice before checking chip ID
      media: ov2680: rename ov2680_v4l2_init() to ov2680_v4l2_register()

Luca Ceresoli (7):
      media: imx274: rename IMX274_DEFAULT_MODE to IMX274_DEFAULT_BINNING
      media: imx274: rearrange sensor startup register tables
      media: imx274: don't hard-code the subdev name to DRIVER_NAME
      media: imx274: rename frmfmt and format to "mode"
      media: imx274: fix error in function docs
      media: imx274: add helper to read multibyte registers
      media: imx274: switch to SPDX license identifier

Sakari Ailus (3):
      v4l: subdev: Add a function to set an I²C sub-device's name
      smiapp: Use v4l2_i2c_subdev_set_name
      v4l: sr030pc30: Remove redundant setting of sub-device name

 drivers/media/i2c/imx274.c             | 165 ++++++++++++++-------------------
 drivers/media/i2c/ov2680.c             |  16 +---
 drivers/media/i2c/smiapp/smiapp-core.c |  10 +-
 drivers/media/i2c/sr030pc30.c          |   3 +-
 drivers/media/v4l2-core/v4l2-common.c  |  18 +++-
 include/media/v4l2-common.h            |  12 +++
 6 files changed, 108 insertions(+), 116 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
