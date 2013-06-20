Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2954 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030251Ab3FTNpL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 09:45:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 15/15] saa7134: don't set vfd->debug.
Date: Thu, 20 Jun 2013 15:44:31 +0200
Message-Id: <1371735871-2658-16-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371735871-2658-1-git-send-email-hverkuil@xs4all.nl>
References: <1371735871-2658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

You can set this through sysfs, so don't mix the two.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index c4bdf45..bfed348 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -803,7 +803,6 @@ static struct video_device *vdev_init(struct saa7134_dev *dev,
 	*vfd = *template;
 	vfd->v4l2_dev  = &dev->v4l2_dev;
 	vfd->release = video_device_release;
-	vfd->debug   = video_debug;
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)",
 		 dev->name, type, saa7134_boards[dev->board].name);
 	set_bit(V4L2_FL_USE_FH_PRIO, &vfd->flags);
-- 
1.8.3.1

