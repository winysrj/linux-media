Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:44387 "EHLO
	resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751236AbbGVWmd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2015 18:42:33 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	laurent.pinchart@ideasonboard.com, tiwai@suse.de,
	sakari.ailus@linux.intel.com, perex@perex.cz, crope@iki.fi,
	arnd@arndb.de, stefanr@s5r6.in-berlin.de,
	ruchandani.tina@gmail.com, chehabrafael@gmail.com,
	dan.carpenter@oracle.com, prabhakar.csengg@gmail.com,
	chris.j.arges@canonical.com, agoode@google.com,
	pierre-louis.bossart@linux.intel.com, gtmkramer@xs4all.nl,
	clemens@ladisch.de, daniel@zonque.org, vladcatoi@gmail.com,
	misterpib@gmail.com, damien@zamaudio.com, pmatilai@laiskiainen.org,
	takamichiho@gmail.com, normalperson@yhbt.net,
	bugzilla.frnkcg@spamgourmet.com, joe@oampo.co.uk,
	calcprogrammer1@gmail.com, jussi@sonarnerd.net,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	kgene@kernel.org, hyun.kwon@xilinx.com, michal.simek@xilinx.com,
	soren.brinkmann@xilinx.com, pawel@osciak.com,
	m.szyprowski@samsung.com, gregkh@linuxfoundation.org,
	skd08@gmail.com, nsekhar@ti.com,
	boris.brezillon@free-electrons.com, Julia.Lawall@lip6.fr,
	elfring@users.sourceforge.net, p.zabel@pengutronix.de,
	ricardo.ribalda@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org
Subject: [PATCH v2 00/19] Update ALSA, and au0828 drivers to use Managed Media Controller API 
Date: Wed, 22 Jul 2015 16:42:01 -0600
Message-Id: <cover.1437599281.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series updates ALSA driver, and au0828 core driver to
use Managed Media controller API to share tuner. Please note that
Managed Media Controller API and DVB and V4L2 drivers updates to
use Media Controller API have been added in a prior patch series.

Media Controller API is enhanced with two new interfaces to
register and unregister entity_notify hooks to allow drivers
to take appropriate actions when as new entities get added to
the shared media device.

Tested exclusion between digital, analog, and audio to ensure
when tuner has an active link to DVB FE, analog, and audio will
detect and honor the tuner busy conditions and vice versa.

Changes since v1:
Link to v1: http://www.spinics.net/lists/linux-media/msg91697.html

1. Fixed Open Issue:

ALSA has makes media_entity_pipeline_start() call in irq
path. I am seeing warnings that the graph_mutex is unsafe
irq lock. Media Controller API updates to start/stop pipeline
to be irq safe might be necessary. Maybe there are other MC
interfaces that need to be irq safe, but I haven't seen any
problems with my testing.

graph_mutex is changed to a spinlock. Changed drivers that
directly hold the lock for graph walks.

media_entity_setup_link() might need to be made IRQ safe.
I am running more tests to ensure there is no lock warns
when dvb, video, and audio apps. run at the sametime and
use MC API (that holds graph_lock) to check for tuner
availability. Initial testing looked good so far.

2. Add enable_source handler field to struct media_device

Add a new field to enable handler to find source entity for the
sink entity and check if it is available, and activate the link
using media_entity_setup_link() interface. Bridge driver is
expected to implement and set the handler when media_device is
registered or when bridge driver finds the media_device during
probe. This is to enable the use-case to find tuner entity
connected to the decoder entity and check if it is available,
and activate the using media_entity_setup_link() if it is available.
This hanlder can be invoked from media core (v4l-core, dvb-core)
as well as other drivers such as ALSA that control the media device.

3. Changes to v4l2-core, ALSA to use enable_source handler

4. Changes to au0828 bridge driver to implement enable_source handler

Note: This series includes a revert to a patch that added media
controller entity framework enhancements that implemented entity
ops for entity_notify functionality. Entity ops for entity_notify
doesn't handle and cover entity create ordering variations that
could occur during boot. entity_notify list has been moved to media
device level which makes the entity_notify calls to work correctly.

History:
This patch series has been updated to address comments from
3 previous versions of this series. Links to v3 version
for reference are:

