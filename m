Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44848 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbcCAO5Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2016 09:57:25 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 6/8] v4l2-pci-skeleton.c: fill in device_caps in video_device
Date: Tue,  1 Mar 2016 16:57:24 +0200
Message-Id: <1456844246-18778-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1456844246-18778-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1456844246-18778-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

With the new core support for the caps the driver no longer needs
to set device_caps and capabilities in the querycap call.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 Documentation/video4linux/v4l2-pci-skeleton.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/video4linux/v4l2-pci-skeleton.c b/Documentation/video4linux/v4l2-pci-skeleton.c
index 79af0c041056..a55cf94ac907 100644
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
 
@@ -872,6 +869,8 @@ static int skeleton_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	vdev->release = video_device_release_empty;
 	vdev->fops = &skel_fops,
 	vdev->ioctl_ops = &skel_ioctl_ops,
+	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
+			    V4L2_CAP_STREAMING;
 	/*
 	 * The main serialization lock. All ioctls are serialized by this
 	 * lock. Exception: if q->lock is set, then the streaming ioctls
-- 
2.4.10

