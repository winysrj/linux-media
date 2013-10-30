Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:50798 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab3J3RIs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Oct 2013 13:08:48 -0400
Date: Wed, 30 Oct 2013 18:08:43 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL v2] V4L2, soc-camera, em28xx: 3.13 fixes and improvements
In-Reply-To: <20131030091941.176f5686@infradead.org>
Message-ID: <Pine.LNX.4.64.1310301807060.18982@axis700.grange>
References: <Pine.LNX.4.64.1310282037500.31909@axis700.grange>
 <Pine.LNX.4.64.1310301012160.18982@axis700.grange> <20131030091941.176f5686@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 30 Oct 2013, Mauro Carvalho Chehab wrote:

> Em Wed, 30 Oct 2013 10:14:13 +0100 (CET)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:
> 
> > Hi Mauro
> > 
> > I'd like to add 2 more patches from other authors to my pull request for 
> > 3.13. Shall I add them to this branch before you have pulled it (I could 
> > also rebase it onto the current -next while at it), or shall I rather wait 
> > for you to pull and then issue a second pull request?
> 
> Well, as you have write permissions at patchwork, you can simply tag your
> previous pull request as superseded and send a new one.

Well, that would still leave a race window, but since now you know, here 
goes a v2:

The following changes since commit 3a94271d0798fe2a2e5bfe2d135f2c8f6db2e80b:

  Add linux-next specific files for 20131030 (2013-10-30 18:27:18 +1100)

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

Michael Opdenacker (1):
      sh_mobile_ceu_camera: remove deprecated IRQF_DISABLED

Valentine Barshak (1):
      media: rcar_vin: Add preliminary r8a7790 support

 drivers/media/i2c/soc_camera/imx074.c              |    4 +-
 drivers/media/platform/soc_camera/rcar_vin.c       |    5 ++-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    2 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   46 ++++++++++++--------
 drivers/media/usb/em28xx/em28xx-camera.c           |   42 ++++++++++++++----
 drivers/media/usb/em28xx/em28xx-cards.c            |    3 +
 drivers/media/usb/em28xx/em28xx.h                  |    1 +
 drivers/media/v4l2-core/v4l2-clk.c                 |   39 +++++++++++++++++
 include/media/soc_camera.h                         |   27 +++++++++---
 include/media/v4l2-clk.h                           |   17 +++++++
 include/media/v4l2-subdev.h                        |   17 ++++++-
 11 files changed, 164 insertions(+), 39 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
