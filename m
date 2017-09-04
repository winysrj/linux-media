Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:56638 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754442AbdIDUMr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Sep 2017 16:12:47 -0400
Subject: [PATCH 6/6] [media] atmel-isi: Adjust a null pointer check in three
 functions
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Songjun Wu <songjun.wu@microchip.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <88d0739c-fdc1-9d7d-fe53-b7c2eeed1849@users.sourceforge.net>
Message-ID: <c539c64a-c6f7-cb03-0dec-1eb4b74de71f@users.sourceforge.net>
Date: Mon, 4 Sep 2017 22:12:38 +0200
MIME-Version: 1.0
In-Reply-To: <88d0739c-fdc1-9d7d-fe53-b7c2eeed1849@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 4 Sep 2017 21:30:48 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written !…

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/atmel/atmel-isi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
index ac40defce1e7..f2e13dfb19a1 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -411,7 +411,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 	spin_lock_irqsave(&isi->irqlock, flags);
 	list_add_tail(&buf->list, &isi->video_buffer_list);
 
-	if (isi->active == NULL) {
+	if (!isi->active) {
 		isi->active = buf;
 		if (vb2_is_streaming(vb->vb2_queue))
 			start_dma(isi, buf);
@@ -1141,7 +1141,7 @@ static int isi_graph_init(struct atmel_isi *isi)
 
 	/* Register the subdevices notifier. */
 	subdevs = devm_kzalloc(isi->dev, sizeof(*subdevs), GFP_KERNEL);
-	if (subdevs == NULL) {
+	if (!subdevs) {
 		of_node_put(isi->entity.node);
 		return -ENOMEM;
 	}
@@ -1200,7 +1200,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
 		return ret;
 
 	isi->vdev = video_device_alloc();
-	if (isi->vdev == NULL) {
+	if (!isi->vdev) {
 		ret = -ENOMEM;
 		goto err_vdev_alloc;
 	}
-- 
2.14.1
