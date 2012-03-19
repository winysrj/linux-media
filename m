Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631Ab2CSVrv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 17:47:51 -0400
Message-ID: <4F67A970.8090606@redhat.com>
Date: Mon, 19 Mar 2012 18:47:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Cohen <dacohen@gmail.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	tuukkat76@gmail.com, Kamil Debski <k.debski@samsung.com>,
	Kim HeungJun <riverful@gmail.com>, teturtia@gmail.com,
	pradeep.sawlani@gmail.com
Subject: Re: [GIT PULL FOR v3.4] V4L2 subdev and sensor control changes and
 SMIA++ driver
References: <20120311165650.GA4220@valkosipuli.localdomain>
In-Reply-To: <20120311165650.GA4220@valkosipuli.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 11-03-2012 13:56, Sakari Ailus escreveu:
> Hi Mauro,
> 
> This patchset adds
> 
> - Integer menu controls,
> - Selection IOCTL for subdevs,
> - Sensor control improvements,
> - link_validate() media entity and V4L2 subdev pad ops,
> - OMAP 3 ISP driver improvements,
> - SMIA++ sensor driver and
> - Other V4L2 and media improvements (see individual patches)
> 
> The previous patchset can be found here:
> 
> <URL:http://www.spinics.net/lists/linux-media/msg45052.html>
> 
> Compared to the patchset, I've dropped the rm-696 camera board code and will
> submit it through linux-omap later on. Other changes done to address review
> comments have been also done --- see the URL above for details.
> 
> The following changes since commit 632fba4d012458fd5fedc678fb9b0f8bc59ceda2:
> 
>   [media] cx25821: Add a card definition for "No brand" cards that have: subvendor = 0x0000 subdevice = 0x0000 (2012-03-08 12:42:28 -0300)
> 
> are available in the git repository at:
>   ssh://linuxtv.org/git/sailus/media_tree.git media-for-3.4
> 
> Jesper Juhl (1):
>       adp1653: Remove unneeded include of version.h
> 
> Laurent Pinchart (3):
>       omap3isp: Prevent pipelines that contain a crashed entity from starting
>       omap3isp: Fix crash caused by subdevs now having a pointer to devnodes
>       omap3isp: Fix frame number propagation
> 
> Sakari Ailus (37):
>       v4l: Introduce integer menu controls
>       v4l: Document integer menu controls
>       vivi: Add an integer menu test control
>       v4l: VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION IOCTLs
>       v4l: vdev_to_v4l2_subdev() should have return type "struct v4l2_subdev *"
>       v4l: Check pad number in get try pointer functions
>       v4l: Support s_crop and g_crop through s/g_selection
>       v4l: Add subdev selections documentation: svg and dia files
>       v4l: Add subdev selections documentation

This patch broke docbook compilation:

  HTML    Documentation/DocBook/media_api.html
warning: failed to load external entity "/home/v4l/v4l/patchwork/Documentation/DocBook/vidioc-subdev-g-selection.xml"
/home/v4l/v4l/patchwork/Documentation/DocBook/dev-subdev.xml:310: parser error : Failure to process entity sub-subdev-g-selection
      size configured using &sub-subdev-g-selection; and
                                                    ^
/home/v4l/v4l/patchwork/Documentation/DocBook/dev-subdev.xml:310: parser error : Entity 'sub-subdev-g-selection' not defined
      size configured using &sub-subdev-g-selection; and
                                                    ^
/home/v4l/v4l/patchwork/Documentation/DocBook/dev-subdev.xml:468: parser error : chunk is not well balanced

^
/home/v4l/v4l/patchwork/Documentation/DocBook/v4l2.xml:476: parser error : Failure to process entity sub-dev-subdev
    <section id="subdev"> &sub-dev-subdev; </section>
                                          ^
/home/v4l/v4l/patchwork/Documentation/DocBook/v4l2.xml:476: parser error : Entity 'sub-dev-subdev' not defined
    <section id="subdev"> &sub-dev-subdev; </section>
                                          ^
