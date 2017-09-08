Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:55027 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756958AbdIHToR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 15:44:17 -0400
Subject: [PATCH 2/3] [media] fsl-viu: Improve two size determinations in
 viu_of_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <bf912679-c695-c9c0-a464-3bd3e976fa8a@users.sourceforge.net>
Message-ID: <44462eba-a9dd-2af7-b187-9607fe8dc1ee@users.sourceforge.net>
Date: Fri, 8 Sep 2017 21:44:06 +0200
MIME-Version: 1.0
In-Reply-To: <bf912679-c695-c9c0-a464-3bd3e976fa8a@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 8 Sep 2017 21:12:52 +0200

Replace the specification of data structures by pointer dereferences
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/fsl-viu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 526f80649864..1fe2a295db93 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -1421,5 +1421,5 @@ static int viu_of_probe(struct platform_device *op)
 	}
 
 	/* remap registers */
-	viu_regs = devm_ioremap(&op->dev, r.start, sizeof(struct viu_reg));
+	viu_regs = devm_ioremap(&op->dev, r.start, sizeof(*viu_regs));
 	if (!viu_regs) {
@@ -1429,5 +1429,5 @@ static int viu_of_probe(struct platform_device *op)
 	}
 
 	/* Prepare our private structure */
-	viu_dev = devm_kzalloc(&op->dev, sizeof(struct viu_dev), GFP_ATOMIC);
+	viu_dev = devm_kzalloc(&op->dev, sizeof(*viu_dev), GFP_ATOMIC);
 	if (!viu_dev) {
-- 
2.14.1
