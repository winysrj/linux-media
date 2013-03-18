Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2199 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab3CRMce (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 08:32:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 03/19] solo6x10: add v4l2_device.
Date: Mon, 18 Mar 2013 13:32:02 +0100
Message-Id: <1363609938-21735-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
References: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for struct v4l2_device.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/core.c     |    8 ++++++--
 drivers/staging/media/solo6x10/solo6x10.h |    2 ++
 drivers/staging/media/solo6x10/v4l2-enc.c |    2 +-
 drivers/staging/media/solo6x10/v4l2.c     |    2 +-
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/solo6x10/core.c b/drivers/staging/media/solo6x10/core.c
index 27ae75a..271759f 100644
--- a/drivers/staging/media/solo6x10/core.c
+++ b/drivers/staging/media/solo6x10/core.c
@@ -180,6 +180,7 @@ static void free_solo_dev(struct solo_dev *solo_dev)
 
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
+	v4l2_device_unregister(&solo_dev->v4l2_dev);
 	pci_set_drvdata(pdev, NULL);
 
 	kfree(solo_dev);
@@ -510,7 +511,9 @@ static int solo_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	solo_dev->type = id->driver_data;
 	solo_dev->pdev = pdev;
 	spin_lock_init(&solo_dev->reg_io_lock);
-	pci_set_drvdata(pdev, solo_dev);
+	ret = v4l2_device_register(&pdev->dev, &solo_dev->v4l2_dev);
+	if (ret)
+		goto fail_probe;
 
 	/* Only for during init */
 	solo_dev->p2m_jiffies = msecs_to_jiffies(100);
@@ -677,7 +680,8 @@ fail_probe:
 
 static void solo_pci_remove(struct pci_dev *pdev)
 {
-	struct solo_dev *solo_dev = pci_get_drvdata(pdev);
+	struct v4l2_device *v4l2_dev = pci_get_drvdata(pdev);
+	struct solo_dev *solo_dev = container_of(v4l2_dev, struct solo_dev, v4l2_dev);
 
 	free_solo_dev(solo_dev);
 }
diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index a8924a9..77041f5 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -37,6 +37,7 @@
 
 #include <linux/videodev2.h>
 #include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
 #include <media/videobuf-core.h>
 
 #include "registers.h"
@@ -178,6 +179,7 @@ struct solo_dev {
 	u32			irq_mask;
 	u32			motion_mask;
 	spinlock_t		reg_io_lock;
+	struct v4l2_device	v4l2_dev;
 
 	/* tw28xx accounting */
 	u8			tw2865, tw2864, tw2815;
diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index 8f02af2..c4b2a34 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -1670,7 +1670,7 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 	solo_enc->ch = ch;
 
 	*solo_enc->vfd = solo_enc_template;
-	solo_enc->vfd->parent = &solo_dev->pdev->dev;
+	solo_enc->vfd->v4l2_dev = &solo_dev->v4l2_dev;
 	ret = video_register_device(solo_enc->vfd, VFL_TYPE_GRABBER, nr);
 	if (ret < 0) {
 		video_device_release(solo_enc->vfd);
diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
index d2f6eb6..ae1c119 100644
--- a/drivers/staging/media/solo6x10/v4l2.c
+++ b/drivers/staging/media/solo6x10/v4l2.c
@@ -823,7 +823,7 @@ int solo_v4l2_init(struct solo_dev *solo_dev, unsigned nr)
 		return -ENOMEM;
 
 	*solo_dev->vfd = solo_v4l2_template;
-	solo_dev->vfd->parent = &solo_dev->pdev->dev;
+	solo_dev->vfd->v4l2_dev = &solo_dev->v4l2_dev;
 
 	ret = video_register_device(solo_dev->vfd, VFL_TYPE_GRABBER, nr);
 	if (ret < 0) {
-- 
1.7.10.4

