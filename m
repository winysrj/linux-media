Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:38497 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752273AbcHMNwN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2016 09:52:13 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id D5DC918026F
	for <linux-media@vger.kernel.org>; Sat, 13 Aug 2016 15:52:07 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.9] More fixes
Message-ID: <99357be0-3a8e-4ddf-96f4-2b0e53ebe4dd@xs4all.nl>
Date: Sat, 13 Aug 2016 15:52:07 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various fixes and documentation updates.

Regards,

	Hans

The following changes since commit b6aa39228966e0d3f0bc3306be1892f87792903a:

  Merge tag 'v4.8-rc1' into patchwork (2016-08-08 07:30:25 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.9b

for you to fetch changes up to 2079de1b912ef2fc930b52708274913a226f91ad:

  vidioc-g-dv-timings.rst: document the v4l2_bt_timings reserved field (2016-08-13 15:50:53 +0200)

----------------------------------------------------------------
Florian Echtler (1):
      sur40: properly report a single frame rate of 60 FPS

Hans Verkuil (3):
      vb2: don't return NULL for alloc and get_userptr ops
      vb2: add WARN_ONs checking if a valid struct device was passed
      vidioc-g-dv-timings.rst: document the v4l2_bt_timings reserved field

Javier Martinez Canillas (2):
      vb2: include lengths in dmabuf qbuf debug message
      vb2: remove TODO comment for dma-buf in QBUF

Ricardo Ribalda Delgado (1):
      Documentation: Fix V4L2_CTRL_FLAG_VOLATILE

 Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst |  8 ++++++++
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst    | 11 +++++++----
 drivers/input/touchscreen/sur40.c                    | 26 +++++++++++++++++++++-----
 drivers/media/v4l2-core/videobuf2-core.c             | 25 ++++++++++++++++---------
 drivers/media/v4l2-core/videobuf2-dma-contig.c       |  9 +++++++++
 drivers/media/v4l2-core/videobuf2-dma-sg.c           | 19 +++++++++++++------
 drivers/media/v4l2-core/videobuf2-vmalloc.c          | 13 ++++++++-----
 include/media/videobuf2-core.h                       |  6 +++---
 8 files changed, 85 insertions(+), 32 deletions(-)
