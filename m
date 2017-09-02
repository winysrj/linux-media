Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:50843 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751192AbdIBUnU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 16:43:20 -0400
Subject: [PATCH 3/7] [media] Hopper: Adjust a null pointer check in two
 functions
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <9ba22d42-0ec0-b865-dec5-4ce67ad443fb@users.sourceforge.net>
Message-ID: <56d490a2-4159-204f-cd69-16fd9b268f29@users.sourceforge.net>
Date: Sat, 2 Sep 2017 22:43:10 +0200
MIME-Version: 1.0
In-Reply-To: <9ba22d42-0ec0-b865-dec5-4ce67ad443fb@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 2 Sep 2017 21:25:50 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written !…

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/pci/mantis/hopper_cards.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/mantis/hopper_cards.c b/drivers/media/pci/mantis/hopper_cards.c
index fe7b40c306f7..88e5b2a97005 100644
--- a/drivers/media/pci/mantis/hopper_cards.c
+++ b/drivers/media/pci/mantis/hopper_cards.c
@@ -72,7 +72,7 @@ static irqreturn_t hopper_irq_handler(int irq, void *dev_id)
 	struct mantis_ca *ca;
 
 	mantis = (struct mantis_pci *) dev_id;
-	if (unlikely(mantis == NULL)) {
+	if (unlikely(!mantis)) {
 		dprintk(MANTIS_ERROR, 1, "Mantis == NULL");
 		return IRQ_NONE;
 	}
@@ -164,7 +164,7 @@ static int hopper_pci_probe(struct pci_dev *pdev,
 	int err = 0;
 
 	mantis = kzalloc(sizeof(*mantis), GFP_KERNEL);
-	if (mantis == NULL) {
+	if (!mantis) {
 		err = -ENOMEM;
 		goto fail0;
 	}
-- 
2.14.1
