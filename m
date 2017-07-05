Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41964 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752040AbdGEXAX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Jul 2017 19:00:23 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [PATCH 0/8] Prepare for CCP2 / CSI-1 support, omap3isp fixes
Date: Thu,  6 Jul 2017 02:00:11 +0300
Message-Id: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel and others,

Most of these patches have been posted to the list in some form or other
already but a lot has happened since. Thus reposting. There are more
patches in my ccp2 branch but they're not quite ready as such, for the
reasons discussed previously.


Pavel Machek (1):
  smiapp: add CCP2 support

Sakari Ailus (7):
  dt: bindings: Explicitly specify bus type
  dt: bindings: Add strobe property for CCP2
  v4l: fwnode: Call CSI2 bus csi2, not csi
  v4l: fwnode: Obtain data bus type from FW
  v4l: Add support for CSI-1 and CCP2 busses
  omap3isp: Check for valid port in endpoints
  omap3isp: Destroy CSI-2 phy mutexes in error and module removal

 .../devicetree/bindings/media/video-interfaces.txt |  8 ++-
 drivers/media/i2c/smiapp/smiapp-core.c             | 14 +++--
 drivers/media/platform/omap3isp/isp.c              |  8 ++-
 drivers/media/platform/omap3isp/ispcsiphy.c        |  6 ++
 drivers/media/platform/omap3isp/ispcsiphy.h        |  1 +
 drivers/media/platform/pxa_camera.c                |  3 +
 drivers/media/platform/soc_camera/soc_mediabus.c   |  3 +
 drivers/media/v4l2-core/v4l2-fwnode.c              | 73 ++++++++++++++++++----
 include/media/v4l2-fwnode.h                        | 19 ++++++
 include/media/v4l2-mediabus.h                      |  4 ++
 10 files changed, 118 insertions(+), 21 deletions(-)

-- 
2.11.0
