Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:47392 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315Ab2HVVAk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 17:00:40 -0400
Received: by weyx8 with SMTP id x8so18499wey.19
        for <linux-media@vger.kernel.org>; Wed, 22 Aug 2012 14:00:39 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH] m2m-deinterlace: Add V4L2_CAP_VIDEO_M2M capability flag
Date: Wed, 22 Aug 2012 23:00:20 +0200
Message-Id: <1345669220-21052-2-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1345669220-21052-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <1345669220-21052-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New mem-to-mem video drivers should use V4L2_CAP_VIDEO_M2M capability, rather
than ORed V4L2_CAP_VIDEO_CAPTURE and V4L2_CAP_VIDEO_OUTPUT flags, as outlined
in commit a1367f1b260d29e9b9fb20d8e2f39f1e74fa6c3b.

Cc: Javier Martin <javier.martin@vista-silicon.com>
Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/platform/m2m-deinterlace.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index a38c152..5c7df67 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -456,8 +456,13 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strlcpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver));
 	strlcpy(cap->card, MEM2MEM_NAME, sizeof(cap->card));
 	strlcpy(cap->bus_info, MEM2MEM_NAME, sizeof(cap->card));
-	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
-			  | V4L2_CAP_STREAMING;
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