/usr/bin/xmlto: line 568:  3232 Segmentation fault      "/usr/bin/xsltproc" --nonet --xinclude --param passivetex.extensions '1' -o "/tmp/xmlto.J0M0go/media_api.proc" "/tmp/xmlto-xsl.GKa5kH" "/home/v4l/v4l/patchwork/Documentation/DocBook/media_api.xml"
/bin/cp: cannot stat `*.*htm*': No such file or directory
make[1]: *** [Documentation/DocBook/media_api.html] Error 1
make: *** [htmldocs] Error 2

Please fix.

Regards,
Mauro

>       v4l: Mark VIDIOC_SUBDEV_G_CROP and VIDIOC_SUBDEV_S_CROP obsolete
>       v4l: Image source control class
>       v4l: Image processing control class
>       v4l: Document raw bayer 4CC codes
>       v4l: Add DPCM compressed raw bayer pixel formats
>       media: Add link_validate() op to check links to the sink pad
>       v4l: Improve sub-device documentation for pad ops
>       v4l: Implement v4l2_subdev_link_validate()
>       v4l: Allow changing control handler lock
>       omap3isp: Support additional in-memory compressed bayer formats
>       omap3isp: Move definitions required by board code under include/media.
>       omap3: add definition for CONTROL_CAMERA_PHY_CTRL
>       omap3isp: Move setting constaints above media_entity_pipeline_start
>       omap3isp: Assume media_entity_pipeline_start may fail
>       omap3isp: Add lane configuration to platform data
>       omap3isp: Collect entities that are part of the pipeline
>       omap3isp: Add information on external subdev to struct isp_pipeline
>       omap3isp: Introduce isp_video_check_external_subdevs()
>       omap3isp: Use external rate instead of vpcfg
>       omap3isp: Default link validation for ccp2, csi2, preview and resizer
>       omap3isp: Move CCDC link validation to ccdc_link_validate()
>       omap3isp: Configure CSI-2 phy based on platform data
>       omap3isp: Add resizer data rate configuration to resizer_link_validate
>       omap3isp: Find source pad from external entity
>       smiapp: Generic SMIA++/SMIA PLL calculator
>       smiapp: Add driver
>       omap3isp: Prevent crash at module unload
>       omap3isp: Handle omap3isp_csi2_reset() errors
> 
>  Documentation/DocBook/media/Makefile               |    4 +-
>  Documentation/DocBook/media/v4l/compat.xml         |   19 +-
>  Documentation/DocBook/media/v4l/controls.xml       |  168 ++
>  Documentation/DocBook/media/v4l/dev-subdev.xml     |  202 ++-
>  Documentation/DocBook/media/v4l/pixfmt-srggb10.xml |    2 +-
>  .../DocBook/media/v4l/pixfmt-srggb10dpcm8.xml      |   29 +
>  Documentation/DocBook/media/v4l/pixfmt.xml         |    1 +
>  .../media/v4l/subdev-image-processing-crop.dia     |  614 +++++
>  .../media/v4l/subdev-image-processing-crop.svg     |   63 +
>  .../media/v4l/subdev-image-processing-full.dia     | 1588 +++++++++++
>  .../media/v4l/subdev-image-processing-full.svg     |  163 ++
>  ...ubdev-image-processing-scaling-multi-source.dia | 1152 ++++++++
>  ...ubdev-image-processing-scaling-multi-source.svg |  116 +
>  Documentation/DocBook/media/v4l/v4l2.xml           |   20 +-
>  .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |   12 +
>  .../DocBook/media/v4l/vidioc-queryctrl.xml         |   39 +-
>  .../DocBook/media/v4l/vidioc-subdev-g-crop.xml     |    9 +-
>  .../media/v4l/vidioc-subdev-g-selection.xml        |  228 ++
>  Documentation/media-framework.txt                  |   19 +
>  Documentation/video4linux/4CCs.txt                 |   32 +
>  Documentation/video4linux/v4l2-framework.txt       |   21 +
>  arch/arm/mach-omap2/control.h                      |    1 +
>  drivers/media/media-entity.c                       |   57 +-
>  drivers/media/video/Kconfig                        |    5 +
>  drivers/media/video/Makefile                       |    3 +
>  drivers/media/video/adp1653.c                      |   11 +-
>  drivers/media/video/omap3isp/isp.c                 |   67 +-
>  drivers/media/video/omap3isp/isp.h                 |   11 +-
>  drivers/media/video/omap3isp/ispccdc.c             |   76 +-
>  drivers/media/video/omap3isp/ispccdc.h             |   10 -
>  drivers/media/video/omap3isp/ispccp2.c             |   24 +-
>  drivers/media/video/omap3isp/ispcsi2.c             |   21 +-
>  drivers/media/video/omap3isp/ispcsi2.h             |    1 -
>  drivers/media/video/omap3isp/ispcsiphy.c           |  172 +-
>  drivers/media/video/omap3isp/ispcsiphy.h           |   25 +-
>  drivers/media/video/omap3isp/isppreview.c          |    1 +
>  drivers/media/video/omap3isp/ispresizer.c          |   16 +
>  drivers/media/video/omap3isp/ispvideo.c            |  341 ++--
>  drivers/media/video/omap3isp/ispvideo.h            |    5 +
>  drivers/media/video/smiapp-pll.c                   |  419 +++
>  drivers/media/video/smiapp-pll.h                   |  103 +
>  drivers/media/video/smiapp/Kconfig                 |   13 +
>  drivers/media/video/smiapp/Makefile                |    3 +
>  drivers/media/video/smiapp/smiapp-core.c           | 2832 ++++++++++++++++++++
>  drivers/media/video/smiapp/smiapp-debug.h          |   32 +
>  drivers/media/video/smiapp/smiapp-limits.c         |  132 +
>  drivers/media/video/smiapp/smiapp-limits.h         |  128 +
>  drivers/media/video/smiapp/smiapp-quirk.c          |  264 ++
>  drivers/media/video/smiapp/smiapp-quirk.h          |   72 +
>  drivers/media/video/smiapp/smiapp-reg-defs.h       |  503 ++++
>  drivers/media/video/smiapp/smiapp-reg.h            |  122 +
>  drivers/media/video/smiapp/smiapp-regs.c           |  213 ++
>  drivers/media/video/smiapp/smiapp-regs.h           |   46 +
>  drivers/media/video/smiapp/smiapp.h                |  251 ++
>  drivers/media/video/v4l2-ctrls.c                   |  133 +-
>  drivers/media/video/v4l2-subdev.c                  |  143 +-
>  drivers/media/video/vivi.c                         |   26 +-
>  include/linux/v4l2-subdev.h                        |   41 +
>  include/linux/videodev2.h                          |   26 +-
>  include/media/media-entity.h                       |    5 +-
>  include/media/omap3isp.h                           |   29 +
>  include/media/smiapp.h                             |   83 +
>  include/media/v4l2-ctrls.h                         |   15 +-
>  include/media/v4l2-subdev.h                        |   49 +-
>  64 files changed, 10544 insertions(+), 487 deletions(-)
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
>  create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-crop.dia
>  create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-crop.svg
>  create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-full.dia
>  create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-full.svg
>  create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.dia
>  create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.svg
>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
>  create mode 100644 Documentation/video4linux/4CCs.txt
>  create mode 100644 drivers/media/video/smiapp-pll.c
>  create mode 100644 drivers/media/video/smiapp-pll.h
>  create mode 100644 drivers/media/video/smiapp/Kconfig
>  create mode 100644 drivers/media/video/smiapp/Makefile
>  create mode 100644 drivers/media/video/smiapp/smiapp-core.c
>  create mode 100644 drivers/media/video/smiapp/smiapp-debug.h
>  create mode 100644 drivers/media/video/smiapp/smiapp-limits.c
>  create mode 100644 drivers/media/video/smiapp/smiapp-limits.h
>  create mode 100644 drivers/media/video/smiapp/smiapp-quirk.c
>  create mode 100644 drivers/media/video/smiapp/smiapp-quirk.h
>  create mode 100644 drivers/media/video/smiapp/smiapp-reg-defs.h
>  create mode 100644 drivers/media/video/smiapp/smiapp-reg.h
>  create mode 100644 drivers/media/video/smiapp/smiapp-regs.c
>  create mode 100644 drivers/media/video/smiapp/smiapp-regs.h
>  create mode 100644 drivers/media/video/smiapp/smiapp.h
>  create mode 100644 include/media/smiapp.h
> 
> 
> Kind regards,
> 

