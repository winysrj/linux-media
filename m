Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:56609 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab3FGOFe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 10:05:34 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id E4D4140BB6
	for <linux-media@vger.kernel.org>; Fri,  7 Jun 2013 16:05:32 +0200 (CEST)
Date: Fri, 7 Jun 2013 16:05:32 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera: 3.11 minor updates
Message-ID: <Pine.LNX.4.64.1306071604180.11277@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

These are just a couple of minor updates for 3.11:

The following changes since commit 7eac97d7e714429f7ef1ba5d35f94c07f4c34f8e:

  [media] media: pci: remove duplicate checks for EPERM (2013-05-27 09:34:56 -0300)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.11-1

Guennadi Liakhovetski (1):
      V4L2: soc-camera: remove unneeded include path

Paul Bolle (1):
      soc-camera: remove two unused configs

Sachin Kamat (6):
      soc_camera: Constify dev_pm_ops in mt9t031.c
      soc_camera: Fix checkpatch warning in ov9640.c
      soc_camera/sh_mobile_csi2: Remove redundant platform_set_drvdata()
      soc_camera_platform: Remove redundant platform_set_drvdata()
      soc_camera: mt9t112: Remove empty function
      soc_camera: tw9910: Remove empty function

Thomas Meyer (1):
      media: Cocci spatch "ptr_ret.spatch"

 drivers/media/i2c/soc_camera/mt9t031.c             |    2 +-
 drivers/media/i2c/soc_camera/mt9t112.c             |    6 ------
 drivers/media/i2c/soc_camera/ov9640.c              |    2 +-
 drivers/media/i2c/soc_camera/tw9910.c              |    6 ------
 drivers/media/platform/sh_veu.c                    |    5 +----
 drivers/media/platform/soc_camera/Kconfig          |    8 --------
 drivers/media/platform/soc_camera/Makefile         |    2 --
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |    8 +-------
 .../platform/soc_camera/soc_camera_platform.c      |   11 +----------
 9 files changed, 5 insertions(+), 45 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
