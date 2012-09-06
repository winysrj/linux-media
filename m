Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49110 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab2IFPYR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2012 11:24:17 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/14] drivers/media/pci/dm1105/dm1105.c: fix error return code
Date: Thu,  6 Sep 2012 17:23:55 +0200
Message-Id: <1346945041-26676-8-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/media/pci/dm1105/dm1105.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index a609b3a..f147031 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -1128,8 +1128,10 @@ static int __devinit dm1105_probe(struct pci_dev *pdev,
 	INIT_WORK(&dev->work, dm1105_dmx_buffer);
 	sprintf(dev->wqn, "%s/%d", dvb_adapter->name, dvb_adapter->num);
 	dev->wq = create_singlethread_workqueue(dev->wqn);
-	if (!dev->wq)
+	if (!dev->wq) {
+		ret = -ENOMEM;
 		goto err_dvb_net;
+	}
 
 	ret = request_irq(pdev->irq, dm1105_irq, IRQF_SHARED,
 						DRIVER_NAME, dev);

