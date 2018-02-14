Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:50078 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754616AbeBNMDY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 07:03:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: stable@vger.kernel.org
Cc: linux-media@vger.kernel.org
Subject: [PATCH for v3.2 00/12] v4l2-compat-ioctl32.c: remove set_fs(KERNEL_DS)
Date: Wed, 14 Feb 2018 13:03:11 +0100
Message-Id: <20180214120323.28778-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series fixes a number of bugs and culminates in the removal
of the set_fs(KERNEL_DS) call in v4l2-compat-ioctl32.c.

This was tested with a VM running 3.2, the vivi driver (a poor substitute for
the much improved vivid driver that's available in later kernels, but it's the
best I had) since that emulates the more common V4L2 ioctls that need to pass
through v4l2-compat-ioctl32.c) and the 32-bit v4l2-compliance + 32-bit v4l2-ctl
utilities that together exercised the most common ioctls.

Most of the v4l2-compat-ioctl32.c do cleanups and fix subtle issues that
v4l2-compliance complained about. The purpose is to 1) make it easy to
verify that the final patch didn't introduce errors by first eliminating
errors caused by other known bugs, and 2) keep the final patch at least
somewhat readable.

Regards,

	Hans

Daniel Mentz (2):
  media: v4l2-compat-ioctl32: Copy v4l2_window->global_alpha
  media: v4l2-compat-ioctl32.c: refactor compat ioctl32 logic

Hans Verkuil (10):
  media: v4l2-ioctl.c: don't copy back the result for -ENOTTY
  media: v4l2-compat-ioctl32.c: add missing VIDIOC_PREPARE_BUF
  media: v4l2-compat-ioctl32.c: fix the indentation
  media: v4l2-compat-ioctl32.c: move 'helper' functions to
    __get/put_v4l2_format32
  media: v4l2-compat-ioctl32.c: avoid sizeof(type)
  media: v4l2-compat-ioctl32.c: copy m.userptr in put_v4l2_plane32
  media: v4l2-compat-ioctl32.c: fix ctrl_is_pointer
  media: v4l2-compat-ioctl32.c: copy clip list in put_v4l2_window32
  media: v4l2-compat-ioctl32.c: drop pr_info for unknown buffer type
  media: v4l2-compat-ioctl32.c: don't copy back the result for certain
    errors

 drivers/media/video/Makefile              |   7 +-
 drivers/media/video/v4l2-compat-ioctl32.c | 966 ++++++++++++++++++------------
 drivers/media/video/v4l2-ioctl.c          |   6 +-
 3 files changed, 597 insertions(+), 382 deletions(-)

-- 
2.15.1
