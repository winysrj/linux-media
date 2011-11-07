Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2581 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab1KGKhm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 05:37:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 2/3] vivi: set device_caps.
Date: Mon,  7 Nov 2011 11:37:25 +0100
Message-Id: <5d9a1932ac141d0537ad4874d3953c3bb0e629b3.1320661643.git.hans.verkuil@cisco.com>
In-Reply-To: <1320662246-8531-1-git-send-email-hverkuil@xs4all.nl>
References: <1320662246-8531-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <43f3b62f1a17a91a02b5a66026b8af02ad31fa2f.1320661643.git.hans.verkuil@cisco.com>
References: <43f3b62f1a17a91a02b5a66026b8af02ad31fa2f.1320661643.git.hans.verkuil@cisco.com>
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
1.7.6.3

