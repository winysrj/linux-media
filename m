Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:47444 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967378AbeBNLog (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 06:44:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: stable@vger.kernel.org
Cc: linux-media@vger.kernel.org
Subject: [PATCH for v4.14 00/13] v4l2-compat-ioctl32.c: remove set_fs(KERNEL_DS)
Date: Wed, 14 Feb 2018 12:44:21 +0100
Message-Id: <20180214114434.26842-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series fixes a number of bugs and culminates in the removal
of the set_fs(KERNEL_DS) call in v4l2-compat-ioctl32.c.

This was tested with a VM running 4.14, the vivid driver (since that
emulates almost all V4L2 ioctls that need to pass through v4l2-compat-ioctl32.c)
and a 32-bit v4l2-compliance utility since that exercises almost all ioctls
as well. Combined this gives good test coverage.

Most of the v4l2-compat-ioctl32.c do cleanups and fix subtle issues that
v4l2-compliance complained about. The purpose is to 1) make it easy to
verify that the final patch didn't introduce errors by first eliminating
errors caused by other bugs, and 2) keep the final patch at least somewhat
readable.

Rgards,

	Hans

Daniel Mentz (1):
  media: v4l2-compat-ioctl32.c: refactor compat ioctl32 logic

Hans Verkuil (12):
  media: v4l2-ioctl.c: use check_fmt for enum/g/s/try_fmt
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
  media: v4l2-compat-ioctl32.c: make ctrl_is_pointer work for subdevs

 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 1032 +++++++++++++++----------
 drivers/media/v4l2-core/v4l2-ioctl.c          |  145 ++--
 2 files changed, 665 insertions(+), 512 deletions(-)

-- 
2.15.1
