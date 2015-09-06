Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53833 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbbIFRbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 13:31:35 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/18] MC fixes, improvements and cleanups
Date: Sun,  6 Sep 2015 14:30:43 -0300
Message-Id: <cover.1441559233.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series go after the previous series:
	"MC next generation patches"
	http://www.spinics.net/lists/linux-media/msg93108.html

It contains a series of fixes and cleanup the MC  Next gen.

The first patches add connector entities to represent RF, S-Video and Composite
interfaces on an analog device and fixes some bugs:
  [media] tuner-core: add an input pad
  [media] au0828: add support for the connectors
  [media] au0828: Create connector links
  [media] media-device: supress backlinks at G_TOPOLOGY ioctl
  [media] media-controller: enable all interface links at init
  [media] media.h: create connector entities for hybrid TV devices

The next sequence of patches enforce __must_check to pads and links creation,
as requested by Hans Verkuil:
  [media] dvbdev: returns error if graph object creation fails
  [media] dvb core: must check dvb_create_media_graph()
  [media] media-entity: enforce check of interface and links creation
  [media] cx231xx: enforce check for graph creation
  [media] au0828:: enforce check for graph creation
  [media] media-entity: must check media_create_pad_link()

The next patches do the entity function rename as agreed at the meeting we had on
IRC last Wednesday, and exposes it via G_TOPOLOGY:
  [media] media-entity.h: rename entity.type to entity.function
  [media] media-device: export the entity function via new ioctl
  [media] uapi/media.h: Rename entities types to functions
  [media] DocBook: update entities documentation

The final patches are some cleanups at the dvbdev link creation:
  [media] dvbdev: move indirect links on dvr/demux to a separate function
  [media] dvbdev: Don't create indirect links

The last patch deserves a better explanation: entities may direct or indirect control
a device, on non-v4l2-subdev-centric devices. We're not creating the indirect
interface control links at V4L2 side. I decided to remove it also from the dvbdev
side. Implementing support for it is not hard, but let's do it only when we have some
usecases.

There aren't much things to be done for the merge of the MC next gen series on
(scheduled for Kernel 4.4). On my  my lists, the remaining items are:

TODO for next Kernel version (goal: Kernel version 4.4):
=========================================================

- Add Javier's fixup patches with fixes for some platform drivers
  and uvc;

- Find entities that belong to V4L2 or DVB via the interfaces,
  in order to enable/disable the inteface links when the device
  gets busy;

TODO for a next versions:
=========================

- Remove unused fields from media_entity (like major, minor, revision,
  group_id, num_links, num_backlinks, num_pads)

- dynamic entity/interface/link creation and removal;

- SETUP_LINK_V2 with dynamic support;

- dynamic pad creation and removal (needed?);

- multiple function per entity support;

- indirect interface links support;

- MC properties API.

Userspace:
==========

- Create a library with v2 API;

- Use the v2 API library on qv4l2/libdvbv5/xawtv/libv4l;

- Add the libudev/libsysfs logic at mc_nextgen_test to convert
  a devnode major/minor into a /dev/* name;


Mauro Carvalho Chehab (18):
  [media] tuner-core: add an input pad
  [media] au0828: add support for the connectors
  [media] au0828: Create connector links
  [media] media-device: supress backlinks at G_TOPOLOGY ioctl
  [media] media-controller: enable all interface links at init
  [media] media.h: create connector entities for hybrid TV devices
  [media] dvbdev: returns error if graph object creation fails
  [media] dvb core: must check dvb_create_media_graph()
  [media] media-entity: enforce check of interface and links creation
  [media] cx231xx: enforce check for graph creation
  [media] au0828:: enforce check for graph creation
  [media] media-entity: must check media_create_pad_link()
  [media] media-entity.h: rename entity.type to entity.function
  [media] media-device: export the entity function via new ioctl
  [media] uapi/media.h: Rename entities types to functions
  [media] DocBook: update entities documentation
  [media] dvbdev: move indirect links on dvr/demux to a separate
    function
  [media] dvbdev: Don't create indirect links

 .../DocBook/media/v4l/media-ioc-enum-entities.xml  |  58 ++--
 Documentation/video4linux/v4l2-framework.txt       |   4 +-
 drivers/media/common/siano/smsdvb-main.c           |   6 +-
 drivers/media/dvb-core/dvbdev.c                    | 343 ++++++++++++---------
 drivers/media/dvb-core/dvbdev.h                    |   7 +-
 drivers/media/dvb-frontends/au8522_decoder.c       |   2 +-
 drivers/media/i2c/adp1653.c                        |   2 +-
 drivers/media/i2c/adv7180.c                        |   2 +-
 drivers/media/i2c/as3645a.c                        |   2 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |   2 +-
 drivers/media/i2c/lm3560.c                         |   2 +-
 drivers/media/i2c/lm3646.c                         |   2 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |   2 +-
 drivers/media/i2c/noon010pc30.c                    |   2 +-
 drivers/media/i2c/ov2659.c                         |   2 +-
 drivers/media/i2c/ov9650.c                         |   2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   4 +-
 drivers/media/i2c/s5k4ecgx.c                       |   2 +-
 drivers/media/i2c/s5k5baf.c                        |   6 +-
 drivers/media/i2c/s5k6aa.c                         |   2 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   2 +-
 drivers/media/i2c/tvp514x.c                        |   2 +-
 drivers/media/i2c/tvp7002.c                        |   2 +-
 drivers/media/media-device.c                       |  10 +-
 drivers/media/media-entity.c                       |   1 +
 drivers/media/platform/xilinx/xilinx-dma.c         |   2 +-
 drivers/media/usb/au0828/au0828-core.c             |  94 +++++-
 drivers/media/usb/au0828/au0828-dvb.c              |   8 +-
 drivers/media/usb/au0828/au0828-video.c            |  76 ++++-
 drivers/media/usb/au0828/au0828.h                  |   3 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |  46 ++-
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |   6 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c        |   4 +-
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c            |   6 +-
 drivers/media/v4l2-core/tuner-core.c               |  10 +-
 drivers/media/v4l2-core/v4l2-dev.c                 |  17 +-
 drivers/media/v4l2-core/v4l2-device.c              |   2 +-
 drivers/media/v4l2-core/v4l2-flash-led-class.c     |   2 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |   6 +-
 include/media/media-entity.h                       |  46 +--
 include/media/tuner.h                              |   8 +
 include/uapi/linux/media.h                         | 120 +++----
 43 files changed, 586 insertions(+), 343 deletions(-)

-- 
2.4.3


