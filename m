Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39754 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab0KUUcy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Nov 2010 15:32:54 -0500
Received: from localhost.localdomain (unknown [91.178.49.10])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5A21F35CA7
	for <linux-media@vger.kernel.org>; Sun, 21 Nov 2010 20:32:53 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 5/5] uvcvideo: Convert to unlocked_ioctl
Date: Sun, 21 Nov 2010 21:32:53 +0100
Message-Id: <1290371573-14907-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1290371573-14907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1290371573-14907-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The uvcvideo driver now locks all ioctls correctly on its own, the BKL
isn't needed anymore.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/uvc_v4l2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index b4615e2..3349e26 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -1088,7 +1088,7 @@ const struct v4l2_file_operations uvc_fops = {
 	.owner		= THIS_MODULE,
 	.open		= uvc_v4l2_open,
 	.release	= uvc_v4l2_release,
-	.ioctl		= uvc_v4l2_ioctl,
+	.unlocked_ioctl	= uvc_v4l2_ioctl,
 	.read		= uvc_v4l2_read,
 	.mmap		= uvc_v4l2_mmap,
 	.poll		= uvc_v4l2_poll,
-- 
1.7.2.2

