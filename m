Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:59631 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab2AXJYj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 04:24:39 -0500
Received: from cobaltpc1.localnet (dhcp-10-54-92-32.cisco.com [10.54.92.32])
	by ams-core-2.cisco.com (8.14.3/8.14.3) with ESMTP id q0O9Ob1O007831
	for <linux-media@vger.kernel.org>; Tue, 24 Jan 2012 09:24:38 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH] vivi: don't set V4L2_CAP_DEVICE_CAPS for the device_caps field.
Date: Tue, 24 Jan 2012 10:24:36 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201241024.36234.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2_CAP_DEVICE_CAPS is valid for the capabilities field only as per
the spec.

Found with v4l2-compliance.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/vivi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 84ea88d..5578c19 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -819,9 +819,9 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strcpy(cap->driver, "vivi");
 	strcpy(cap->card, "vivi");
 	strlcpy(cap->bus_info, dev->v4l2_dev.name, sizeof(cap->bus_info));
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
-			    V4L2_CAP_READWRITE | V4L2_CAP_DEVICE_CAPS;
-	cap->device_caps = cap->capabilities;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
+			    V4L2_CAP_READWRITE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
-- 
1.7.7.3

