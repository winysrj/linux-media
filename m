Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:52805 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab1I2PZT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 11:25:19 -0400
Date: Thu, 29 Sep 2011 17:25:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PULL] soc-camera, v4l for 3.2
Message-ID: <Pine.LNX.4.64.1109291714560.1082@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

I'm finally ready to push my soc-camera and generic v4l collection for 
3.2. The absolute highlight is, of course, the addition of the two new 
IOCTLs, which, I think, are now in a good shape to go. A huge pile of 
soc-camera patches, largely releasing subdevice drivers into the wild for 
all subdevice API compatible bridge drivers, the addition of the control 
framework to soc-camera - thanks to Hans Verkuil. A few patches outside of 
the V4L / media area are supplied with respective acks. I think, this is 
going to be my largest push so far.

The following changes since commit 446b792c6bd87de4565ba200b75a708b4c575a06:

  [media] media: DocBook: Fix trivial typo in Sub-device Interface (2011-09-27 09:14:58 -0300)

are available in the git repository at:
  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.2

Bastian Hecht (1):
      media: ov5642: Add support for arbitrary resolution

Guennadi Liakhovetski (86):
      V4L: mt9p031 and mt9t001 drivers depend on VIDEO_V4L2_SUBDEV_API
      V4L: sh_mobile_ceu_camera: output image sizes must be a multiple of 4
      V4L: sh_mobile_ceu_camera: don't try to improve client scaling, if perfect
      V4L: sh_mobile_ceu_camera: fix field addresses in interleaved mode
      V4L: sh_mobile_ceu_camera: remove duplicated code
      V4L: imx074: support the new mbus-config subdev ops
      V4L: soc-camera: add helper functions for new bus configuration type
      V4L: mt9m001: support the new mbus-config subdev ops
      V4L: mt9m111: support the new mbus-config subdev ops
      V4L: mt9t031: support the new mbus-config subdev ops
      V4L: mt9t112: support the new mbus-config subdev ops
      V4L: mt9v022: support the new mbus-config subdev ops
      V4L: ov2640: support the new mbus-config subdev ops
      V4L: ov5642: support the new mbus-config subdev ops
      V4L: ov6650: support the new mbus-config subdev ops
      V4L: ov772x: rename macros to not pollute the global namespace
      V4L: ov772x: support the new mbus-config subdev ops
      V4L: ov9640: support the new mbus-config subdev ops
      V4L: ov9740: support the new mbus-config subdev ops
      V4L: rj54n1cb0c: support the new mbus-config subdev ops
      ARM: ap4evb: switch imx074 configuration to default number of lanes
      V4L: sh_mobile_csi2: verify client compatibility
      V4L: sh_mobile_csi2: support the new mbus-config subdev ops
      V4L: tw9910: remove a not really implemented cropping support
      V4L: tw9910: support the new mbus-config subdev ops
      V4L: soc_camera_platform: support the new mbus-config subdev ops
      V4L: soc-camera: compatible bus-width flags
      ARM: mach-shmobile: convert mackerel to mediabus flags
      sh: convert ap325rxa to mediabus flags
      ARM: PXA: use gpio_set_value_cansleep() on pcm990
      V4L: atmel-isi: convert to the new mbus-config subdev operations
      V4L: mx1_camera: convert to the new mbus-config subdev operations
      V4L: mx2_camera: convert to the new mbus-config subdev operations
      V4L: ov2640: remove undefined struct
      V4L: mx3_camera: convert to the new mbus-config subdev operations
      V4L: mt9m001, mt9v022: add a clarifying comment
      V4L: omap1_camera: convert to the new mbus-config subdev operations
      V4L: pxa_camera: convert to the new mbus-config subdev operations
      V4L: sh_mobile_ceu_camera: convert to the new mbus-config subdev operations
      V4L: soc-camera: camera client operations no longer compulsory
      V4L: mt9m001: remove superfluous soc-camera client operations
      V4L: mt9m111: remove superfluous soc-camera client operations
      V4L: imx074: remove superfluous soc-camera client operations
      V4L: mt9t031: remove superfluous soc-camera client operations
      V4L: mt9t112: remove superfluous soc-camera client operations
      V4L: mt9v022: remove superfluous soc-camera client operations
      V4L: ov2640: remove superfluous soc-camera client operations
      V4L: ov5642: remove superfluous soc-camera client operations
      V4L: ov6650: remove superfluous soc-camera client operations
      sh: ap3rxa: remove redundant soc-camera platform data fields
      sh: migor: remove unused ov772x buswidth flag
      V4L: ov772x: remove superfluous soc-camera client operations
      V4L: ov9640: remove superfluous soc-camera client operations
      V4L: ov9740: remove superfluous soc-camera client operations
      V4L: rj54n1cb0c: remove superfluous soc-camera client operations
      V4L: sh_mobile_csi2: remove superfluous soc-camera client operations
      ARM: mach-shmobile: mackerel doesn't need legacy SOCAM_* flags anymore
      V4L: soc_camera_platform: remove superfluous soc-camera client operations
      V4L: tw9910: remove superfluous soc-camera client operations
      V4L: soc-camera: remove soc-camera client bus-param operations and supporting code
      V4L: mt9t112: fix broken cropping and scaling
      V4L: sh-mobile-ceu-camera: fix mixed CSI2 & parallel camera case
      V4L: omap1-camera: fix Oops with NULL platform data
      V4L: add a new videobuf2 buffer state VB2_BUF_STATE_PREPARED
      V4L: add two new ioctl()s for multi-size videobuffer management
      V4L: videobuf2: update buffer state on VIDIOC_QBUF
      V4L: document the new VIDIOC_CREATE_BUFS and VIDIOC_PREPARE_BUF ioctl()s
      V4L: vb2: prepare to support multi-size buffers
      V4L: vb2: add support for buffers of different sizes on a single queue
      V4L: sh-mobile-ceu-camera: prepare to support multi-size buffers
      dmaengine: ipu-idmac: add support for the DMA_PAUSE control
      V4L: mx3-camera: prepare to support multi-size buffers
      V4L: soc-camera: add 2 new ioctl() handlers
      V4L: sh_mobile_ceu_camera: the host shall configure the pipeline
      V4L: sh_mobile_csi2: do not guess the client, the host tells us
      V4L: soc-camera: split a function into two
      V4L: soc_camera_platform: do not leave dangling invalid pointers
      V4L: soc-camera: call subdevice .s_power() method, when powering up or down
      V4L: docbook documentation for struct v4l2_create_buffers
      V4L: soc-camera: start removing struct soc_camera_device from client drivers
      V4L: mt9m001, mt9v022: use internally cached pixel code
      V4L: sh_mobile_csi2: fix unbalanced pm_runtime_put()
      V4L: dynamically allocate video_device nodes in subdevices
      V4L: add .g_std() core V4L2 subdevice operation
      V4L: soc-camera: make (almost) all client drivers re-usable outside of the framework
      V4L: replace soc-camera specific soc_mediabus.h with v4l2-mediabus.h

