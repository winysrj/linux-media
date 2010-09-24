Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:41967 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753213Ab0IXJNw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 05:13:52 -0400
Date: Fri, 24 Sep 2010 11:14:01 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PULL] soc-camera: for-2.6.37 #1
Message-ID: <Pine.LNX.4.64.1009241101530.14966@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

Here's the first lot of soc-camera and related patches for 2.6.37. Please 
notice, that my patch "V4L2: add a generic function to find the nearest 
discrete format to the required one" has not reached a consensus in point 
of metrics used, but since there have been no definitive argument in 
favour of one of them or another, I'd propose to use the one in my patch 
for now as the simplest and lightest in terms of required processing 
power.

I'm still hoping to get a couple more patches in 2.6.37 with my next pull 
request: the OMAP1 patch-set from Janusz Krzysztofik, a new sensor driver 
for imx074, and hopefully a new (final) version of the mt9m111 / mt9m131 
patch from Michael Grzeschik with new supported formats.

The following changes since commit 48f1bba604f1a5a312368bad822d2c03198a3ec3:

  V4L/DVB: IR/lirc_dev: check for valid irctl in unregister path (2010-09-23 11:34:50 -0300)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-2.6.37

Baruch Siach (2):
      mx2_camera: fix comment typo
      mx2_camera: implement forced termination of active buffer for mx25

Guennadi Liakhovetski (2):
      V4L2: add a generic function to find the nearest discrete format to the required one
      soc-camera: allow only one video queue per device

Michael Grzeschik (3):
      mt9m111: register cleanup hex to dec bitoffset
      mx2_camera: remove emma limitation for RGB565
      mx2_camera: add informative camera clock frequency printout

 drivers/media/video/mt9m111.c              |   16 ++--
 drivers/media/video/mx1_camera.c           |    8 +-
 drivers/media/video/mx2_camera.c           |   40 ++++---
 drivers/media/video/mx3_camera.c           |    6 +-
 drivers/media/video/pxa_camera.c           |    8 +-
 drivers/media/video/sh_mobile_ceu_camera.c |    8 +-
 drivers/media/video/soc_camera.c           |  178 ++++++++++++++--------------
 drivers/media/video/v4l2-common.c          |   24 ++++
 include/linux/videodev2.h                  |    8 ++
 include/media/soc_camera.h                 |    9 +-
 10 files changed, 172 insertions(+), 133 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
