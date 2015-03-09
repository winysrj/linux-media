Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:60524 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057AbbCIHU1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 03:20:27 -0400
Message-ID: <54FD49A3.2090908@xs4all.nl>
Date: Mon, 09 Mar 2015 08:20:03 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Joseph Jasi <joe.yasi@gmail.com>
Subject: [PATCHv2 for v4.0] cx23885: fix querycap
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes in v2:

- PCI -> PCIe
- expand cap->capabilities with all capabilities since these are global
  capabilities.

cap->device_caps wasn't set in cx23885-417.c causing a warning from
the v4l2-core.

Reported-by: Joseph Jasi <joe.yasi@gmail.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index e4901a5..63c0ee5 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1339,14 +1339,13 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(cap->driver, dev->name, sizeof(cap->driver));
 	strlcpy(cap->card, cx23885_boards[tsport->dev->board].name,
 		sizeof(cap->card));
-	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
-	cap->capabilities =
-		V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_READWRITE     |
-		V4L2_CAP_STREAMING     |
-		0;
+	sprintf(cap->bus_info, "PCIe:%s", pci_name(dev->pci));
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
+			   V4L2_CAP_STREAMING;
 	if (dev->tuner_type != TUNER_ABSENT)
-		cap->capabilities |= V4L2_CAP_TUNER;
+		cap->device_caps |= V4L2_CAP_TUNER;
+	cap->capabilities = cap->device_caps | V4L2_CAP_VBI_CAPTURE |
+		V4L2_CAP_AUDIO | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
 }
