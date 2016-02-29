Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:60958 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180AbcB2Lpz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 06:45:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/5] v4l2-pci-skeleton.c: fill in device_caps in video_device
Date: Mon, 29 Feb 2016 12:45:42 +0100
Message-Id: <1456746345-1431-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1456746345-1431-1-git-send-email-hverkuil@xs4all.nl>
References: <1456746345-1431-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

With the new core support for the caps the driver no longer needs
to set device_caps and capabilities in the querycap call.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-pci-skeleton.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/video4linux/v4l2-pci-skeleton.c b/Documentation/video4linux/v4l2-pci-skeleton.c
index 79af0c0..65fae1a 100644
--- a/Documentation/video4linux/v4l2-pci-skeleton.c
+++ b/Documentation/video4linux/v4l2-pci-skeleton.c
@@ -308,9 +308,6 @@ static int skeleton_querycap(struct file *file, void *priv,
 	strlcpy(cap->card, "V4L2 PCI Skeleton", sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
 		 pci_name(skel->pdev));
-	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
-			   V4L2_CAP_STREAMING;
-	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
@@ -872,6 +869,9 @@ static int skeleton_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	vdev->release = video_device_release_empty;
 	vdev->fops = &skel_fops,
 	vdev->ioctl_ops = &skel_ioctl_ops,
+	/* Fill in the device caps */
+	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
+			    V4L2_CAP_STREAMING;
 	/*
 	 * The main serialization lock. All ioctls are serialized by this
 	 * lock. Exception: if q->lock is set, then the streaming ioctls
-- 
2.7.0

