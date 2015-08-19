Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38115 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbbHSLDo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 07:03:44 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v6 0/8] MC preparation patches
Date: Wed, 19 Aug 2015 08:01:47 -0300
Message-Id: <cover.1439981515.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those are the same patches as sent at PATCH RFCv5, addressing most of
the stuff pointed by Hans.

The only thing I didn't do yet is the removal of entity->parent, in
favor of using, instead, entity->graph_obj.mdev. Such patch will
be done latter on.

As the previous series:

The first 5 patches on this series ensures that all existing object
types (entities, pads and links) will have an unique ID, as agreed
at the MC workshop.

The next two patches add two debug functions, that helps with the
tests of the MC changes. Both are enabled only if DEBUG or dynamic
debug is enabled.

The first one just help to identify when the media_device register,
remove and unregister functions are called. It helps to identify if
those events happen before or after object creation.

The second one is more interesting: it hooks at the object init and
remove functions and dump what's there at the new object when it
got created. This is very useful to test the future patches, as we'll
be able to track any topology changes.

Also, it demonstates the capability of the functions
media_gobj_init() and media_gobj_remove() to track topology
changes. Tracking topology changes is fundamental for the new API,
in order to implement G_TOPOLOGY ioctl. They should contain, in
the future, a callback to warn the several drivers envolved at the
MC topology build about topology changes.

The last patch on this preparation series is just a renaming patch,
that will avoid mess when future patches introduce the
entity->interface links.

They're tested using the cx231xx and au0828 with V4L2 and DVB support.

Those are the new media_gobj_init debug messages when the device is probed:

[ 3357.988183] usb 1-2.4: media_gobj_init: id 0x00000001 entity#1: 'au8522 19-0047'
[ 3357.989505] usb 1-2.4: media_gobj_init: id 0x01000001 pad#1: 'au8522 19-0047':0
[ 3357.990867] usb 1-2.4: media_gobj_init: id 0x01000002 pad#2: 'au8522 19-0047':1
[ 3357.992123] usb 1-2.4: media_gobj_init: id 0x01000003 pad#3: 'au8522 19-0047':2
[ 3357.996008] usb 1-2.4: media_gobj_init: id 0x00000002 entity#2: '(tuner unset)'
[ 3357.997158] usb 1-2.4: media_gobj_init: id 0x01000004 pad#4: '(tuner unset)':0
[ 3358.488779] usb 1-2.4: media_gobj_init: id 0x00000003 entity#3: 'au0828a video'
[ 3358.490177] usb 1-2.4: media_gobj_init: id 0x01000005 pad#5: 'au0828a video':0
[ 3358.491944] usb 1-2.4: media_gobj_init: id 0x00000004 entity#4: 'au0828a vbi'
[ 3358.493382] usb 1-2.4: media_gobj_init: id 0x01000006 pad#6: 'au0828a vbi':0
[ 3358.510977] usb 1-2.4: media_gobj_init: id 0x00000005 entity#5: 'Auvitek AU8522 QAM/8VSB Frontend'
[ 3358.512441] usb 1-2.4: media_gobj_init: id 0x01000007 pad#7: 'Auvitek AU8522 QAM/8VSB Frontend':0
[ 3358.513909] usb 1-2.4: media_gobj_init: id 0x01000008 pad#8: 'Auvitek AU8522 QAM/8VSB Frontend':1
[ 3358.516828] usb 1-2.4: media_gobj_init: id 0x00000006 entity#6: 'dvb-demux'
[ 3358.518226] usb 1-2.4: media_gobj_init: id 0x01000009 pad#9: 'dvb-demux':0
[ 3358.519594] usb 1-2.4: media_gobj_init: id 0x0100000a pad#10: 'dvb-demux':1
[ 3358.522461] usb 1-2.4: media_gobj_init: id 0x00000007 entity#7: 'dvb-dvr'
[ 3358.523914] usb 1-2.4: media_gobj_init: id 0x0100000b pad#11: 'dvb-dvr':0
[ 3358.526625] usb 1-2.4: media_gobj_init: id 0x00000008 entity#8: 'dvb-net'
[ 3358.529307] usb 1-2.4: media_gobj_init: id 0x02000001 link#1: 'Xceive XC5000' pad#4 ==> 'Auvitek AU8522 QAM/8VSB Frontend' pad#7
[ 3358.530715] usb 1-2.4: media_gobj_init: id 0x02000002 link#2: 'Xceive XC5000' pad#4 ==> 'Auvitek AU8522 QAM/8VSB Frontend' pad#7
[ 3358.532116] usb 1-2.4: media_gobj_init: id 0x02000003 link#3: 'Auvitek AU8522 QAM/8VSB Frontend' pad#8 ==> 'dvb-demux' pad#9
[ 3358.533520] usb 1-2.4: media_gobj_init: id 0x02000004 link#4: 'Auvitek AU8522 QAM/8VSB Frontend' pad#8 ==> 'dvb-demux' pad#9
[ 3358.534957] usb 1-2.4: media_gobj_init: id 0x02000005 link#5: 'dvb-demux' pad#10 ==> 'dvb-dvr' pad#11
[ 3358.536278] usb 1-2.4: media_gobj_init: id 0x02000006 link#6: 'dvb-demux' pad#10 ==> 'dvb-dvr' pad#11
[ 3358.610351] usb 1-2.4: media_gobj_init: id 0x02000007 link#7: 'Xceive XC5000' pad#4 ==> 'au8522 19-0047' pad#1
[ 3358.611455] usb 1-2.4: media_gobj_init: id 0x02000008 link#8: 'Xceive XC5000' pad#4 ==> 'au8522 19-0047' pad#1
[ 3358.612539] usb 1-2.4: media_gobj_init: id 0x02000009 link#9: 'au8522 19-0047' pad#2 ==> 'au0828a video' pad#5
[ 3358.613611] usb 1-2.4: media_gobj_init: id 0x0200000a link#10: 'au8522 19-0047' pad#2 ==> 'au0828a video' pad#5
[ 3358.614686] usb 1-2.4: media_gobj_init: id 0x0200000b link#11: 'au8522 19-0047' pad#3 ==> 'au0828a vbi' pad#6
[ 3358.615720] usb 1-2.4: media_gobj_init: id 0x0200000c link#12: 'au8522 19-0047' pad#3 ==> 'au0828a vbi' pad#6

