Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60370 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933837AbdCLQww (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Mar 2017 12:52:52 -0400
Received: from axis700.grange ([81.173.166.100]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MSdRI-1cd6Iy2RCW-00RWd2 for
 <linux-media@vger.kernel.org>; Sun, 12 Mar 2017 17:52:44 +0100
Received: from localhost (localhost [127.0.0.1])
        by axis700.grange (Postfix) with ESMTP id 72DD28B110
        for <linux-media@vger.kernel.org>; Sun, 12 Mar 2017 17:52:43 +0100 (CET)
Date: Sun, 12 Mar 2017 17:52:43 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera for 4.12
Message-ID: <Pine.LNX.4.64.1703121751340.22698@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 700ea5e0e0dd70420a04e703ff264cc133834cba:

  Merge tag 'v4.11-rc1' into patchwork (2017-03-06 06:49:34 -0300)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-4.12-1

for you to fetch changes up to c259da29a447dbb5737c5c85e99c039263df94cc:

  soc-camera: fix rectangle adjustment in cropping (2017-03-12 12:53:25 +0100)

----------------------------------------------------------------
Bhumika Goyal (1):
      media: i2c: soc_camera: constify v4l2_subdev_* structures

Geliang Tang (1):
      sh_mobile_ceu_camera: use module_platform_driver

Janusz Krzysztofik (1):
      media: i2c/soc_camera: fix ov6650 sensor getting wrong clock

Koji Matsuoka (1):
      soc-camera: fix rectangle adjustment in cropping

 drivers/media/i2c/soc_camera/imx074.c                    |  6 +++---
 drivers/media/i2c/soc_camera/mt9m001.c                   |  6 +++---
 drivers/media/i2c/soc_camera/mt9t031.c                   |  6 +++---
 drivers/media/i2c/soc_camera/mt9t112.c                   |  6 +++---
 drivers/media/i2c/soc_camera/mt9v022.c                   |  6 +++---
 drivers/media/i2c/soc_camera/ov2640.c                    |  6 +++---
 drivers/media/i2c/soc_camera/ov5642.c                    |  6 +++---
 drivers/media/i2c/soc_camera/ov6650.c                    |  8 ++++----
 drivers/media/i2c/soc_camera/ov772x.c                    |  6 +++---
 drivers/media/i2c/soc_camera/ov9640.c                    |  6 +++---
 drivers/media/i2c/soc_camera/ov9740.c                    |  6 +++---
 drivers/media/i2c/soc_camera/rj54n1cb0c.c                |  6 +++---
 drivers/media/i2c/soc_camera/tw9910.c                    |  6 +++---
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 13 +------------
 drivers/media/platform/soc_camera/soc_scale_crop.c       | 11 ++++++-----
 15 files changed, 47 insertions(+), 57 deletions(-)

Thanks
Guennadi
