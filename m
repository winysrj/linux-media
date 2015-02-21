Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:46534 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbbBUSk1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2015 13:40:27 -0500
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	adi-buildroot-devel@lists.sourceforge.net
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v3 00/15] media: blackfin: bfin_capture enhancements
Date: Sat, 21 Feb 2015 18:39:46 +0000
Message-Id: <1424544001-19045-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch series, enhances blackfin capture driver with
vb2 helpers.

Changes for v3:
1: patches unchanged except for patch 8/15 fixing starting of ppi only
   after we have the resources.
2: Rebased on media tree.

v2: http://lkml.iu.edu/hypermail/linux/kernel/1501.2/04655.html

v1: https://lkml.org/lkml/2014/12/20/27

Lad, Prabhakar (15):
  media: blackfin: bfin_capture: drop buf_init() callback
  media: blackfin: bfin_capture: release buffers in case
    start_streaming() call back fails
  media: blackfin: bfin_capture: set min_buffers_needed
  media: blackfin: bfin_capture: improve buf_prepare() callback
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

 drivers/media/platform/blackfin/bfin_capture.c | 306 ++++++++-----------------
 1 file changed, 94 insertions(+), 212 deletions(-)

-- 
2.1.0

