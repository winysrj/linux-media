Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44408 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751361AbdGQWNh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 18:13:37 -0400
Received: from lanttu.localdomain (lanttu-e.localdomain [192.168.1.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id ACFBE600BF
        for <linux-media@vger.kernel.org>; Tue, 18 Jul 2017 01:13:34 +0300 (EEST)
Received: from sailus by lanttu.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@iki.fi>)
        id 1dXEGm-0004zV-1p
        for linux-media@vger.kernel.org; Tue, 18 Jul 2017 01:13:36 +0300
Date: Tue, 18 Jul 2017 01:13:35 +0300
From: sakari.ailus@iki.fi
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.14] CCP2 support preparation
Message-ID: <20170717221335.ciz7b2uqrfb4eexm@lanttu.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patchset prepares for CCP2 support in omap3isp; the patches have been
around for ages and I think it's time to get them in. I'd hope we'll have
all the missing bits in during this merge window.

Please pull.


The following changes since commit a3db9d60a118571e696b684a6e8c692a2b064941:

  Merge tag 'v4.13-rc1' into patchwork (2017-07-17 11:17:36 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git ccp2-prepare

for you to fetch changes up to 5151d5af4010a2aeeaff1fb05de4661f2fd6d982:

  omap3isp: add CSI1 support (2017-07-17 23:55:20 +0300)

----------------------------------------------------------------
Pavel Machek (2):
      smiapp: add CCP2 support
      omap3isp: add CSI1 support

Sakari Ailus (8):
      dt: bindings: Explicitly specify bus type
      dt: bindings: Add strobe property for CCP2
      v4l: fwnode: Call CSI2 bus csi2, not csi
      v4l: fwnode: Obtain data bus type from FW
      v4l: Add support for CSI-1 and CCP2 busses
      omap3isp: Check for valid port in endpoints
      omap3isp: Destroy CSI-2 phy mutexes in error and module removal
      omap3isp: Explicitly set the number of CSI-2 lanes used in lane cfg

 .../devicetree/bindings/media/video-interfaces.txt |  8 ++-
 drivers/media/i2c/smiapp/smiapp-core.c             | 14 +++--
 drivers/media/platform/omap3isp/isp.c              | 13 ++--
 drivers/media/platform/omap3isp/ispccp2.c          |  1 +
 drivers/media/platform/omap3isp/ispcsiphy.c        | 41 ++++++++----
 drivers/media/platform/omap3isp/ispcsiphy.h        |  1 +
 drivers/media/platform/omap3isp/omap3isp.h         |  3 +
 drivers/media/platform/pxa_camera.c                |  3 +
 drivers/media/platform/soc_camera/soc_mediabus.c   |  3 +
 drivers/media/v4l2-core/v4l2-fwnode.c              | 73 ++++++++++++++++++----
 include/media/v4l2-fwnode.h                        | 19 ++++++
 include/media/v4l2-mediabus.h                      |  4 ++
 12 files changed, 149 insertions(+), 34 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
