Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56742 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750950Ab2EINzv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 May 2012 09:55:51 -0400
Date: Wed, 9 May 2012 16:55:46 +0300
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
Subject: [GIT PULL FOR v3.5 v3] V4L2 subdev and sensor control changes
Message-ID: <20120509135546.GB3373@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patchset adds

- Sensor control improvements,
- link_validate() media entity and V4L2 subdev pad ops,
- Other V4L2 and media improvements (see individual patches),
- SMIA++ driver

Changes since pull for 3.5 v2:

- Put back the SMIA++ driver and the adp1653 patch. They have nothing to do
  with the few OMAP 3 ISP patches that have been postponed. The remaining
  OMAP 3 ISP patches are available in the media-for-3.5-omap3isp branch.

Changes since pull for 3.5 v1:

- Rebased on top of current linux-media
- Postponed some patches

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

The following changes since commit 121b3ddbe4ad17df77cb7284239be0a63d9a66bd:

  [media] media: videobuf2-dma-contig: quiet sparse noise about plain integer as NULL pointer (2012-05-08 14:35:14 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.5

Jesper Juhl (1):
      adp1653: Remove unneeded include of version.h

Sakari Ailus (21):
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
      omap3isp: Move setting constaints above media_entity_pipeline_start
      omap3isp: Assume media_entity_pipeline_start may fail
      omap3isp: Add lane configuration to platform data
      omap3isp: Refactor collecting information on entities in pipeline
      omap3isp: Add information on external subdev to struct isp_pipeline
      omap3isp: Introduce isp_video_check_external_subdevs()
      omap3isp: Use external rate instead of vpcfg
      omap3isp: Default link validation for ccp2, csi2, preview and resizer
      omap3isp: Move CCDC link validation to ccdc_link_validate()
      smiapp: Generic SMIA++/SMIA PLL calculator
      smiapp: Add driver

 Documentation/DocBook/media/v4l/controls.xml       |  168 ++
 Documentation/DocBook/media/v4l/pixfmt-srggb10.xml |    2 +-
 .../DocBook/media/v4l/pixfmt-srggb10dpcm8.xml      |   29 +
 Documentation/DocBook/media/v4l/pixfmt.xml         |    6 +-
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |   12 +
 Documentation/media-framework.txt                  |   19 +
 Documentation/video4linux/4CCs.txt                 |   32 +
 Documentation/video4linux/v4l2-framework.txt       |   21 +
 drivers/media/media-entity.c                       |   57 +-
 drivers/media/video/Kconfig                        |    3 +
 drivers/media/video/Makefile                       |    3 +
 drivers/media/video/adp1653.c                      |   10 +-
 drivers/media/video/omap3isp/isp.c                 |   14 -
 drivers/media/video/omap3isp/isp.h                 |    5 -
 drivers/media/video/omap3isp/ispccdc.c             |   71 +-
 drivers/media/video/omap3isp/ispccdc.h             |   10 -
 drivers/media/video/omap3isp/ispccp2.c             |    1 +
 drivers/media/video/omap3isp/ispcsi2.c             |    1 +
 drivers/media/video/omap3isp/ispcsiphy.h           |   15 +-
 drivers/media/video/omap3isp/isppreview.c          |    1 +
 drivers/media/video/omap3isp/ispresizer.c          |    1 +
 drivers/media/video/omap3isp/ispvideo.c            |  307 ++-
 drivers/media/video/omap3isp/ispvideo.h            |    3 +
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
 drivers/media/video/v4l2-ctrls.c                   |   60 +-
 drivers/media/video/v4l2-subdev.c                  |   64 +
 drivers/media/video/vivi.c                         |    4 +-
 include/linux/videodev2.h                          |   20 +
 include/media/media-entity.h                       |    5 +-
 include/media/omap3isp.h                           |   29 +
 include/media/smiapp.h                             |   83 +
 include/media/v4l2-ctrls.h                         |    9 +-
 include/media/v4l2-subdev.h                        |   12 +
 47 files changed, 5984 insertions(+), 226 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
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
