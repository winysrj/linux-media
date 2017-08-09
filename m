Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41934 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752432AbdHIH7k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Aug 2017 03:59:40 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 552A5600C8
        for <linux-media@vger.kernel.org>; Wed,  9 Aug 2017 10:59:39 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakke@valkosipuli.retiisi.org.uk>)
        id 1dfLty-0005Ww-R1
        for linux-media@vger.kernel.org; Wed, 09 Aug 2017 10:59:38 +0300
Date: Wed, 9 Aug 2017 10:59:38 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.14] Sensor driver patches for 4.14
Message-ID: <20170809075938.5jn7ww6h2cevtyqk@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are a bunch of sensor driver fixes and improvements for 4.14.

Please pull.


The following changes since commit da48c948c263c9d87dfc64566b3373a858cc8aa2:

  media: fix warning on v4l2_subdev_call() result interpreted as bool (2017-07-26 13:43:17 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.14-3

for you to fetch changes up to f95a6413a07c372cd586b9087a1425b6c216978a:

  ov9650: fix missing mutex_destroy() (2017-08-09 10:39:13 +0300)

----------------------------------------------------------------
Arnd Bergmann (1):
      media: i2c: add KConfig dependencies for ov5670

Chiranjeevi Rapolu (4):
      ov13858: Set default fps as current fps
      ov13858: Fix initial expsoure max
      ov13858: Correct link-frequency and pixel-rate
      ov13858: Increase digital gain granularity, range

Fabio Estevam (2):
      ov7670: Return the real error code
      ov7670: Check the return value from clk_prepare_enable()

Hugues Fruchet (2):
      ov9650: fix coding style
      ov9650: fix missing mutex_destroy()

Julia Lawall (1):
      vs6624: constify vs6624_default_fmt

 drivers/media/i2c/Kconfig   |  2 +-
 drivers/media/i2c/ov13858.c | 70 ++++++++++++++++++++++++---------------------
 drivers/media/i2c/ov7670.c  |  6 ++--
 drivers/media/i2c/ov9650.c  | 67 +++++++++++++++++++++++++------------------
 drivers/media/i2c/vs6624.c  |  2 +-
 5 files changed, 83 insertions(+), 64 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
