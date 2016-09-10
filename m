Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.polytechnique.org ([129.104.30.34]:58875 "EHLO
        mx1.polytechnique.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751862AbcIJRAC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Sep 2016 13:00:02 -0400
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH 1/1] [media] ite-cir: initialize use_demodulator before using it
Date: Sat, 10 Sep 2016 18:59:49 +0200
Message-Id: <20160910165949.3507-1-nicolas.iooss_linux@m4x.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Function ite_set_carrier_params() uses variable use_demodulator after
having initialized it to false in some if branches, but this variable is
never set to true otherwise.

This bug has been found using clang -Wsometimes-uninitialized warning
flag.

Fixes: 620a32bba4a2 ("[media] rc: New rc-based ite-cir driver for
several ITE CIRs")
Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 drivers/media/rc/ite-cir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 0f301903aa6f..63165d324fff 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -263,6 +263,8 @@ static void ite_set_carrier_params(struct ite_dev *dev)
 
 			if (allowance > ITE_RXDCR_MAX)
 				allowance = ITE_RXDCR_MAX;
+
+			use_demodulator = true;
 		}
 	}
 
-- 
2.9.3

