Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3258 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab0EIT1c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 15:27:32 -0400
Received: from localhost (cm-84.208.87.21.getinternet.no [84.208.87.21])
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id o49JRU9K034599
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 9 May 2010 21:27:30 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Message-Id: <cover.1273432986.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 09 May 2010 21:29:05 +0200
Subject: [PATCH 0/7] [RFC] Move VIDIOC_G/S_PRIORITY handling to the V4L core
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Few drivers implement VIDIOC_G/S_PRIORITY and those that do often implement
it incorrectly.

Now that we have a v4l2_fh struct it is easy to add support for priority
handling to the v4l core framework.

There are three types of drivers:

1) Those that use v4l2_fh. There the local priority can be stored in the
   v4l2_fh struct.

2) Those that do not have an open or release function defined in v4l2_file_ops.
   That means that file->private_data will never be filled and so we can use
   that to store the local priority in.

3) Others. In all other cases we leave it to the driver. Of course, the goal is
   to eventually move the 'others' into type 1 or 2.

This patch series shows how it is done and converts ivtv to rely on the core
framework instead of doing it manually.

Comments?

Regards,

	Hans

Hans Verkuil (7):
  v4l2_prio: move from v4l2-common to v4l2-device.
  v4l2-device: add v4l2_prio_state to v4l2_device.
  v4l2-fh: implement v4l2_priority support.
  v4l2-dev: add and support flag V4L2_FH_USE_PRIO.
  v4l2-ioctl: add priority handling support.
  ivtv: drop priority handling, use core framework for this.
  ivtv: add priority checks for the non-standard commands.

 drivers/media/video/cpia2/cpia2.h          |    1 +
 drivers/media/video/ivtv/ivtv-driver.h     |    2 -
 drivers/media/video/ivtv/ivtv-fileops.c    |    2 -
 drivers/media/video/ivtv/ivtv-ioctl.c      |   61 ++++++++------------------
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c |    1 +
 drivers/media/video/v4l2-common.c          |   59 -------------------------
 drivers/media/video/v4l2-dev.c             |   23 +++++++++-
 drivers/media/video/v4l2-device.c          |   62 +++++++++++++++++++++++++++
 drivers/media/video/v4l2-fh.c              |    4 ++
 drivers/media/video/v4l2-ioctl.c           |   64 +++++++++++++++++++++++++---
 include/media/v4l2-common.h                |   15 -------
 include/media/v4l2-dev.h                   |    6 +++
 include/media/v4l2-device.h                |   17 +++++++
 include/media/v4l2-fh.h                    |    1 +
 14 files changed, 190 insertions(+), 128 deletions(-)

