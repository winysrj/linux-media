Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:40361 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387928AbeKFXcJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Nov 2018 18:32:09 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vivid: fill in media_device bus_info
Message-ID: <2e76ef0b-9b62-4f1d-0bde-bfed96b963e5@xs4all.nl>
Date: Tue, 6 Nov 2018 15:06:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If you create multiple vivid instances, each with their own media
device, then there was no way to tell them apart.

Fill in the bus_info so each instance has a unique bus_info string.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index bc7307183b1d..c1b5976af3e6 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -670,6 +670,8 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)

 	/* Initialize media device */
 	strlcpy(dev->mdev.model, VIVID_MODULE_NAME, sizeof(dev->mdev.model));
+	snprintf(dev->mdev.bus_info, sizeof(dev->mdev.bus_info),
+		 "platform:%s-%03d", VIVID_MODULE_NAME, inst);
 	dev->mdev.dev = &pdev->dev;
 	media_device_init(&dev->mdev);
 	dev->mdev.ops = &vivid_media_ops;
