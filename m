Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43018 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab1DEH5L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 03:57:11 -0400
Received: from localhost.localdomain (unknown [91.178.236.143])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id EAF0435994
	for <linux-media@vger.kernel.org>; Tue,  5 Apr 2011 07:57:09 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 00/14] OMAP3 ISP and media controller patches for 2.6.39
Date: Tue,  5 Apr 2011 09:57:22 +0200
Message-Id: <1301990256-6963-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everybody,

Here's a set of OMAP3 ISP patches for 2.6.39, including two media controller
patches and a V4L2 core patch.

Most of those patches fix code and documentation. Patches 10/14 to 13/14
implement lane shifter support in the OMAP3 ISP driver. That's a new feature,
but there's no risk of regression from 2.6.38 as the OMAP3 ISP driver has been
merged into 2.6.39-r1.

I'll send a pull request at the end of the week if there's no comment on the
patches.

David Cohen (1):
  omap3isp: stat: update struct ispstat_generic_config's comments

Laurent Pinchart (6):
  media: Use correct ioctl name in MEDIA_IOC_SETUP_LINK documentation
  omap3isp: resizer: Center the crop rectangle
  omap3isp: resizer: Use 4-tap mode equations when the ratio is <= 512
  media: Properly handle link flags in link setup, link notify callback
  omap3isp: isp: Reset the ISP when the pipeline can't be stopped
  omap3isp: Don't increment node entity use count when poweron fails

Michael Jones (5):
  omap3isp: Fix trivial typos
  v4l: add V4L2_PIX_FMT_Y12 format
  media: add missing 8-bit bayer formats and Y12
  omap3isp: ccdc: support Y10/12, 8-bit bayer fmts
  omap3isp: lane shifter support

Sakari Ailus (1):
  omap3isp: resizer: Improved resizer rsz factor formula

Stanimir Varbanov (1):
  omap3isp: Use isp xclk defines

 Documentation/DocBook/media-entities.tmpl          |    1 +
 Documentation/DocBook/v4l/media-ioc-setup-link.xml |    2 +-
 Documentation/DocBook/v4l/pixfmt-y12.xml           |   79 ++++++++++++++
 Documentation/DocBook/v4l/pixfmt.xml               |    1 +
 Documentation/DocBook/v4l/subdev-formats.xml       |   59 +++++++++++
 drivers/media/media-entity.c                       |    8 +-
 drivers/media/video/omap3isp/isp.c                 |   39 +++++--
 drivers/media/video/omap3isp/isp.h                 |   12 +-
 drivers/media/video/omap3isp/ispccdc.c             |   37 ++++++--
 drivers/media/video/omap3isp/isppreview.c          |    2 +-
 drivers/media/video/omap3isp/ispqueue.c            |    4 +-
 drivers/media/video/omap3isp/ispresizer.c          |   75 +++++++++++---
 drivers/media/video/omap3isp/ispstat.h             |    6 +-
 drivers/media/video/omap3isp/ispvideo.c            |  108 +++++++++++++++++---
 drivers/media/video/omap3isp/ispvideo.h            |    3 +
 include/linux/v4l2-mediabus.h                      |    7 +-
 include/linux/videodev2.h                          |    1 +
 17 files changed, 380 insertions(+), 64 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/pixfmt-y12.xml

-- 
Regards,

Laurent Pinchart

