Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57668 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab1K2K0z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 05:26:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-media@vger.kernel.org
Subject: [PATCH v4 0/3] fbdev: Add FOURCC-based format configuration API
Date: Tue, 29 Nov 2011 11:26:56 +0100
Message-Id: <1322562419-9934-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here's the fourth version of the fbdev FOURCC-based format configuration API.

The third version nearly got merged, but we noticed that gcc choked on
anonymous union initializers. This has been fixed in gcc 4.6, but I don't have
the power to force Linux to set the base gcc version to 4.6 :-)

There were two ways to fix the issue, neither of which was particularly
attractive to me. The first one involved a 10k lines patch that modified all
the drivers, and the second one required using one of the reserved fields in
the fb_var_screeninfo structure. After discussing this with Florian, I've
decided to go for the second fix.

The colorspace field is thus now stored in a previously reserved field. The
fourcc field is still shared with the grayscale field, but doesn't have its
own name anymore.

I've updated the fbdev-test tool to this new API. The code is available in the
fbdev-test yuv branch at
http://git.ideasonboard.org/?p=fbdev-test.git;a=shortlog;h=refs/heads/yuv.

Laurent Pinchart (3):
  fbdev: Add FOURCC-based format configuration API
  v4l: Add V4L2_PIX_FMT_NV24 and V4L2_PIX_FMT_NV42 formats
  fbdev: sh_mobile_lcdc: Support FOURCC-based format API

 Documentation/DocBook/media/v4l/pixfmt-nv24.xml |  129 ++++++++
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
 drivers/video/sh_mobile_lcdcfb.c                |  360 +++++++++++++++--------
 include/linux/fb.h                              |   14 +-
 include/linux/videodev2.h                       |    2 +
 include/video/sh_mobile_lcdc.h                  |    4 +-
 15 files changed, 701 insertions(+), 137 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv24.xml
 create mode 100644 Documentation/fb/api.txt

-- 
Regards,

Laurent Pinchart

