Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40097 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbbHGOUV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2015 10:20:21 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC v2 00/16] Changes on MC core due to MC workshop discussion
Date: Fri,  7 Aug 2015 11:19:58 -0300
Message-Id: <cover.1438954897.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the second version of an initial set of patches showing
the approach I'm taking in order to fulfill all the MC needs that
was discussed on the 3 day MC summit in Helsinki.

The goal of this patchset is:

1) to create a common struct that will be embedded on all internal
   structs that represents the comon data that will be used by
   all kinds of objects;

2) to have an unique object ID for each object in the graph. The
   object ID will be needed by the userspace API in the future, as
   discussed during the MC workshop;

3) to create objects to represent Kernel->userspace interfaces;

4) to extend the link support to allow linking interfaces to entities.

On version 2, I removed the kref, as some people at the #v4l channel
are not convinced about its need. So, let's postpone such discussion
when we start introducing patches that will actually do dynamic object
removal in runtime.

As suggested, I'll be sending incremental patches and avoiding to
do a large set of changes into one changeset series. That basically
means that those patches aren't tested yet (except for compilation
tests).

Along this patch series, I'll be calling "object" as any "symbol"
that belongs to a media graph, like processing entities, connectors,
links, pads, interfaces.

As said on the goals of this RFC, on version 2 of this patch series, 
we're coming with the new concept: interfaces.

An interface is a graph object that does the interaction between
Kernelspace <===> Userspace. While the code written for interface
creation and interface<==>entity link is generic, currently
I added support only for the type of interface currently used at the
existing MC graphs: device node interfaces. We should add other
types of interfaces in a future patchset. For example, we need to
add support for network interfaces in order to fulfill the needs of
the DVB subsystem. We'll also need to add support for sysfs interfaces
in order to support IIO and remote controllers.

Those API changes are aligned with the RFC for the userspace API
proposed by Hans Verkuil:
	http://www.spinics.net/lists/linux-media/msg92166.html

The only difference is that I'm using a single counter to generate
an unique object ID, while Hans proposal is to use one per object
type. As explained on my comments on the last patch series, the
rationale is to simply simplify the code, helping to make the internal
API changes clearer. We can change this latter before adding support
for the userspace API.

I suspect that we'll also need another type to represent groups of
objects, but this will be covered on future patches if/when needed.

No userspace API changes here, just changes at the internal structs
that contains the media graph objects and some new helper functions.

===========
Future work
===========

I think that, after changing the MC core to support the new proposed
API, a next step would be to simplify the internal representation of
the media objects, in order to make it easier to be reused on other
subsystems like IIO and to spend less memory. With that regards, I
think that we can get rid of some fields at the existing structures:

struct media_link.reverse - Currently we create two copies of the
same link, in order to use at the graph traversal. I think we can
remove it and use just one copy;

struct media_entity - well, there are several things that we can
get hid there:
	- parent - we're already storing it at the objects;
	- id - we have already an unique ID at the objects;
	- type - this should be replaced by properties;
	- revision - not used, afaikt;
	- group_id - groups should really be a new object type that
	  will have the list of object IDs that belong to the group.
	- num_links/num_backlinks - those are used only at the
	  userspace interface, but we need to track link creation/removal
	  just to feed those things. I would remove those and add a logic
	  at media_device.c to count;
	- num_pads - if we convert pads to lists (with seems to be
	  the best thing, as not all entities need pads), then we can
	  get rid of this too;
	- union info - this should be retrieved via the interface, and
	  not via the entity.

Yet, the above are suggestions for some future next steps. I won't
probably address the above, except if needed in order to support the
DVB or ALSA needs.

