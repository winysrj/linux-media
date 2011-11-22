Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1865 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab1KVKFe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 05:05:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/3] vivi: set device_caps.
Date: Tue, 22 Nov 2011 11:05:21 +0100
Message-Id: <bd80eb41a795b4fac63dff9005b10835e4aa8b17.1321956058.git.hans.verkuil@cisco.com>
In-Reply-To: <1321956322-25084-1-git-send-email-hverkuil@xs4all.nl>
References: <1321956322-25084-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <dc234659a7b513338583cb48ba9234460e52e9be.1321956058.git.hans.verkuil@cisco.com>
References: <dc234659a7b513338583cb48ba9234460e52e9be.1321956058.git.hans.verkuil@cisco.com>
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

