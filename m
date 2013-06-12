Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3267 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755248Ab3FLPCG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jun 2013 11:02:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 06/12] saa7164: add v4l2_device and replace parent with v4l2_dev
Date: Wed, 12 Jun 2013 17:00:56 +0200
Message-Id: <1371049262-5799-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371049262-5799-1-git-send-email-hverkuil@xs4all.nl>
References: <1371049262-5799-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver did not yet support struct v4l2_device, so add it. This
make it possible to replace the deprecated parent field with the
v4l2_dev field, allowing the eventual removal of the parent field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7164/saa7164-core.c    |    7 +++++++
 drivers/media/pci/saa7164/saa7164-encoder.c |    2 +-
 drivers/media/pci/saa7164/saa7164-vbi.c     |    2 +-
 drivers/media/pci/saa7164/saa7164.h         |    3 +++
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 7618fda..5d27865 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -1196,6 +1196,11 @@ static int saa7164_initdev(struct pci_dev *pci_dev,
 	if (NULL == dev)
 		return -ENOMEM;
 
+	if (v4l2_device_register(&pci_dev->dev, &dev->v4l2_dev)) {
+		dev_err(&pci_dev->dev, "v4l2_device_register failed\n");
+		goto fail_free;
+	}
+
 	/* pci init */
 	dev->pci = pci_dev;
 	if (pci_enable_device(pci_dev)) {
@@ -1367,6 +1372,7 @@ fail_fw:
 fail_irq:
 	saa7164_dev_unregister(dev);
 fail_free:
+	v4l2_device_unregister(&dev->v4l2_dev);
 	kfree(dev);
 	return err;
 }
@@ -1439,6 +1445,7 @@ static void saa7164_finidev(struct pci_dev *pci_dev)
 	mutex_unlock(&devlist);
 
 	saa7164_dev_unregister(dev);
+	v4l2_device_unregister(&dev->v4l2_dev);
 	kfree(dev);
 }
 
diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 7b7ed97..9266965 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -1348,7 +1348,7 @@ static struct video_device *saa7164_encoder_alloc(
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)", dev->name,
 		type, saa7164_boards[dev->board].name);
 
-	vfd->parent  = &pci->dev;
+	vfd->v4l2_dev  = &dev->v4l2_dev;
 	vfd->release = video_device_release;
 	return vfd;
 }
diff --git a/drivers/media/pci/saa7164/saa7164-vbi.c b/drivers/media/pci/saa7164/saa7164-vbi.c
index 552c01a..6e025fe 100644
--- a/drivers/media/pci/saa7164/saa7164-vbi.c
+++ b/drivers/media/pci/saa7164/saa7164-vbi.c
@@ -1297,7 +1297,7 @@ static struct video_device *saa7164_vbi_alloc(
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)", dev->name,
 		type, saa7164_boards[dev->board].name);
 
-	vfd->parent  = &pci->dev;
+	vfd->v4l2_dev  = &dev->v4l2_dev;
 	vfd->release = video_device_release;
 	return vfd;
 }
diff --git a/drivers/media/pci/saa7164/saa7164.h b/drivers/media/pci/saa7164/saa7164.h
index 2df47ea..8b29e89 100644
--- a/drivers/media/pci/saa7164/saa7164.h
+++ b/drivers/media/pci/saa7164/saa7164.h
@@ -63,6 +63,7 @@
 #include <dmxdev.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-device.h>
 
 #include "saa7164-reg.h"
 #include "saa7164-types.h"
@@ -427,6 +428,8 @@ struct saa7164_dev {
 	struct list_head	devlist;
 	atomic_t		refcount;
 
+	struct v4l2_device v4l2_dev;
+
 	/* pci stuff */
 	struct pci_dev	*pci;
 	unsigned char	pci_rev, pci_lat;
-- 
1.7.10.4

