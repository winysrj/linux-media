Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:57798 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815Ab2INK57 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 06:57:59 -0400
Received: from cobaltpc1.cisco.com (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id q8EAvqBb013688
	for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 10:57:54 GMT
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Subject: [RFCv3 API PATCH 06/31] vivi/mem2mem_testdev: update to latest bus_info specification.
Date: Fri, 14 Sep 2012 12:57:21 +0200
Message-Id: <0d254e4e0e8976370c6741818a1b7bfae68b8bce.1347619766.git.hans.verkuil@cisco.com>
In-Reply-To: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
References: <7447a305817a5e6c63f089c2e1e948533f1d57ea.1347619765.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prefix bus_info with "platform:".

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/mem2mem_testdev.c |    3 ++-
 drivers/media/platform/vivi.c            |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 0b496f3..74de642 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -430,7 +430,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	strncpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver) - 1);
 	strncpy(cap->card, MEM2MEM_NAME, sizeof(cap->card) - 1);
-	strlcpy(cap->bus_info, MEM2MEM_NAME, sizeof(cap->bus_info));
+	snprintf(cap->bus_info, sizeof(cap->bus_info),
+			"platform:%s", MEM2MEM_NAME);
 	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index a6351c4..7f3e6329 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -898,7 +898,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
 
 	strcpy(cap->driver, "vivi");
 	strcpy(cap->card, "vivi");
-	strlcpy(cap->bus_info, dev->v4l2_dev.name, sizeof(cap->bus_info));
+	snprintf(cap->bus_info, sizeof(cap->bus_info),
+			"platform:%s", dev->v4l2_dev.name);
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
 			    V4L2_CAP_READWRITE;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
-- 
1.7.10.4

