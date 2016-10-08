Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:62030 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935004AbcJHLtK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 8 Oct 2016 07:49:10 -0400
Subject: [PATCH 1/2] [media] cx88-dsp: Use kmalloc_array() in
 read_rds_samples()
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <ebf6d2f7-eb50-d55b-e782-689af9ecda31@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <ac88fc8d-05ec-644b-6b46-dc5027892a46@users.sourceforge.net>
Date: Sat, 8 Oct 2016 13:47:49 +0200
MIME-Version: 1.0
In-Reply-To: <ebf6d2f7-eb50-d55b-e782-689af9ecda31@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 7 Oct 2016 22:07:27 +0200

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus use the corresponding function "kmalloc_array".

  This issue was detected by using the Coccinelle software.

* Replace the specification of a data type by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/pci/cx88/cx88-dsp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-dsp.c b/drivers/media/pci/cx88/cx88-dsp.c
index a990726..9acda12 100644
--- a/drivers/media/pci/cx88/cx88-dsp.c
+++ b/drivers/media/pci/cx88/cx88-dsp.c
@@ -245,8 +245,7 @@ static s16 *read_rds_samples(struct cx88_core *core, u32 *N)
 		"sample_count=%d, aud_intstat=%08x\n", current_address,
 		current_address - srch->fifo_start, sample_count,
 		cx_read(MO_AUD_INTSTAT));
-
-	samples = kmalloc(sizeof(s16)*sample_count, GFP_KERNEL);
+	samples = kmalloc_array(sample_count, sizeof(*samples), GFP_KERNEL);
 	if (!samples)
 		return NULL;
 
-- 
2.10.1

