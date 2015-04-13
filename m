Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:49463 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753621AbbDMKJV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2015 06:09:21 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id B5C742A0099
	for <linux-media@vger.kernel.org>; Mon, 13 Apr 2015 12:09:08 +0200 (CEST)
Message-ID: <552B95C4.50901@xs4all.nl>
Date: Mon, 13 Apr 2015 12:09:08 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] Marvell fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This supersedes https://patchwork.linuxtv.org/patch/28767 since that fell
through the cracks somehow and it is now too late to merge for 4.1 :-(

Added one more patch (drop support for PIX_FMT_422P) that was also Acked
by Jon and the "fix Y'CbCr ordering" is now Cc-ed for stable for 3.19 and up.
It really should be applied to 3.12 and up, but the patch won't apply for those
older kernels, so I will have to manually make a patch for that once it is
merged.

Regards,

	Hans

The following changes since commit e183201b9e917daf2530b637b2f34f1d5afb934d:

  [media] uvcvideo: add support for VIDIOC_QUERY_EXT_CTRL (2015-04-10 10:29:27 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.2a

for you to fetch changes up to f7e5c96534c40aef688d323f1b0f0a0014580b13:

  marvell-ccic: drop support for PIX_FMT_422P (2015-04-13 12:04:59 +0200)

----------------------------------------------------------------
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
      marvell-ccic: fix Y'CbCr ordering
      marvell-ccic: drop support for PIX_FMT_422P

 drivers/media/i2c/ov7670.c                        |  25 +++-
 drivers/media/platform/marvell-ccic/cafe-driver.c |   1 +
 drivers/media/platform/marvell-ccic/mcam-core.c   | 462 +++++++++++++++++++++++++++-----------------------------------------------
 drivers/media/platform/marvell-ccic/mcam-core.h   |  11 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c  |   1 +
 5 files changed, 198 insertions(+), 302 deletions(-)