https://www.mail-archive.com/linux-media%40vger.kernel.org/msg89491.html
https://www.mail-archive.com/linux-media@vger.kernel.org/msg89492.html
https://www.mail-archive.com/linux-media%40vger.kernel.org/msg89493.html

Shuah Khan (19):
  Revert "[media] media: media controller entity framework enhancements
    for ALSA"
  media: Media Controller register/unregister entity_notify API
  media: Add ALSA Media Controller devnodes
  media: au8522 change to create MC pad for ALSA Audio Out
  media: Convert graph_mutex to a spinlock and call it graph_lock
  media: platform exynos4-is: Update graph_mutex to graph_lock spinlock
  media: platform omap3isp: Update graph_mutex to graph_lock spinlock
  media: platform s3c-camif: Update graph_mutex to graph_lock spinlock
  media: platform vsp1: Update graph_mutex to graph_lock spinlock
  media: platform xilinx: Update graph_mutex to graph_lock spinlock
  staging media: davinci_vpfe: Update graph_mutex to graph_lock spinlock
  staging media: omap4iss: Update graph_mutex to graph_lock spinlock
  media: Add irq safe Media Controller start/stop pipeline API
  media: Add enable_source handler field to struct media_device
  media: v4l-core add v4l_enable_media_tuner() to check for tuner
    availability
  media: Change v4l-core to check for tuner availability
  media: dvb-frontend change to check for tuner availability from open
  media: au0828 change to use Managed Media Controller API
  sound/usb: Update ALSA driver to use Managed Media Controller API

 drivers/media/dvb-core/dvb_frontend.c              |  43 ++--
 drivers/media/dvb-frontends/au8522.h               |   8 +
 drivers/media/dvb-frontends/au8522_decoder.c       |   1 +
 drivers/media/dvb-frontends/au8522_priv.h          |   8 -
 drivers/media/media-device.c                       |  60 +++++-
 drivers/media/media-entity.c                       |  88 ++++++--
 drivers/media/platform/exynos4-is/fimc-isp-video.c |   8 +-
 drivers/media/platform/exynos4-is/fimc-lite.c      |   8 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  14 +-
 drivers/media/platform/exynos4-is/media-dev.h      |   4 +-
 drivers/media/platform/omap3isp/isp.c              |   4 +-
 drivers/media/platform/omap3isp/ispvideo.c         |   4 +-
 drivers/media/platform/s3c-camif/camif-core.c      |   6 +-
 drivers/media/platform/vsp1/vsp1_video.c           |   4 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |   4 +-
 drivers/media/usb/au0828/au0828-core.c             | 184 ++++++++++++-----
 drivers/media/usb/au0828/au0828-video.c            |  72 ++-----
 drivers/media/usb/au0828/au0828.h                  |   5 +
 drivers/media/v4l2-core/v4l2-dev.c                 |  17 ++
 drivers/media/v4l2-core/v4l2-ioctl.c               |  29 +++
 drivers/media/v4l2-core/videobuf2-core.c           |   5 +
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |  12 +-
 drivers/staging/media/omap4iss/iss.c               |   4 +-
 drivers/staging/media/omap4iss/iss_video.c         |   4 +-
 include/media/media-device.h                       |  41 +++-
 include/media/media-entity.h                       |   7 +-
 include/media/v4l2-dev.h                           |   3 +
 include/uapi/linux/media.h                         |   5 +
 sound/usb/Makefile                                 |  15 +-
 sound/usb/card.c                                   |   5 +
 sound/usb/card.h                                   |   1 +
 sound/usb/media.c                                  | 227 +++++++++++++++++++++
 sound/usb/media.h                                  |  52 +++++
 sound/usb/pcm.c                                    |  15 +-
 sound/usb/quirks-table.h                           |   1 +
 sound/usb/quirks.c                                 |   9 +-
 sound/usb/stream.c                                 |   2 +
 sound/usb/usbaudio.h                               |   1 +
 38 files changed, 765 insertions(+), 215 deletions(-)
 create mode 100644 sound/usb/media.c
 create mode 100644 sound/usb/media.h

-- 
2.1.4

