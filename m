Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:52375 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933860AbcJLPBh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 11:01:37 -0400
Subject: [PATCH 23/34] [media] DaVinci-VPFE-Capture: Delete unnecessary braces
 in vpfe_isr()
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <ba461e17-d7fe-b1bc-cd39-4f37ffd691bc@users.sourceforge.net>
Date: Wed, 12 Oct 2016 17:01:27 +0200
MIME-Version: 1.0
In-Reply-To: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 12 Oct 2016 14:54:21 +0200

Do not use curly brackets at one source code place
where a single statement should be sufficient.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/davinci/vpfe_capture.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index f0467fe..e264c90 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -615,9 +615,8 @@ static irqreturn_t vpfe_isr(int irq, void *dev_id)
 			 * interleavely or separately in memory, reconfigure
 			 * the CCDC memory address
 			 */
-			if (field == V4L2_FIELD_SEQ_TB) {
+			if (field == V4L2_FIELD_SEQ_TB)
 				vpfe_schedule_bottom_field(vpfe_dev);
-			}
 			goto clear_intr;
 		}
 		/*
-- 
2.10.1

