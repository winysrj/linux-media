Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:54885 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751520AbbEYMBd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 08:01:33 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 2E60F2A0095
	for <linux-media@vger.kernel.org>; Mon, 25 May 2015 14:01:27 +0200 (CEST)
Message-ID: <55630F17.1040306@xs4all.nl>
Date: Mon, 25 May 2015 14:01:27 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.2] More fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series merges various fixes and improves colorspace support.

It also contains the Y16_BE patches which were not merged the previous time for
no clear reason, and my patch updating the querycap error code description, this time
with a better commit log explaining why we cannot say for certain what the error
will be.

Regards,

	Hans

The following changes since commit 2a80f296422a01178d0a993479369e94f5830127:

  [media] dvb-core: fix 32-bit overflow during bandwidth calculation (2015-05-20 14:01:46 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.2k

for you to fetch changes up to 4ec6c326de9d1a06444ebb54477b712850ce7f15:

  v4l2: correct two SDR format names (2015-05-25 13:33:37 +0200)

----------------------------------------------------------------
Antti Palosaari (2):
      vivid: SDR cap add 'CU08' Complex U8 format
      v4l2: correct two SDR format names

Hans Verkuil (9):
      DocBook/media: add missing entry for V4L2_PIX_FMT_Y16_BE
      ivtv: fix incorrect audio mode report in log_status
      DocBook/media: fix querycap error code
      videodev2.h: add COLORSPACE_DEFAULT
      DocBook/media: document COLORSPACE_DEFAULT
      videodev2.h: add COLORSPACE_RAW
      DocBook/media: document COLORSPACE_RAW.
      videodev2.h: add macros to map colorspace defaults
      vivid: use new V4L2_MAP_*_DEFAULT defines

Ricardo Ribalda Delgado (5):
      media/videobuf2-dma-sg: Fix handling of sg_table structure
      media/videobuf2-dma-contig: Save output from dma_map_sg
      media/videobuf2-dma-vmalloc: Save output from dma_map_sg
      media/v4l2-core: Add support for V4L2_PIX_FMT_Y16_BE
      media/vivid: Add support for Y16_BE format

 Documentation/DocBook/media/v4l/pixfmt-y16-be.xml   | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml          | 13 ++++++++++
 Documentation/DocBook/media/v4l/vidioc-querycap.xml |  2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                 |  3 ++-
 drivers/media/platform/vivid/vivid-core.c           |  7 ++++--
 drivers/media/platform/vivid/vivid-core.h           |  2 ++
 drivers/media/platform/vivid/vivid-sdr-cap.c        | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 drivers/media/platform/vivid/vivid-sdr-cap.h        |  2 ++
 drivers/media/platform/vivid/vivid-tpg.c            | 60 +++++++++++++---------------------------------
 drivers/media/platform/vivid/vivid-vid-common.c     |  8 +++++++
 drivers/media/v4l2-core/v4l2-ioctl.c                |  5 ++--
 drivers/media/v4l2-core/videobuf2-dma-contig.c      |  6 ++---
 drivers/media/v4l2-core/videobuf2-dma-sg.c          | 22 ++++++++++-------
 drivers/media/v4l2-core/videobuf2-vmalloc.c         |  6 ++---
 include/uapi/linux/videodev2.h                      | 40 +++++++++++++++++++++++++++++++
 15 files changed, 278 insertions(+), 75 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-y16-be.xml
