Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56854 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753142AbdHXVlO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Aug 2017 17:41:14 -0400
Date: Fri, 25 Aug 2017 00:41:10 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: alan@linux.intel.com
Subject: [GIT PULL for 4.14] Still more atomisp cleanups and fixes
Message-ID: <20170824214110.4vamaflemdpggegy@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are the last atomisp cleanups and fixes for 4.14.

Please pull.


The following changes since commit 0779b8855c746c90b85bfe6e16d5dfa2a6a46655:

  media: ddbridge: fix semicolon.cocci warnings (2017-08-20 10:25:22 -0400)

are available in the git repository at:

  https://linuxtv.org/git/sailus/media_tree.git atomisp

for you to fetch changes up to fdb35c456dd1bcb792b107e1ebc9b46744037281:

  staging: atomisp: fix bounds checking in mt9m114_s_exposure_selection() (2017-08-25 00:20:05 +0300)

----------------------------------------------------------------
Arnd Bergmann (1):
      staging: atomisp: imx: remove dead code

Dan Carpenter (1):
      staging: atomisp: fix bounds checking in mt9m114_s_exposure_selection()

Harold Gomez (1):
      staging: media: atomisp: ap1302: Remove FSF postal address

 drivers/staging/media/atomisp/i2c/ap1302.c        |  5 ----
 drivers/staging/media/atomisp/i2c/imx/ad5816g.c   | 11 +-------
 drivers/staging/media/atomisp/i2c/imx/drv201.c    | 11 +-------
 drivers/staging/media/atomisp/i2c/imx/dw9714.c    | 14 +---------
 drivers/staging/media/atomisp/i2c/imx/dw9718.c    |  5 ----
 drivers/staging/media/atomisp/i2c/imx/dw9719.c    | 11 --------
 drivers/staging/media/atomisp/i2c/imx/imx.c       | 32 -----------------------
 drivers/staging/media/atomisp/i2c/imx/imx.h       | 29 --------------------
 drivers/staging/media/atomisp/i2c/mt9m114.c       |  8 +++---
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.c |  2 +-
 drivers/staging/media/atomisp/i2c/ov8858.h        |  3 ---
 drivers/staging/media/atomisp/i2c/ov8858_btns.h   |  3 ---
 12 files changed, 8 insertions(+), 126 deletions(-)

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
