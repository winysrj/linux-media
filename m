Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60201 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1HaLRy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 07:17:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-media@vger.kernel.org, magnus.damm@gmail.com
Subject: [PATCH v3 0/3] fbdev: Add FOURCC-based format configuration API
Date: Wed, 31 Aug 2011 13:18:18 +0200
Message-Id: <1314789501-824-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's the third version of the fbdev FOURCC-based format configuration API.

Compared to the previous version, I've added an FB_TYPE_FOURCC in addition to
FB_VISUAL_FOURCC, fixed the documentation (thanks to Geert for reviewing it
and explaining how fbdev bitplanes work) and fixed bugs in the sh_mobile_lcdc
YUV support.

The sb_mobile_lcdc patch applies on top of the latest patches that I've sent
to the list. You can find a consolidated version that includes this patch set
at http://git.linuxtv.org/pinchartl/fbdev.git/shortlog/refs/heads/fbdev-yuv.

I've updated the fbdev-test tool to add FOURCC support. The code is available
in the fbdev-test yuv branch at
http://git.ideasonboard.org/?p=fbdev-test.git;a=shortlog;h=refs/heads/yuv.

Laurent Pinchart (3):
  fbdev: Add FOURCC-based format configuration API
  v4l: Add V4L2_PIX_FMT_NV24 and V4L2_PIX_FMT_NV42 formats
  fbdev: sh_mobile_lcdc: Support FOURCC-based format API

 Documentation/DocBook/media/v4l/pixfmt-nv24.xml |  129 ++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml      |    1 +
 Documentation/fb/api.txt                        |  317 ++++++++++++++++++++
 arch/arm/mach-shmobile/board-ag5evm.c           |    2 +-
 arch/arm/mach-shmobile/board-ap4evb.c           |    4 +-
 arch/arm/mach-shmobile/board-mackerel.c         |    4 +-
 arch/sh/boards/mach-ap325rxa/setup.c            |    2 +-
 arch/sh/boards/mach-ecovec24/setup.c            |    2 +-
 arch/sh/boards/mach-kfr2r09/setup.c             |    2 +-
 arch/sh/boards/mach-migor/setup.c               |    4 +-
 arch/sh/boards/mach-se/7724/setup.c             |    2 +-
 drivers/video/sh_mobile_lcdcfb.c                |  362 +++++++++++++++--------
 include/linux/fb.h                              |   28 ++-
 include/linux/videodev2.h                       |    2 +
 include/video/sh_mobile_lcdc.h                  |    4 +-
 15 files changed, 726 insertions(+), 139 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv24.xml
 create mode 100644 Documentation/fb/api.txt

-- 
Regards,

Laurent Pinchart
