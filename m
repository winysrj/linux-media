Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43442 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753212AbdHQVGJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 17:06:09 -0400
Date: Fri, 18 Aug 2017 00:06:05 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [GIT PULL v2 for 4.14] Omap3isp CCP2 support
Message-ID: <20170817210605.2juop3gefkyqjue4@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These patches add functional CCP2 support for the omap3isp, as needed for
the Nokia N900.

since v1:

- Take further review comments into account, in particular store the entity
  associated to a given PHY struct (omap3isp) and add a patch cleaning up
  storing information on external sub-devices' bus configuration
  (omap3isp).

Please pull.


The following changes since commit ec0c3ec497cabbf3bfa03a9eb5edcc252190a4e0:

  media: ddbridge: split code into multiple files (2017-08-09 12:17:01 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git ccp2

for you to fetch changes up to d5107162567b192a58efc9ad930dd65cb70c4530:

  omap3isp: Quit using struct v4l2_subdev.host_priv field (2017-08-17 22:18:22 +0300)

----------------------------------------------------------------
Pavel Machek (2):
      omap3isp: Parse CSI1 configuration from the device tree
      omap3isp: Correctly set IO_OUT_SEL and VP_CLK_POL for CCP2 mode

Sakari Ailus (3):
      omap3isp: Always initialise isp and mutex for csiphy1
      omap3isp: csiphy: Don't assume the CSI receiver is a CSI2 module
      omap3isp: Quit using struct v4l2_subdev.host_priv field

 drivers/media/platform/omap3isp/isp.c       | 134 ++++++++++++++++++----------
 drivers/media/platform/omap3isp/isp.h       |   4 +-
 drivers/media/platform/omap3isp/ispccdc.c   |  16 ++--
 drivers/media/platform/omap3isp/ispccp2.c   |  12 ++-
 drivers/media/platform/omap3isp/ispcsi2.c   |   6 +-
 drivers/media/platform/omap3isp/ispcsiphy.c |  50 +++++------
 drivers/media/platform/omap3isp/ispcsiphy.h |   6 +-
 drivers/media/platform/omap3isp/ispreg.h    |   4 +
 drivers/media/platform/omap3isp/omap3isp.h  |   1 +
 9 files changed, 139 insertions(+), 94 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
