Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60809 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbbFLLcW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 07:32:22 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v2] Kconfig: disable Media Controller for DVB
Date: Fri, 12 Jun 2015 08:31:26 -0300
Message-Id: <95e2a872eef0289e19e104d520abd69709899e3a.1434108678.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since when we start discussions about the usage Media Controller
for complex hardware, one thing become clear: the way it is, MC
fails to map anything more complex than a webcam.

The point is that MC has entities named as devnodes, but the only
devnode used (before the DVB patches) is MEDIA_ENT_T_DEVNODE_V4L.
Due to the way MC got implemented, however, this entity actually
doesn't represent the devnode, but the hardware I/O engine that
receives data via DMA.

By coincidence, such DMA is associated with the V4L device node
on webcam hardware, but this is not true even for other V4L2
devices. For example, on USB hardware, the DMA is done via the
USB controller. The data passes though a in-kernel filter that
strips off the URB headers. Other V4L2 devices like radio may not
even have DMA. When it have, the DMA is done via ALSA, and not
via the V4L devnode.

In other words, MC is broken as a whole, but tagging it as BROKEN
right now would do more harm than good.

So, instead, let's mark, for now, the DVB part as broken and
block all new changes to MC while we fix this mess, whith
we hopefully will do for the next Kernel version.

Requested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 3ef0f90b128f..157099243d61 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -97,6 +97,7 @@ config MEDIA_CONTROLLER
 config MEDIA_CONTROLLER_DVB
 	bool "Enable Media controller for DVB"
 	depends on MEDIA_CONTROLLER
+	depends on BROKEN
 	---help---
 	  Enable the media controller API support for DVB.
 
-- 
2.4.2

