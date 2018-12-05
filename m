Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D31CC04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 17:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20CD420879
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 17:23:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20CD420879
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbeLERX5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 12:23:57 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44608 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727242AbeLERX5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 12:23:57 -0500
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1001])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id AA939634C83;
        Wed,  5 Dec 2018 19:23:47 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     mchehab@kernel.org
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 1/1] media: Add a Kconfig option for the Request API
Date:   Wed,  5 Dec 2018 19:23:54 +0200
Message-Id: <20181205172354.32372-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The Request API is now merged to the kernel but the confidence on the
stability of that API is not great, especially regarding the interaction
with V4L2.

Add a Kconfig option for the API, with a scary-looking warning.

The patch itself disables request creation as well as does not advertise
them as buffer flags. The driver requiring requests (cedrus) now depends
on the Kconfig option as well.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
since v1:

- Write out the #ifdef's in request creation

- The option's functionality was reversed in request creation, fixed that

 drivers/media/Kconfig                           | 13 +++++++++++++
 drivers/media/common/videobuf2/videobuf2-v4l2.c |  2 ++
 drivers/media/media-device.c                    |  4 ++++
 drivers/staging/media/sunxi/cedrus/Kconfig      |  1 +
 4 files changed, 20 insertions(+)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 8add62a18293..102eb35fcf3f 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -110,6 +110,19 @@ config MEDIA_CONTROLLER_DVB
 
 	  This is currently experimental.
 
+config MEDIA_CONTROLLER_REQUEST_API
+	bool "Enable Media controller Request API (EXPERIMENTAL)"
+	depends on MEDIA_CONTROLLER && STAGING_MEDIA
+	default n
+	---help---
+	  DO NOT ENABLE THIS OPTION UNLESS YOU KNOW WHAT YOU'RE DOING.
+
+	  This option enables the Request API for the Media controller and V4L2
+	  interfaces. It is currently needed by a few stateless codec drivers.
+
+	  There is currently no intention to provide API or ABI stability for
+	  this new API as of yet.
+
 #
 # Video4Linux support
 #	Only enables if one of the V4L2 types (ATV, webcam, radio) is selected
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 1244c246d0c4..83c3c0c49e56 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -630,8 +630,10 @@ static void fill_buf_caps(struct vb2_queue *q, u32 *caps)
 		*caps |= V4L2_BUF_CAP_SUPPORTS_USERPTR;
 	if (q->io_modes & VB2_DMABUF)
 		*caps |= V4L2_BUF_CAP_SUPPORTS_DMABUF;
+#ifdef CONFIG_MEDIA_CONTROLLER_REQUEST_API
 	if (q->supports_requests)
 		*caps |= V4L2_BUF_CAP_SUPPORTS_REQUESTS;
+#endif
 }
 
 int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index bed24372e61f..b8ec88612df7 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -381,10 +381,14 @@ static long media_device_get_topology(struct media_device *mdev, void *arg)
 static long media_device_request_alloc(struct media_device *mdev,
 				       int *alloc_fd)
 {
+#ifdef CONFIG_MEDIA_CONTROLLER_REQUEST_API
 	if (!mdev->ops || !mdev->ops->req_validate || !mdev->ops->req_queue)
 		return -ENOTTY;
 
 	return media_request_alloc(mdev, alloc_fd);
+#else
+	return -ENOTTY;
+#endif
 }
 
 static long copy_arg_from_user(void *karg, void __user *uarg, unsigned int cmd)
diff --git a/drivers/staging/media/sunxi/cedrus/Kconfig b/drivers/staging/media/sunxi/cedrus/Kconfig
index a7a34e89c42d..3252efa422f9 100644
--- a/drivers/staging/media/sunxi/cedrus/Kconfig
+++ b/drivers/staging/media/sunxi/cedrus/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_SUNXI_CEDRUS
 	depends on VIDEO_DEV && VIDEO_V4L2 && MEDIA_CONTROLLER
 	depends on HAS_DMA
 	depends on OF
+	depends on MEDIA_CONTROLLER_REQUEST_API
 	select SUNXI_SRAM
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
-- 
2.11.0

