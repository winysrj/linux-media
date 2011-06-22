Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22315 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758528Ab1FVSBj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 14:01:39 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 22 Jun 2011 20:01:06 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/19] s5p-fimc driver conversion to media controller and
 control framework
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1308765684-10677-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

following is an updated patchset for s5p-fimc driver conversion to the media
controller API and control framework.

In this version the ioctl handlers for format setting at the video node and
the FIMC subdev has been reworked so they use common functions for capture
data format adjustment to the hardware capabilities. This prevent trouble
from any differences in handling ioctls at the subdev and the video node
when those are used simultaneously.

Except that I have killed a few bugs that jumped out when the driver was tried
to be used as a kernel module. 

Additionally to allow the driver to be used in V4L2 video node compatibility
mode (when sensor subdev is configured by the host driver rather that directly
by the applications through /dev/v4l-subdev*) a sysfs entry is added.
All that needs to be done to disable sensors configuration from /dev/video*
node level, in order to use sub-device user space API, is to write correct
string to s5p-fimc-md platform device "subdev_conf_mode" sysfs entry, e.g.

echo sub-dev > /sys/devices/platform/s5p-fimc-md/subdev_conf_mode
or to revert:
echo vid-dev > /sys/devices/platform/s5p-fimc-md/subdev_conf_mode

The following procedure is adopted for format and crop/composition
configuration at the FIMC.{n} (capture) subdevs:

1) set format at sink pad (this will reset sink crop rectangle)
2) set crop rectangle at sink pad (optional)
3) set rotate control
4) set crop (composition) at source pad (optional). Here scaling constraints
   are checked according to whether sink pad crop has been set or not and
   whether 90/270 deg rotation is set.
5) set format at source pad
6) set format at corresponding video node

Rotation can also be changed while streaming, in this case when 90/270 deg
rotation is attempted to be set and scaling bounds are exceeded 
(max. 64x downscaling) s_ctrl returns EINVAL.

I have tried this driver with v4l-compliance and it returned only 1 fail
on S/G_PRIORITY.
								
This patch set depends on my previous s5p-fimc bugfixes, available at: 
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/s5p-fimc

as well as the control framework updates from Hans Verkuil:
http://www.spinics.net/lists/linux-media/msg33552.html
(patch 1...6, 8, 11).

Full source tree can be found at:
 http://git.infradead.org/users/kmpark/linux-2.6-samsung
 branch: s5p-fimc-next

I have skipped patch one patch in this series comparing to first version:
s5p-fimc: Add support for runtime PM in the mem-to-mem driver
This patch is available in the above git repository. 
I need to work a bit more on that one.

As usual, all comments and suggestions are welcome!

Sylwester Nawrocki (18):
  s5p-fimc: Add media entity initialization
  s5p-fimc: Remove registration of video nodes from probe()
  s5p-fimc: Remove sclk_cam clock handling
  s5p-fimc: Limit number of available inputs to one
  s5p-fimc: Remove sensor management code from FIMC capture driver
  s5p-fimc: Remove v4l2_device from video capture and m2m driver
  s5p-fimc: Add the media device driver
  s5p-fimc: Conversion to use struct v4l2_fh
  s5p-fimc: Conversion to the control framework
  s5p-fimc: Add media operations in the capture entity driver
  s5p-fimc: Add PM helper function for streaming control
  s5p-fimc: Correct color format enumeration
  s5p-fimc: Convert to use media pipeline operations
  s5p-fimc: Add subdev for the FIMC processing block
  s5p-fimc: Add support for camera capture in JPEG format
  s5p-fimc: Add v4l2_device notification support for single frame capture
  s5p-fimc: Use consistent names for the buffer list functions
  s5p-fimc: Add runtime PM support in the camera capture driver

 drivers/media/video/Kconfig                 |    2 +-
 drivers/media/video/s5p-fimc/Makefile       |    2 +-
 drivers/media/video/s5p-fimc/fimc-capture.c | 1387 ++++++++++++++++++---------
 drivers/media/video/s5p-fimc/fimc-core.c    |  864 ++++++++---------
 drivers/media/video/s5p-fimc/fimc-core.h    |  204 +++--
 drivers/media/video/s5p-fimc/fimc-mdevice.c |  822 ++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-mdevice.h |  118 +++
 drivers/media/video/s5p-fimc/fimc-reg.c     |   74 +-
 drivers/media/video/s5p-fimc/regs-fimc.h    |    8 +-
 include/media/s5p_fimc.h                    |   11 +
 10 files changed, 2490 insertions(+), 1002 deletions(-)
 create mode 100644 drivers/media/video/s5p-fimc/fimc-mdevice.c
 create mode 100644 drivers/media/video/s5p-fimc/fimc-mdevice.h

--
Thanks,
Sylwester
