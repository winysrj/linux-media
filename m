Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:56234 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750975AbcJIT47 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Oct 2016 15:56:59 -0400
Subject: [PATCH 1/2] [media] blackfin-capture: Use kcalloc() in
 bcap_init_sensor_formats()
To: adi-buildroot-devel@lists.sourceforge.net,
        linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Scott Jiang <scott.jiang.linux@gmail.com>
References: <ae9a008f-35e2-e4e0-be18-635050c8277e@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <581af7b9-030d-9d65-02c5-53bf11d40716@users.sourceforge.net>
Date: Sun, 9 Oct 2016 21:56:37 +0200
MIME-Version: 1.0
In-Reply-To: <ae9a008f-35e2-e4e0-be18-635050c8277e@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 9 Oct 2016 21:12:13 +0200

A multiplication for the size determination of a memory allocation
indicated that an array data structure should be processed.
Thus reuse the corresponding function "kcalloc".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/blackfin/bfin_capture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 8eb0339..c5e1043 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -169,7 +169,7 @@ static int bcap_init_sensor_formats(struct bcap_device *bcap_dev)
 	if (!num_formats)
 		return -ENXIO;
 
-	sf = kzalloc(num_formats * sizeof(*sf), GFP_KERNEL);
+	sf = kcalloc(num_formats, sizeof(*sf), GFP_KERNEL);
 	if (!sf)
 		return -ENOMEM;
 
-- 
2.10.1

