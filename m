Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46664 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbbACOtZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Jan 2015 09:49:25 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv2 0/9] dvb core: add basic support for the media controller
Date: Sat,  3 Jan 2015 12:49:02 -0200
Message-Id: <cover.1420294938.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds basic support for the media controller at the
DVB core: it creates one media entity per DVB devnode, if the media
device is passed as an argument to the DVB structures.

The cx231xx driver was modified to pass such argument for DVB NET,
DVB frontend and DVB demux.

-

version 2:
- Now the PADs are created for all nodes
- Instead of using entity->flags for subtypes, create separate
  MEDIA_ENT_T_DEVNODE_DVB_foo for each DVB devtype
- The API change patch was split from the DVB core changes

TODO:
- Create links
- Update media API for the DVB media controller changes
- Add the new devnodes at media-ctl at v4l-utils

Results of the media controller, using the modified version found at:
	http://git.linuxtv.org/cgit.cgi/mchehab/experimental-v4l-utils.git/log/?h=dvb-media-ctl

Media controller API version 0.1.1

Media device information
------------------------
driver          cx231xx
model           Pixelview PlayTV USB Hybrid
serial          CIR000000000001
bus info        4
hw revision     0x4001
driver version  3.19.0

Device topology
- entity 1: cx25840 19-0044 (0 pad, 0 link)
            type V4L2 subdev subtype Unknown flags 0

- entity 2: tuner 21-0060 (0 pad, 0 link)
            type V4L2 subdev subtype Unknown flags 0

- entity 3: cx231xx #0 video (0 pad, 0 link)
            type Node subtype V4L flags 0
            device node name /dev/video0

- entity 4: cx231xx #0 vbi (0 pad, 0 link)
            type Node subtype V4L flags 0
            device node name /dev/vbi0

- entity 5: Fujitsu mb86A20s (1 pad, 0 link)
            type Node subtype DVB FE flags 0
            device node name /dev/dvb/adapter0/frontend0
	pad0: Source

- entity 6: demux (2 pads, 0 link)
            type Node subtype DVB DEMUX flags 0
            device node name /dev/dvb/adapter0/demux0
	pad0: Source
	pad1: Sink

- entity 7: dvr (1 pad, 0 link)
            type Node subtype DVB DVR flags 0
            device node name /dev/dvb/adapter0/dvr0
	pad0: Sink

- entity 8: dvb net (0 pad, 0 link)
            type Node subtype DVB NET flags 0
            device node name /dev/dvb/adapter0/net0

Mauro Carvalho Chehab (9):
  media: Fix DVB representation at media controller API
  media: add new types for DVB devnodes
  dvb core: add support for media controller at dvbdev
  dvb core: add media controller support for DVB frontend
  dvb core: add support for demux/dvr nodes at media controller
  dvb core: add support for CA node at the media controller
  dvb core: add support for DVB net node at the media controller
  cx231xx: add media controller support
  dvbdev: add pad for the DVB devnodes

 drivers/media/dvb-core/dmxdev.c           | 34 ++++++-----
 drivers/media/dvb-core/dmxdev.h           |  6 ++
 drivers/media/dvb-core/dvb_ca_en50221.c   | 19 +++---
 drivers/media/dvb-core/dvb_ca_en50221.h   |  6 ++
 drivers/media/dvb-core/dvb_frontend.c     |  8 ++-
 drivers/media/dvb-core/dvb_frontend.h     |  7 +++
 drivers/media/dvb-core/dvb_net.c          | 18 +++---
 drivers/media/dvb-core/dvb_net.h          |  6 ++
 drivers/media/dvb-core/dvbdev.c           | 96 ++++++++++++++++++++++++++++++-
 drivers/media/dvb-core/dvbdev.h           | 11 ++++
 drivers/media/usb/cx231xx/cx231xx-cards.c | 60 +++++++++++++++++--
 drivers/media/usb/cx231xx/cx231xx-dvb.c   |  4 ++
 drivers/media/usb/cx231xx/cx231xx.h       |  4 ++
 include/media/media-entity.h              |  5 +-
 include/uapi/linux/media.h                | 16 +++++-
 15 files changed, 257 insertions(+), 43 deletions(-)

-- 
2.1.0

