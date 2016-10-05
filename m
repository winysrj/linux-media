Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53854 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751230AbcJEHJN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Oct 2016 03:09:13 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 3FBE760096
        for <linux-media@vger.kernel.org>; Wed,  5 Oct 2016 10:09:04 +0300 (EEST)
Date: Wed, 5 Oct 2016 10:08:33 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL v2 FOR v4.10] smiapp cleanups, fixes and runtime PM support
Message-ID: <20161005070833.GH3225@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are a number of cleanups and some fixes plus runtime PM support for the
smiapp driver.

Since the previous pull request, the runtime PM support patches have been
rewritten.

Please pull.


The following changes since commit e3ea5e94489bc8c711d422dfa311cfa310553a1b:

  [media] si2165: switch to regmap (2016-09-22 12:56:35 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git smiapp

for you to fetch changes up to b77aa18b2b132468dcc42c17926e5dcc7c6fe9a6:

  smiapp: Implement support for autosuspend (2016-10-03 12:11:37 +0300)

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
 drivers/media/i2c/smiapp/smiapp-core.c | 946 +++++++++++++++++----------------
 drivers/media/i2c/smiapp/smiapp.h      |  28 +-
 3 files changed, 495 insertions(+), 482 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
