Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34400 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755279AbcIODgQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 23:36:16 -0400
Received: by mail-pf0-f195.google.com with SMTP id 21so178724pfy.1
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2016 20:36:15 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-media@vger.kernel.org
Subject: [PATCH -next] [media] vivid: fix error return code in vivid_create_instance()
Date: Thu, 15 Sep 2016 03:36:09 +0000
Message-Id: <1473910569-4677-1-git-send-email-weiyj.lk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix to return error code -ENOMEM from the memory or workqueue alloc
error handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/media/platform/vivid/vivid-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 741460a..5464fef 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -839,6 +839,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		dev->radio_tx_caps = V4L2_CAP_RDS_OUTPUT | V4L2_CAP_MODULATOR |
 				     V4L2_CAP_READWRITE;
 
+	ret = -ENOMEM;
 	/* initialize the test pattern generator */
 	tpg_init(&dev->tpg, 640, 360);
 	if (tpg_alloc(&dev->tpg, MAX_ZOOM * MAX_WIDTH))
@@ -1033,8 +1034,10 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	 */
 	dev->cec_workqueue =
 		alloc_ordered_workqueue("vivid-%03d-cec", WQ_MEM_RECLAIM, inst);
-	if (!dev->cec_workqueue)
+	if (!dev->cec_workqueue) {
+		ret = -ENOMEM;
 		goto unreg_dev;
+	}
 
 	/* start creating the vb2 queues */
 	if (dev->has_vid_cap) {

