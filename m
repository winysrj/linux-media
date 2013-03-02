Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3923 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3CBXpv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 18:45:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 04/20] solo6x10: add v4l2_device.
Date: Sun,  3 Mar 2013 00:45:20 +0100
Message-Id: <3e3a1e4d495a6e8f5213b8d87aa00c0e65c9c267.1362266529.git.hans.verkuil@cisco.com>
In-Reply-To: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
References: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
References: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
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
index fd83d6d..f571a24 100644
--- a/drivers/staging/media/solo6x10/core.c
+++ b/drivers/staging/media/solo6x10/core.c
@@ -124,6 +124,7 @@ static void free_solo_dev(struct solo_dev *solo_dev)
 
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
+	v4l2_device_unregister(&solo_dev->v4l2_dev);
 	pci_set_drvdata(pdev, NULL);
 
 	kfree(solo_dev);
@@ -144,7 +145,9 @@ static int solo_pci_probe(struct pci_dev *pdev,
 
 	solo_dev->pdev = pdev;
 	spin_lock_init(&solo_dev->reg_io_lock);
-	pci_set_drvdata(pdev, solo_dev);
+	ret = v4l2_device_register(&pdev->dev, &solo_dev->v4l2_dev);
+	if (ret)
+		goto fail_probe;
 
 	ret = pci_enable_device(pdev);
 	if (ret)
@@ -286,7 +289,8 @@ fail_probe:
 
 static void solo_pci_remove(struct pci_dev *pdev)
 {
-	struct solo_dev *solo_dev = pci_get_drvdata(pdev);
+	struct v4l2_device *v4l2_dev = pci_get_drvdata(pdev);
+	struct solo_dev *solo_dev = container_of(v4l2_dev, struct solo_dev, v4l2_dev);
 
 	free_solo_dev(solo_dev);
 }
diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index abee721..8fd3a6a 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -33,6 +33,7 @@
 #include <linux/atomic.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-dev.h>
+#include <media/v4l2-device.h>
 #include <media/videobuf-core.h>
 #include "registers.h"
 
@@ -189,6 +190,7 @@ struct solo_dev {
 	u32			irq_mask;
 	u32			motion_mask;
 	spinlock_t		reg_io_lock;
+	struct v4l2_device	v4l2_dev;
 
 	/* tw28xx accounting */
 	u8			tw2865, tw2864, tw2815;
diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index 85e90df..a949a14 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -1746,7 +1746,7 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
 	solo_enc->ch = ch;
 
 	*solo_enc->vfd = solo_enc_template;
-	solo_enc->vfd->parent = &solo_dev->pdev->dev;
+	solo_enc->vfd->v4l2_dev = &solo_dev->v4l2_dev;
 	ret = video_register_device(solo_enc->vfd, VFL_TYPE_GRABBER,
 				    video_nr);
 	if (ret < 0) {
diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
index 9c69c34..f15ca03 100644
--- a/drivers/staging/media/solo6x10/v4l2.c
+++ b/drivers/staging/media/solo6x10/v4l2.c
@@ -912,7 +912,7 @@ int solo_v4l2_init(struct solo_dev *solo_dev)
 		return -ENOMEM;
 
 	*solo_dev->vfd = solo_v4l2_template;
-	solo_dev->vfd->parent = &solo_dev->pdev->dev;
+	solo_dev->vfd->v4l2_dev = &solo_dev->v4l2_dev;
 
 	ret = video_register_device(solo_dev->vfd, VFL_TYPE_GRABBER, video_nr);
 	if (ret < 0) {
-- 
1.7.10.4

