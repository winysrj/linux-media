Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:44686 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727082AbeIMUBt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 16:01:49 -0400
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        linux-media@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v10 0/5] Cedrus driver for the Allwinner Video Engine, using media requests
Date: Thu, 13 Sep 2018 16:51:50 +0200
Message-Id: <20180913145155.1636-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the ninth iteration of the updated Cedrus driver,
that supports the Video Engine found on most Allwinner SoCs, starting
with the A10. It was tested on the A13, A20, A33 and H3.

The initial version of this driver[0] was originally written and
submitted by Florent Revest using a previous version of the request API
that is necessary to provide coherency between controls and the buffers
they apply to.

The driver was adapted to use the latest version of the media request
API[1], as submitted by Hans Verkuil. Media request API support is a
hard requirement for the Cedrus driver.

The driver itself currently only supports MPEG2 and more codecs will be
added eventually. The default output frame format provided by the Video
Engine is a multi-planar tiled YUV format (based on NV12). A specific
format is introduced in the V4L2 API to describe it. Starting with the
A33, the Video Engine can also output untiled YUV formats.

This implementation is based on the significant work that was conducted
by various members of the linux-sunxi community for understanding and
documenting the Video Engine's innards.

In addition to the media requests API, the following series are required
for Cedrus:
* vicodec: the Virtual Codec driver
* allwinner: a64: add SRAM controller / system control
* SRAM patches from the Cedrus VPU driver series version 5

Changes since v10:
* Moved to strscpy
* Fixed the checkpatch warning
* Fixed the wrongful P-frames mention in the MPEG2 documentation
* Removed the DT patches

Changes since v8:
* Removed dummy job_abort as it is now optional;
* Fixed video device registration order;
* Fixed queue_setup for properly handling CREATE_BUFFERS;
* Switched to single-planar API and applied associated reworks,
  since our formats are not multi-planar V4L2 pixel formats.
* Added validation of the number of buffers associated with the request,
  by modifying the relevant helper as instructed;
* Used strlcpy where needed;
* Applied various minor fixups from suggestions;
* Added some comments for clarity.

Changes since v7:
* Rebased on the latest Request API;
* Brought back comment about DRAM width;
* Fixed building as a module;
* Fixed copyright headers.

Changes since v6:
* Reworked MPEG2 controls to stick closer to the bitstream;
* Updated controls documentation accordingly and added requested fixes;
* Renamed tiled format to V4L2_PIX_FMT_SUNXI_TILED_NV12;
* Added various minor driver fixes based on Hans' feedback;
* Fixed dst frame alignment based on Jernej's feedback and tests;
* Removed set bits for the disabled secondary output.

Changes since v5:
* Added MPEG2 quantization matrices definitions and support;
* Cleaned up registers definitions;
* Moved the driver to staging as requested;
* Removed label and newline in device-tree sources;
* Made it possible to build the driver for COMPILE_TEST;
* Fixed various strict checkpatch warnings;
* Used v4l2_m2m_register_media_controller and MEDIA_ENT_F_PROC_VIDEO_DECODER;
* Moved capabilities to compatible-specific variants;
* Removed overkill buffer checks in device_run;
* Renamed from Sunxi-Cedrus to Cedrus.

Changes since v4:
* updated to version 16 of the media requests API;
* added support for VPU-based untiling (starting with the A33);
* added support for the H3, with SRAM support;
* reworked SRAM support and associated compatibles;
* improved failure paths;
* added some MPEG2 input data validation;
* reworked video/format functions to handle multiple formats;
* removed in-driver buffer queues;
* used a threaded irq instead of a workqueue;
* merged various improvements and cleanups from Maxime;
* renamed MPEG2_SLICE_HEADER to MPEG2_SLICE_PARAMS;
* added prefixes to MPEG2 picture coding types;
* used single-buffer allocations to ensure contiguous planes

Changes since v3:
* updated to version 15 of the media request API;
* got rid of untested MPEG1 support;
* added definitons for picture coding types;
* added documentation about MPEG2 slice header fields;
* added documentation about MPEG2 slice format;
* added documentation about the MB32 NV12 format;
* added MPEG2 slice header validation;
* removed the assigned-clocks property;
* reworked and fixed error paths;
* harmonized debug prints, with v4l2 helpers when applicable;
* checked the series through checkpatch;
* switched to SPDX license headers;
* renamed MPEG2 frame header to slice header for consistency and clarity;
* removed A20 SRAM compatible from the driver's list.

Changes since v2:
* updated to version 13 of the media request API;
* integrated various changes from Maxime Ripard;
* reworked memory reservation to use CMA, dynamic allocation and allow
  DMABUF;
* removed reserved memory binding since the CMA pool is the default one
  (and allow ENODEV in the driver, for that use case);
