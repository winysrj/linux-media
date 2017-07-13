Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47668 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752396AbdGMQTH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 12:19:07 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: pavel@ucw.cz
Subject: [PATCH 0/2] OMAP3ISP CCP2 support
Date: Thu, 13 Jul 2017 19:19:01 +0300
Message-Id: <20170713161903.9974-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

I took the liberty of changing your patch a bit. I added another to extract
the number of lanes from the endpoint instead as it's not really a property
of the PHY. (Not tested yet, will check with N9.)

Pavel Machek (1):
  omap3isp: add CSI1 support

Sakari Ailus (1):
  omap3isp: Explicitly set the number of CSI-2 lanes used in lane cfg

 drivers/media/platform/omap3isp/isp.c       |  5 ++++-
 drivers/media/platform/omap3isp/ispccp2.c   |  1 +
 drivers/media/platform/omap3isp/ispcsiphy.c | 35 +++++++++++++++++++----------
 drivers/media/platform/omap3isp/omap3isp.h  |  3 +++
 4 files changed, 31 insertions(+), 13 deletions(-)

-- 
2.11.0
