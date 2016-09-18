Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:41874 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754286AbcIROY5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Sep 2016 10:24:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.8] cx23885/saa7134: assign q->dev to the PCI device
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Marton Balint <cus@passwd.hu>
Message-ID: <90368e3b-776e-1e58-77a9-d8ab2e59ef5e@xs4all.nl>
Date: Sun, 18 Sep 2016 16:24:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a regression caused by commit 2bc46b3a (media/pci: convert drivers to use the
new vb2_queue dev field). Three places where q->dev should be set were missed, causing
a WARN.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Marton Balint <cus@passwd.hu>
---
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index efec2d1..4d080da 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1552,6 +1552,7 @@ int cx23885_417_register(struct cx23885_dev *dev)
 	q->mem_ops = &vb2_dma_sg_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &dev->lock;
+	q->dev = &dev->pci->dev;

 	err = vb2_queue_init(q);
 	if (err < 0)
diff --git a/drivers/media/pci/saa7134/saa7134-dvb.c b/drivers/media/pci/saa7134/saa7134-dvb.c
index db987e5..59a4b5f 100644
--- a/drivers/media/pci/saa7134/saa7134-dvb.c
+++ b/drivers/media/pci/saa7134/saa7134-dvb.c
@@ -1238,6 +1238,7 @@ static int dvb_init(struct saa7134_dev *dev)
 	q->buf_struct_size = sizeof(struct saa7134_buf);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &dev->lock;
+	q->dev = &dev->pci->dev;
 	ret = vb2_queue_init(q);
 	if (ret) {
 		vb2_dvb_dealloc_frontends(&dev->frontends);
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index ca417a4..791a516 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -295,6 +295,7 @@ static int empress_init(struct saa7134_dev *dev)
 	q->buf_struct_size = sizeof(struct saa7134_buf);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &dev->lock;
+	q->dev = &dev->pci->dev;
 	err = vb2_queue_init(q);
 	if (err)
 		return err;
