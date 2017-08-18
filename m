Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50568 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750812AbdHRJZm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 05:25:42 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id E2C2360111
        for <linux-media@vger.kernel.org>; Fri, 18 Aug 2017 12:25:40 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakke@valkosipuli.retiisi.org.uk>)
        id 1didXA-0007jO-CO
        for linux-media@vger.kernel.org; Fri, 18 Aug 2017 12:25:40 +0300
Date: Fri, 18 Aug 2017 12:25:40 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.14] More sensor driver patches
Message-ID: <20170818092539.qrnnhoezklaert3q@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are more sensor driver patches for 4.14.

Please pull.


The following changes since commit ec0c3ec497cabbf3bfa03a9eb5edcc252190a4e0:

  media: ddbridge: split code into multiple files (2017-08-09 12:17:01 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.14-4

for you to fetch changes up to 0a1405339595edaaf165988b313683b1c1c90fdb:

  media: ov13858: Limit vblank to permissible range (2017-08-18 11:42:04 +0300)

----------------------------------------------------------------
Chiranjeevi Rapolu (3):
      media: ov5670: Fix incorrect frame timing reported to user
      media: ov5670: Limit vblank to permissible range
      media: ov13858: Limit vblank to permissible range

Julia Lawall (2):
      v4l: mt9t001: constify video_subdev structures
      media: mt9m111: constify video_subdev structures

Sakari Ailus (1):
      et8ek8: Decrease stack usage

 drivers/media/i2c/et8ek8/et8ek8_driver.c | 26 ++++++----
 drivers/media/i2c/mt9m111.c              |  6 +--
 drivers/media/i2c/mt9t001.c              |  8 +--
 drivers/media/i2c/ov13858.c              | 35 ++++++++-----
 drivers/media/i2c/ov5670.c               | 85 ++++++++++++++++++--------------
 5 files changed, 96 insertions(+), 64 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
