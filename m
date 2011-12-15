Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3242 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab1LOJmh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 04:42:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 2/3] vivi: set device_caps.
Date: Thu, 15 Dec 2011 10:42:27 +0100
Message-Id: <3ef7923c09d85dc91d21bfa26d89548a81417f42.1323941922.git.hans.verkuil@cisco.com>
In-Reply-To: <1323942148-13503-1-git-send-email-hverkuil@xs4all.nl>
References: <1323942148-13503-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <b6fe112d47eb23b6c1f87da072915140d7a3b2f6.1323941922.git.hans.verkuil@cisco.com>
References: <b6fe112d47eb23b6c1f87da072915140d7a3b2f6.1323941922.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/vivi.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 7d754fb..84ea88d 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -819,8 +819,9 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strcpy(cap->driver, "vivi");
 	strcpy(cap->card, "vivi");
 	strlcpy(cap->bus_info, dev->v4l2_dev.name, sizeof(cap->bus_info));
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING | \
-			    V4L2_CAP_READWRITE;
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
+			    V4L2_CAP_READWRITE | V4L2_CAP_DEVICE_CAPS;
+	cap->device_caps = cap->capabilities;
 	return 0;
 }
 
-- 
1.7.7.3

