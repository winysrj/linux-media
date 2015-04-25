Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:45328 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933508AbbDYPnf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2015 11:43:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 07/12] dt3155v4l: drop CONFIG_DT3155_STREAMING
Date: Sat, 25 Apr 2015 17:42:46 +0200
Message-Id: <1429976571-34872-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
References: <1429976571-34872-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

No need to do this as a config option. Just support both MMAP and read()
methods like any other driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/dt3155v4l/Kconfig     | 8 --------
 drivers/staging/media/dt3155v4l/dt3155v4l.c | 8 +-------
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/Kconfig b/drivers/staging/media/dt3155v4l/Kconfig
index 2d49600..fcba866 100644
--- a/drivers/staging/media/dt3155v4l/Kconfig
+++ b/drivers/staging/media/dt3155v4l/Kconfig
@@ -19,11 +19,3 @@ config DT3155_CCIR
 	---help---
 	  Select it for CCIR/50Hz (European region),
 	  or leave it unselected for RS-170/60Hz (North America).
-
-config DT3155_STREAMING
-	bool "Selects streaming capture method"
-	depends on VIDEO_DT3155
-	default y
-	---help---
-	  Select it if you want to use streaming of memory mapped buffers
-	  or leave it unselected if you want to use read method (one copy more).
diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 6d571f6..0162c62 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -29,12 +29,6 @@
 
 #define DT3155_DEVICE_ID 0x1223
 
-#ifdef CONFIG_DT3155_STREAMING
-#define DT3155_CAPTURE_METHOD V4L2_CAP_STREAMING
-#else
-#define DT3155_CAPTURE_METHOD V4L2_CAP_READWRITE
-#endif
-
 /*  global initializers (for all boards)  */
 #ifdef CONFIG_DT3155_CCIR
 static const u8 csr2_init = VT_50HZ;
@@ -346,7 +340,7 @@ static int dt3155_querycap(struct file *filp, void *p, struct v4l2_capability *c
 	strcpy(cap->card, DT3155_NAME " frame grabber");
 	sprintf(cap->bus_info, "PCI:%s", pci_name(pd->pdev));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
-				DT3155_CAPTURE_METHOD;
+		V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
-- 
2.1.4

