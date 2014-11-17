Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:22776 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaKQMSI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 07:18:08 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	<linux-media@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [REVIEW PATCH 4/5] img-ir: Don't set driver's module owner
Date: Mon, 17 Nov 2014 12:17:48 +0000
Message-ID: <1416226669-2983-5-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1416226669-2983-1-git-send-email-james.hogan@imgtec.com>
References: <1416226669-2983-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't bother setting .owner = THIS_MODULE, since it's already handled by
the platform_driver_register macro.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/rc/img-ir/img-ir-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/rc/img-ir/img-ir-core.c b/drivers/media/rc/img-ir/img-ir-core.c
index a0cac2f09109..77c78de4f5bf 100644
--- a/drivers/media/rc/img-ir/img-ir-core.c
+++ b/drivers/media/rc/img-ir/img-ir-core.c
@@ -166,7 +166,6 @@ MODULE_DEVICE_TABLE(of, img_ir_match);
 static struct platform_driver img_ir_driver = {
 	.driver = {
 		.name = "img-ir",
-		.owner	= THIS_MODULE,
 		.of_match_table	= img_ir_match,
 		.pm = &img_ir_pmops,
 	},
-- 
2.0.4