Hans Verkuil (13):
      soc_camera: add control handler support
      sh_mobile_ceu_camera: implement the control handler.
      ov9640: convert to the control framework.
      ov772x: convert to the control framework.
      rj54n1cb0c: convert to the control framework.
      mt9v022: convert to the control framework.
      ov2640: convert to the control framework.
      ov6650: convert to the control framework.
      ov9740: convert to the control framework.
      mt9m001: convert to the control framework.
      mt9m111: convert to the control framework.
      mt9t031: convert to the control framework.
      soc_camera: remove the now obsolete struct soc_camera_ops

Janusz Krzysztofik (1):
      media: ov6650: stylistic improvements

 Documentation/DocBook/media/v4l/compat.xml         |    3 +
 Documentation/DocBook/media/v4l/io.xml             |   27 +
 Documentation/DocBook/media/v4l/v4l2.xml           |    2 +
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |  147 ++++++
 .../DocBook/media/v4l/vidioc-prepare-buf.xml       |   96 ++++
 arch/arm/mach-pxa/pcm990-baseboard.c               |    4 +-
 arch/arm/mach-shmobile/board-ap4evb.c              |    2 +-
 arch/arm/mach-shmobile/board-mackerel.c            |    7 +-
 arch/sh/boards/mach-ap325rxa/setup.c               |   10 +-
 arch/sh/boards/mach-migor/setup.c                  |    4 +-
 drivers/dma/ipu/ipu_idmac.c                        |   65 ++-
 drivers/media/video/Kconfig                        |    4 +-
 drivers/media/video/atmel-isi.c                    |  142 +++---
 drivers/media/video/imx074.c                       |   54 +--
 drivers/media/video/marvell-ccic/mcam-core.c       |    3 +-
 drivers/media/video/mem2mem_testdev.c              |    7 +-
 drivers/media/video/mt9m001.c                      |  328 +++++--------
 drivers/media/video/mt9m111.c                      |  260 +++--------
 drivers/media/video/mt9t031.c                      |  347 ++++++--------
 drivers/media/video/mt9t112.c                      |  269 +++++------
 drivers/media/video/mt9v022.c                      |  447 +++++++----------
 drivers/media/video/mx1_camera.c                   |   71 ++--
 drivers/media/video/mx2_camera.c                   |   78 ++--
 drivers/media/video/mx3_camera.c                   |  357 +++++++-------
 drivers/media/video/omap1_camera.c                 |   62 ++-
 drivers/media/video/ov2640.c                       |  178 ++-----
 drivers/media/video/ov5642.c                       |  288 +++++++-----
 drivers/media/video/ov6650.c                       |  504 +++++++-------------
 drivers/media/video/ov772x.c                       |  198 +++-----
 drivers/media/video/ov9640.c                       |  186 +++-----
 drivers/media/video/ov9640.h                       |    4 +-
 drivers/media/video/ov9740.c                       |  151 +++----
 drivers/media/video/pwc/pwc-if.c                   |    6 +-
 drivers/media/video/pxa_camera.c                   |  140 +++---
 drivers/media/video/rj54n1cb0c.c                   |  223 +++------
 drivers/media/video/s5p-fimc/fimc-capture.c        |    6 +-
 drivers/media/video/s5p-fimc/fimc-core.c           |    6 +-
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c          |    7 +-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c          |    5 +-
 drivers/media/video/s5p-tv/mixer_video.c           |    4 +-
 drivers/media/video/sh_mobile_ceu_camera.c         |  489 +++++++++++--------
 drivers/media/video/sh_mobile_csi2.c               |  132 ++++--
 drivers/media/video/soc_camera.c                   |  273 ++++++-----
 drivers/media/video/soc_camera_platform.c          |   45 +--
 drivers/media/video/soc_mediabus.c                 |   33 ++
 drivers/media/video/tw9910.c                       |  268 +++++------
 drivers/media/video/v4l2-compat-ioctl32.c          |   76 +++-
 drivers/media/video/v4l2-device.c                  |   36 ++-
 drivers/media/video/v4l2-ioctl.c                   |   36 ++
 drivers/media/video/videobuf2-core.c               |  360 +++++++++++---
 drivers/media/video/vivi.c                         |    6 +-
 include/linux/videodev2.h                          |   26 +
 include/media/ov772x.h                             |   26 +-
 include/media/soc_camera.h                         |  104 ++---
 include/media/soc_camera_platform.h                |    4 +-
 include/media/soc_mediabus.h                       |    2 +
 include/media/v4l2-ioctl.h                         |    2 +
 include/media/v4l2-subdev.h                        |    5 +-
 include/media/videobuf2-core.h                     |   43 ++-
 59 files changed, 3331 insertions(+), 3337 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
