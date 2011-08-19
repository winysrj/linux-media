Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40599 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab1HSJhI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Aug 2011 05:37:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-media@vger.kernel.org, magnus.damm@gmail.com
Subject: [PATCH/RFC v2 0/3] fbdev: Add FOURCC-based format configuration API
Date: Fri, 19 Aug 2011 11:37:03 +0200
Message-Id: <1313746626-23845-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's the second version of the fbdev FOURCC-based format configuration API.

Compared to the previous version, I've removed the FB_VMODE_FOURCC bit (FOURCC
mode is now selected by a grayscale value > 1), reorganized the union in the
fb_var_screeninfo structure, and added a colorspace field used for YUV modes.

This patch set also contains an implementation of the FOURCC-based format API
for the sh_mobile_lcdc driver, based on top of the latest patches I've sent to
the list. You can find a consolidated version that includes this patch set at
http://git.linuxtv.org/pinchartl/fbdev.git/shortlog/refs/heads/fbdev-yuv.
YUV support when MERAM is enabled is currently broken, I'm working on fixing
that.

I've updated the fbdev-test tool to add FOURCC support. The code is available
in the fbdev-test yuv branch at
http://git.ideasonboard.org/?p=fbdev-test.git;a=shortlog;h=refs/heads/yuv.

Laurent Pinchart (3):
  fbdev: Add FOURCC-based format configuration API
  v4l: Add V4L2_PIX_FMT_NV24 and V4L2_PIX_FMT_NV42 formats
  fbdev: sh_mobile_lcdc: Support FOURCC-based format API

 Documentation/DocBook/media/v4l/pixfmt-nv24.xml |  128 +++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml      |    1 +
 Documentation/fb/api.txt                        |  299 ++++++++++++++++++++
 arch/arm/mach-shmobile/board-ag5evm.c           |    2 +-
 arch/arm/mach-shmobile/board-ap4evb.c           |    4 +-
 arch/arm/mach-shmobile/board-mackerel.c         |    4 +-
 drivers/video/sh_mobile_lcdcfb.c                |  342 +++++++++++++++--------
 include/linux/fb.h                              |   27 ++-
 include/linux/videodev2.h                       |    2 +
 include/video/sh_mobile_lcdc.h                  |    4 +-
 10 files changed, 681 insertions(+), 132 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv24.xml
 create mode 100644 Documentation/fb/api.txt

-- 
Regards,

Laurent Pinchart

