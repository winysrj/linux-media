Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:36552 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbcGPKmE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 06:42:04 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Antti Palosaari <crope@iki.fi>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v3 0/9] Add HSV format
Date: Sat, 16 Jul 2016 12:41:47 +0200
Message-Id: <1468665716-10178-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HSV formats are extremely useful for image segmentation. This set of
patches makes v4l2 aware of this kind of formats.

Vivid changes have been divided to ease the reviewing process.

We are working on patches for Gstreamer and OpenCV that will make use
of these formats.

We still need to decide if and how we will support HUE range 0-255


Changelog:
v3:  Fix wrong handling of some YUV formats when brightness != 128

Suggested by Laurent Pinchart <laurent.pinchart@ideasonboard.com>
-Remove unneeded empty lines on .rst file
Thanks!

Suggested by Hans Verkuil <hverkuil@xs4all.nl>
-Rebase over master and docs-next
-Introduce TPG_COLOR_ENC_LUMA for gray formats
-CodeStyle
Thanks!

v2: Suggested by Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
-Rebase on top of docs-next (port documentation to .rst)

Ricardo Ribalda Delgado (9):
  [media] videodev2.h Add HSV formats
  [media] Documentation: Add HSV format
  [media] Documentation: Add Ricardo Ribalda
  [media] vivid: code refactor for color encoding
  [media] vivid: Add support for HSV formats
  [media] vivid: Rename variable
  [media] vivid: Introduce TPG_COLOR_ENC_LUMA
  [media] vivid: Fix YUV555 and YUV565 handling
  [media] vivid: Local optimization

 Documentation/media/uapi/v4l/hsv-formats.rst       |  19 +
 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst | 158 ++++++++
 Documentation/media/uapi/v4l/pixfmt.rst            |   1 +
 Documentation/media/uapi/v4l/v4l2.rst              |   9 +
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c      | 399 +++++++++++++--------
 drivers/media/platform/vivid/vivid-core.h          |   2 +-
 drivers/media/platform/vivid/vivid-vid-common.c    |  66 ++--
 drivers/media/v4l2-core/v4l2-ioctl.c               |   2 +
 include/media/v4l2-tpg.h                           |   9 +-
 include/uapi/linux/videodev2.h                     |   4 +
 10 files changed, 499 insertions(+), 170 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/hsv-formats.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst

-- 
2.8.1

