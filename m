Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:41367 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752843AbbCHRx2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Mar 2015 13:53:28 -0400
Message-ID: <54FC8C80.2050108@xs4all.nl>
Date: Sun, 08 Mar 2015 18:53:04 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Joseph Jasi <joe.yasi@gmail.com>
Subject: [PATCH for v4.0] cx23885: fix querycap
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cap->device_caps wasn't set in cx23885-417.c causing a warning from
the v4l2-core.

Reported-by: Joseph Jasi <joe.yasi@gmail.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index e4901a5..9cb92c6 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1340,13 +1340,11 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	strlcpy(cap->card, cx23885_boards[tsport->dev->board].name,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
-	cap->capabilities =
-		V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_READWRITE     |
-		V4L2_CAP_STREAMING     |
-		0;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
+			   V4L2_CAP_STREAMING;
 	if (dev->tuner_type != TUNER_ABSENT)
-		cap->capabilities |= V4L2_CAP_TUNER;
+		cap->device_caps |= V4L2_CAP_TUNER;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
 }