* added SRAM controller support for the SRAM region used by the VE;
* updated the device-tree bindings the for SRAM region;
* added per-platform bindings;
* added A13 support;
* renamed VE node name and label;
* fixed Florent's authorship for the MPEG2 headers;
* added a MAINTAINERS entry.

Changes since v1:
* use the latest version of the request API for Hans Verkuil;
* added media controller support and dependency
* renamed v4l2 format to the more explicit V4L2_PIX_FMT_MB32_NV12;
* reworked bindings documentation;
* moved driver to drivers/media/platforms/sunxi/cedrus to pair with
  incoming CSI support ;
* added a workqueue and lists to schedule buffer completion, since it
  cannot be done in interrupt context;
* split mpeg2 support into a setup and a trigger function to avoid race
  condition;
* split video-related ops to a dedicated sunxi_cedrus_video file;
* cleaned up the included headers for each file;
* used device PFN offset instead of subtracting PHYS_BASE;
* used reset_control_reset instead of assert+deassert;
* put the device in reset when removing driver;
* changed dt bindings to use the last 96 Mib of the first 256 MiB of
  DRAM;
* made it clear in the mpeg frame header structure that forward and
  backward indexes are used as reference frames for motion vectors;
* lots of small cosmetic and consistency changes, including naming
  harmonization and headers text rework.

Cheers!

[0]: https://patchwork.kernel.org/patch/9299073/
[1]: https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv18-1


Paul Kocialkowski (5):
  media: videobuf2-core: Rework and rename helper for request buffer
    count
  media: v4l: Add definitions for MPEG-2 slice format and metadata
  media: v4l: Add definition for the Sunxi tiled NV12 format
  dt-bindings: media: Document bindings for the Cedrus VPU driver
  media: platform: Add Cedrus VPU decoder driver

 .../devicetree/bindings/media/cedrus.txt      |  54 ++
 .../media/uapi/v4l/extended-controls.rst      | 176 ++++++
 .../media/uapi/v4l/pixfmt-compressed.rst      |  16 +
 .../media/uapi/v4l/pixfmt-reserved.rst        |  13 +
 .../media/uapi/v4l/vidioc-queryctrl.rst       |  14 +-
 .../media/videodev2.h.rst.exceptions          |   2 +
 MAINTAINERS                                   |   7 +
 .../media/common/videobuf2/videobuf2-core.c   |  18 +-
 .../media/common/videobuf2/videobuf2-v4l2.c   |   2 +-
 drivers/media/v4l2-core/v4l2-ctrls.c          |  63 ++
 drivers/media/v4l2-core/v4l2-ioctl.c          |   2 +
 drivers/staging/media/Kconfig                 |   2 +
 drivers/staging/media/Makefile                |   1 +
 drivers/staging/media/sunxi/Kconfig           |  15 +
 drivers/staging/media/sunxi/Makefile          |   1 +
 drivers/staging/media/sunxi/cedrus/Kconfig    |  14 +
 drivers/staging/media/sunxi/cedrus/Makefile   |   3 +
 drivers/staging/media/sunxi/cedrus/TODO       |   7 +
 drivers/staging/media/sunxi/cedrus/cedrus.c   | 431 ++++++++++++++
 drivers/staging/media/sunxi/cedrus/cedrus.h   | 167 ++++++
 .../staging/media/sunxi/cedrus/cedrus_dec.c   |  70 +++
 .../staging/media/sunxi/cedrus/cedrus_dec.h   |  27 +
 .../staging/media/sunxi/cedrus/cedrus_hw.c    | 327 +++++++++++
 .../staging/media/sunxi/cedrus/cedrus_hw.h    |  30 +
 .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 246 ++++++++
 .../staging/media/sunxi/cedrus/cedrus_regs.h  | 235 ++++++++
 .../staging/media/sunxi/cedrus/cedrus_video.c | 542 ++++++++++++++++++
 .../staging/media/sunxi/cedrus/cedrus_video.h |  30 +
 include/media/v4l2-ctrls.h                    |  18 +-
 include/media/videobuf2-core.h                |   4 +-
 include/uapi/linux/v4l2-controls.h            |  65 +++
 include/uapi/linux/videodev2.h                |   6 +
 32 files changed, 2586 insertions(+), 22 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/cedrus.txt
 create mode 100644 drivers/staging/media/sunxi/Kconfig
 create mode 100644 drivers/staging/media/sunxi/Makefile
 create mode 100644 drivers/staging/media/sunxi/cedrus/Kconfig
 create mode 100644 drivers/staging/media/sunxi/cedrus/Makefile
 create mode 100644 drivers/staging/media/sunxi/cedrus/TODO
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus.c
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus.h
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_dec.c
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_dec.h
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_hw.c
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_hw.h
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_regs.h
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_video.c
 create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_video.h

-- 
2.17.1
