Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:43928 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932954AbbBQIpH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2015 03:45:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 4/6] uvc gadget: switch to unlocked_ioctl.
Date: Tue, 17 Feb 2015 09:44:07 +0100
Message-Id: <1424162649-17249-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1424162649-17249-1-git-send-email-hverkuil@xs4all.nl>
References: <1424162649-17249-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Instead of .ioctl use unlocked_ioctl. This allows us to finally remove
the old .ioctl op.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/usb/gadget/function/uvc_v4l2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/uvc_v4l2.c b/drivers/usb/gadget/function/uvc_v4l2.c
index 0bd6965..5a84e51 100644
--- a/drivers/usb/gadget/function/uvc_v4l2.c
+++ b/drivers/usb/gadget/function/uvc_v4l2.c
@@ -357,7 +357,7 @@ struct v4l2_file_operations uvc_v4l2_fops = {
 	.owner		= THIS_MODULE,
 	.open		= uvc_v4l2_open,
 	.release	= uvc_v4l2_release,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.mmap		= uvc_v4l2_mmap,
 	.poll		= uvc_v4l2_poll,
 #ifndef CONFIG_MMU
-- 
2.1.4

