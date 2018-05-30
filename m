Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53898 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750790AbeE3LcU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 07:32:20 -0400
Date: Wed, 30 May 2018 14:32:18 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: akinobu.mita@gmail.com
Subject: [GIT PULL for 4.18] More ov772x patches
Message-ID: <20180530113217.2txkopqj4z2fw2w7@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are the rest of the ov772x patches that were missed the last time.

I've dropped the patch avoiding I2C_FUNC_PROTOCOL_MANGLING as discussed.

Please pull.


The following changes since commit a00031c159748f322f771f3c1d5ed944cba4bd30:

  media: ddbridge: conditionally enable fast TS for stv0910-equipped bridges (2018-05-28 17:47:05 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.18-5.1

for you to fetch changes up to 457ed65306ca41dd664c16c27e939971827b7421:

  media: ov772x: create subdevice device node (2018-05-30 09:57:32 +0300)

----------------------------------------------------------------
Akinobu Mita (11):
      media: ov772x: add checks for register read errors
      media: ov772x: add media controller support
      media: ov772x: use generic names for reset and powerdown gpios
      media: ov772x: omit consumer ID when getting clock reference
      media: ov772x: support device tree probing
      media: ov772x: handle nested s_power() calls
      media: ov772x: reconstruct s_frame_interval()
      media: ov772x: use v4l2_ctrl to get current control value
      media: ov772x: avoid accessing registers under power saving mode
      media: ov772x: make set_fmt() and s_frame_interval() return -EBUSY while streaming
      media: ov772x: create subdevice device node

 arch/sh/boards/mach-migor/setup.c |   7 +-
 drivers/media/i2c/ov772x.c        | 333 ++++++++++++++++++++++++++++----------
 2 files changed, 250 insertions(+), 90 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
