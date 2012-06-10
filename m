Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1665 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab2FJK0I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:26:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFCv1 PATCH 00/32] Core and vb2 enhancements
Date: Sun, 10 Jun 2012 12:25:22 +0200
Message-Id: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This large patch series makes a number of changes to the core (ioctl
handling in particular) and vb2. It all builds on one another, so there
wasn't much point in splitting it. Most patches are fairly trivial, so it
is not as bad as it looks :-)

I will go through the patches one by one:

- Regression fixes.

This is a small patch that fixes a number of regressions that are relevant to
this patch series. These fixes have already been posted to the list.

- v4l2-ioctl.c: move a block of code down, no other changes.

Just move code around, no other changes.

- v4l2-ioctl.c: introduce INFO_FL_CLEAR to replace switch.

This replaces the switch that determines how much of the struct needs to be
copied from userspace with a simple table lookup.

- v4l2-ioctl.c: v4l2-ioctl: add debug and callback/offset functionality.

Prepare for the next step where the large switch is replaced by table lookups.

- v4l2-ioctl.c: remove an unnecessary #ifdef.

A small fix for the table: keep the DBG_G/S_REGISTER ioctl in the table. All
the right checks are already made, and this way you will actually see the ioctl
name in the debug messages if you use it.

- v4l2-ioctl.c: use the new table for querycap and i/o ioctls.
- v4l2-ioctl.c: use the new table for priority ioctls.
- v4l2-ioctl.c: use the new table for format/framebuffer ioctls.
- v4l2-ioctl.c: use the new table for overlay/streamon/off ioctls.
- v4l2-ioctl.c: use the new table for std/tuner/modulator ioctls.
- v4l2-ioctl.c: use the new table for queuing/parm ioctls.
- v4l2-ioctl.c: use the new table for control ioctls.
- v4l2-ioctl.c: use the new table for selection ioctls.
- v4l2-ioctl.c: use the new table for compression ioctls.
- v4l2-ioctl.c: use the new table for debug ioctls.
- v4l2-ioctl.c: use the new table for preset/timings ioctls.
- v4l2-ioctl.c: use the new table for the remaining ioctls.

Here the switch is replaced by table lookups section-by-section.

- v4l2-ioctl.c: finalize table conversion.

Remove the last part of the switch.

- v4l2-dev.c: add debug sysfs entry.

The video_device debug field is pretty useful, if only you could set it. The
solution is simple: export it in sysfs. That way you can easily set the debug
level per device node. Works like a charm.

- v4l2-ioctl: remove v4l_(i2c_)print_ioctl

Clean up a few rarely used macros.

- ivtv: don't mess with vfd->debug.
- cx18: don't mess with vfd->debug.

Rely on the new sysfs debug mechanism instead.

- v4l2-dev/ioctl.c: add vb2_queue support to video_device.

Add core support for vb2 to struct video_device. This will be used in the next patch.
Note: this assumes that there is no more than one vb2_queue per device node. So this
can't be used for mem2mem.

- videobuf2-core: add helper functions.

These helpers simplify using vb2: If you set vdev->queue and vdev->queue_lock then these
helpers will take care of queue ownership and locking. So as soon as REQBUFS or
CREATE_BUFFERS is called, that file handle owns the queue and no other filehandle can do
anything with it except for QUERYBUF and mmap. I'm not sure about mmap: should that also
be limited to the owner?

The locking has been changed: it is now possible to specify a mutex that protects the
queue (vdev->queue_lock), and that will be taken instead of the core lock (vdev->lock) when
the vb2 ioctls are called. If you need to serialize against the core lock, then you should
take that lock in the vb2 ops you implemented. So queue_lock is always taken before vdev->lock.

This approach should remove the need for disabling locking for specific ioctls which was
introduced in 3.5. I believe that was the wrong approach.

I have refactored reqbufs and request_buffers a bit: they call the same code to check for
valid memory and buffer types. In addition, these functions will always return -EINVAL if
the types are invalid, and only then will they check for busy state. That way code like qv4l2
that tries to detect which memory types are available can still do that, even if streaming
is in progress. Currently you can get -EBUSY back and that hides whether the memory type
was valid.

create_buffers now also supports count == 0: if count == 0, then you will never get -EBUSY.

- create_bufs: handle count == 0.

Update documentation.

- vivi: remove pointless g/s_std support
- vivi: embed struct video_device instead of allocating it.
- vivi: use vb2 helper functions.

Two vivi cleanups and implement the vb2 helpers in vivi.

- v4l2-dev.c: also add debug support for the fops.

Show debugging when the fops are called if vdev->debug is set.

- v4l2-ioctl.c: shorten the lines of the table.

Make the ioctl table more readable.

- pwc: use the new vb2 helpers.

Implement the vb2 helpers in pwc.

- pwc: v4l2-compliance fixes.

Fix some complaints from v4l2-compliance.

This patch series is also available here:

git://linuxtv.org/hverkuil/media_tree.git ioctlv5

Personally I think that the table conversion is fairly trivial (just a lot of work).
The interesting bits are with the new debug sysfs entry, the vb2 helpers and the way
the core handles vb2 locking (and yes, you don't have to use vb2 locking, but then
you most likely still have to write wrapper functions).

Comments? Ideas?

Regards,

	Hans

diffstat:

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
 drivers/media/video/v4l2-ioctl.c                       | 3452 ++++++++++++++++++++++++++++++++++++++--------------------------------------
 drivers/media/video/videobuf2-core.c                   |  353 ++++++--
 drivers/media/video/vivi.c                             |  190 +----
 include/linux/videodev2.h                              |    6 +-
 include/media/v4l2-dev.h                               |    8 +
 include/media/v4l2-ioctl.h                             |   25 +-
 include/media/videobuf2-core.h                         |   19 +
 21 files changed, 2159 insertions(+), 2341 deletions(-)

