Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60644 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755780Ab2DJTgF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 15:36:05 -0400
Date: Tue, 10 Apr 2012 22:35:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: mchehab@redhat.com,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Cohen <dacohen@gmail.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	tuukkat76@gmail.com, Kamil Debski <k.debski@samsung.com>,
	Kim HeungJun <riverful@gmail.com>, teturtia@gmail.com,
	pradeep.sawlani@gmail.com
Subject: [GIT PULL FOR v3.5 v2] V4L2 subdev and sensor control changes and
 SMIA++ driver
Message-ID: <20120410193559.GB4552@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patchset adds

- Integer menu controls,
- Selection IOCTL for subdevs,
- Sensor control improvements,
- link_validate() media entity and V4L2 subdev pad ops,
- OMAP 3 ISP driver improvements,
- SMIA++ sensor driver and
- Other V4L2 and media improvements (see individual patches)

Changes since pull for 3.5 v1:

- Rebased on top of for_v3.5 branch --- some of the earlier patches are
  included in that branch: integer menu and subdev selections
  (apart from docs)
- Fix DocBook build warnings in subdev selections and DPCM compressed raw
  bayer pixel format documentation

Changes since pull for 3.4 v3:

- Changed kernel revision and V4L2 changelog dates appropriately for Linux
  3.5.

Changes since pull v2:

- Fixed incorrect 4CC codes in documentation for compresed raw bayer formats

Changes since pull v1:

- Correct selection rectangle field description in subdev selection
  documentation (thanks to Sylwester)
- Use roundup() instead of ALIGN() in SMIA++ driver
- Rebased on current media_tree.git/staging/for_v3.4

---

