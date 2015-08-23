Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58869 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbbHWUSI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 16:18:08 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v7 00/44] MC next generation patches
Date: Sun, 23 Aug 2015 17:17:17 -0300
Message-Id: <cover.1440359643.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The latest version of this patch series is at:
	http://git.linuxtv.org/cgit.cgi/mchehab/experimental.git/log/?h=mc_next_gen

The latest version of the userspace tool to test it is at:
	http://git.linuxtv.org/cgit.cgi/mchehab/experimental-v4l-utils.git/log/?h=mc-next-gen

The initial patches of this series are the same as the ones at the
	"[PATCH v6 0/8] MC preparation patches"
plus Javier patch series:
	"[PATCH 0/4] [media] Media entity cleanups and build fixes"
Addressing some of the concerns from Laurent:
	Javier media_entity_id() patches got reordered;
	all "elements" occurrences were replaced by "objects"

The patches of this part are:
	media: create a macro to get entity ID
	staging: omap4iss: get entity ID using media_entity_id()
	omap3isp: get entity ID using media_entity_id()
	media: add a common struct to be embed on media graph objects
	media: use media_gobj inside entities
	media: use media_gobj inside pads
	media: use media_gobj inside links
	media: add messages when media device gets (un)registered
	media: add a debug message to warn about gobj creation/removal
	media: rename the function that create pad links
	media: use entity.graph_obj.mdev instead of .parent
	media: remove media entity .parent field

The next set of patches add the interface types as defined by
Hans Verkuil "[RFC] Media Controller, the next generation" proposal:
	uapi/media.h: Declare interface types
	media: add functions to allow creating interfaces
	media: get rid of an unused code
	media: convert links from array to list
	media: make add link more generic
	media: make media_link more generic to handle interace links
	media: make link debug printk more generic
	media: add support to link interfaces and entities
	dvbdev: add support for interfaces
	media: add a linked list to track interfaces by mdev
	dvbdev: add support for indirect interface links

The next part in this series fix the API namespace, making them
to match what it was defined by Hans Verkuil's:
	"[RFC] Media Controller, the next generation"

It basically contains most of the changes that was done on my
RFC patch series:
	"[PATCH 00/18] Remove media controller entity subtypes and rename types"

And constitutes on the following patches:
	uapi/media.h: Fix entity namespace
	replace all occurrences of MEDIA_ENT_T_DEVNODE_V4L
	replace all occurrences of MEDIA_ENT_T_DEVNODE_DVB
	media: add macros to check if subdev or V4L2 DMA
	media: use macros to check for V4L2 subdev entities
	omap3/omap4/davinci: get rid of MEDIA_ENT_T_V4L2_SUBDEV abuse
	s5c73m3: fix subdev type
	s5k5baf: fix subdev type
	davinci_vbpe: stop MEDIA_ENT_T_V4L2_SUBDEV abuse
	omap4iss: stop MEDIA_ENT_T_V4L2_SUBDEV abuse
	v4l2-subdev: use MEDIA_ENT_T_UNKNOWN for new subdevs
	media controller: get rid of entity subtype on Kernel
	DocBook: update descriptions for the media controller entities
	dvb: modify core to implement interfaces/entities at MC new gen
	media: report if a pad is sink or source at debug msg

It is basically renaming stuff, plus some fixups for some driver
abuses of the legacy namespace.

Finally, the final series introduce the MEDIA_IOC_G_TOPOLOGY ioctl at
the media.h header, and do the needed changes at the drivers side
to implement support for it:
	uapi/media.h: Add MEDIA_IOC_G_TOPOLOGY ioctl
	media: Use a macro to interate between all interfaces
	media: move mdev list init to gobj
	media-device: add pads and links to media_device
	media_device: add a topology version field

The new API can be tested using the 3 patch series I made for
v4l-utils.

TODO:
	- Add interfaces for V4L2 capture and output;
	- Add interfaces for subdevs;
	- Remove lots of fields from media_entity that will
	  become obsolete with the new API addition
	  (major, minor, group_id, num_links, num_pads, num_backlinks)
	- Address dynamic support for entities/interfaces/links.
	  I suspect that not much is needed here, but locks need to
	  be checked.
	- Add dynamic support for PADs. This should be the harder
	  pending item, I think.

Javier Martinez Canillas (4):
  [media] staging: omap4iss: get entity ID using media_entity_id()
  [media] omap3isp: get entity ID using media_entity_id()
  [media] media: use entity.graph_obj.mdev instead of .parent
  [media] media: remove media entity .parent field

