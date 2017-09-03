Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:56697 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752828AbdICOCf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Sep 2017 10:02:35 -0400
Subject: [PATCH 1/2] [media] meye: Delete three error messages for a failed
 memory allocation in meye_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pan Bian <bianpan2016@163.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <4370c644-e440-1268-089b-8a8686bbcd5c@users.sourceforge.net>
Message-ID: <ba90af37-ef8d-ed7f-f331-c15694064672@users.sourceforge.net>
Date: Sun, 3 Sep 2017 16:02:17 +0200
MIME-Version: 1.0
In-Reply-To: <4370c644-e440-1268-089b-8a8686bbcd5c@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 3 Sep 2017 15:30:04 +0200

Omit extra messages for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/pci/meye/meye.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index 9c4a024745de..db36040770a6 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -1626,23 +1626,18 @@ static int meye_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 	meye.mchip_dev = pcidev;
 
 	meye.grab_temp = vmalloc(MCHIP_NB_PAGES_MJPEG * PAGE_SIZE);
-	if (!meye.grab_temp) {
-		v4l2_err(v4l2_dev, "grab buffer allocation failed\n");
+	if (!meye.grab_temp)
 		goto outvmalloc;
-	}
 
 	spin_lock_init(&meye.grabq_lock);
 	if (kfifo_alloc(&meye.grabq, sizeof(int) * MEYE_MAX_BUFNBRS,
-				GFP_KERNEL)) {
-		v4l2_err(v4l2_dev, "fifo allocation failed\n");
+			GFP_KERNEL))
 		goto outkfifoalloc1;
-	}
+
 	spin_lock_init(&meye.doneq_lock);
 	if (kfifo_alloc(&meye.doneq, sizeof(int) * MEYE_MAX_BUFNBRS,
-				GFP_KERNEL)) {
-		v4l2_err(v4l2_dev, "fifo allocation failed\n");
+			GFP_KERNEL))
 		goto outkfifoalloc2;
-	}
 
 	meye.vdev = meye_template;
 	meye.vdev.v4l2_dev = &meye.v4l2_dev;
-- 
2.14.1
