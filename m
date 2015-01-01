Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57605 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbbAAPvo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Jan 2015 10:51:44 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Akihiro TSUKADA <tskd08@gmail.com>
Subject: [RFC PATCH 0/5] mb96a20s:use DVB core I2C binding and add media controller support
Date: Thu,  1 Jan 2015 13:51:21 -0200
Message-Id: <cover.1420127255.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those patches are currently experimental and they depend on
this patch:
	https://patchwork.linuxtv.org/patch/27329/

There are 2 cleanup patches here for mb86a20s, and one patch that
converts it to use the new I2C binding helper routines added at the
DVB core.

The next patch extends the DVB core I2C binding routines to add media
controller support for the DVB demod.

The final patch makes cx231xx to register to the media controller,
if the device has a mb86a20s.

Please notice that the current media controller support is actually
too poor and not complete, as it doesn't create and pads to the demod
entity. More work is needed, in order to add the demod pads to it.

That would require some changes at the dvb core, for it to be media
controller aware, and to create the nodes for the DVR and for the other
elements of the DVB graph.

For now, all it shows is:

Media controller API version 0.1.1

Media device information
------------------------
driver          cx231xx
model           Pixelview PlayTV USB Hybrid
serial          CIR000000000001
bus info        1.2
hw revision     0x4001
driver version  3.19.0

Device topology
- entity 1: mb86a20s (0 pad, 0 link)
            type Node subtype DVB flags 20005

Mauro Carvalho Chehab (5):
  mb86a20s: remove unused debug modprobe parameter
  mb86a20s: convert it to I2C binding model
  mb86a20s: remove two uneeded macros
  dvb core: add media controller support for the demod
  cx231xx: add media controller support for mb86a20s boards

 drivers/media/dvb-core/dvb_frontend.h   |  7 +++
 drivers/media/dvb-core/dvb_i2c.c        | 30 ++++++++++-
 drivers/media/dvb-core/dvb_i2c.h        |  3 +-
 drivers/media/dvb-frontends/mb86a20s.c  | 90 +++++++++++++++------------------
 drivers/media/dvb-frontends/mb86a20s.h  | 19 -------
 drivers/media/pci/cx23885/cx23885-dvb.c | 13 +++--
 drivers/media/pci/saa7134/saa7134-dvb.c | 13 +++--
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 64 ++++++++++++++++++++---
 drivers/media/usb/em28xx/em28xx-dvb.c   | 13 +++--
 include/uapi/linux/media.h              |  4 +-
 10 files changed, 165 insertions(+), 91 deletions(-)

-- 
2.1.0

