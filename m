Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35757 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbcBVOQb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 09:16:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/5] [media] v4l2-mc: fix hardware version for PCI devices
Date: Mon, 22 Feb 2016 11:16:20 -0300
Message-Id: <94b7dd3efb7125e7809be1d42958565f7e0aaba7.1456150537.git.mchehab@osg.samsung.com>
In-Reply-To: <72ef5fcae1ee23265c796b0cacd64ee41b9b9301.1456150537.git.mchehab@osg.samsung.com>
References: <72ef5fcae1ee23265c796b0cacd64ee41b9b9301.1456150537.git.mchehab@osg.samsung.com>
In-Reply-To: <72ef5fcae1ee23265c796b0cacd64ee41b9b9301.1456150537.git.mchehab@osg.samsung.com>
References: <72ef5fcae1ee23265c796b0cacd64ee41b9b9301.1456150537.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It should be a bitwise or, and not a logical one. Also, add
parenthesis, to make sure it will be applied in the right order.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/v4l2-core/v4l2-mc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
index a7f41b323522..64eefb9ffb7e 100644
--- a/drivers/media/v4l2-core/v4l2-mc.c
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -40,8 +40,8 @@ struct media_device *v4l2_mc_pci_media_device_init(struct pci_dev *pci_dev,
 
 	sprintf(mdev->bus_info, "PCI:%s", pci_name(pci_dev));
 
-	mdev->hw_revision = pci_dev->subsystem_vendor << 16
-			    || pci_dev->subsystem_device;
+	mdev->hw_revision = (pci_dev->subsystem_vendor << 16)
+			    | pci_dev->subsystem_device;
 
 	mdev->driver_version = LINUX_VERSION_CODE;
 
-- 
2.5.0

