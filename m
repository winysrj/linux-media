Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:56798 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab2HOOVc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 10:21:32 -0400
Date: Wed, 15 Aug 2012 16:20:48 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PULL] left-overs from old 3.6 pull, more to come
Message-ID: <Pine.LNX.4.64.1208151618180.4024@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

Below are patches, that I tried to push for 3.6, but that went missing. 
I'll also try to look through other my pending patches within the next 
couple of hours, so, there might be one or two more pull requests from me 
shortly.

The following changes since commit f1b1b85c7f85417d73d3b315f5df1e2730477c0f:

  tw9910: Don't access the device in the g_mbus_fmt operation (2012-07-20 16:13:24 +0200)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.6

Fabio Estevam (2):
      video: mx1_camera: Use clk_prepare_enable/clk_disable_unprepare
      video: mx2_camera: Use clk_prepare_enable/clk_disable_unprepare

Guennadi Liakhovetski (1):
      V4L: soc-camera: add selection API host operations

Javier Martin (2):
      media: mx2_camera: Fix mbus format handling
      media: mx2_camera: Add YUYV output format.

Laurent Pinchart (13):
      soc_camera: Don't call .s_power() during probe
      soc-camera: Continue the power off sequence if one of the steps fails
      soc-camera: Add and use soc_camera_power_[on|off]() helper functions
      soc-camera: Push probe-time power management to drivers
      ov772x: Fix memory leak in probe error path
      ov772x: Select the default format at probe time
      ov772x: Don't fail in s_fmt if the requested format isn't supported
      ov772x: try_fmt must not default to the current format
      ov772x: Make to_ov772x convert from v4l2_subdev to ov772x_priv
      ov772x: Add ov772x_read() and ov772x_write() functions
      ov772x: Add support for SBGGR10 format
      ov772x: Compute window size registers at runtime
      ov772x: Stop sensor readout right after reset

 drivers/media/video/imx074.c              |   30 ++-
 drivers/media/video/mt9m001.c             |   26 ++-
 drivers/media/video/mt9m111.c             |  116 +++++---
 drivers/media/video/mt9t031.c             |   48 ++--
 drivers/media/video/mt9t112.c             |   21 ++-
 drivers/media/video/mt9v022.c             |   14 +
 drivers/media/video/mx1_camera.c          |    4 +-
 drivers/media/video/mx2_camera.c          |   79 +++++-
 drivers/media/video/ov2640.c              |   20 ++-
 drivers/media/video/ov5642.c              |   31 ++-
 drivers/media/video/ov6650.c              |   28 ++-
 drivers/media/video/ov772x.c              |  447 +++++++++++++++--------------
 drivers/media/video/ov9640.c              |   27 ++-
 drivers/media/video/ov9740.c              |   47 ++-
 drivers/media/video/rj54n1cb0c.c          |   27 ++-
 drivers/media/video/soc_camera.c          |  166 +++++++----
 drivers/media/video/soc_camera_platform.c |   11 +-
 drivers/media/video/tw9910.c              |   21 ++-
 include/media/soc_camera.h                |   12 +
 19 files changed, 764 insertions(+), 411 deletions(-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
