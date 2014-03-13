Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.89.28.115]:55042 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaCMK3z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 06:29:55 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: <linux-media@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 3/3] rc: img-ir: jvc: Remove unused no-leader timings
Date: Thu, 13 Mar 2014 10:29:23 +0000
Message-ID: <1394706563-31081-4-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1394706563-31081-1-git-send-email-james.hogan@imgtec.com>
References: <1394706563-31081-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The JVC timings included timings intended for the secondary decoder
(which matches messages with no leader), however they were in the wrong
part of the timings structure, repeating s00 and s01 rather than being
in s10 and s11.

Distinct repeat timings can't be properly supported yet for JVC anyway
since the scancode callback cannot determine which decoder matched the
message, so for now remove these timings and don't bother to enable the
secondary decoder.

This fixes the following warnings with W=1:
drivers/media/rc/img-ir/img-ir-jvc.c +76 :3: warning: initialized field overwritten [-Woverride-init]
drivers/media/rc/img-ir/img-ir-jvc.c +76 :3: warning: (near initialization for ‘img_ir_jvc.timings.s00’) [-Woverride-init]
drivers/media/rc/img-ir/img-ir-jvc.c +81 :3: warning: initialized field overwritten [-Woverride-init]
drivers/media/rc/img-ir/img-ir-jvc.c +81 :3: warning: (near initialization for ‘img_ir_jvc.timings.s01’) [-Woverride-init]

Reported-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
I don't object to this patch being squashed into the patch "rc: img-ir:
add JVC decoder module".
---
 drivers/media/rc/img-ir/img-ir-jvc.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/media/rc/img-ir/img-ir-jvc.c b/drivers/media/rc/img-ir/img-ir-jvc.c
index ae55867f6c5c..10209d200efb 100644
--- a/drivers/media/rc/img-ir/img-ir-jvc.c
+++ b/drivers/media/rc/img-ir/img-ir-jvc.c
@@ -49,7 +49,6 @@ struct img_ir_decoder img_ir_jvc = {
 	.control = {
 		.decoden = 1,
 		.code_type = IMG_IR_CODETYPE_PULSEDIST,
-		.decodend2 = 1,
 	},
 	/* main timings */
 	.unit = 527500, /* 527.5 us */
@@ -69,16 +68,6 @@ struct img_ir_decoder img_ir_jvc = {
 			.pulse = { 1	/* 527.5 us +-60 us */ },
 			.space = { 3	/* 1.5825 ms +-40 us */ },
 		},
-		/* 0 symbol (no leader) */
-		.s00 = {
-			.pulse = { 1	/* 527.5 us +-60 us */ },
-			.space = { 1	/* 527.5 us */ },
-		},
-		/* 1 symbol (no leader) */
-		.s01 = {
-			.pulse = { 1	/* 527.5 us +-60 us */ },
-			.space = { 3	/* 1.5825 ms +-40 us */ },
-		},
 		/* free time */
 		.ft = {
 			.minlen = 16,
-- 
1.8.1.2

