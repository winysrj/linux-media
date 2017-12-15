Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:39577 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932085AbdLOPIf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 10:08:35 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.16] Various fixes
Message-ID: <22139159-007f-5b37-978e-b5334af5715b@xs4all.nl>
Date: Fri, 15 Dec 2017 16:08:32 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 0ca4e3130402caea8731a7b54afde56a6edb17c9:

  media: pxa_camera: rename the soc_camera_ prefix to pxa_camera_ (2017-12-14 12:40:01 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.16c

for you to fetch changes up to 03672a5bd2ba76b8b54a296e51e85919529d23b8:

  bdisp: Fix a possible sleep-in-atomic bug in bdisp_hw_save_request (2017-12-15 15:57:12 +0100)

----------------------------------------------------------------
Flavio Ceolin (1):
      media: pxa_camera: disable and unprepare the clock source on error

Hans Verkuil (1):
      pvrusb2: correctly return V4L2_PIX_FMT_MPEG in enum_fmt

Jacopo Mondi (1):
      v4l: sh_mobile_ceu: Return buffers on streamoff()

Jia-Ju Bai (1):
      bdisp: Fix a possible sleep-in-atomic bug in bdisp_hw_save_request

Lucas Stach (1):
      coda: set min_buffers_needed

Philipp Zabel (5):
      coda: fix capture TRY_FMT for YUYV with non-MB-aligned widths
      coda: round up frame sizes to multiples of 16 for MPEG-4 decoder
      coda: allocate space for mpeg4 decoder mvcol buffer
      coda: use correct offset for mpeg4 decoder mvcol buffer
      vb2: clear V4L2_BUF_FLAG_LAST when filling vb2_buffer

Stanimir Varbanov (1):
      media: vb2: unify calling of set_page_dirty_lock

 drivers/media/platform/coda/coda-bit.c                   | 23 ++++++++++++-----------
 drivers/media/platform/coda/coda-common.c                | 13 ++++++++++---
 drivers/media/platform/pxa_camera.c                      |  4 +++-
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c |  7 ++++++-
 drivers/media/platform/sti/bdisp/bdisp-hw.c              |  2 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c                 | 32 +++++++-------------------------
 drivers/media/v4l2-core/videobuf2-dma-contig.c           |  6 ++++--
 drivers/media/v4l2-core/videobuf2-dma-sg.c               |  7 +++----
 drivers/media/v4l2-core/videobuf2-v4l2.c                 |  2 ++
 9 files changed, 48 insertions(+), 48 deletions(-)
