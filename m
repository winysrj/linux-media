Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49264 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751884AbdHITkA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Aug 2017 15:40:00 -0400
Date: Wed, 9 Aug 2017 22:39:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: pavel@uwc.cz
Subject: [GIT PULL for 4.14] Omap3isp CCP2 support
Message-ID: <20170809193956.ywlwfxsuzhavrcq5@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These patches add functional CCP2 support for the omap3isp, as needed for
the Nokia N900.

Please pull.


The following changes since commit ec0c3ec497cabbf3bfa03a9eb5edcc252190a4e0:

  media: ddbridge: split code into multiple files (2017-08-09 12:17:01 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git ccp2

for you to fetch changes up to 1d3f6ca1c698441784755d40b441fd969e9b2303:

  omap3isp: Skip CSI-2 receiver initialisation in CCP2 configuration (2017-08-09 22:36:58 +0300)

----------------------------------------------------------------
Pavel Machek (2):
      omap3isp: Parse CSI1 configuration from the device tree
      omap3isp: Correctly set IO_OUT_SEL and VP_CLK_POL for CCP2 mode

Sakari Ailus (2):
      omap3isp: Always initialise isp and mutex for csiphy1
      omap3isp: Skip CSI-2 receiver initialisation in CCP2 configuration

 drivers/media/platform/omap3isp/isp.c       | 105 +++++++++++++++++++++-------
 drivers/media/platform/omap3isp/ispccp2.c   |   9 ++-
 drivers/media/platform/omap3isp/ispcsi2.c   |   4 +-
 drivers/media/platform/omap3isp/ispcsiphy.c |  38 +++++-----
 drivers/media/platform/omap3isp/ispcsiphy.h |   6 +-
 drivers/media/platform/omap3isp/ispreg.h    |   4 ++
 drivers/media/platform/omap3isp/omap3isp.h  |   1 +
 7 files changed, 115 insertions(+), 52 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
