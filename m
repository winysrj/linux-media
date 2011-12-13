Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46211 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab1LMNCP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Dec 2011 08:02:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-media@vger.kernel.org
Subject: [PATCH v5 0/3] fbdev: Add FOURCC-based format configuration API
Date: Tue, 13 Dec 2011 14:02:25 +0100
Message-Id: <1323781348-9884-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,
fbdev: Add FOURCC-based format configuration API
Here's the fifth version of the fbdev FOURCC-based format configuration API.

Compared to the fourth version,

- fb_set_var() now checks that the red, green, blue and transp fields are all
set to 0 when using the FOURCC-based API and return an error if they are not

- the NV24 and NV42 format documentation doesn't include emacs formatting
directives anymore.

As usual the fbdev-test tool supporting this new API is available in the
fbdev-test yuv branch at
http://git.ideasonboard.org/?p=fbdev-test.git;a=shortlog;h=refs/heads/yuv.

Laurent Pinchart (3):
  fbdev: Add FOURCC-based format configuration API
  v4l: Add V4L2_PIX_FMT_NV24 and V4L2_PIX_FMT_NV42 formats
  fbdev: sh_mobile_lcdc: Support FOURCC-based format API

 Documentation/DocBook/media/v4l/pixfmt-nv24.xml |  121 ++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml      |    1 +
 Documentation/fb/api.txt                        |  306 +++++++++++++++++++
 arch/arm/mach-shmobile/board-ag5evm.c           |    2 +-
 arch/arm/mach-shmobile/board-ap4evb.c           |    4 +-
 arch/arm/mach-shmobile/board-mackerel.c         |    4 +-
 arch/sh/boards/mach-ap325rxa/setup.c            |    2 +-
 arch/sh/boards/mach-ecovec24/setup.c            |    2 +-
 arch/sh/boards/mach-kfr2r09/setup.c             |    2 +-
 arch/sh/boards/mach-migor/setup.c               |    4 +-
 arch/sh/boards/mach-se/7724/setup.c             |    2 +-
 drivers/video/fbmem.c                           |   14 +
 drivers/video/sh_mobile_lcdcfb.c                |  360 +++++++++++++++--------
 include/linux/fb.h                              |   14 +-
 include/linux/videodev2.h                       |    2 +
 include/video/sh_mobile_lcdc.h                  |    4 +-
 16 files changed, 707 insertions(+), 137 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv24.xml
 create mode 100644 Documentation/fb/api.txt

-- 
Regards,

Laurent Pinchart

