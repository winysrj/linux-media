Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:10250 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbaKQMSH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 07:18:07 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [REVIEW PATCH 2/5] img-ir/hw: Drop [un]register_decoder declarations
Date: Mon, 17 Nov 2014 12:17:46 +0000
Message-ID: <1416226669-2983-3-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1416226669-2983-1-git-send-email-james.hogan@imgtec.com>
References: <1416226669-2983-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The img_ir_register_decoder() and img_ir_unregister_decoder() functions
were dropped prior to the img-ir driver being applied to simplify the
protocol decoder setup. However the declarations of these functions in
img-ir-hw.h were still included. Delete them since they're completely
unused.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/rc/img-ir/img-ir-hw.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/rc/img-ir/img-ir-hw.h b/drivers/media/rc/img-ir/img-ir-hw.h
index 8fcc16c32c5b..a8c6a8d40206 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.h
+++ b/drivers/media/rc/img-ir/img-ir-hw.h
@@ -186,9 +186,6 @@ struct img_ir_reg_timings {
 	struct img_ir_timing_regvals	rtimings;
 };
 
-int img_ir_register_decoder(struct img_ir_decoder *dec);
-void img_ir_unregister_decoder(struct img_ir_decoder *dec);
-
 struct img_ir_priv;
 
 #ifdef CONFIG_IR_IMG_HW
-- 
2.0.4

