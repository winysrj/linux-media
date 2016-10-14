Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:51736 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754641AbcJNLpk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 07:45:40 -0400
Subject: [PATCH 5/5] [media] winbond-cir: Move a variable assignment in two
 functions
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
Message-ID: <0b6de919-35a0-8ee3-9ea7-907c9b9a36f2@users.sourceforge.net>
Date: Fri, 14 Oct 2016 13:45:32 +0200
MIME-Version: 1.0
In-Reply-To: <1d7d6a2c-0f1e-3434-9023-9eab25bb913f@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 14 Oct 2016 13:13:11 +0200

Move the assignment for the local variable "data" behind the source code
for condition checks by these functions.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/rc/winbond-cir.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 3d286b9..716b1fe 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -566,7 +566,7 @@ wbcir_set_carrier_report(struct rc_dev *dev, int enable)
 static int
 wbcir_txcarrier(struct rc_dev *dev, u32 carrier)
 {
-	struct wbcir_data *data = dev->priv;
+	struct wbcir_data *data;
 	unsigned long flags;
 	u8 val;
 	u32 freq;
@@ -592,6 +592,7 @@ wbcir_txcarrier(struct rc_dev *dev, u32 carrier)
 		break;
 	}
 
+	data = dev->priv;
 	spin_lock_irqsave(&data->spinlock, flags);
 	if (data->txstate != WBCIR_TXSTATE_INACTIVE) {
 		spin_unlock_irqrestore(&data->spinlock, flags);
@@ -611,7 +612,7 @@ wbcir_txcarrier(struct rc_dev *dev, u32 carrier)
 static int
 wbcir_txmask(struct rc_dev *dev, u32 mask)
 {
-	struct wbcir_data *data = dev->priv;
+	struct wbcir_data *data;
 	unsigned long flags;
 	u8 val;
 
@@ -637,6 +638,7 @@ wbcir_txmask(struct rc_dev *dev, u32 mask)
 		return -EINVAL;
 	}
 
+	data = dev->priv;
 	spin_lock_irqsave(&data->spinlock, flags);
 	if (data->txstate != WBCIR_TXSTATE_INACTIVE) {
 		spin_unlock_irqrestore(&data->spinlock, flags);
-- 
2.10.1

