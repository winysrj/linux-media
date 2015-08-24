Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36646 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbbHXMDr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2015 08:03:47 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/2] MC next gen: add sub-device interfaces
Date: Mon, 24 Aug 2015 09:03:30 -0300
Message-Id: <cover.1440417725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch depends on my MC next gen previous series. It creates
interfaces for V4L2-subdev when the corresponding device nodes
are created.

Mauro Carvalho Chehab (2):
  [media] media-entity: unregister entity links
  [media] v4l2-subdev: create interfaces at MC

 drivers/media/media-entity.c          | 23 +++++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-device.c | 15 +++++++++++++++
 include/media/media-entity.h          |  3 +++
 include/media/v4l2-subdev.h           |  1 +
 4 files changed, 42 insertions(+)

-- 
2.4.3

