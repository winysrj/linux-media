Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:59434 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932611AbcJGTp2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 15:45:28 -0400
Subject: [PATCH 1/2] [media] dvb-tc90522: Use kmalloc_array() in
 tc90522_master_xfer()
To: linux-media@vger.kernel.org, Akihiro Tsukada <tskd08@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ira Krufky <mkrufky@linuxtv.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <906cc86f-bac0-fd47-8a6f-d3310b10fd08@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <78258072-609a-c887-11d9-7206c3e4d2a8@users.sourceforge.net>
Date: Fri, 7 Oct 2016 21:45:05 +0200
MIME-Version: 1.0
In-Reply-To: <906cc86f-bac0-fd47-8a6f-d3310b10fd08@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 7 Oct 2016 21:07:43 +0200

A multiplication for the size determination of a memory allocation
indicated that an array data structure should be processed.
Thus use the corresponding function "kmalloc_array".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/tc90522.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
index 31cd325..c2d45f0 100644
--- a/drivers/media/dvb-frontends/tc90522.c
+++ b/drivers/media/dvb-frontends/tc90522.c
@@ -656,7 +656,7 @@ tc90522_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
 	for (i = 0; i < num; i++)
 		if (msgs[i].flags & I2C_M_RD)
 			rd_num++;
-	new_msgs = kmalloc(sizeof(*new_msgs) * (num + rd_num), GFP_KERNEL);
+	new_msgs = kmalloc_array(num + rd_num, sizeof(*new_msgs), GFP_KERNEL);
 	if (!new_msgs)
 		return -ENOMEM;
 
-- 
2.10.1

