Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:52805 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755548AbcJLPP3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 11:15:29 -0400
Subject: [PATCH 33/34] [media] DaVinci-VPIF-Display: Delete an unnecessary
 variable initialisation in vpif_channel_isr()
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <4d6bde65-54e8-7887-c9de-61dbf64d1ab9@users.sourceforge.net>
Date: Wed, 12 Oct 2016 17:14:45 +0200
MIME-Version: 1.0
In-Reply-To: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 12 Oct 2016 15:43:12 +0200

The local variable "channel_id" will be reassigned with the following
statement at the beginning. Thus omit the explicit initialisation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/davinci/vpif_display.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index fff1ece..cd44990 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -363,7 +363,7 @@ static irqreturn_t vpif_channel_isr(int irq, void *dev_id)
 	struct channel_obj *ch;
 	struct common_obj *common;
 	int fid = -1, i;
-	int channel_id = 0;
+	int channel_id;
 
 	channel_id = *(int *)(dev_id);
 	if (!vpif_intr_status(channel_id + 2))
-- 
2.10.1

