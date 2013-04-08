Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:3520 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934763Ab3DHK7W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 06:59:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 06/12] hdpvr: support device_caps in querycap.
Date: Mon,  8 Apr 2013 12:58:35 +0200
Message-Id: <1365418721-23859-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365418721-23859-1-git-send-email-hverkuil@xs4all.nl>
References: <1365418721-23859-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/hdpvr/hdpvr-video.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index e30ece2..406eda8 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -538,9 +538,9 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strcpy(cap->driver, "hdpvr");
 	strcpy(cap->card, "Hauppauge HD PVR");
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
-	cap->capabilities =     V4L2_CAP_VIDEO_CAPTURE |
-				V4L2_CAP_AUDIO         |
-				V4L2_CAP_READWRITE;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_AUDIO |
+			    V4L2_CAP_READWRITE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
-- 
1.7.10.4

