Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:33131 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab2GBJH7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2012 05:07:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.6] Core and vb2 enhancements
Date: Mon, 2 Jul 2012 11:07:45 +0200
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201207021107.45924.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is the pull request for the RFC patch series adding core and vb2 enhancements.

Changes since the RFCv3 (http://www.spinics.net/lists/linux-media/msg49583.html):

- Added vb2_fop_get_unmapped_area (thanks to Scott Jiang for catching that one).
- Added vb2_ops_wait_prepare/finish helpers and use them in pwc.
- Improved the locking documentation in v4l2-framework.txt.
- Rebased to the latest 3.6 code.

Regards,

	Hans

The following changes since commit 704a28e88ab6c9cfe393ae626b612cab8b46028e:

  [media] drxk: prevent doing something wrong when init is not ok (2012-06-29 19:04:32 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git ioctlv6

for you to fetch changes up to 7b030e341a604c56d4ef59062955620ac4c95d05:

  v4l2-framework.txt: Update the locking documentation. (2012-07-02 10:59:56 +0200)

----------------------------------------------------------------
Hans Verkuil (34):
      v4l2-ioctl.c: move a block of code down, no other changes.
      v4l2-ioctl.c: introduce INFO_FL_CLEAR to replace switch.
      v4l2-ioctl.c: v4l2-ioctl: add debug and callback/offset functionality.
      v4l2-ioctl.c: remove an unnecessary #ifdef.
      v4l2-ioctl.c: use the new table for querycap and i/o ioctls.
      v4l2-ioctl.c: use the new table for priority ioctls.
      v4l2-ioctl.c: use the new table for format/framebuffer ioctls.
      v4l2-ioctl.c: use the new table for overlay/streamon/off ioctls.
      v4l2-ioctl.c: use the new table for std/tuner/modulator ioctls.
      v4l2-ioctl.c: use the new table for queuing/parm ioctls.
      v4l2-ioctl.c: use the new table for control ioctls.
      v4l2-ioctl.c: use the new table for selection ioctls.
      v4l2-ioctl.c: use the new table for compression ioctls.
      v4l2-ioctl.c: use the new table for debug ioctls.
      v4l2-ioctl.c: use the new table for preset/timings ioctls.
      v4l2-ioctl.c: use the new table for the remaining ioctls.
      v4l2-ioctl.c: finalize table conversion.
      v4l2-dev.c: add debug sysfs entry.
      v4l2-ioctl: remove v4l_(i2c_)print_ioctl
      ivtv: don't mess with vfd->debug.
      cx18: don't mess with vfd->debug.
      vb2-core: refactor reqbufs/create_bufs.
      vb2-core: add support for count == 0 in create_bufs.
      Spec: document CREATE_BUFS behavior if count == 0.
      v4l2-dev/ioctl.c: add vb2_queue support to video_device.
      videobuf2-core: add helper functions.
      vivi: remove pointless g/s_std support
      vivi: embed struct video_device instead of allocating it.
      vivi: use vb2 helper functions.
      vivi: add create_bufs/preparebuf support.
      v4l2-dev.c: also add debug support for the fops.
      pwc: use the new vb2 helpers.
      pwc: v4l2-compliance fixes.
      v4l2-framework.txt: Update the locking documentation.

 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml |    8 +-
 Documentation/video4linux/v4l2-framework.txt           |   73 +--
 drivers/media/video/cx18/cx18-ioctl.c                  |   18 -
 drivers/media/video/cx18/cx18-ioctl.h                  |    2 -
 drivers/media/video/cx18/cx18-streams.c                |    4 +-
 drivers/media/video/ivtv/ivtv-ioctl.c                  |   12 -
 drivers/media/video/ivtv/ivtv-ioctl.h                  |    1 -
 drivers/media/video/ivtv/ivtv-streams.c                |    4 +-
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c             |    4 +-
 drivers/media/video/pwc/pwc-if.c                       |  171 +-----
 drivers/media/video/pwc/pwc-v4l.c                      |  165 +-----
 drivers/media/video/pwc/pwc.h                          |    3 -
 drivers/media/video/sn9c102/sn9c102.h                  |    2 +-
 drivers/media/video/uvc/uvc_v4l2.c                     |    2 +-
 drivers/media/video/v4l2-dev.c                         |   65 +-
 drivers/media/video/v4l2-ioctl.c                       | 3285 ++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------------------
 drivers/media/video/videobuf2-core.c                   |  412 ++++++++++---
 drivers/media/video/vivi.c                             |  194 +-----
 include/media/v4l2-dev.h                               |    3 +
 include/media/v4l2-ioctl.h                             |   25 +-
 include/media/videobuf2-core.h                         |   54 ++
 21 files changed, 2196 insertions(+), 2311 deletions(-)
