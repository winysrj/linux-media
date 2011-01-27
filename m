Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59831 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab1A0MbW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 07:31:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v1 0/8] Misc V4L2 patches for the OMAP3 ISP driver
Date: Thu, 27 Jan 2011 13:31:04 +0100
Message-Id: <1296131472-30045-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everybody,

Here are eight miscellaneous patches to the V4L2 core that are required by the
OMAP3 ISP driver. They mostly add new format codes, as well as a new subdev
sensor operation.

The "v4l: Fix a use-before-set in the control framework" and
"v4l: Add subdev sensor g_skip_frames operation" patches have been discussed
on the linux-media mailing list and acked.

The patches are based on top of 2.6.37.

Laurent Pinchart (8):
  v4l: subdev: Generic ioctl support
  v4l: Add subdev sensor g_skip_frames operation
  v4l: Include linux/videodev2.h in media/v4l2-ctrls.h
  v4l: Fix a use-before-set in the control framework
  v4l: Add 8-bit YUYV on 16-bit bus and SGRBG10 media bus pixel codes
  v4l: Add remaining RAW10 patterns w DPCM pixel code variants
  v4l: Add missing 12 bits bayer media bus formats
  v4l: Add 12 bits bayer pixel formats

 Documentation/DocBook/v4l/subdev-formats.xml |   51 ++++++++++++++++++++++++++
 Documentation/video4linux/v4l2-framework.txt |    5 +++
 drivers/media/video/v4l2-ctrls.c             |    2 +-
 drivers/media/video/v4l2-subdev.c            |    2 +-
 include/linux/v4l2-mediabus.h                |   18 ++++++++-
 include/linux/videodev2.h                    |    4 ++
 include/media/v4l2-ctrls.h                   |    1 +
 include/media/v4l2-subdev.h                  |    4 ++
 8 files changed, 83 insertions(+), 4 deletions(-)

-- 
Regards,

Laurent Pinchart

