Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37965 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab1IAPa3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 11:30:29 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 01 Sep 2011 17:30:04 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/19 v4] s5p-fimc driver conversion to media controller and
 control framework
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: mchehab@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

following is a fourth version of the patchset converting s5p-fimc driver
to the media controller API and the new control framework.

Mauro, could you please have a look at the patches and let me know of any doubts?
I tried to provide possibly detailed description of what each patch does and why.

The changeset is available at:
  http://git.infradead.org/users/kmpark/linux-2.6-samsung
  branch: v4l_fimc_for_mauro

on top of patches from Marek's 'Videobuf2 & FIMC fixes" pull request
which this series depends on.

Changes since v3:
 - more detailed commit descriptions
 - add missing dependency on EXPERIMENTAL and mark the driver as experimental
   in the config menu
 - removed the first patch as of v3 series, it has been posted separately
 - added 2 new patches: 18/19, 19/19
 - moved the link_setup capture video node media entity operation to the capture
   subdev entity; the link_setup op prevented having 2 active source attached to
   single data sink, there is no need for this at the video node entity as it
   has only an immutable link; Instead we guard the number of sources being 
   connected to the FIMC capture subdev
 - rebased onto recent vb2 modifications changing the queue initialization order
 - s/fimc_start_capture/fimc_init_capture, 
   s/fimc_capture_apply_cfg/fimc_capture_config_update
 - slightly improved the comments and fixed typos 

Changes since v2:
- reworked (runtime) power management;
- added pm_runtime_get_sync/pm_runtime_put around sensor registration
  code so the clock for sensors is enabled during host driver's probe();
- reworked try_crop operation handler to support multiple of the prescaler
  ratio relationship constraint for format at the sink pad;
- corrected fimc_md_unregister_entities() function


Sylwester Nawrocki (19):
  s5p-fimc: Remove registration of video nodes from probe()
  s5p-fimc: Remove sclk_cam clock handling
  s5p-fimc: Limit number of available inputs to one
  s5p-fimc: Remove sensor management code from FIMC capture driver
  s5p-fimc: Remove v4l2_device from video capture and m2m driver
  s5p-fimc: Add the media device driver
  s5p-fimc: Conversion to use struct v4l2_fh
  s5p-fimc: Convert to the new control framework
  s5p-fimc: Add media operations in the capture entity driver
  s5p-fimc: Add PM helper function for streaming control
  s5p-fimc: Correct color format enumeration
  s5p-fimc: Convert to use media pipeline operations
  s5p-fimc: Add subdev for the FIMC processing block
  s5p-fimc: Add support for JPEG capture
  s5p-fimc: Add v4l2_device notification support for single frame
    capture
  s5p-fimc: Use consistent names for the buffer list functions
  s5p-fimc: Add runtime PM support in the camera capture driver
  s5p-fimc: Correct crop offset alignment on exynos4
  s5p-fimc: Remove single-planar capability flags

 drivers/media/video/Kconfig                 |    5 +-
 drivers/media/video/s5p-fimc/Makefile       |    2 +-
 drivers/media/video/s5p-fimc/fimc-capture.c | 1416 ++++++++++++++++++--------
 drivers/media/video/s5p-fimc/fimc-core.c    |  884 ++++++++---------
 drivers/media/video/s5p-fimc/fimc-core.h    |  201 +++--
 drivers/media/video/s5p-fimc/fimc-mdevice.c |  857 ++++++++++++++++
 drivers/media/video/s5p-fimc/fimc-mdevice.h |  118 +++
 drivers/media/video/s5p-fimc/fimc-reg.c     |   74 +-
 drivers/media/video/s5p-fimc/regs-fimc.h    |    8 +-
 include/media/s5p_fimc.h                    |   11 +
 10 files changed, 2551 insertions(+), 1025 deletions(-)
 create mode 100644 drivers/media/video/s5p-fimc/fimc-mdevice.c
 create mode 100644 drivers/media/video/s5p-fimc/fimc-mdevice.h


Regards,
--
Sylwester Nawrocki
Samsung Poland R&D Center

