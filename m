Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33421 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727286AbeHaT2y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 15:28:54 -0400
Received: by mail-wr1-f67.google.com with SMTP id v90-v6so11586346wrc.0
        for <linux-media@vger.kernel.org>; Fri, 31 Aug 2018 08:20:55 -0700 (PDT)
From: Javier Martinez Canillas <javierm@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javierm@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Jian Xu Zheng <jian.xu.zheng@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>, linux-media@vger.kernel.org
Subject: [PATCH] media: intel-ipu3: cio2: register the mdev on v4l2 async notifier complete
Date: Fri, 31 Aug 2018 17:20:45 +0200
Message-Id: <20180831152045.9957-1-javierm@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 9832e155f1ed ("[media] media-device: split media initialization and
registration") split the media_device_register() function in two, to avoid
a race condition that can happen when the media device node is accessed by
userpace before the pending subdevices have been asynchronously registered.

But the ipu3-cio2 driver calls the media_device_register() function right
after calling media_device_init() which defeats the purpose of having two
separate functions.

In that case, userspace could have a partial view of the media device if
it opened the media device node before all the pending devices have been
bound. So instead, only register the media device once all pending v4l2
subdevices have been registered.

Fixes: 9832e155f1ed ("media: intel-ipu3: cio2: add new MIPI-CSI2 driver")
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
---

 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 29027159eced..d936f3426c4e 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1468,7 +1468,14 @@ static int cio2_notifier_complete(struct v4l2_async_notifier *notifier)
 		}
 	}
 
-	return v4l2_device_register_subdev_nodes(&cio2->v4l2_dev);
+	ret = v4l2_device_register_subdev_nodes(&cio2->v4l2_dev);
+	if (ret) {
+		dev_err(&cio2->pci_dev->dev,
+			"failed to register V4L2 subdev nodes (%d)\n", ret);
+		return ret;
+	}
+
+	return media_device_register(&cio2->media_dev);
 }
 
 static const struct v4l2_async_notifier_operations cio2_async_ops = {
@@ -1792,16 +1799,12 @@ static int cio2_pci_probe(struct pci_dev *pci_dev,
 	cio2->media_dev.hw_revision = 0;
 
 	media_device_init(&cio2->media_dev);
-	r = media_device_register(&cio2->media_dev);
-	if (r < 0)
-		goto fail_mutex_destroy;
-
 	cio2->v4l2_dev.mdev = &cio2->media_dev;
 	r = v4l2_device_register(&pci_dev->dev, &cio2->v4l2_dev);
 	if (r) {
 		dev_err(&pci_dev->dev,
 			"failed to register V4L2 device (%d)\n", r);
-		goto fail_media_device_unregister;
+		goto fail_media_device_cleanup;
 	}
 
 	r = cio2_queues_init(cio2);
@@ -1831,10 +1834,8 @@ static int cio2_pci_probe(struct pci_dev *pci_dev,
 	cio2_queues_exit(cio2);
 fail_v4l2_device_unregister:
 	v4l2_device_unregister(&cio2->v4l2_dev);
-fail_media_device_unregister:
-	media_device_unregister(&cio2->media_dev);
+fail_media_device_cleanup:
 	media_device_cleanup(&cio2->media_dev);
-fail_mutex_destroy:
 	mutex_destroy(&cio2->lock);
 	cio2_fbpt_exit_dummy(cio2);
 
-- 
2.17.1
