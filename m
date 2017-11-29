Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60722 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753310AbdK2IIE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 03:08:04 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id F1F4C600EF
        for <linux-media@vger.kernel.org>; Wed, 29 Nov 2017 10:08:02 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1eJxPW-00069e-6e
        for linux-media@vger.kernel.org; Wed, 29 Nov 2017 10:08:02 +0200
Date: Wed, 29 Nov 2017 10:08:02 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT FIXES for 4.15] Sensor driver and V4L2 async, fwnode fixes
Message-ID: <20171129080801.j6v4ehizcir5oc7f@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are fixes for sensor drivers and the V4L2 async and fwnode frameworks.

Please pull.


The following changes since commit 30b4e122d71cbec2944a5f8b558b88936ee42f10:

  media: rc: sir_ir: detect presence of port (2017-11-15 08:57:34 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.15-fix-1

for you to fetch changes up to f1f16dc62ee643f70fc14dea871599d40ac4a927:

  v4l: async: use the v4l2_dev from the root notifier when matching sub-devices (2017-11-29 09:55:21 +0200)

----------------------------------------------------------------
Arnd Bergmann (1):
      media: et8ek8: select V4L2_FWNODE

Niklas Söderlund (1):
      v4l: async: use the v4l2_dev from the root notifier when matching sub-devices

Sakari Ailus (1):
      ov13858: Select V4L2_FWNODE

Tomasz Figa (1):
      media: v4l2-fwnode: Check subdev count after checking port

 drivers/media/i2c/Kconfig             |  1 +
 drivers/media/i2c/et8ek8/Kconfig      |  1 +
 drivers/media/v4l2-core/v4l2-async.c  |  3 +--
 drivers/media/v4l2-core/v4l2-fwnode.c | 10 +++++-----
 4 files changed, 8 insertions(+), 7 deletions(-)

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