Please notice that I changed the log messages there in order to put
both the global ID and the local ID together. Now, all log messages
will look the same:

    media_gobj_init: id 0x0100000a    pad#10:   'dvb-demux':1
    ===============  =============    ======    ============= 
    Event name	     Global ID        Local ID  Obj-specific data

I think that this way, the logs become clearer and easier to read.
I also added the pad index on the logs (as shown above).

Mauro Carvalho Chehab (8):
  [media] media: create a macro to get entity ID
  [media] media: add a common struct to be embed on media graph objects
  [media] media: use media_gobj inside entities
  [media] media: use media_gobj inside pads
  [media] media: use media_gobj inside links
  [media] media: add messages when media device gets (un)registered
  [media] media: add a debug message to warn about gobj creation/removal
  [media] media: rename the function that create pad links

 Documentation/media-framework.txt                  |   2 +-
 drivers/media/dvb-core/dvbdev.c                    |   8 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   4 +-
 drivers/media/i2c/s5k5baf.c                        |   2 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   4 +-
 drivers/media/media-device.c                       |  41 +++++--
 drivers/media/media-entity.c                       | 127 ++++++++++++++++++++-
 drivers/media/platform/exynos4-is/media-dev.c      |  16 +--
 drivers/media/platform/omap3isp/isp.c              |  18 +--
 drivers/media/platform/omap3isp/ispccdc.c          |   2 +-
 drivers/media/platform/omap3isp/ispccp2.c          |   2 +-
 drivers/media/platform/omap3isp/ispcsi2.c          |   2 +-
 drivers/media/platform/omap3isp/isppreview.c       |   4 +-
 drivers/media/platform/omap3isp/ispresizer.c       |   4 +-
 drivers/media/platform/s3c-camif/camif-core.c      |   4 +-
 drivers/media/platform/vsp1/vsp1_drv.c             |   4 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |   2 +-
 drivers/media/platform/vsp1/vsp1_video.c           |   4 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |   2 +-
 drivers/media/platform/xilinx/xilinx-vipp.c        |   4 +-
 drivers/media/usb/au0828/au0828-core.c             |   6 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c          |   6 +-
 drivers/media/usb/uvc/uvc_entity.c                 |   2 +-
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |   2 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c    |   2 +-
 drivers/staging/media/davinci_vpfe/dm365_resizer.c |   8 +-
 .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |  10 +-
 drivers/staging/media/omap4iss/iss.c               |  12 +-
 drivers/staging/media/omap4iss/iss_csi2.c          |   2 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c       |   2 +-
 drivers/staging/media/omap4iss/iss_resizer.c       |   2 +-
 include/media/media-device.h                       |   7 +-
 include/media/media-entity.h                       |  84 +++++++++++++-
 33 files changed, 311 insertions(+), 90 deletions(-)

-- 
2.4.3

