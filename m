Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47646 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728927AbeGYN7v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 09:59:51 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 7ECF0634C7F
        for <linux-media@vger.kernel.org>; Wed, 25 Jul 2018 15:48:17 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1fiJDF-0008UX-8G
        for linux-media@vger.kernel.org; Wed, 25 Jul 2018 15:48:17 +0300
Date: Wed, 25 Jul 2018 15:48:17 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.19] ov2680 driver and dw9807 driver rename
Message-ID: <20180725124816.z26t5cvwsjkvlytd@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's a driver for the ov2680 sensor and a patch that renamed dw0807 as
dw9807-vcm for it's a driver for the VCM bit only. Rename it now to avoid
Kconfig option fuss for most people.

Please pull.


The following changes since commit 8601494e0ec0a7697230b2abca25d786b793341b:

  media: media-ioc-enum-entities.rst/-g-topology.rst: clarify ID/name usage (2018-07-25 08:05:06 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.19-4

for you to fetch changes up to 070438e314c5f7f8bbb6d7af9bfc4cf20f33a275:

  dw9807-vcm: Recognise this is just the VCM bit of the device (2018-07-25 15:45:08 +0300)

----------------------------------------------------------------
Rui Miguel Silva (2):
      media: ov2680: dt: Add bindings for OV2680
      media: ov2680: Add Omnivision OV2680 sensor driver

Sakari Ailus (1):
      dw9807-vcm: Recognise this is just the VCM bit of the device

 .../devicetree/bindings/media/i2c/ov2680.txt       |   46 +
 drivers/media/i2c/Kconfig                          |   14 +-
 drivers/media/i2c/Makefile                         |    3 +-
 drivers/media/i2c/{dw9807.c => dw9807-vcm.c}       |    0
 drivers/media/i2c/ov2680.c                         | 1186 ++++++++++++++++++++
 5 files changed, 1247 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov2680.txt
 rename drivers/media/i2c/{dw9807.c => dw9807-vcm.c} (100%)
 create mode 100644 drivers/media/i2c/ov2680.c

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
