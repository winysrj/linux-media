Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51198 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbbIILcj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Sep 2015 07:32:39 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/2] MC minor cleanups
Date: Wed,  9 Sep 2015 08:32:01 -0300
Message-Id: <cover.1441798267.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This two patch series do some minor cleanups as suggested by Sakari.

Mauro Carvalho Chehab (2):
  [media] media_entity: remove gfp_flags argument
  [media] media-device: use unsigned ints on some places

 drivers/media/dvb-core/dvbdev.c    | 3 +--
 drivers/media/media-device.c       | 7 ++++---
 drivers/media/media-entity.c       | 5 ++---
 drivers/media/v4l2-core/v4l2-dev.c | 3 +--
 include/media/media-entity.h       | 4 +---
 5 files changed, 9 insertions(+), 13 deletions(-)

-- 
2.4.3


