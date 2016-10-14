Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:58628 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754725AbcJNLm0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 07:42:26 -0400
Subject: [PATCH 2/5] [media] winbond-cir: Move a variable assignment in
 wbcir_tx()
To: linux-media@vger.kernel.org,
        =?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <26ee4adb-2637-52c3-ac83-ae121bed5eff@users.sourceforge.net>
Date: Fri, 14 Oct 2016 13:42:16 +0200
MIME-Version: 1.0
In-Reply-To: <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 14 Oct 2016 07:34:46 +0200

Move the assignment for the local variable "data" behind the source code
for a memory allocation by this function.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/rc/winbond-cir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 59050f5..fd997f0 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -655,7 +655,7 @@ wbcir_txmask(struct rc_dev *dev, u32 mask)
 static int
 wbcir_tx(struct rc_dev *dev, unsigned *b, unsigned count)
 {
-	struct wbcir_data *data = dev->priv;
+	struct wbcir_data *data;
 	unsigned *buf;
 	unsigned i;
 	unsigned long flags;
@@ -668,6 +668,7 @@ wbcir_tx(struct rc_dev *dev, unsigned *b, unsigned count)
 	for (i = 0; i < count; i++)
 		buf[i] = DIV_ROUND_CLOSEST(b[i], 10);
 
+	data = dev->priv;
 	/* Not sure if this is possible, but better safe than sorry */
 	spin_lock_irqsave(&data->spinlock, flags);
 	if (data->txstate != WBCIR_TXSTATE_INACTIVE) {
-- 
2.10.1

