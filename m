Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53857 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314AbbCJPPN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 11:15:13 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id CD8A22A0092
	for <linux-media@vger.kernel.org>; Tue, 10 Mar 2015 16:15:05 +0100 (CET)
Message-ID: <54FF0A79.3090107@xs4all.nl>
Date: Tue, 10 Mar 2015 16:15:05 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.1] fixes, blackfin cleanups
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patch series has various fixes all over and the blackfin cleanups
(this time with new and improved commit messages!).

Regards,

	Hans

The following changes since commit 3d945be05ac1e806af075e9315bc1b3409adae2b:

  [media] mn88473: simplify bandwidth registers setting code (2015-03-03 13:09:12 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.1h

for you to fetch changes up to 80c9cab2241928ed348a5539478f9a5feb35873d:

  media: davinci: vpif_display: embed video_device struct in channel_obj (2015-03-10 16:12:55 +0100)

----------------------------------------------------------------
Hans Verkuil (7):
      vb2: check if vb2_fop_write/read is allowed
      v4l2-framework.txt: debug -> dev_debug
      v4l2-ioctl: tidy up debug messages
      DocBook media: fix xv601/709 formulas
      DocBook media: BT.2020 RGB uses limited quantization range
      videodev2.h: fix comment
      vivid: BT.2020 R'G'B' is limited range

Lad, Prabhakar (22):
      media: am437x-vpfe: match the OF node/i2c addr instead of name
      media: am437x-vpfe: return error in case memory allocation failure
      media: am437x-vpfe: embed video_device struct in vpfe_device
      media: blackfin: bfin_capture: drop buf_init() callback
      media: blackfin: bfin_capture: release buffers in case start_streaming() call back fails
      media: blackfin: bfin_capture: set min_buffers_needed
      media: blackfin: bfin_capture: set vb2 buffer field
      media: blackfin: bfin_capture: improve queue_setup() callback
      media: blackfin: bfin_capture: use vb2_fop_mmap/poll
      media: blackfin: bfin_capture: use v4l2_fh_open and vb2_fop_release
      media: blackfin: bfin_capture: use vb2_ioctl_* helpers
      media: blackfin: bfin_capture: make sure all buffers are returned on stop_streaming() callback
      media: blackfin: bfin_capture: return -ENODATA for *std calls
      media: blackfin: bfin_capture: return -ENODATA for *dv_timings calls
      media: blackfin: bfin_capture: add support for vidioc_create_bufs
      media: blackfin: bfin_capture: add support for VB2_DMABUF
      media: blackfin: bfin_capture: add support for VIDIOC_EXPBUF
      media: blackfin: bfin_capture: set v4l2 buffer sequence
      media: blackfin: bfin_capture: drop bcap_get_unmapped_area()
      media: blackfin: bfin_capture: embed video_device struct in bcap_device
      media: davinci: vpif_capture: embed video_device struct in channel_obj
      media: davinci: vpif_display: embed video_device struct in channel_obj

Laurent Pinchart (1):
      media: am437x: Don't release OF node reference twice

Masatake YAMATO (1):
      am437x: include linux/videodev2.h for expanding BASE_VIDIOC_PRIVATE

Tapasweni Pathak (1):
      drivers: media: platform: vivid: Fix possible null derefrence

 Documentation/DocBook/media/v4l/pixfmt.xml     |  23 +++---
 Documentation/video4linux/v4l2-framework.txt   |   6 +-
 drivers/media/platform/am437x/am437x-vpfe.c    |  57 ++++++-------
 drivers/media/platform/am437x/am437x-vpfe.h    |   3 +-
 drivers/media/platform/blackfin/bfin_capture.c | 348 +++++++++++++++++++++++------------------------------------------------------
 drivers/media/platform/davinci/vpif_capture.c  |  52 +++---------
 drivers/media/platform/davinci/vpif_capture.h  |   2 +-
 drivers/media/platform/davinci/vpif_display.c  |  49 ++---------
 drivers/media/platform/davinci/vpif_display.h  |   2 +-
 drivers/media/platform/vivid/vivid-tpg.c       |   4 +
 drivers/media/platform/vivid/vivid-vid-out.c   |   4 +-
 drivers/media/v4l2-core/v4l2-ioctl.c           |   4 +-
 drivers/media/v4l2-core/videobuf2-core.c       |   4 +
 include/uapi/linux/am437x-vpfe.h               |   2 +
 include/uapi/linux/videodev2.h                 |   7 +-
 15 files changed, 184 insertions(+), 383 deletions(-)
