Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:57951 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934280Ab3HHO4R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 10:56:17 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 0/6] V4L2: soc-camera: more asynchronous conversions
Date: Thu,  8 Aug 2013 16:52:31 +0200
Message-Id: <1375973557-23333-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set converts the mx3-camera host and the mt9m111 sensor drivers 
to asynchronous probing. Also an Oops in the mt9t031 driver is fixed for 
the case, where an asynchronous probing is attempted.

Guennadi Liakhovetski (6):
  V4L2: soc-camera: fix requesting regulators in synchronous case
  V4L2: mx3_camera: convert to managed resource allocation
  V4L2: mx3_camera: print V4L2_MBUS_FMT_* codes in hexadecimal format
  V4L2: mx3_camera: add support for asynchronous subdevice registration
  V4L2: mt9t031: don't Oops if asynchronous probing is attempted
  V4L2: mt9m111: switch to asynchronous subdevice probing

 drivers/media/i2c/soc_camera/mt9m111.c         |   38 +++++++++----
 drivers/media/i2c/soc_camera/mt9t031.c         |    7 ++-
 drivers/media/platform/soc_camera/mx3_camera.c |   67 +++++++++---------------
 drivers/media/platform/soc_camera/soc_camera.c |   33 ++++++++++--
 include/linux/platform_data/camera-mx3.h       |    4 ++
 5 files changed, 87 insertions(+), 62 deletions(-)

-- 
1.7.2.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
