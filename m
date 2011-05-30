Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44393 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1E3Spo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2011 14:45:44 -0400
Received: from localhost.localdomain (unknown [91.178.186.233])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 187293599C
	for <linux-media@vger.kernel.org>; Mon, 30 May 2011 18:45:43 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: Fix media device minor registration
Date: Mon, 30 May 2011 20:45:47 +0200
Message-Id: <1306781147-25480-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The find_next_zero_bit() is called with the from and to arguments in the
wrong order. This results in the function always returning 0, and all
media devices being registered with minor 0. Furthermore, mdev->minor is
then used before being assigned with the find_next_zero_bit() return
value. This really makes sure we'll always use minor 0.

Fix this and let the system support more than one media device.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: stable@kernel.org
---
 drivers/media/media-devnode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index af5263c..7b42ace 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -213,14 +213,14 @@ int __must_check media_devnode_register(struct media_devnode *mdev)
 
 	/* Part 1: Find a free minor number */
 	mutex_lock(&media_devnode_lock);
-	minor = find_next_zero_bit(media_devnode_nums, 0, MEDIA_NUM_DEVICES);
+	minor = find_next_zero_bit(media_devnode_nums, MEDIA_NUM_DEVICES, 0);
 	if (minor == MEDIA_NUM_DEVICES) {
 		mutex_unlock(&media_devnode_lock);
 		printk(KERN_ERR "could not get a free minor\n");
 		return -ENFILE;
 	}
 
-	set_bit(mdev->minor, media_devnode_nums);
+	set_bit(minor, media_devnode_nums);
 	mutex_unlock(&media_devnode_lock);
 
 	mdev->minor = minor;
-- 
1.7.3.4

