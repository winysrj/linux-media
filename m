Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1855 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932870Ab2FVMWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 08:22:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFCv2 PATCH 00/34] Core and vb2 enhancements
Date: Fri, 22 Jun 2012 14:20:54 +0200
Message-Id: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This is the second version of this patch series.

The first version is here:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg47558.html

Changes since RFCv1:

- Incorporated all review comments from Hans de Goede and Laurent Pinchart (Thanks!)
  except for splitting off the vb2 helper functions into a separate source. I decided
  to keep it together with the vb2-core code.

- Improved commit messages, added more comments to the code.

- The owner filehandle and the queue lock are both moved to struct vb2_queue since
  these are a property of the queue.

- The debug function has a new 'write_only' boolean: some debug functions can only
  print a subset of the arguments if it is called by an _IOW ioctl. The previous
  patch series split this up into two functions. Handling the debug function for
  a write-only ioctl is annoying at the moment: you have to print the arguments
  before calling the ioctl since the ioctl can overwrite arguments. I am considering
  changing the op argument to const for such ioctls and see if any driver is
  actually messing around with the contents of such structs. If we can guarantee
  that drivers do not change the argument struct, then we can simplify the debug
  code.

- All debugging is now KERN_DEBUG instead of KERN_INFO.

I still have one outstanding question: should anyone be able to call mmap() or
only the owner of the vb2 queue? Right now anyone can call mmap().

Comments are welcome!

Regards,

	Hans

diffstat & git repo:

The following changes since commit 17bd27bd78b59f7cbe0ff2cb8bb0e473260a9801:

  [media] stradis: remove unused V4L1 headers (2012-06-21 14:43:04 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git ioctlv6

for you to fetch changes up to 11e684f2052cfea1b3897b3a06e0b4021acca85d:

  pwc: v4l2-compliance fixes. (2012-06-22 13:26:26 +0200)

----------------------------------------------------------------
Hans Verkuil (34):
      Regression fixes.
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

 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml |    8 +-
 drivers/media/video/cx18/cx18-ioctl.c                  |   18 -
 drivers/media/video/cx18/cx18-ioctl.h                  |    2 -
 drivers/media/video/cx18/cx18-streams.c                |    4 +-
 drivers/media/video/ivtv/ivtv-ioctl.c                  |   12 -
 drivers/media/video/ivtv/ivtv-ioctl.h                  |    1 -
 drivers/media/video/ivtv/ivtv-streams.c                |    4 +-
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c             |    4 +-
 drivers/media/video/pwc/pwc-if.c                       |  155 +---
 drivers/media/video/pwc/pwc-v4l.c                      |  165 +---
 drivers/media/video/pwc/pwc.h                          |    3 -
 drivers/media/video/sn9c102/sn9c102.h                  |    2 +-
 drivers/media/video/uvc/uvc_v4l2.c                     |    2 +-
 drivers/media/video/v4l2-dev.c                         |   67 +-
 drivers/media/video/v4l2-ioctl.c                       | 3283 +++++++++++++++++++++++++++++++++++++---------------------------------------
 drivers/media/video/videobuf2-core.c                   |  390 +++++++--
 drivers/media/video/vivi.c                             |  190 +----
 include/linux/videodev2.h                              |    6 +-
 include/media/v4l2-dev.h                               |    3 +
 include/media/v4l2-ioctl.h                             |   25 +-
 include/media/videobuf2-core.h                         |   45 ++
 21 files changed, 2123 insertions(+), 2266 deletions(-)

