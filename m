Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:50472 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab3J1Tmi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Oct 2013 15:42:38 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id AF87E13EC9
	for <linux-media@vger.kernel.org>; Mon, 28 Oct 2013 20:42:36 +0100 (CET)
Date: Mon, 28 Oct 2013 20:42:36 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] V4L2, soc-camera, em28xx: 3.13 fixes and improvements
Message-ID: <Pine.LNX.4.64.1310282037500.31909@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

As agreed a couple of days ago, here go several general V4L2 patches, 
posted at vatious times with no objections, and patches, aiming at fixing 
the current em28xx+ov2640 breakage. After you pull them I'll have to 
remember to change their status in patchwork too...

The following changes since commit 9e11bce4d7065aa826a953936149e182e018a3df:

  Add linux-next specific files for 20131025 (2013-10-25 17:07:05 +0200)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.13-1

Guennadi Liakhovetski (9):
      V4L2: (cosmetic) remove redundant use of unlikely()
      imx074: fix error handling for failed async subdevice registration
      V4L2: add a common V4L2 subdevice platform data type
      soc-camera: switch to using the new struct v4l2_subdev_platform_data
      V4L2: add v4l2-clock helpers to register and unregister a fixed-rate clock
      V4L2: add a v4l2-clk helper macro to produce an I2C device ID
      V4L2: em28xx: register a V4L2 clock source
      V4L2: soc-camera: work around unbalanced calls to .s_power()
      V4L2: em28xx: tell the ov2640 driver to balance clock enabling internally

 drivers/media/i2c/soc_camera/imx074.c          |    4 ++-
 drivers/media/platform/soc_camera/soc_camera.c |   46 ++++++++++++++---------
 drivers/media/usb/em28xx/em28xx-camera.c       |   42 ++++++++++++++++-----
 drivers/media/usb/em28xx/em28xx-cards.c        |    3 ++
 drivers/media/usb/em28xx/em28xx.h              |    1 +
 drivers/media/v4l2-core/v4l2-clk.c             |   39 ++++++++++++++++++++
 include/media/soc_camera.h                     |   27 +++++++++++---
 include/media/v4l2-clk.h                       |   17 +++++++++
 include/media/v4l2-subdev.h                    |   17 ++++++++-
 9 files changed, 159 insertions(+), 37 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
