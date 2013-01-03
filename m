Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:50011 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab3ACRQk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 12:16:40 -0500
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 30D1040B98
	for <linux-media@vger.kernel.org>; Thu,  3 Jan 2013 18:16:38 +0100 (CET)
Date: Thu, 3 Jan 2013 18:16:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] soc-camera take 1 for 3.9
Message-ID: <Pine.LNX.4.64.1301031731090.17494@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

We're moving ever closer to asynchronous probing and DT:-) This pull 
request includes several fixes for our 3.9 stack (3.8 is ok), the removal 
of i.MX25 support (at last!), some more preparation for asynchronous 
probing. I'm not including v4l2-clk and v4l2-async (and soc-camera porting 
on top of them) in this pull request yet, let's wait a bit more for any 
comments.

What concerns patchwork IDs, you requested lines in this form:

pwclient -u 'accepted' 15727
pwclient -u 'accepted' 15988
pwclient -u 'accepted' 15989
pwclient -u 'accepted' 15990
pwclient -u 'accepted' 15991
pwclient -u 'accepted' 15992
pwclient -u 'accepted' 15297
pwclient -u 'accepted' 15299
pwclient -u 'accepted' 15300
pwclient -u 'accepted' 15760

whereas my version of pwclient seems to suggest, that that should be 
"pwclient update -s Accepted <ID>," but I'll use your requested form in 
case you've got a different version;-)

My branch is based on current next, because I needed patches, that went 
via other trees... And the patches:

The following changes since commit 3696068e4e1231311b07e5c312876deec182f18b:

  Add linux-next specific files for 20130103 (2013-01-03 14:24:37 +1100)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.9

Fabio Estevam (1):
      mx2_camera: Convert it to platform driver

Guennadi Liakhovetski (5):
      soc-camera: properly fix camera probing races
      soc-camera: fix repeated regulator requesting
      soc-camera: remove struct soc_camera_device::video_lock
      soc-camera: split struct soc_camera_link into host and subdevice parts
      soc-camera: use devm_kzalloc in subdevice drivers

Javier Martin (3):
      mx2_camera: Remove i.mx25 support.
      mx2_camera: Remove 'buf_cleanup' callback.
      mx2_camera: Remove buffer states.

Wei Yongjun (1):
      mt9v022: fix potential NULL pointer dereference in mt9v022_probe()

 drivers/media/i2c/soc_camera/imx074.c              |   27 +-
 drivers/media/i2c/soc_camera/mt9m001.c             |   52 +--
 drivers/media/i2c/soc_camera/mt9m111.c             |   36 +-
 drivers/media/i2c/soc_camera/mt9t031.c             |   36 +-
 drivers/media/i2c/soc_camera/mt9t112.c             |   27 +-
 drivers/media/i2c/soc_camera/mt9v022.c             |   45 +-
 drivers/media/i2c/soc_camera/ov2640.c              |   29 +-
 drivers/media/i2c/soc_camera/ov5642.c              |   31 +-
 drivers/media/i2c/soc_camera/ov6650.c              |   30 +-
 drivers/media/i2c/soc_camera/ov772x.c              |   36 +-
 drivers/media/i2c/soc_camera/ov9640.c              |   27 +-
 drivers/media/i2c/soc_camera/ov9740.c              |   29 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c          |   39 +-
 drivers/media/i2c/soc_camera/tw9910.c              |   30 +-
 drivers/media/platform/soc_camera/Kconfig          |    7 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |    4 +-
 drivers/media/platform/soc_camera/mx1_camera.c     |    3 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |  531 ++++----------------
 drivers/media/platform/soc_camera/mx3_camera.c     |    4 +-
 drivers/media/platform/soc_camera/omap1_camera.c   |    4 +-
 drivers/media/platform/soc_camera/pxa_camera.c     |    6 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |    4 +-
 drivers/media/platform/soc_camera/soc_camera.c     |  167 ++++---
 .../platform/soc_camera/soc_camera_platform.c      |    6 +-
 include/media/soc_camera.h                         |  107 +++-
 include/media/soc_camera_platform.h                |   10 +-
 26 files changed, 498 insertions(+), 829 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