Mauro Carvalho Chehab (16):
  media: Add some fields to store graph objects
  media: Add a common embeed struct for all media graph objects
  media: add functions to inialize media_graph_obj
  media: ensure that entities will have an object ID
  media: initialize PAD objects
  media: initialize the graph object inside the media links
  media: get rid of unused "extra_links" param on media_entity_init()
  media: convert links from array to list
  media: use media_graph_obj for link endpoints
  media: rename the function that create pad links
  FIXUP: source link removal on failure
  media: move __media_entity_remove_link to avoid prototype
  media: make the internal function to create links more generic
  media: add a generic function to remove a link
  media: rename media_entity_remove_foo functions
  media: add functions to allow creating interfaces

 Documentation/media-framework.txt                  |   2 +-
 Documentation/video4linux/v4l2-framework.txt       |   4 +-
 Documentation/zh_CN/video4linux/v4l2-framework.txt |   4 +-
 drivers/media/dvb-core/dvb_frontend.c              |  10 +-
 drivers/media/dvb-core/dvbdev.c                    |  10 +-
 drivers/media/i2c/ad9389b.c                        |   2 +-
 drivers/media/i2c/adp1653.c                        |   2 +-
 drivers/media/i2c/adv7180.c                        |   2 +-
 drivers/media/i2c/adv7511.c                        |   2 +-
 drivers/media/i2c/adv7604.c                        |   2 +-
 drivers/media/i2c/adv7842.c                        |   2 +-
 drivers/media/i2c/as3645a.c                        |   2 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |   2 +-
 drivers/media/i2c/lm3560.c                         |   2 +-
 drivers/media/i2c/lm3646.c                         |   2 +-
 drivers/media/i2c/m5mols/m5mols_core.c             |   2 +-
 drivers/media/i2c/mt9m032.c                        |   2 +-
 drivers/media/i2c/mt9p031.c                        |   2 +-
 drivers/media/i2c/mt9t001.c                        |   2 +-
 drivers/media/i2c/mt9v032.c                        |   2 +-
 drivers/media/i2c/noon010pc30.c                    |   2 +-
 drivers/media/i2c/ov2659.c                         |   2 +-
 drivers/media/i2c/ov9650.c                         |   2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   8 +-
 drivers/media/i2c/s5k4ecgx.c                       |   2 +-
 drivers/media/i2c/s5k5baf.c                        |   6 +-
 drivers/media/i2c/s5k6a3.c                         |   2 +-
 drivers/media/i2c/s5k6aa.c                         |   2 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   8 +-
 drivers/media/i2c/tc358743.c                       |   2 +-
 drivers/media/i2c/tvp514x.c                        |   2 +-
 drivers/media/i2c/tvp7002.c                        |   2 +-
 drivers/media/media-device.c                       |  48 ++-
 drivers/media/media-entity.c                       | 367 ++++++++++++++-------
 drivers/media/platform/exynos4-is/fimc-capture.c   |   4 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   2 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |   2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   4 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c       |   2 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  18 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   2 +-
 drivers/media/platform/omap3isp/isp.c              |  22 +-
 drivers/media/platform/omap3isp/ispccdc.c          |   6 +-
 drivers/media/platform/omap3isp/ispccp2.c          |   4 +-
 drivers/media/platform/omap3isp/ispcsi2.c          |   4 +-
 drivers/media/platform/omap3isp/isppreview.c       |   6 +-
 drivers/media/platform/omap3isp/ispresizer.c       |   6 +-
 drivers/media/platform/omap3isp/ispstat.c          |   2 +-
 drivers/media/platform/omap3isp/ispvideo.c         |   2 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   4 +-
 drivers/media/platform/s3c-camif/camif-core.c      |   4 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |   4 +-
 drivers/media/platform/vsp1/vsp1_entity.c          |   2 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |   2 +-
 drivers/media/platform/vsp1/vsp1_video.c           |   2 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |   2 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |   2 +-
 drivers/media/platform/xilinx/xilinx-tpg.c         |   2 +-
 drivers/media/platform/xilinx/xilinx-vipp.c        |   4 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |   6 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |  18 +-
 drivers/media/usb/uvc/uvc_entity.c                 |   6 +-
 drivers/media/v4l2-core/tuner-core.c               |   2 +-
 drivers/media/v4l2-core/v4l2-device.c              |   2 +-
 drivers/media/v4l2-core/v4l2-flash-led-class.c     |   2 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |   6 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |   2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |   4 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |   4 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |  14 +-
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |  10 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |   2 +-
 drivers/staging/media/omap4iss/iss.c               |  18 +-
 drivers/staging/media/omap4iss/iss_csi2.c          |   6 +-
 drivers/staging/media/omap4iss/iss_ipipe.c         |   2 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c       |   4 +-
 drivers/staging/media/omap4iss/iss_resizer.c       |   4 +-
 drivers/staging/media/omap4iss/iss_video.c         |   2 +-
 include/media/media-device.h                       |   4 +
 include/media/media-entity.h                       | 130 +++++++-
 80 files changed, 575 insertions(+), 302 deletions(-)

-- 
2.4.3

