Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59368 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753940AbdGUOrM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 10:47:12 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 75473600CF
        for <linux-media@vger.kernel.org>; Fri, 21 Jul 2017 15:06:33 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakke@valkosipuli.retiisi.org.uk>)
        id 1dYWhU-00016r-TY
        for linux-media@vger.kernel.org; Fri, 21 Jul 2017 15:06:32 +0300
Date: Fri, 21 Jul 2017 15:06:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.14] V4L2 flash class and misc patches
Message-ID: <20170721120632.6cdmsxmsvryx77ud@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

More patches for 4.14. Flash fixes and improvements plus other
miscellaneous patches.

Please pull.


The following changes since commit 6538b02d210f52ef2a2e67d59fcb58be98451fbd:

  media: Make parameter of media_entity_remote_pad() const (2017-07-20 16:54:04 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.14-2

for you to fetch changes up to c8c62ce6f725078ec3cf8a3b1945417f0d8e6706:

  ov5640: Remove unneeded gpiod NULL check (2017-07-21 14:56:06 +0300)

----------------------------------------------------------------
Fabio Estevam (1):
      ov5640: Remove unneeded gpiod NULL check

Laurent Pinchart (1):
      v4l: omap3isp: Get the parallel bus type from DT

Sakari Ailus (3):
      v4l2-fwnode: link_frequency is an optional property
      v4l2-flash: Use led_classdev instead of led_classdev_flash for indicator
      v4l2-flash: Flash ops aren't mandatory

 drivers/media/i2c/ov5640.c                     |  3 +--
 drivers/media/platform/omap3isp/isp.c          |  1 +
 drivers/media/platform/omap3isp/ispccdc.c      |  8 +------
 drivers/media/platform/omap3isp/omap3isp.h     |  2 ++
 drivers/media/v4l2-core/v4l2-flash-led-class.c | 30 +++++++++++---------------
 drivers/media/v4l2-core/v4l2-fwnode.c          | 30 +++++++++++++-------------
 drivers/staging/greybus/light.c                |  4 ++--
 include/media/v4l2-flash-led-class.h           |  6 +++---
 8 files changed, 37 insertions(+), 47 deletions(-)

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
