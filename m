Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:38366 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932954AbbBQIol (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 03:44:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/6] pvrusb2: replace .ioctl by .unlocked_ioctl.
Date: Tue, 17 Feb 2015 09:44:04 +0100
Message-Id: <1424162649-17249-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1424162649-17249-1-git-send-email-hverkuil@xs4all.nl>
References: <1424162649-17249-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

As far as I can tell pvrusb2 does its own locking, so there is
no need to use .ioctl.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index 35e4ea5..91c1700 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -1247,7 +1247,7 @@ static const struct v4l2_file_operations vdev_fops = {
 	.open       = pvr2_v4l2_open,
 	.release    = pvr2_v4l2_release,
 	.read       = pvr2_v4l2_read,
-	.ioctl      = pvr2_v4l2_ioctl,
+	.unlocked_ioctl = pvr2_v4l2_ioctl,
 	.poll       = pvr2_v4l2_poll,
 };
 
-- 
2.1.4

