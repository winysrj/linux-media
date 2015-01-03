Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60277 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbbACCE4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jan 2015 21:04:56 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/7] dvb core: add basic support for the media controller
Date: Sat,  3 Jan 2015 00:04:33 -0200
Message-Id: <cover.1420250453.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds basic support for the media controller at the
DVB core: it creates one media entity per DVB devnode, if the media
device is passed as an argument to the DVB structures.

The cx231xx driver was modified to pass such argument for DVB NET,
DVB frontend and DVB demux.

TODO: The media PADs weren't created yet, nor the links between the
several entities.

Mauro Carvalho Chehab (7):
  media: Fix DVB representation at media controller API
  dvb core: add support for media controller at dvbdev
  dvb core: add media controller support for DVB frontend
  dvb core: add support for demux/dvr nodes at media controller
  dvb core: add support for CA node at the media controller
  dvb core: add support for DVB net node at the media controller
  cx231xx: add media controller support

 drivers/media/dvb-core/dmxdev.c           | 34 ++++++++++-------
 drivers/media/dvb-core/dmxdev.h           |  6 +++
 drivers/media/dvb-core/dvb_ca_en50221.c   | 19 ++++++----
 drivers/media/dvb-core/dvb_ca_en50221.h   |  6 +++
 drivers/media/dvb-core/dvb_frontend.c     |  8 +++-
 drivers/media/dvb-core/dvb_frontend.h     |  7 ++++
 drivers/media/dvb-core/dvb_net.c          | 18 +++++----
 drivers/media/dvb-core/dvb_net.h          |  6 +++
 drivers/media/dvb-core/dvbdev.c           | 63 ++++++++++++++++++++++++++++++-
 drivers/media/dvb-core/dvbdev.h           | 10 +++++
 drivers/media/usb/cx231xx/cx231xx-cards.c | 60 ++++++++++++++++++++++++++---
 drivers/media/usb/cx231xx/cx231xx-dvb.c   |  4 ++
 drivers/media/usb/cx231xx/cx231xx.h       |  4 ++
 include/media/media-entity.h              |  5 ++-
 include/uapi/linux/media.h                | 13 ++++++-
 15 files changed, 221 insertions(+), 42 deletions(-)

-- 
2.1.0

