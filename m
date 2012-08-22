Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53295 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933298Ab2HVVAj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 17:00:39 -0400
Received: by weyx8 with SMTP id x8so18483wey.19
        for <linux-media@vger.kernel.org>; Wed, 22 Aug 2012 14:00:38 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH] coda: Add V4L2_CAP_VIDEO_M2M capability flag
Date: Wed, 22 Aug 2012 23:00:19 +0200
Message-Id: <1345669220-21052-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New mem-to-mem video drivers should use V4L2_CAP_VIDEO_M2M capability, rather
than ORed V4L2_CAP_VIDEO_CAPTURE and V4L2_CAP_VIDEO_OUTPUT flags, as outlined
in commit a1367f1b260d29e9b9fb20d8e2f39f1e74fa6c3b.

Cc: Javier Martin <javier.martin@vista-silicon.com>
Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/platform/coda.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 0d6e0a0..e74705c 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -287,8 +287,13 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strlcpy(cap->driver, CODA_NAME, sizeof(cap->driver));
 	strlcpy(cap->card, CODA_NAME, sizeof(cap->card));
 	strlcpy(cap->bus_info, CODA_NAME, sizeof(cap->bus_info));
-	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
-				| V4L2_CAP_STREAMING;
+	/*
+	 * This is only a mem-to-mem video device. The capture and output
+	 * device capability flags are left only for backward compatibility
+	 * and are scheduled for removal.
+	 */
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT |
+			   V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
-- 
1.7.4.1

