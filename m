Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56001 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbcBEQGa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Feb 2016 11:06:30 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/6] Add media controller support to saa7134
Date: Fri,  5 Feb 2016 14:04:54 -0200
Message-Id: <cover.1454688187.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series add media controller support to sa7134 driver. Tested with a
ASUStek P7131 Dual board.

Mauro Carvalho Chehab (6):
  [media] add media controller support to videobuf2-dvb
  [media] saa7134: use input types, instead of hardcoding strings
  [media] saa7134: unconditionlally update TV standard at demod
  [media] saa7134: Get rid of struct saa7134_input.tv field
  [media] v4l2-mc: add an ancillary routine for PCI-based MC
  [media] saa7134: add media controller support

 drivers/media/pci/cx23885/cx23885-dvb.c            |    3 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |    3 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c |    4 +-
 drivers/media/pci/saa7134/saa7134-cards.c          | 1813 +++++++++-----------
 drivers/media/pci/saa7134/saa7134-core.c           |  191 ++-
 drivers/media/pci/saa7134/saa7134-dvb.c            |    9 +-
 drivers/media/pci/saa7134/saa7134-tvaudio.c        |   13 +-
 drivers/media/pci/saa7134/saa7134-video.c          |   87 +-
 drivers/media/pci/saa7134/saa7134.h                |   45 +-
 drivers/media/v4l2-core/v4l2-mc.c                  |   35 +
 drivers/media/v4l2-core/videobuf2-dvb.c            |   13 +-
 include/media/v4l2-mc.h                            |   24 +-
 include/media/videobuf2-dvb.h                      |    5 +
 13 files changed, 1209 insertions(+), 1036 deletions(-)

-- 
2.5.0


