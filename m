Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp74.ord1c.emailsrvr.com ([108.166.43.74]:60380 "EHLO
	smtp74.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042AbbBMIxQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 03:53:16 -0500
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jingoo Han <jg1.han@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>, prabhakar.csengg@gmail.com,
	Jon Mason <jdmason@kudzu.us>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Kiran Padwal <kiran.padwal21@gmail.com>,
	Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH] [media] staging: dt3155v4l: Switch to using managed resource with devm_
Date: Fri, 13 Feb 2015 14:22:10 +0530
Message-Id: <1423817530-7745-1-git-send-email-kiran.padwal@smartplayin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch uses managed resource APIs to allocate memory
in order to simplify the driver unload or failure cases

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 293ffda..e60a53e 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -901,14 +901,13 @@ dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 	if (err)
 		return -ENODEV;
-	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
+	pd = devm_kzalloc(&pdev->dev, sizeof(*pd), GFP_KERNEL);
 	if (!pd)
 		return -ENOMEM;
 	pd->vdev = video_device_alloc();
-	if (!pd->vdev) {
-		err = -ENOMEM;
-		goto err_video_device_alloc;
-	}
+	if (!pd->vdev)
+		return -ENOMEM;
+
 	*pd->vdev = dt3155_vdev;
 	pci_set_drvdata(pdev, pd);    /* for use in dt3155_remove() */
 	video_set_drvdata(pd->vdev, pd);  /* for use in video_fops */
@@ -951,8 +950,7 @@ err_req_region:
 	pci_disable_device(pdev);
 err_enable_dev:
 	video_device_release(pd->vdev);
-err_video_device_alloc:
-	kfree(pd);
+
 	return err;
 }
 
@@ -970,7 +968,6 @@ dt3155_remove(struct pci_dev *pdev)
 	 * video_device_release() is invoked automatically
 	 * see: struct video_device dt3155_vdev
 	 */
-	kfree(pd);
 }
 
 static const struct pci_device_id pci_ids[] = {
-- 
1.7.9.5

