Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35315 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbcGOQNY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 12:13:24 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v2 0/6] Add HSV format
Date: Fri, 15 Jul 2016 18:13:13 +0200
Message-Id: <1468599199-5902-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HSV formats are extremely useful for image segmentation. This set of
patches makes v4l2 aware of this kind of formats.

Vivid changes have been divided in three to ease the reviewing process.

We are working on patches for Gstreamer and OpenCV that will make use
of these formats.

Thanks!

Changelog
v2: Suggested by Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
-Rebase on top of docs-next (port documentation to .rst)
@mchehab, You were right, there was no conflict after the rebase, Thanks!

Ricardo Ribalda Delgado (6):
  [media] videodev2.h Add HSV formats
  [media] Documentation: Add HSV format
  [media] Documentation: Add Ricardo Ribalda
  [media] vivid: code refactor for color representation
  [media] vivid: Add support for HSV formats
  [media] vivid: Rename variable

 Documentation/media/uapi/v4l/hsv-formats.rst       |  19 ++
 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst | 253 +++++++++++++++
 Documentation/media/uapi/v4l/pixfmt.rst            |   1 +
 Documentation/media/uapi/v4l/v4l2.rst              |   9 +
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      | 341 ++++++++++++++-------
 drivers/media/platform/vivid/vivid-core.h          |   2 +-
 drivers/media/platform/vivid/vivid-vid-common.c    |  66 ++--
 drivers/media/v4l2-core/v4l2-ioctl.c               |   2 +
 include/media/v4l2-tpg.h                           |   8 +-
 include/uapi/linux/videodev2.h                     |   4 +
 10 files changed, 558 insertions(+), 147 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/hsv-formats.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst

-- 
2.8.1

