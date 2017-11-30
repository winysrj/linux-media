Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50846 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752514AbdK3MdT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 07:33:19 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 9E1F9600F8
        for <linux-media@vger.kernel.org>; Thu, 30 Nov 2017 14:33:17 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1eKO1l-0006Kq-8q
        for linux-media@vger.kernel.org; Thu, 30 Nov 2017 14:33:17 +0200
Date: Thu, 30 Nov 2017 14:33:17 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.16] Sensor driver patches, et8ek8 lens binding
Message-ID: <20171130123316.uepj2ccezdvpqgdj@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here are sensor driver patches, including error handling fixes, and DT
binding documentation and DTS changes for Nokia N900.

Please pull.


The following changes since commit be9b53c83792e3898755dce90f8c632d40e7c83e:

  media: dvb-frontends: complete kernel-doc markups (2017-11-30 04:19:05 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.16-1

for you to fetch changes up to 5e1372893debd1d0e74546072424ee912c9625fd:

  v4l: mt9v032: Disable clock on error paths (2017-11-30 14:26:42 +0200)

----------------------------------------------------------------
Akinobu Mita (2):
      media: ov7670: use v4l2_async_unregister_subdev()
      media: ov7670: add V4L2_CID_TEST_PATTERN control

Alexey Khoroshilov (1):
      v4l: mt9v032: Disable clock on error paths

Pavel Machek (2):
      dt-bindings: et8ek8: Document support for flash and lens devices
      ARM: dts: nokia n900: enable autofocus

Sakari Ailus (1):
      imx274: Fix error handling, add MAINTAINERS entry

 .../bindings/media/i2c/toshiba,et8ek8.txt          |  7 ++++
 MAINTAINERS                                        |  8 ++++
 arch/arm/boot/dts/omap3-n900.dts                   |  2 +
 drivers/media/i2c/imx274.c                         |  5 +--
 drivers/media/i2c/mt9v032.c                        | 21 +++++++---
 drivers/media/i2c/ov7670.c                         | 48 +++++++++++++++++++++-
 6 files changed, 80 insertions(+), 11 deletions(-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
