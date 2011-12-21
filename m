Return-path: <linux-media-owner@vger.kernel.org>
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:4917
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751719Ab1LUDdg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 22:33:36 -0500
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: <sakari.ailus@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	<linux-media@vger.kernel.org>,
	<uclinux-dist-devel@blackfin.uclinux.org>
CC: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [PATCH] v4l2: v4l2-fh: v4l2_fh_is_singular should use list head to test
Date: Wed, 21 Dec 2011 10:30:54 -0500
Message-ID: <1324481454-30066-1-git-send-email-scott.jiang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

list_is_singular accepts a list head to test whether a list has just one entry.
fh->list is the entry, fh->vdev->fh_list is the list head.

Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
---
 drivers/media/video/v4l2-fh.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
index 9e3fc04..8292c4a 100644
--- a/drivers/media/video/v4l2-fh.c
+++ b/drivers/media/video/v4l2-fh.c
@@ -113,7 +113,7 @@ int v4l2_fh_is_singular(struct v4l2_fh *fh)
 	if (fh == NULL || fh->vdev == NULL)
 		return 0;
 	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
-	is_singular = list_is_singular(&fh->list);
+	is_singular = list_is_singular(&fh->vdev->fh_list);
 	spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
 	return is_singular;
 }
-- 
1.7.0.4


