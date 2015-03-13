Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:39535 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753885AbbCMKKA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 06:10:00 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 3A4072A002F
	for <linux-media@vger.kernel.org>; Fri, 13 Mar 2015 11:09:50 +0100 (CET)
Message-ID: <5502B76E.4090202@xs4all.nl>
Date: Fri, 13 Mar 2015 11:09:50 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.1] marvell-ccic: fixes and cleanups
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This pull request brings the marvell-ccic driver up to date with the
latest frameworks. It has been fully tested on an OLPC XO-1 laptop and
now passes the v4l2-compliance test suite.

This pull request sits on top of this for-v4.1g pull request that is
currently still pending (and was the reason for working on this driver
in the first place): https://patchwork.linuxtv.org/patch/28532/

Regards,

	Hans

The following changes since commit ae3da40179c66001afad608f972bdb57d50d1e66:

  v4l2-subdev: remove enum_framesizes/intervals (2015-03-06 10:01:44 +0100)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.1i

for you to fetch changes up to dd3de0af9fbfcef33d8406696e4103d26c7313a1:

  marvell-ccic: drop support for PIX_FMT_422P (2015-03-13 10:54:33 +0100)

----------------------------------------------------------------
Hans Verkuil (21):
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
      marvell-ccic: add XRGB444 and fix (X)RGB444 colors
      marvell-ccic: drop bayer format
      marvell-ccic: drop support for PIX_FMT_422P

 drivers/media/i2c/ov7670.c                        |  25 +++-
 drivers/media/platform/marvell-ccic/cafe-driver.c |   1 +
 drivers/media/platform/marvell-ccic/mcam-core.c   | 479 +++++++++++++++++++++++++++-----------------------------------------------
 drivers/media/platform/marvell-ccic/mcam-core.h   |  11 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c  |   1 +
 5 files changed, 207 insertions(+), 310 deletions(-)
