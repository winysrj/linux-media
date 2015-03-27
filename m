Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:50017 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751715AbbC0SSF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2015 14:18:05 -0400
Message-ID: <55159ED4.8040507@xs4all.nl>
Date: Fri, 27 Mar 2015 11:17:56 -0700
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
Subject: [PATCH] saa7164: fix querycap warning
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

Please use this patch to fix the querycap warning in saa7164, this is the
correct fix. In the past drivers were all over the place in how they filled
in the capabilities field: it was either just the caps for the device node, or
the caps for the full driver capabilities. Now capabilities reports the
full driver caps and device_caps that of just the device node. Best of both
worlds. The warning was added to warn about drivers that didn't set device_caps
correctly, and it is a mystery to me how I missed saa7164. Anyway, the warning
did its job.

Regards,

	Hans

------

Fix the VIDIOC_QUERYCAP warning due to the missing device_caps. Don't fill
in the version field, the V4L2 core will do that for you.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 9266965..7a0a651 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -721,13 +721,14 @@ static int vidioc_querycap(struct file *file, void  *priv,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));

-	cap->capabilities =
+	cap->device_caps =
 		V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_READWRITE     |
-		0;
+		V4L2_CAP_READWRITE |
+		V4L2_CAP_TUNER;

-	cap->capabilities |= V4L2_CAP_TUNER;
-	cap->version = 0;
+	cap->capabilities = cap->device_caps |
+		V4L2_CAP_VBI_CAPTURE |
+		V4L2_CAP_DEVICE_CAPS;

 	return 0;
 }
diff --git a/drivers/media/pci/saa7164/saa7164-vbi.c b/drivers/media/pci/saa7164/saa7164-vbi.c
index 6e025fe..06117e6 100644
--- a/drivers/media/pci/saa7164/saa7164-vbi.c
+++ b/drivers/media/pci/saa7164/saa7164-vbi.c
@@ -660,13 +660,14 @@ static int vidioc_querycap(struct file *file, void  *priv,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));

-	cap->capabilities =
+	cap->device_caps =
 		V4L2_CAP_VBI_CAPTURE |
-		V4L2_CAP_READWRITE     |
-		0;
+		V4L2_CAP_READWRITE |
+		V4L2_CAP_TUNER;

-	cap->capabilities |= V4L2_CAP_TUNER;
-	cap->version = 0;
+	cap->capabilities = cap->device_caps |
+		V4L2_CAP_VIDEO_CAPTURE |
+		V4L2_CAP_DEVICE_CAPS;

 	return 0;
 }
