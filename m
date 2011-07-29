Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:52449 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id CF35F189B6D
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:56:59 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkV-0007mx-My
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:56:59 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 00/59] Convert soc-camera to .[gs]_mbus_config() subdev operations
Date: Fri, 29 Jul 2011 12:56:00 +0200
Message-Id: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch-series converts all soc-camera client and host drivers and the 
core from soc-camera specific .{query,set}_bus_param() operations to the 
new .[gs]_mbus_config() subdev operations. In order to prevent bisect 
breakage we first have to only add new methods to client drivers, then 
convert all host drivers, taking care to preserve platform compatibility, 
and only then soc-camera methods can be removed. These patches are also 
available as a git branch:

git://linuxtv.org/gliakhovetski/v4l-dvb.git mbus-config

Tested on i.MX31, PXA270, SuperH, mach-shmobile. Compile-tested on many 
others. Reviews and tests welcome!:-)

Sorry for a slightly longish set;-)

Thanks
Guennadi

Guennadi Liakhovetski (59):
  V4L: sh_mobile_ceu_camera: output image sizes must be a multiple of 4
  V4L: sh_mobile_ceu_camera: don't try to improve client scaling, if
    perfect
  V4L: sh_mobile_ceu_camera: fix field addresses in interleaved mode
  V4L: sh_mobile_ceu_camera: remove duplicated code
  V4L: imx074: support the new mbus-config subdev ops
  V4L: soc-camera: add helper functions for new bus configuration type
  V4L: mt9m001: support the new mbus-config subdev ops
  V4L: mt9m111: support the new mbus-config subdev ops
  V4L: mt9t031: support the new mbus-config subdev ops
  V4L: mt9t112: support the new mbus-config subdev ops
  V4L: mt9v022: support the new mbus-config subdev ops
  V4L: ov2640: support the new mbus-config subdev ops
  V4L: ov5642: support the new mbus-config subdev ops
  V4L: ov6650: support the new mbus-config subdev ops
  V4L: ov772x: rename macros to not pollute the global namespace
  V4L: ov772x: support the new mbus-config subdev ops
  V4L: ov9640: support the new mbus-config subdev ops
  V4L: ov9740: support the new mbus-config subdev ops
  V4L: rj54n1cb0c: support the new mbus-config subdev ops
  ARM: ap4evb: switch imx074 configuration to default number of lanes
  V4L: sh_mobile_csi2: verify client compatibility
  V4L: sh_mobile_csi2: support the new mbus-config subdev ops
  V4L: tw9910: remove a not really implemented cropping support
  V4L: tw9910: support the new mbus-config subdev ops
  V4L: soc_camera_platform: support the new mbus-config subdev ops
  V4L: soc-camera: compatible bus-width flags
  ARM: mach-shmobile: convert mackerel to mediabus flags
  sh: convert ap325rxa to mediabus flags
  ARM: PXA: use gpio_set_value_cansleep() on pcm990
  V4L: atmel-isi: convert to the new mbus-config subdev operations
  V4L: mx1_camera: convert to the new mbus-config subdev operations
  V4L: mx2_camera: convert to the new mbus-config subdev operations
  V4L: ov2640: remove undefined struct
  V4L: mx3_camera: convert to the new mbus-config subdev operations
  V4L: mt9m001, mt9v022: add a clarifying comment
  V4L: omap1_camera: convert to the new mbus-config subdev operations
  V4L: pxa_camera: convert to the new mbus-config subdev operations
  V4L: sh_mobile_ceu_camera: convert to the new mbus-config subdev
    operations
  V4L: soc-camera: camera client operations no longer compulsory
  V4L: mt9m001: remove superfluous soc-camera client operations
  V4L: mt9m111: remove superfluous soc-camera client operations
  V4L: imx074: remove superfluous soc-camera client operations
  V4L: mt9t031: remove superfluous soc-camera client operations
  V4L: mt9t112: remove superfluous soc-camera client operations
  V4L: mt9v022: remove superfluous soc-camera client operations
  V4L: ov2640: remove superfluous soc-camera client operations
  V4L: ov5642: remove superfluous soc-camera client operations
  V4L: ov6650: remove superfluous soc-camera client operations
  sh: ap3rxa: remove redundant soc-camera platform data fields
  sh: migor: remove unused ov772x buswidth flag
  V4L: ov772x: remove superfluous soc-camera client operations
  V4L: ov9640: remove superfluous soc-camera client operations
  V4L: ov9740: remove superfluous soc-camera client operations
  V4L: rj54n1cb0c: remove superfluous soc-camera client operations
  V4L: sh_mobile_csi2: remove superfluous soc-camera client operations
  ARM: mach-shmobile: mackerel doesn't need legacy SOCAM_* flags
    anymore
  V4L: soc_camera_platform: remove superfluous soc-camera client
    operations
  V4L: tw9910: remove superfluous soc-camera client operations
  V4L: soc-camera: remove soc-camera client bus-param operations and
    supporting code

 arch/arm/mach-pxa/pcm990-baseboard.c       |    4 +-
 arch/arm/mach-shmobile/board-ap4evb.c      |    2 +-
 arch/arm/mach-shmobile/board-mackerel.c    |    7 +-
 arch/sh/boards/mach-ap325rxa/setup.c       |   10 +-
 arch/sh/boards/mach-migor/setup.c          |    4 +-
 drivers/media/video/atmel-isi.c            |  136 ++++++++-------
 drivers/media/video/imx074.c               |   36 ++---
 drivers/media/video/mt9m001.c              |   87 +++++-----
 drivers/media/video/mt9m111.c              |   37 ++--
 drivers/media/video/mt9t031.c              |   64 ++++----
 drivers/media/video/mt9t112.c              |  115 ++++---------
 drivers/media/video/mt9v022.c              |  156 +++++++++--------
 drivers/media/video/mx1_camera.c           |   71 +++++---
 drivers/media/video/mx2_camera.c           |   78 +++++----
 drivers/media/video/mx3_camera.c           |  197 ++++++++++------------
 drivers/media/video/omap1_camera.c         |   52 ++++--
 drivers/media/video/ov2640.c               |   65 +++-----
 drivers/media/video/ov5642.c               |   36 ++---
 drivers/media/video/ov6650.c               |  103 ++++++------
 drivers/media/video/ov772x.c               |   57 +++----
 drivers/media/video/ov9640.c               |   50 +++---
 drivers/media/video/ov9740.c               |   55 +++---
 drivers/media/video/pxa_camera.c           |  140 +++++++++-------
 drivers/media/video/rj54n1cb0c.c           |   61 ++++---
 drivers/media/video/sh_mobile_ceu_camera.c |  254 ++++++++++++++++------------
 drivers/media/video/sh_mobile_csi2.c       |  116 +++++++++----
 drivers/media/video/soc_camera.c           |   40 ++---
 drivers/media/video/soc_camera_platform.c  |   43 ++----
 drivers/media/video/soc_mediabus.c         |   33 ++++
 drivers/media/video/tw9910.c               |  225 ++++++++++--------------
 include/media/ov772x.h                     |   26 ++--
 include/media/soc_camera.h                 |   58 ++-----
 include/media/soc_camera_platform.h        |    4 +-
 include/media/soc_mediabus.h               |    2 +
 34 files changed, 1211 insertions(+), 1213 deletions(-)

-- 
1.7.2.5

