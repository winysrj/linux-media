Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39182 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934362AbdLSO0F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 09:26:05 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id E2B8F600DA
        for <linux-media@vger.kernel.org>; Tue, 19 Dec 2017 16:26:03 +0200 (EET)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1eRIqJ-0001hx-Du
        for linux-media@vger.kernel.org; Tue, 19 Dec 2017 16:26:03 +0200
Date: Tue, 19 Dec 2017 16:26:03 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.16] Remove as3645a V4L2 driver
Message-ID: <20171219142602.rsf3qamhyahhl4ct@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This set removes the as3645a V4L2 LED flash driver. The LED flash class
driver offering V4L2 API already exists, and should be used instead.

Please pull.


The following changes since commit 8ea636dcecfa7b05d60309a50beabc5317a845bf:

  media: ir-spi: add SPDX identifier (2017-12-18 15:22:50 -0500)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git as3645a-v4l2-remove

for you to fetch changes up to 09eb6ec7ad9f7301a12457369dd1373999d38aea:

  media: i2c: as3645a: Remove driver (2017-12-19 16:21:58 +0200)

----------------------------------------------------------------
Sakari Ailus (1):
      media: i2c: as3645a: Remove driver

 MAINTAINERS                 |   8 -
 drivers/media/i2c/Kconfig   |   8 -
 drivers/media/i2c/Makefile  |   1 -
 drivers/media/i2c/as3645a.c | 880 --------------------------------------------
 include/media/i2c/as3645a.h |  66 ----
 5 files changed, 963 deletions(-)
 delete mode 100644 drivers/media/i2c/as3645a.c
 delete mode 100644 include/media/i2c/as3645a.h

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
