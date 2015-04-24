Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:41037 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138AbbDXKAc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 06:00:32 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 2D92D2A002F
	for <linux-media@vger.kernel.org>; Fri, 24 Apr 2015 12:00:01 +0200 (CEST)
Message-ID: <553A1421.1050700@xs4all.nl>
Date: Fri, 24 Apr 2015 12:00:01 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] marvell-ccic fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This supersedes https://patchwork.linuxtv.org/patch/29163/.

Added two more patches ("fix memory leak on failure path in cafe_smbus_setup()"
and "fix V4L2_PIX_FMT_SBGGR8 support").

All tested on my OLPC XO laptop.

Regards,

	Hans

The following changes since commit e183201b9e917daf2530b637b2f34f1d5afb934d:

  [media] uvcvideo: add support for VIDIOC_QUERY_EXT_CTRL (2015-04-10 10:29:27 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.2a

for you to fetch changes up to 3ac439bd9a26d2852f631b5ba90b9fc2bf5deff6:

  marvell-ccic: fix memory leak on failure path in cafe_smbus_setup() (2015-04-24 11:55:34 +0200)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      marvell-ccic: fix memory leak on failure path in cafe_smbus_setup()

Hans Verkuil (19):
      marvell-ccic: fix vb2 warning
      marvell-ccic: fill in bus_info
      marvell-ccic: webcam drivers shouldn't support g/s_std
      ov7670: check for valid width/height in ov7670_enum_frame_interval
      marvell-ccic: fill in colorspace
      marvell-ccic: control handler fixes
      marvell-ccic: switch to struct v4l2_fh
      marvell-ccic: implement control events
      marvell-ccic: use vb2 helpers and core locking
      marvell-ccic: add create_bufs support
      marvell-ccic: add DMABUF support for all three DMA modes
      marvell-ccic: fix streaming issues
      marvell-ccic: correctly requeue buffers
      marvell-ccic: add planar support to dma-vmalloc
      marvell-ccic: drop V4L2_PIX_FMT_JPEG dead code
      ov7670: use colorspace SRGB instead of JPEG
      marvell-ccic: fix the bytesperline and sizeimage calculations
      marvell-ccic: drop support for PIX_FMT_422P
      marvell-ccic: fix V4L2_PIX_FMT_SBGGR8 support

 drivers/media/i2c/ov7670.c                        |  25 ++++-
 drivers/media/platform/marvell-ccic/cafe-driver.c |  13 ++-
 drivers/media/platform/marvell-ccic/mcam-core.c   | 452 +++++++++++++++++++++++++++-----------------------------------------------
 drivers/media/platform/marvell-ccic/mcam-core.h   |   3 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c  |   1 +
 5 files changed, 199 insertions(+), 295 deletions(-)
