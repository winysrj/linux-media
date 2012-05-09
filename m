Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56578 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751071Ab2EIGeW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 9 May 2012 02:34:22 -0400
Date: Wed, 9 May 2012 09:34:16 +0300
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
Subject: [GIT PULL FOR v3.5 v2] V4L2 subdev and sensor control changes
Message-ID: <20120509063416.GM852@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This patchset adds

- Sensor control improvements,
- link_validate() media entity and V4L2 subdev pad ops,
- Other V4L2 and media improvements (see individual patches)

The SMIA++ driver and some of the OMAP3 ISP driver improvements have been
removed from this patchset since they are now dependent on other patches for
linux-omap tree:

<URL:http://www.spinics.net/lists/linux-omap/msg69914.html>

Integer menu controls and the subdev selection support has already been
pulled.

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

Sakari Ailus (19):
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

 Documentation/DocBook/media/v4l/controls.xml       |  168 +++++++++++
 Documentation/DocBook/media/v4l/pixfmt-srggb10.xml |    2 +-
 .../DocBook/media/v4l/pixfmt-srggb10dpcm8.xml      |   29 ++
 Documentation/DocBook/media/v4l/pixfmt.xml         |    6 +-
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |   12 +
 Documentation/media-framework.txt                  |   19 ++
 Documentation/video4linux/4CCs.txt                 |   32 ++
 Documentation/video4linux/v4l2-framework.txt       |   21 ++
 drivers/media/media-entity.c                       |   57 ++++-
 drivers/media/video/adp1653.c                      |    8 +-
 drivers/media/video/omap3isp/isp.c                 |   14 -
 drivers/media/video/omap3isp/isp.h                 |    5 -
 drivers/media/video/omap3isp/ispccdc.c             |   71 +++++-
 drivers/media/video/omap3isp/ispccdc.h             |   10 -
 drivers/media/video/omap3isp/ispccp2.c             |    1 +
 drivers/media/video/omap3isp/ispcsi2.c             |    1 +
 drivers/media/video/omap3isp/ispcsiphy.h           |   15 +-
 drivers/media/video/omap3isp/isppreview.c          |    1 +
 drivers/media/video/omap3isp/ispresizer.c          |    1 +
 drivers/media/video/omap3isp/ispvideo.c            |  307 +++++++++++---------
 drivers/media/video/omap3isp/ispvideo.h            |    3 +
 drivers/media/video/v4l2-ctrls.c                   |   60 +++--
 drivers/media/video/v4l2-subdev.c                  |   64 ++++
 drivers/media/video/vivi.c                         |    4 +-
 include/linux/videodev2.h                          |   20 ++
 include/media/media-entity.h                       |    5 +-
 include/media/omap3isp.h                           |   29 ++
 include/media/v4l2-ctrls.h                         |    9 +-
 include/media/v4l2-subdev.h                        |   12 +
 29 files changed, 761 insertions(+), 225 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
 create mode 100644 Documentation/video4linux/4CCs.txt


Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
