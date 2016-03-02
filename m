Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60867 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbcCBOQQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 09:16:16 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/2] Don't duplicate a function to create graph on au0828
Date: Wed,  2 Mar 2016 11:16:07 -0300
Message-Id: <cover.1456928097.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All other drivers are using already the core to create the graph. Do the
same for au0828.

Mauro Carvalho Chehab (2):
  [media] au0828: use standard demod pads struct
  [media] au0828: use v4l2_mc_create_media_graph()

 drivers/media/dvb-frontends/au8522.h         |  9 ---
 drivers/media/dvb-frontends/au8522_decoder.c |  8 +--
 drivers/media/dvb-frontends/au8522_priv.h    |  3 +-
 drivers/media/usb/au0828/au0828-core.c       |  2 +-
 drivers/media/usb/au0828/au0828-video.c      | 99 +---------------------------
 drivers/media/v4l2-core/v4l2-mc.c            | 21 +++++-
 include/media/v4l2-mc.h                      |  1 +
 7 files changed, 30 insertions(+), 113 deletions(-)

-- 
2.5.0


