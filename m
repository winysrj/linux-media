Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56182 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751172AbdJaMXq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 08:23:46 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 10632600D2
        for <linux-media@vger.kernel.org>; Tue, 31 Oct 2017 14:23:44 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1e9Va3-00013M-I8
        for linux-media@vger.kernel.org; Tue, 31 Oct 2017 14:23:43 +0200
Date: Tue, 31 Oct 2017 14:23:43 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.15] More sensor driver fixes
Message-ID: <20171031122342.fhxomyhqupctdp2x@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's essentially what ended up being missed in the previous sensor driver
pull request (due to various oddities that happened on the way, no harm
done in the end). All are fixes.

Please pull.


The following changes since commit 1bfbb88564b17bbc2187cbce9e867628532ce1a8:

  media: cx231xx: Fix NTSC/PAL on Astrometa T2hybrid (2017-10-31 06:36:19 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.15-4

for you to fetch changes up to edc94ed0f7024598f29b853be90bfa1951e8e14a:

  media: ov9650: remove unnecessary terminated entry in menu items array (2017-10-31 13:29:58 +0200)

----------------------------------------------------------------
Akinobu Mita (5):
      media: adv7180: don't clear V4L2_SUBDEV_FL_IS_I2C
      media: max2175: don't clear V4L2_SUBDEV_FL_IS_I2C
      media: ov2640: don't clear V4L2_SUBDEV_FL_IS_I2C
      media: ov5640: don't clear V4L2_SUBDEV_FL_IS_I2C
      media: ov9650: remove unnecessary terminated entry in menu items array

 drivers/media/i2c/adv7180.c | 2 +-
 drivers/media/i2c/max2175.c | 2 +-
 drivers/media/i2c/ov2640.c  | 2 +-
 drivers/media/i2c/ov5640.c  | 2 +-
 drivers/media/i2c/ov9650.c  | 1 -
 5 files changed, 4 insertions(+), 5 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
