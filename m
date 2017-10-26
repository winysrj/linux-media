Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40404 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751027AbdJZJC5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 05:02:57 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 3BDFC600E1
        for <linux-media@vger.kernel.org>; Thu, 26 Oct 2017 12:02:56 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1e7e3z-00032a-To
        for linux-media@vger.kernel.org; Thu, 26 Oct 2017 12:02:55 +0300
Date: Thu, 26 Oct 2017 12:02:55 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.15] Yet more sensor driver patches
Message-ID: <20171026090255.2oe6a24qugrngj3o@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the final set of sensor driver patches for 4.15.

Please pull.


The following changes since commit 61065fc3e32002ba48aa6bc3816c1f6f9f8daf55:

  Merge commit '3728e6a255b5' into patchwork (2017-10-17 17:22:20 -0700)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.15-4

for you to fetch changes up to fc8d24b85bc230afe66e9aece38350384c9b65f8:

  media: ov9650: remove unnecessary terminated entry in menu items array (2017-10-25 19:08:43 +0300)

----------------------------------------------------------------
Akinobu Mita (5):
      media: adv7180: don't clear V4L2_SUBDEV_FL_IS_I2C
      media: max2175: don't clear V4L2_SUBDEV_FL_IS_I2C
      media: ov2640: don't clear V4L2_SUBDEV_FL_IS_I2C
      media: ov5640: don't clear V4L2_SUBDEV_FL_IS_I2C
      media: ov9650: remove unnecessary terminated entry in menu items array

Jacob Chen (2):
      media: i2c: OV5647: ensure clock lane in LP-11 state before streaming on
      media: i2c: OV5647: change to use macro for the registers

Philipp Zabel (1):
      tc358743: validate lane count

Wenyou Yang (3):
      media: ov7670: Add entity pads initialization
      media: ov7670: Add the get_fmt callback
      media: ov7670: Add the ov7670_s_power function

 drivers/media/i2c/adv7180.c  |   2 +-
 drivers/media/i2c/max2175.c  |   2 +-
 drivers/media/i2c/ov2640.c   |   2 +-
 drivers/media/i2c/ov5640.c   |   2 +-
 drivers/media/i2c/ov5647.c   |  51 ++++++++++++-----
 drivers/media/i2c/ov7670.c   | 129 ++++++++++++++++++++++++++++++++++++++++---
 drivers/media/i2c/ov9650.c   |   1 -
 drivers/media/i2c/tc358743.c |   5 ++
 8 files changed, 167 insertions(+), 27 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
