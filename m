Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55351 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539AbbAFVJW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Jan 2015 16:09:22 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv3 00/20] dvb core: add basic support for the media controller
Date: Tue,  6 Jan 2015 19:08:31 -0200
Message-Id: <cover.1420578087.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds basic support for the media controller at the
DVB core: it creates one media entity per DVB devnode, if the media
device is passed as an argument to the DVB structures.

The cx231xx driver was modified to pass such argument for DVB NET,
DVB frontend and DVB demux.

-

version 3:
- Added the second series of patches ("add link graph to cx231xx 
  using the media controller")
- tuner-core and cx25840: add proper error handling as suggested by
  Sakari Ailus and pointed by Joe Perches;
- dvb core: move the media_dev struct to be inside the DVB adapter. That
  allowed to simplify the changes for the dvbdev clients;
- Add logic to setup the pipelines when analog or digital TV stream starts.
- Renamed some patches to better describe its contents.

version 2:
- Now the PADs are created for all nodes
- Instead of using entity->flags for subtypes, create separate
  MEDIA_ENT_T_DEVNODE_DVB_foo for each DVB devtype
- The API change patch was split from the DVB core changes

TODO:
- Update media API docbook for the DVB media controller changes
- Solve the issues pointed by a separate e-mail

Those patches are also available at my experimental tree:
	http://git.linuxtv.org/cgit.cgi/mchehab/experimental-v4l-utils.git/log/?h=dvb-media-ctl

Mauro Carvalho Chehab (20):
  media: add new types for DVB devnodes
  dvbdev: add support for media controller
  cx231xx: add media controller support
  dvb_frontend: add media controller support for DVB frontend
  dmxdev: add support for demux/dvr nodes at media controller
  dvb_ca_en50221: add support for CA node at the media controller
  dvb_net: add support for DVB net node at the media controller
  dvbdev: add pad for the DVB devnodes
  tuner-core: properly initialize media controller subdev
  cx25840: fill the media controller entity
  cx231xx: initialize video/vbi pads
  cx231xx: create media links for analog mode
  dvbdev: represent frontend with two pads
  dvbdev: add a function to create DVB media graph
  cx231xx: create DVB graph
  dvbdev: enable DVB-specific links
  dvb-frontend: enable tuner link when the FE thread starts
  cx231xx: enable tuner->decoder link at videobuf start
  cx231xx: create a streaming pipeline at VB start
  dvb_frontend: start media pipeline while thread is running

 drivers/media/dvb-core/dmxdev.c           |  11 ++-
 drivers/media/dvb-core/dvb_ca_en50221.c   |   6 +-
 drivers/media/dvb-core/dvb_frontend.c     | 121 ++++++++++++++++++++++++-
 drivers/media/dvb-core/dvb_net.c          |   6 +-
 drivers/media/dvb-core/dvbdev.c           | 143 +++++++++++++++++++++++++++++-
 drivers/media/dvb-core/dvbdev.h           |  15 ++++
 drivers/media/i2c/cx25840/cx25840-core.c  |  18 ++++
 drivers/media/i2c/cx25840/cx25840-core.h  |   3 +
 drivers/media/usb/cx231xx/cx231xx-cards.c |  98 ++++++++++++++++++--
 drivers/media/usb/cx231xx/cx231xx-dvb.c   |   4 +
 drivers/media/usb/cx231xx/cx231xx-video.c | 101 ++++++++++++++++++++-
 drivers/media/usb/cx231xx/cx231xx.h       |   7 ++
 drivers/media/v4l2-core/tuner-core.c      |  20 +++++
 include/uapi/linux/media.h                |  11 ++-
 14 files changed, 547 insertions(+), 17 deletions(-)

-- 
2.1.0

