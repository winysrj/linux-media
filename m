Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34690 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1032173AbdIZVev (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 17:34:51 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 08F1560107
        for <linux-media@vger.kernel.org>; Wed, 27 Sep 2017 00:34:50 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakke@valkosipuli.retiisi.org.uk>)
        id 1dwxVB-0007Kc-HM
        for linux-media@vger.kernel.org; Wed, 27 Sep 2017 00:34:49 +0300
Date: Wed, 27 Sep 2017 00:34:49 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.15] Camera sensor patches
Message-ID: <20170926213449.475bgle4kectae4f@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's the first set of camera sensor patches for 4.15.

There's one framework patch included, "media: Check for active and
has_no_links overrun".

Please pull.


The following changes since commit d5426f4c2ebac8cf05de43988c3fccddbee13d28:

  media: staging: atomisp: use clock framework for camera clocks (2017-09-23 15:09:37 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.15-1

for you to fetch changes up to a0b4db3ddd14b6202b2dba9dfa90572d6767b571:

  smiapp: Make clock control optional (2017-09-26 23:58:56 +0300)

----------------------------------------------------------------
Chiranjeevi Rapolu (4):
      media: ov5670: Use recommended black level and output bias
      media: ov5670: Fix not streaming issue after resume.
      media: ov13858: Calculate pixel-rate at runtime, use mode
      media: ov13858: Fix 4224x3136 video flickering at some vblanks

Colin Ian King (1):
      ov2640: make array reset_seq static, reduces object code size

Fabio Estevam (3):
      mt9m111: Propagate the real error on v4l2_clk_get() failure
      ov2640: Propagate the real error on devm_clk_get() failure
      ov2640: Check the return value from clk_prepare_enable()

Markus Elfring (7):
      ov2640: Delete an error message for a failed memory allocation in ov2640_probe()
      ov2640: Improve a size determination in ov2640_probe()
      ov6650: Delete an error message for a failed memory allocation in ov6650_probe()
      ov9640: Delete an error message for a failed memory allocation in ov9640_probe()
      ov9640: Improve a size determination in ov9640_probe()
      ov9740: Delete an error message for a failed memory allocation in ov9740_probe()
      ov9740: Improve a size determination in ov9740_probe()

Rajmohan Mani (1):
      dw9714: Set the v4l2 focus ctrl step as 1

Sakari Ailus (6):
      media: Check for active and has_no_links overrun
      ov13858: Use do_div() for dividing a 64-bit number
      smiapp: Fix error handling in power on sequence
      smiapp: Verify clock frequency after setting it, prevent changing it
      smiapp: Get clock rate if it's not available through DT
      smiapp: Make clock control optional

 drivers/media/i2c/dw9714.c             |  7 +++-
 drivers/media/i2c/mt9m111.c            |  2 +-
 drivers/media/i2c/ov13858.c            | 59 +++++++++++++++++++++-------------
 drivers/media/i2c/ov2640.c             | 15 ++++-----
 drivers/media/i2c/ov5670.c             | 35 ++++++++++++++------
 drivers/media/i2c/ov6650.c             |  5 +--
 drivers/media/i2c/smiapp/smiapp-core.c | 50 +++++++++++++++++++++-------
 drivers/media/i2c/soc_camera/ov9640.c  |  7 ++--
 drivers/media/i2c/soc_camera/ov9740.c  |  6 ++--
 drivers/media/media-entity.c           | 13 +++++---
 10 files changed, 127 insertions(+), 72 deletions(-)


-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