Mauro Carvalho Chehab (40):
  [media] media: create a macro to get entity ID
  [media] media: add a common struct to be embed on media graph objects
  [media] media: use media_gobj inside entities
  [media] media: use media_gobj inside pads
  [media] media: use media_gobj inside links
  [media] media: add messages when media device gets (un)registered
  [media] media: add a debug message to warn about gobj creation/removal
  [media] media: rename the function that create pad links
  [media] uapi/media.h: Declare interface types
  [media] media: add functions to allow creating interfaces
  [media] media: get rid of an unused code
  [media] media: convert links from array to list
  [media] media: make add link more generic
  [media] media: make media_link more generic to handle interace links
  [media] media: make link debug printk more generic
  [media] media: add support to link interfaces and entities
  [media] dvbdev: add support for interfaces
  [media] media: add a linked list to track interfaces by mdev
  [media] dvbdev: add support for indirect interface links
  [media] uapi/media.h: Fix entity namespace
  [media] replace all occurrences of MEDIA_ENT_T_DEVNODE_V4L
  [media] replace all occurrences of MEDIA_ENT_T_DEVNODE_DVB
  [media] media: add macros to check if subdev or V4L2 DMA
  [media] media: use macros to check for V4L2 subdev entities
  [media] omap3/omap4/davinci: get rid of MEDIA_ENT_T_V4L2_SUBDEV abuse
  [media] s5c73m3: fix subdev type
  [media] s5k5baf: fix subdev type
  [media] davinci_vbpe: stop MEDIA_ENT_T_V4L2_SUBDEV abuse
  [media] omap4iss: stop MEDIA_ENT_T_V4L2_SUBDEV abuse
  [media] v4l2-subdev: use MEDIA_ENT_T_UNKNOWN for new subdevs
  [media] media controller: get rid of entity subtype on Kernel
  [media] DocBook: update descriptions for the media controller entities
  [media] dvb: modify core to implement interfaces/entities at MC new
    gen
  [media] media: report if a pad is sink or source at debug msg
  [media] uapi/media.h: Add MEDIA_IOC_G_TOPOLOGY ioctl
  [media] media: Use a macro to interate between all interfaces
  [media] media: move mdev list init to gobj
  [media] media-device: add pads and links to media_device
  [media] media_device: add a topology version field
  [media] media-device: add support for MEDIA_IOC_G_TOPOLOGY ioctl

 .../DocBook/media/v4l/media-ioc-enum-entities.xml  |  57 ++-
 Documentation/media-framework.txt                  |   2 +-
 drivers/media/dvb-core/dmxdev.c                    |   4 +-
 drivers/media/dvb-core/dvb_ca_en50221.c            |   2 +-
 drivers/media/dvb-core/dvb_frontend.c              |  11 +-
 drivers/media/dvb-core/dvb_net.c                   |   2 +-
 drivers/media/dvb-core/dvbdev.c                    | 274 ++++++++++---
 drivers/media/dvb-core/dvbdev.h                    |  10 +-
 drivers/media/firewire/firedtv-ci.c                |   2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   8 +-
 drivers/media/i2c/s5k5baf.c                        |   4 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   4 +-
 drivers/media/media-device.c                       | 207 ++++++++--
 drivers/media/media-entity.c                       | 439 ++++++++++++++++-----
 drivers/media/pci/bt8xx/dst_ca.c                   |   3 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |   2 +-
 drivers/media/pci/ngene/ngene-core.c               |   2 +-
 drivers/media/pci/ttpci/av7110.c                   |   2 +-
 drivers/media/pci/ttpci/av7110_av.c                |   4 +-
 drivers/media/pci/ttpci/av7110_ca.c                |   2 +-
 drivers/media/platform/exynos4-is/common.c         |   3 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |   5 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   9 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |  18 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  25 +-
 drivers/media/platform/exynos4-is/media-dev.h      |   8 +-
 drivers/media/platform/omap3isp/isp.c              |  43 +-
 drivers/media/platform/omap3isp/ispccdc.c          |  19 +-
 drivers/media/platform/omap3isp/ispccp2.c          |  15 +-
 drivers/media/platform/omap3isp/ispcsi2.c          |  13 +-
 drivers/media/platform/omap3isp/isppreview.c       |  19 +-
 drivers/media/platform/omap3isp/ispresizer.c       |  17 +-
 drivers/media/platform/omap3isp/ispvideo.c         |  17 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   2 +-
 drivers/media/platform/s3c-camif/camif-core.c      |   4 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |   4 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |   2 +-
 drivers/media/platform/vsp1/vsp1_video.c           |  15 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |   2 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |  10 +-
 drivers/media/platform/xilinx/xilinx-vipp.c        |   4 +-
 drivers/media/usb/au0828/au0828-core.c             |  14 +-
 drivers/media/usb/au0828/au0828-video.c            |   8 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |   6 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   8 +-
 drivers/media/usb/uvc/uvc_entity.c                 |   2 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |   2 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |   6 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |   9 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |  15 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |  15 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |  30 +-
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |  10 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |  17 +-
 drivers/staging/media/omap4iss/iss.c               |  32 +-
 drivers/staging/media/omap4iss/iss_csi2.c          |  13 +-
 drivers/staging/media/omap4iss/iss_ipipe.c         |   7 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c       |  15 +-
 drivers/staging/media/omap4iss/iss_resizer.c       |  13 +-
 drivers/staging/media/omap4iss/iss_video.c         |   9 +-
 include/media/media-device.h                       |  34 +-
 include/media/media-entity.h                       | 199 +++++++++-
 include/uapi/linux/media.h                         | 192 ++++++++-
 63 files changed, 1466 insertions(+), 485 deletions(-)

-- 
2.4.3

