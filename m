Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44938 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751493AbcIAMCs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Sep 2016 08:02:48 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 7774E6009C
        for <linux-media@vger.kernel.org>; Thu,  1 Sep 2016 15:02:44 +0300 (EEST)
Date: Thu, 1 Sep 2016 15:02:44 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.9] smiapp cleanups and probe deferral
Message-ID: <20160901120243.GV12130@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are cleanups and probe deferral in case of a failure to obtain a clock
for the smiapp driver.

Please pull.


The following changes since commit b6aa39228966e0d3f0bc3306be1892f87792903a:

  Merge tag 'v4.8-rc1' into patchwork (2016-08-08 07:30:25 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git smiapp

for you to fetch changes up to e5523b3e420ea19172e364bb6f10ce6eeec61efc:

  smiapp: Remove set_xclk() callback from hwconfig (2016-09-01 12:42:13 +0300)

----------------------------------------------------------------
Sakari Ailus (6):
      smiapp: Unify enforced and need-based 8-bit read
      smiapp: Rename smiapp_platform_data as smiapp_hwconfig
      smiapp: Return -EPROBE_DEFER if the clock cannot be obtained
      smiapp: Constify the regs argument to smiapp_write_8s()
      smiapp: Switch to gpiod API for GPIO control
      smiapp: Remove set_xclk() callback from hwconfig

 drivers/media/i2c/smiapp/smiapp-core.c  | 172 +++++++++++++-------------------
 drivers/media/i2c/smiapp/smiapp-quirk.c |  16 ++-
 drivers/media/i2c/smiapp/smiapp-regs.c  |  22 ++--
 drivers/media/i2c/smiapp/smiapp.h       |   3 +-
 include/media/i2c/smiapp.h              |   7 +-
 5 files changed, 93 insertions(+), 127 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
