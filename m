Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1892 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3CRMca (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 08:32:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 02/19] solo6x10: fix querycap and update driver version.
Date: Mon, 18 Mar 2013 13:32:01 +0100
Message-Id: <1363609938-21735-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
References: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Setup correct bus_info, let the v4l2 core set the version and add device_caps
support.

Also update the module version to 3.0.0 since this is a major upgrade.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/solo6x10.h |   11 +----------
 drivers/staging/media/solo6x10/v4l2-enc.c |    9 ++++-----
 drivers/staging/media/solo6x10/v4l2.c     |    9 ++++-----
 3 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index 44ae160..a8924a9 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -71,16 +71,7 @@
 
 #define SOLO_MAX_CHANNELS		16
 
-/* Make sure these two match */
-#define SOLO6X10_VER_MAJOR		2
-#define SOLO6X10_VER_MINOR		4
-#define SOLO6X10_VER_SUB		4
-#define SOLO6X10_VER_NUM \
-	KERNEL_VERSION(SOLO6X10_VER_MAJOR, SOLO6X10_VER_MINOR, SOLO6X10_VER_SUB)
-#define SOLO6X10_VERSION \
-	__stringify(SOLO6X10_VER_MAJOR) "." \
-	__stringify(SOLO6X10_VER_MINOR) "." \
-	__stringify(SOLO6X10_VER_SUB)
+#define SOLO6X10_VERSION		"3.0.0"
 
 /*
  * The SOLO6x10 actually has 8 i2c channels, but we only use 2.
diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index b05b328..8f02af2 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -991,12 +991,11 @@ static int solo_enc_querycap(struct file *file, void  *priv,
 	strcpy(cap->driver, SOLO6X10_NAME);
 	snprintf(cap->card, sizeof(cap->card), "Softlogic 6x10 Enc %d",
 		 solo_enc->ch);
-	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI %s",
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
 		 pci_name(solo_dev->pdev));
-	cap->version = SOLO6X10_VER_NUM;
-	cap->capabilities =     V4L2_CAP_VIDEO_CAPTURE |
-				V4L2_CAP_READWRITE |
-				V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
+			V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
index f8ec2a3..d2f6eb6 100644
--- a/drivers/staging/media/solo6x10/v4l2.c
+++ b/drivers/staging/media/solo6x10/v4l2.c
@@ -476,12 +476,11 @@ static int solo_querycap(struct file *file, void  *priv,
 
 	strcpy(cap->driver, SOLO6X10_NAME);
 	strcpy(cap->card, "Softlogic 6x10");
-	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI %s",
+	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
 		 pci_name(solo_dev->pdev));
-	cap->version = SOLO6X10_VER_NUM;
-	cap->capabilities =     V4L2_CAP_VIDEO_CAPTURE |
-				V4L2_CAP_READWRITE |
-				V4L2_CAP_STREAMING;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
+			V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
-- 
1.7.10.4

