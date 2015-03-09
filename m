Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50115 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752929AbbCIVWa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 17:22:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net
Subject: [PATCH 00/18] marvell-ccic + ov7670 fixes
Date: Mon,  9 Mar 2015 22:22:05 +0100
Message-Id: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series makes loads of fixes and improvements to the marvell-ccic
and ov7670 drivers. This has been tested on an OLPC XO-1 laptop.

This patch series sits on top of this pull request:

https://patchwork.linuxtv.org/patch/28532/

I do need to check the last patch with Libin Yang since his patch from mid-2013
broke the driver for the OLPC laptop. Nobody noticed since the latest released
kernel from the OLPC project for that laptop is 3.3, which didn't have his patch.

This driver now passes the v4l2-compliance test-suite, so that's very nice.

Regards,

	Hans

Hans Verkuil (18):
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
  marvell-ccic: fix Y'CbCr ordering

 drivers/media/i2c/ov7670.c                        |  25 +-
 drivers/media/platform/marvell-ccic/cafe-driver.c |   1 +
 drivers/media/platform/marvell-ccic/mcam-core.c   | 461 ++++++++--------------
 drivers/media/platform/marvell-ccic/mcam-core.h   |  11 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c  |   1 +
 5 files changed, 207 insertions(+), 292 deletions(-)

-- 
2.1.4

