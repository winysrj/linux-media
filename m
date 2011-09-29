Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:64836 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191Ab1I2QTD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 12:19:03 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH 0/9] Media Controller for soc-camera
Date: Thu, 29 Sep 2011 18:18:48 +0200
Message-Id: <1317313137-4403-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the first attempt at extending soc-camera with Media Controller / 
pad-level APIs. Yes, I know, that Laurent wasn't quite happy with "V4L: 
add convenience macros to the subdevice / Media Controller API," maybe 
we'll remove it eventually, but so far my patches use it, so, I kept it 
for now. The general idea has been described in

http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/38083

In short: soc-camera implements a media controller device and two entities 
per camera host (bridge) instance, linked statically to each other and to 
the client. The host driver gets a chance to implement "local" only 
configuration, as opposed to the standard soc-camera way of propagating the 
configuration up the pipeline to the client (sensor / decoder) driver. An 
example implementation is provided for sh_mobile_ceu_camera and two sensor 
drivers. The whole machinery gets activated if the soc-camera core finds a 
client driver, that implements pad operations. In that case both the 
"standard" (V4L2) and the "new" (MC) ways of addressing the driver become 
available. I.e., it is possible to run both standard V4L2 applications and 
MC-aware ones.

Of course, applies on top of

git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.2

Deepthy: this is what I told you about in

http://article.gmane.org/gmane.linux.ports.arm.omap/64847

it just took me a bit longer, than I thought.

Guennadi Liakhovetski (9):
  V4L: soc-camera: add a function to lookup xlate by mediabus code
  sh_mobile_ceu_camera: simplify scaling and cropping algorithms
  V4L: soc-camera: remove redundant parameter from the .set_bus_param()
    method
  V4L: add convenience macros to the subdevice / Media Controller API
  V4L: soc-camera: move bus parameter configuration to
    .vidioc_streamon()
  V4L: soc-camera: prepare hooks for Media Controller wrapper
  V4L: soc-camera: add a Media Controller wrapper
  V4L: mt9t112: add pad level operations
  V4L: imx074: add pad level operations

 drivers/media/video/Makefile               |    6 +-
 drivers/media/video/atmel-isi.c            |   12 +-
 drivers/media/video/imx074.c               |   85 +++-
 drivers/media/video/mt9t112.c              |   97 +++-
 drivers/media/video/mx1_camera.c           |   12 +-
 drivers/media/video/mx2_camera.c           |   13 +-
 drivers/media/video/mx3_camera.c           |   13 +-
 drivers/media/video/omap1_camera.c         |   16 +-
 drivers/media/video/pxa_camera.c           |   13 +-
 drivers/media/video/sh_mobile_ceu_camera.c |  904 +++++++++++-----------------
 drivers/media/video/soc_camera.c           |  157 ++++-
 drivers/media/video/soc_entity.c           |  284 +++++++++
 drivers/media/video/soc_mediabus.c         |   16 -
 include/media/soc_camera.h                 |   34 +-
 include/media/soc_entity.h                 |   31 +
 include/media/v4l2-subdev.h                |   11 +
 16 files changed, 1064 insertions(+), 640 deletions(-)
 create mode 100644 drivers/media/video/soc_entity.c
 create mode 100644 include/media/soc_entity.h

-- 
1.7.2.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
