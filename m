Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40786 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1DLN1z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 09:27:55 -0400
Received: from lancelot.localnet (unknown [91.178.195.68])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 1D82035999
	for <linux-media@vger.kernel.org>; Tue, 12 Apr 2011 13:27:52 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR 2.6.39] MC, V4L2 and OMAP3 ISP fixes
Date: Tue, 12 Apr 2011 15:28:00 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104121528.00908.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

The following changes since commit 28df73703e738d8ae7a958350f74b08b2e9fe9ed:

  [media] xc5000: Improve it to work better with 6MHz-spaced channels 
(2011-03-28 15:49:28 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/media.git omap3isp-next-omap3isp

Those changes are either bug fixes (MC, V4L2 and OMAP3 ISP) or small 
enhancements to the OMAP3 ISP driver ('omap3isp: ccdc: support Y10/12, 8-bit 
bayer fmts' and 'omap3isp: lane shifter support'). The later won't cause any 
regression, as the OMAP3 ISP driver will appear in 2.6.39 for the first time.

David Cohen (1):
      omap3isp: stat: update struct ispstat_generic_config's comments

Laurent Pinchart (8):
      media: Use correct ioctl name in MEDIA_IOC_SETUP_LINK documentation
      omap3isp: resizer: Center the crop rectangle
      omap3isp: resizer: Use 4-tap mode equations when the ratio is <= 512
      media: Properly handle link flags in link setup, link notify callback
      omap3isp: isp: Reset the ISP when the pipeline can't be stopped
      omap3isp: Don't increment node entity use count when poweron fails
      v4l: Don't register media entities for subdev device nodes
      omap3isp: queue: Don't corrupt buf->npages when get_user_pages() fails

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
 drivers/media/video/omap3isp/isp.c                 |   38 +++++--
 drivers/media/video/omap3isp/isp.h                 |   12 +-
 drivers/media/video/omap3isp/ispccdc.c             |   37 ++++++--
 drivers/media/video/omap3isp/isppreview.c          |    2 +-
 drivers/media/video/omap3isp/ispqueue.c            |    6 +-
 drivers/media/video/omap3isp/ispresizer.c          |   75 +++++++++++---
 drivers/media/video/omap3isp/ispstat.h             |    6 +-
 drivers/media/video/omap3isp/ispvideo.c            |  108 ++++++++++++++++---
 drivers/media/video/omap3isp/ispvideo.h            |    3 +
 drivers/media/video/v4l2-dev.c                     |   15 ++-
 include/linux/v4l2-mediabus.h                      |    7 +-
 include/linux/videodev2.h                          |    1 +
 18 files changed, 390 insertions(+), 70 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/pixfmt-y12.xml

-- 
Regards,

Laurent Pinchart
