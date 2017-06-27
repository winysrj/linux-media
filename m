Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34610 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751473AbdF0FUk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 01:20:40 -0400
Received: from valkosipuli.retiisi.org.uk (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 5C7A1600A0
        for <linux-media@vger.kernel.org>; Tue, 27 Jun 2017 08:20:36 +0300 (EEST)
Date: Tue, 27 Jun 2017 08:20:35 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [GIT PULL v2 for 4.13] ov6650 V4L2 sub-device conversion
Message-ID: <20170627052035.GV12407@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

(v2, this time with the appropriate git tags, plus rebased on current media
tree master. No other changes.)

This set includes converting the ov6650 driver to V4L2 sub-device driver
(from SoC camera).

Rebased w/o conflicts on more recent media tree master.

Please pull.

The following changes since commit 2748e76ddb2967c4030171342ebdd3faa6a5e8e8:

  media: staging: cxd2099: Activate cxd2099 buffer mode (2017-06-26 08:19:13 -0300)

are available in the git repository at:

  ssh://linuxtv.org/git/sailus/media_tree.git for-4.13-4-2

for you to fetch changes up to 4519f07fc2b13a2bc0f45ad3aa87c06bd43192ff:

  media: ov6650: convert to standalone v4l2 subdevice (2017-06-27 08:18:02 +0300)

----------------------------------------------------------------
Janusz Krzysztofik (1):
      media: ov6650: convert to standalone v4l2 subdevice

 drivers/media/i2c/Kconfig                   | 11 +++++
 drivers/media/i2c/Makefile                  |  1 +
 drivers/media/i2c/{soc_camera => }/ov6650.c | 77 +++++++++--------------------
 drivers/media/i2c/soc_camera/Kconfig        |  6 ---
 drivers/media/i2c/soc_camera/Makefile       |  1 -
 5 files changed, 35 insertions(+), 61 deletions(-)
 rename drivers/media/i2c/{soc_camera => }/ov6650.c (92%)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
