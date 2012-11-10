Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53577 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab2KJW6M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Nov 2012 17:58:12 -0500
Received: by mail-wi0-f178.google.com with SMTP id hr7so1464532wib.1
        for <linux-media@vger.kernel.org>; Sat, 10 Nov 2012 14:58:11 -0800 (PST)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [PATCH] exynos-gsc: Add missing video device vfl_dir flag initialization
Date: Sat, 10 Nov 2012 23:57:56 +0100
Message-Id: <1352588276-16260-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vfl_dir should be set to VFL_DIR_M2M so valid ioctls for this
mem-to-mem device can be properly determined in the v4l2 core.

Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>
Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
I didn't run-time test this patch.

 drivers/media/platform/exynos-gsc/gsc-m2m.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 3c7f005..88642a8 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -732,6 +732,7 @@ int gsc_register_m2m_device(struct gsc_dev *gsc)
 	gsc->vdev.ioctl_ops	= &gsc_m2m_ioctl_ops;
 	gsc->vdev.release	= video_device_release_empty;
 	gsc->vdev.lock		= &gsc->lock;
+	gsc->vdev.vfl_dir	= VFL_DIR_M2M;
 	snprintf(gsc->vdev.name, sizeof(gsc->vdev.name), "%s.%d:m2m",
 					GSC_MODULE_NAME, gsc->id);

--
1.7.4.1