The following changes since commit ecd9acbf545a0d7191478eea8a14331baf5ed121:

  [media] s5p-fimc: Handle sub-device interdependencies using deferred probing (2012-04-10 15:25:25 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.5

Jesper Juhl (1):
      adp1653: Remove unneeded include of version.h

Laurent Pinchart (2):
      omap3isp: Prevent pipelines that contain a crashed entity from starting
      omap3isp: Fix frame number propagation

Sakari Ailus (30):
      v4l: Add subdev selections documentation: svg and dia files
      v4l: Add subdev selections documentation
      v4l: Mark VIDIOC_SUBDEV_G_CROP and VIDIOC_SUBDEV_S_CROP obsolete
      v4l: Image source control class
      v4l: Image processing control class
      v4l: Document raw bayer 4CC codes
      v4l: Add DPCM compressed raw bayer pixel formats
      media: Add link_validate() op to check links to the sink pad
      v4l: Improve sub-device documentation for pad ops
      v4l: Implement v4l2_subdev_link_validate()
      v4l: Allow changing control handler lock
      omap3isp: Support additional in-memory compressed bayer formats
      omap3isp: Move definitions required by board code under include/media.
      omap3: add definition for CONTROL_CAMERA_PHY_CTRL
      omap3isp: Move setting constaints above media_entity_pipeline_start
      omap3isp: Assume media_entity_pipeline_start may fail
      omap3isp: Add lane configuration to platform data
      omap3isp: Collect entities that are part of the pipeline
      omap3isp: Add information on external subdev to struct isp_pipeline
      omap3isp: Introduce isp_video_check_external_subdevs()
      omap3isp: Use external rate instead of vpcfg
      omap3isp: Default link validation for ccp2, csi2, preview and resizer
      omap3isp: Move CCDC link validation to ccdc_link_validate()
      omap3isp: Configure CSI-2 phy based on platform data
      omap3isp: Add resizer data rate configuration to resizer_link_validate
      omap3isp: Find source pad from external entity
      smiapp: Generic SMIA++/SMIA PLL calculator
      smiapp: Add driver
      omap3isp: Prevent crash at module unload
      omap3isp: Handle omap3isp_csi2_reset() errors

 Documentation/DocBook/media/Makefile               |    4 +-
 Documentation/DocBook/media/v4l/compat.xml         |   16 +
 Documentation/DocBook/media/v4l/controls.xml       |  168 ++
 Documentation/DocBook/media/v4l/dev-subdev.xml     |  202 ++-
 Documentation/DocBook/media/v4l/pixfmt-srggb10.xml |    2 +-
 .../DocBook/media/v4l/pixfmt-srggb10dpcm8.xml      |   29 +
 Documentation/DocBook/media/v4l/pixfmt.xml         |    6 +-
 .../media/v4l/subdev-image-processing-crop.dia     |  614 +++++
 .../media/v4l/subdev-image-processing-crop.svg     |   63 +
 .../media/v4l/subdev-image-processing-full.dia     | 1588 +++++++++++
 .../media/v4l/subdev-image-processing-full.svg     |  163 ++
 ...ubdev-image-processing-scaling-multi-source.dia | 1152 ++++++++
 ...ubdev-image-processing-scaling-multi-source.svg |  116 +
 Documentation/DocBook/media/v4l/v4l2.xml           |   15 +-
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |   12 +
 .../DocBook/media/v4l/vidioc-subdev-g-crop.xml     |    9 +-
 .../media/v4l/vidioc-subdev-g-selection.xml        |  228 ++
 Documentation/media-framework.txt                  |   19 +
 Documentation/video4linux/4CCs.txt                 |   32 +
 Documentation/video4linux/v4l2-framework.txt       |   21 +
 arch/arm/mach-omap2/control.h                      |    1 +
 drivers/media/media-entity.c                       |   57 +-
 drivers/media/video/Kconfig                        |    3 +
 drivers/media/video/Makefile                       |    3 +
 drivers/media/video/adp1653.c                      |   11 +-
 drivers/media/video/omap3isp/isp.c                 |   67 +-
 drivers/media/video/omap3isp/isp.h                 |   11 +-
 drivers/media/video/omap3isp/ispccdc.c             |   74 +-
 drivers/media/video/omap3isp/ispccdc.h             |   10 -
 drivers/media/video/omap3isp/ispccp2.c             |   24 +-
 drivers/media/video/omap3isp/ispcsi2.c             |   21 +-
 drivers/media/video/omap3isp/ispcsi2.h             |    1 -
 drivers/media/video/omap3isp/ispcsiphy.c           |  172 +-
 drivers/media/video/omap3isp/ispcsiphy.h           |   25 +-
 drivers/media/video/omap3isp/isppreview.c          |    1 +
 drivers/media/video/omap3isp/ispresizer.c          |   16 +
 drivers/media/video/omap3isp/ispvideo.c            |  341 ++--
 drivers/media/video/omap3isp/ispvideo.h            |    5 +
 drivers/media/video/smiapp-pll.c                   |  419 +++
 drivers/media/video/smiapp-pll.h                   |  103 +
 drivers/media/video/smiapp/Kconfig                 |   13 +
 drivers/media/video/smiapp/Makefile                |    3 +
 drivers/media/video/smiapp/smiapp-core.c           | 2832 ++++++++++++++++++++
 drivers/media/video/smiapp/smiapp-debug.h          |   32 +
 drivers/media/video/smiapp/smiapp-limits.c         |  132 +
 drivers/media/video/smiapp/smiapp-limits.h         |  128 +
 drivers/media/video/smiapp/smiapp-quirk.c          |  264 ++
 drivers/media/video/smiapp/smiapp-quirk.h          |   72 +
 drivers/media/video/smiapp/smiapp-reg-defs.h       |  503 ++++
 drivers/media/video/smiapp/smiapp-reg.h            |  122 +
 drivers/media/video/smiapp/smiapp-regs.c           |  213 ++
 drivers/media/video/smiapp/smiapp-regs.h           |   46 +
 drivers/media/video/smiapp/smiapp.h                |  251 ++
 drivers/media/video/v4l2-ctrls.c                   |   59 +-
 drivers/media/video/v4l2-subdev.c                  |   64 +
 drivers/media/video/vivi.c                         |    4 +-
 include/linux/videodev2.h                          |   20 +
 include/media/media-entity.h                       |    5 +-
 include/media/omap3isp.h                           |   29 +
 include/media/smiapp.h                             |   83 +
 include/media/v4l2-ctrls.h                         |    9 +-
 include/media/v4l2-subdev.h                        |   12 +
 62 files changed, 10280 insertions(+), 440 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-crop.dia
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-crop.svg
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-full.dia
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-full.svg
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.dia
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.svg
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
 create mode 100644 Documentation/video4linux/4CCs.txt
 create mode 100644 drivers/media/video/smiapp-pll.c
 create mode 100644 drivers/media/video/smiapp-pll.h
 create mode 100644 drivers/media/video/smiapp/Kconfig
 create mode 100644 drivers/media/video/smiapp/Makefile
 create mode 100644 drivers/media/video/smiapp/smiapp-core.c
 create mode 100644 drivers/media/video/smiapp/smiapp-debug.h
 create mode 100644 drivers/media/video/smiapp/smiapp-limits.c
 create mode 100644 drivers/media/video/smiapp/smiapp-limits.h
 create mode 100644 drivers/media/video/smiapp/smiapp-quirk.c
 create mode 100644 drivers/media/video/smiapp/smiapp-quirk.h
 create mode 100644 drivers/media/video/smiapp/smiapp-reg-defs.h
 create mode 100644 drivers/media/video/smiapp/smiapp-reg.h
 create mode 100644 drivers/media/video/smiapp/smiapp-regs.c
 create mode 100644 drivers/media/video/smiapp/smiapp-regs.h
 create mode 100644 drivers/media/video/smiapp/smiapp.h
 create mode 100644 include/media/smiapp.h


Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
