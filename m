Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44310 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752169AbeC1Hph (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 03:45:37 -0400
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id B35E7634C53
        for <linux-media@vger.kernel.org>; Wed, 28 Mar 2018 10:45:35 +0300 (EEST)
Received: from sakke by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1f15m3-0001Ib-FP
        for linux-media@vger.kernel.org; Wed, 28 Mar 2018 10:45:35 +0300
Date: Wed, 28 Mar 2018 10:45:35 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for 4.17] Finding nearest matching size, sensor driver +
 SPDX header changes
Message-ID: <20180328074535.tdjnsftc3dseuqep@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here's a change that adds the array size back to v4l2_find_nearest_size()
as well as a few sensor and lens driver patches including fixes, cleanups
and SPDX header changes.

Please pull.


The following changes since commit 6ccd228e0cfce2a4f44558422d25c60fcb1a6710:

  media: fimc-capture: get rid of two warnings (2018-03-23 08:56:36 -0400)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.17-2

for you to fetch changes up to a51fe17a6a44082edf014bb9079df8aaa4feeb94:

  media: ov5640: add missing output pixel format setting (2018-03-26 16:08:43 +0300)

----------------------------------------------------------------
Akinobu Mita (2):
      media: ov5645: add missing of_node_put() in error path
      media: ov5640: add missing output pixel format setting

Chiranjeevi Rapolu (2):
      media: ov5670: Update to SPDX identifier
      media: ov13858: Update to SPDX identifier

Fabio Estevam (1):
      media: ov2685: Remove owner assignment from i2c_driver

Hugues Fruchet (1):
      media: ov5640: fix get_/set_fmt colorspace related fields

Luca Ceresoli (1):
      media: imx274: fix typo in error message

Rajmohan Mani (1):
      media: dw9714: Update to SPDX license identifier

Sakari Ailus (1):
      v4l: Bring back array_size parameter to v4l2_find_nearest_size

Todor Tomov (1):
      media: ov5645: Use v4l2_find_nearest_size

 drivers/media/i2c/dw9714.c                   | 14 ++--------
 drivers/media/i2c/imx274.c                   |  2 +-
 drivers/media/i2c/ov13858.c                  | 19 ++++----------
 drivers/media/i2c/ov2685.c                   |  1 -
 drivers/media/i2c/ov5640.c                   | 38 +++++++++++++++++++++-------
 drivers/media/i2c/ov5645.c                   | 29 ++++++---------------
 drivers/media/i2c/ov5670.c                   | 19 ++++----------
 drivers/media/platform/vivid/vivid-vid-cap.c |  5 ++--
 include/media/v4l2-common.h                  |  5 ++--
 9 files changed, 56 insertions(+), 76 deletions(-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
