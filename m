Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36204 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726281AbeIDPzQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Sep 2018 11:55:16 -0400
Received: by mail-wr1-f68.google.com with SMTP id m27-v6so3603184wrf.3
        for <linux-media@vger.kernel.org>; Tue, 04 Sep 2018 04:30:32 -0700 (PDT)
From: Javier Martinez Canillas <javierm@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tian Shu Qiu <tian.shu.qiu@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jian Xu Zheng <jian.xu.zheng@intel.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Bingbu Cao <bingbu.cao@intel.com>, linux-media@vger.kernel.org
Subject: [PATCH 2/2] media: intel-ipu3: create pad links and register subdev nodes at bound time
Date: Tue,  4 Sep 2018 13:30:18 +0200
Message-Id: <20180904113018.14428-3-javierm@redhat.com>
In-Reply-To: <20180904113018.14428-1-javierm@redhat.com>
References: <20180904113018.14428-1-javierm@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver create the pad links and registers the device nodes for bound
subdevices in the v4l2 async notififer .complete callback. But that will
prevent the media graph to be usable if for example one of the drivers
for a subdevice fails to probe.

In that case, the media entity will be registered but there will be not
pad links created nor the subdev device node will be registered.

So do these operations in the .bound callback instead of doing it at
.complete time.

Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>

---

 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 66 ++++++++----------------
 1 file changed, 22 insertions(+), 44 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 29027159eced..4eb80b690e3f 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1403,6 +1403,8 @@ static int cio2_notifier_bound(struct v4l2_async_notifier *notifier,
 	struct sensor_async_subdev *s_asd = container_of(asd,
 					struct sensor_async_subdev, asd);
 	struct cio2_queue *q;
+	unsigned int pad;
+	int ret;
 
 	if (cio2->queue[s_asd->csi2.port].sensor)
 		return -EBUSY;
@@ -1413,7 +1415,26 @@ static int cio2_notifier_bound(struct v4l2_async_notifier *notifier,
 	q->sensor = sd;
 	q->csi_rx_base = cio2->base + CIO2_REG_PIPE_BASE(q->csi2.port);
 
-	return 0;
+	for (pad = 0; pad < q->sensor->entity.num_pads; pad++)
+		if (q->sensor->entity.pads[pad].flags & MEDIA_PAD_FL_SOURCE)
+			break;
+
+	if (pad == q->sensor->entity.num_pads) {
+		dev_err(&cio2->pci_dev->dev,
+			"failed to find src pad for %s\n",
+			q->sensor->name);
+		return -ENXIO;
+	}
+
+	ret = media_create_pad_link(&q->sensor->entity, pad, &q->subdev.entity,
+				    CIO2_PAD_SINK, 0);
+	if (ret) {
+		dev_err(&cio2->pci_dev->dev, "failed to create link for %s\n",
+			q->sensor->name);
+		return ret;
+	}
+
+	return v4l2_device_register_subdev_node(&cio2->v4l2_dev, sd);
 }
 
 /* The .unbind callback */
@@ -1429,52 +1450,9 @@ static void cio2_notifier_unbind(struct v4l2_async_notifier *notifier,
 	cio2->queue[s_asd->csi2.port].sensor = NULL;
 }
 
-/* .complete() is called after all subdevices have been located */
-static int cio2_notifier_complete(struct v4l2_async_notifier *notifier)
-{
-	struct cio2_device *cio2 = container_of(notifier, struct cio2_device,
-						notifier);
-	struct sensor_async_subdev *s_asd;
-	struct cio2_queue *q;
-	unsigned int i, pad;
-	int ret;
-
-	for (i = 0; i < notifier->num_subdevs; i++) {
-		s_asd = container_of(cio2->notifier.subdevs[i],
-				     struct sensor_async_subdev, asd);
-		q = &cio2->queue[s_asd->csi2.port];
-
-		for (pad = 0; pad < q->sensor->entity.num_pads; pad++)
-			if (q->sensor->entity.pads[pad].flags &
-						MEDIA_PAD_FL_SOURCE)
-				break;
-
-		if (pad == q->sensor->entity.num_pads) {
-			dev_err(&cio2->pci_dev->dev,
-				"failed to find src pad for %s\n",
-				q->sensor->name);
-			return -ENXIO;
-		}
-
-		ret = media_create_pad_link(
-				&q->sensor->entity, pad,
-				&q->subdev.entity, CIO2_PAD_SINK,
-				0);
-		if (ret) {
-			dev_err(&cio2->pci_dev->dev,
-				"failed to create link for %s\n",
-				cio2->queue[i].sensor->name);
-			return ret;
-		}
-	}
-
-	return v4l2_device_register_subdev_nodes(&cio2->v4l2_dev);
-}
-
 static const struct v4l2_async_notifier_operations cio2_async_ops = {
 	.bound = cio2_notifier_bound,
 	.unbind = cio2_notifier_unbind,
-	.complete = cio2_notifier_complete,
 };
 
 static int cio2_fwnode_parse(struct device *dev,
-- 
2.17.1
