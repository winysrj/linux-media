Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34907 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbcBLJqf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 04:46:35 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/11] Some improvements/fixes
Date: Fri, 12 Feb 2016 07:44:55 -0200
Message-Id: <cover.1455269986.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm testing the Media Controller graph on some of my boards.
While here, I noticed some troubles when producing the graphs.

This series address them. 

PS.: I'm storing the graphs of the boards I've tested at:
	https://mchehab.fedorapeople.org/mc-next-gen/?C=M;O=D

I improved the v4l2-utils tool that produces the graph (contrib/test/mc_nextgen_test)
to add a title on each graph. So, the files after 2016-02-12 will contain the info
provided by MEDIA_IOC_DEVICE_INFO ioctl.

Mauro Carvalho Chehab (11):
  [media] v4l2-mc.h: prevent it for being included twice
  [media] v4l2-mc: add a routine to create USB media_device
  [media] rc-core: don't lock device at rc_register_device()
  [media] allow overriding the driver name
  [media] use v4l2_mc_usb_media_device_init() on most USB devices
  [media] v4l2-mc: use usb_make_path() to provide bus info
  [media] em28xx-dvb: create RF connector on DVB-only mode
  [media] cx231xx: use v4l2 core function to create the MC graph
  [media] si2157: register as a tuner entity
  [media] cx231xx, em28xx: pass media_device to si2157
  [media] cx231xx: create connectors at the media graph

 drivers/media/media-device.c                |  6 ++-
 drivers/media/rc/rc-main.c                  | 45 ++++++++++++---------
 drivers/media/tuners/si2157.c               | 32 ++++++++++++++-
 drivers/media/tuners/si2157.h               |  5 +++
 drivers/media/tuners/si2157_priv.h          |  8 ++++
 drivers/media/usb/au0828/au0828-core.c      | 19 ++-------
 drivers/media/usb/cx231xx/cx231xx-cards.c   | 62 +++--------------------------
 drivers/media/usb/cx231xx/cx231xx-dvb.c     | 10 ++++-
 drivers/media/usb/cx231xx/cx231xx-video.c   | 46 +++++++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx.h         |  3 ++
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 13 +-----
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c     | 15 +------
 drivers/media/usb/em28xx/em28xx-cards.c     | 23 ++++-------
 drivers/media/usb/em28xx/em28xx-dvb.c       | 13 +++++-
 drivers/media/usb/em28xx/em28xx-video.c     |  3 +-
 drivers/media/usb/siano/smsusb.c            |  1 +
 drivers/media/v4l2-core/v4l2-mc.c           | 41 ++++++++++++++++++-
 include/media/media-device.h                |  5 +++
 include/media/rc-core.h                     |  2 +
 include/media/v4l2-mc.h                     | 44 +++++++++++++++++---
 20 files changed, 255 insertions(+), 141 deletions(-)

-- 
2.5.0


