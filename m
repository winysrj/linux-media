Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52488 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbbL3Nti (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 08:49:38 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/6]  Some improvements for DVB media graph
Date: Wed, 30 Dec 2015 11:48:50 -0200
Message-Id: <cover.1451482760.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series is the result of some additional tests with the media controller and
several different  pure digital TV devices, using the dvb-usb, dvb-usb-v2 core and 
the siano driver.

It addresses some minor issues, and improves the graph representation of
those devices. In particular, the DVB USB v2 mxl111sf driver supports one
device that has:
- one tuner, provided by the MXL chipset;
- three demodulators (one for ATSC, one for ClearQAM and one for DVB-T), each
  one using a different chip and different driver (lg2161, lgdt3305 and an internal
  DVB-T demodulator inside the MXL chipset);
- one demod, provided by the MXL chipset.

The graph for such design is at:
	https://mchehab.fedorapeople.org/mc-next-gen/mxl111sf.png
with is generated, after this changeset, using mc-nextgen-test tool, available
at:
	https://git.linuxtv.org/mchehab/experimental-v4l-utils.git/log/?h=mc-next-gen-v2

The .dot file produced by the tool is at:
	https://mchehab.fedorapeople.org/mc-next-gen/mxl111sf.dot

Before this patch series, the RF connector and tuner were not shown.
Also, the graph were missing the connections for the frontends 0 and 1.

Mauro Carvalho Chehab (6):
  [media] dvbdev: remove two dead functions if
    !CONFIG_MEDIA_CONTROLLER_DVB
  [media] dvbdev: Add RF connector if needed
  [media] dvb-usb-v2: postpone removal of media_device
  [media] media-entitiy: add a function to create multiple links
  [media] dvbdev: create links on devices with multiple frontends
  [media] mxl111sf: Add a tuner entity

 drivers/media/common/siano/smsdvb-main.c    |  2 +-
 drivers/media/dvb-core/dvbdev.c             | 98 +++++++++++++++++++++++++----
 drivers/media/dvb-core/dvbdev.h             | 33 +++++++++-
 drivers/media/media-entity.c                | 65 +++++++++++++++++++
 drivers/media/usb/au0828/au0828-dvb.c       |  2 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c     |  2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c |  4 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c     | 20 ++++++
 drivers/media/usb/dvb-usb-v2/mxl111sf.h     |  5 ++
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c     |  2 +-
 include/media/media-entity.h                | 51 +++++++++++++++
 11 files changed, 264 insertions(+), 20 deletions(-)

-- 
2.5.0


