Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53814 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753865AbcI0OEo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Sep 2016 10:04:44 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id B7F0D60096
        for <linux-media@vger.kernel.org>; Tue, 27 Sep 2016 17:04:35 +0300 (EEST)
Date: Tue, 27 Sep 2016 17:04:05 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.10] smiapp cleanups, fixes and runtime PM support
Message-ID: <20160927140404.GC3225@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are a number of cleanups and some fixes plus runtime PM support for the
smiapp driver.

Please pull.


The following changes since commit e3ea5e94489bc8c711d422dfa311cfa310553a1b:

  [media] si2165: switch to regmap (2016-09-22 12:56:35 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git smiapp-runtime-pm

for you to fetch changes up to eaae98f0b16d41c6b8f7ee414b49b11534024651:

  smiapp: Implement support for autosuspend (2016-09-27 16:50:14 +0300)

----------------------------------------------------------------
Sakari Ailus (23):
      smiapp: Move sub-device initialisation into a separate function
      smiapp: Explicitly define number of pads in initialisation
      smiapp: Initialise media entity after sensor init
      smiapp: Split off sub-device registration into two
      smiapp: Provide a common function to obtain native pixel array size
      smiapp: Remove unnecessary BUG_ON()'s
      smiapp: Always initialise the sensor in probe
      smiapp: Fix resource management in registration failure
      smiapp: Merge smiapp_init() with smiapp_probe()
      smiapp: Read frame format earlier
      smiapp: Unify setting up sub-devices
      smiapp: Use SMIAPP_PADS when referring to number of pads
      smiapp: Obtain frame layout from the frame descriptor
      smiapp: Improve debug messages from frame layout reading
      smiapp: Remove useless newlines and other small cleanups
      smiapp: Obtain correct media bus code for try format
      smiapp: Drop a debug print on frame size and bit depth
      smiapp-pll: Don't complain aloud about failing PLL calculation
      smiapp: Drop BUG_ON() in suspend path
      smiapp: Set device for pixel array and binner
      smiapp: Set use suspend and resume ops for other functions
      smiapp: Use runtime PM
      smiapp: Implement support for autosuspend

 drivers/media/i2c/smiapp-pll.c         |   3 +-
 drivers/media/i2c/smiapp/smiapp-core.c | 942 ++++++++++++++++-----------------
 drivers/media/i2c/smiapp/smiapp-regs.c |  24 +-
 drivers/media/i2c/smiapp/smiapp.h      |  28 +-
 4 files changed, 489 insertions(+), 508 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
