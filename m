Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1282 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab3BPKSm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 05:18:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Anatolij Gustschin <agust@denx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/5] fsl-viu: add device_caps support to querycap.
Date: Sat, 16 Feb 2013 11:18:24 +0100
Message-Id: <6f8643d963b8ca63bb65c7878d1bbf8ec586e457.1361009701.git.hans.verkuil@cisco.com>
In-Reply-To: <1361009907-30990-1-git-send-email-hverkuil@xs4all.nl>
References: <1361009907-30990-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <77816a8ba6f0fe685a83a012371cf07b1ab505da.1361009701.git.hans.verkuil@cisco.com>
References: <77816a8ba6f0fe685a83a012371cf07b1ab505da.1361009701.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Also fill in bus_info correctly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/fsl-viu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 4a46819..1567878 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -561,10 +561,12 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	strcpy(cap->driver, "viu");
 	strcpy(cap->card, "viu");
-	cap->capabilities =	V4L2_CAP_VIDEO_CAPTURE |
+	strcpy(cap->bus_info, "platform:viu");
+	cap->device_caps =	V4L2_CAP_VIDEO_CAPTURE |
 				V4L2_CAP_STREAMING     |
 				V4L2_CAP_VIDEO_OVERLAY |
 				V4L2_CAP_READWRITE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
-- 
1.7.10.4

