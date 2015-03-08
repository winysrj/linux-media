Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:42065 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbbCHOlD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2015 10:41:03 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Cc: adi-buildroot-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v4 00/17] media: blackfin: bfin_capture enhancements
Date: Sun,  8 Mar 2015 14:40:36 +0000
Message-Id: <1425825653-14768-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch series, enhances blackfin capture driver with
vb2 helpers.

Changes for v4:
1: Improved commit message for path 4/17 and 5/17.
2: Added Ack's from Scott to patches 1-15
3: Two new patches 16/17 and 17/17

Lad, Prabhakar (17):
  media: blackfin: bfin_capture: drop buf_init() callback
  media: blackfin: bfin_capture: release buffers in case
    start_streaming() call back fails
  media: blackfin: bfin_capture: set min_buffers_needed
  media: blackfin: bfin_capture: set vb2 buffer field
  media: blackfin: bfin_capture: improve queue_setup() callback
  media: blackfin: bfin_capture: use vb2_fop_mmap/poll
  media: blackfin: bfin_capture: use v4l2_fh_open and vb2_fop_release
  media: blackfin: bfin_capture: use vb2_ioctl_* helpers
  media: blackfin: bfin_capture: make sure all buffers are returned on
    stop_streaming() callback
  media: blackfin: bfin_capture: return -ENODATA for *std calls
  media: blackfin: bfin_capture: return -ENODATA for *dv_timings calls
  media: blackfin: bfin_capture: add support for vidioc_create_bufs
  media: blackfin: bfin_capture: add support for VB2_DMABUF
  media: blackfin: bfin_capture: add support for VIDIOC_EXPBUF
  media: blackfin: bfin_capture: set v4l2 buffer sequence
  media: blackfin: bfin_capture: drop bcap_get_unmapped_area()
  media: blackfin: bfin_capture: embed video_device struct in
    bcap_device

 drivers/media/platform/blackfin/bfin_capture.c | 348 ++++++++-----------------
 1 file changed, 103 insertions(+), 245 deletions(-)

-- 
2.1.0

