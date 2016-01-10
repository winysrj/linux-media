Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50611 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333AbcAJSet (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2016 13:34:49 -0500
Received: from axis700.grange ([87.79.216.87]) by mail.gmx.com (mrgmx001) with
 ESMTPSA (Nemesis) id 0LhOO8-1ZnNnr0HA0-00mYms for
 <linux-media@vger.kernel.org>; Sun, 10 Jan 2016 19:34:47 +0100
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id EFF3413EC9
	for <linux-media@vger.kernel.org>; Sun, 10 Jan 2016 19:34:45 +0100 (CET)
Date: Sun, 10 Jan 2016 19:34:45 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera: 3 4.6 patched
Message-ID: <Pine.LNX.4.64.1601101933060.24180@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please, pull 3 soc-camera patches for 4.6.

The following changes since commit 768acf46e1320d6c41ed1b7c4952bab41c1cde79:

  [media] rc: sunxi-cir: Initialize the spinlock properly (2015-12-23 15:51:40 -0200)

are available in the git repository at:

  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-4.6-1

for you to fetch changes up to 0ce5dc413ad3f2aac19349c0b7cf5e2fcffb38f1:

  soc_camera: constify v4l2_subdev_sensor_ops structures (2016-01-09 12:40:51 +0100)

----------------------------------------------------------------
Geliang Tang (1):
      sh_mobile_ceu_camera: use soc_camera_from_vb2q

Julia Lawall (1):
      soc_camera: constify v4l2_subdev_sensor_ops structures

Yoshihiko Mori (1):
      soc_camera: rcar_vin: Add R-Car Gen3 support

 Documentation/devicetree/bindings/media/rcar_vin.txt     |  1 +
 drivers/media/i2c/soc_camera/mt9m001.c                   |  2 +-
 drivers/media/i2c/soc_camera/mt9t031.c                   |  2 +-
 drivers/media/i2c/soc_camera/mt9v022.c                   |  2 +-
 drivers/media/platform/soc_camera/rcar_vin.c             |  2 ++
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 14 +++++---------
 6 files changed, 11 insertions(+), 12 deletions(-)

Thanks
Guennadi
