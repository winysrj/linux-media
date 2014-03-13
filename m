Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.89.28.114]:42705 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbaCMK3y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 06:29:54 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: <linux-media@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 2/3] rc: img-ir: hw: Fix min/max bits setup
Date: Thu, 13 Mar 2014 10:29:22 +0000
Message-ID: <1394706563-31081-3-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1394706563-31081-1-git-send-email-james.hogan@imgtec.com>
References: <1394706563-31081-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The calculated values for the minlen and maxlen fields, which were
rounded to multiples of 2 and clamped to a valid range, were left
unused. Use them in the calculation of the register value rather than
using the raw input minlen and maxlen.

This fixes the following warning with a W=1 build:
drivers/media/rc/img-ir/img-ir-hw.c In function ‘img_ir_free_timing’:
drivers/media/rc/img-ir/img-ir-hw.c +228 :23: warning: variable ‘maxlen’ set but not used [-Wunused-but-set-variable]
drivers/media/rc/img-ir/img-ir-hw.c +228 :15: warning: variable ‘minlen’ set but not used [-Wunused-but-set-variable]

Reported-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
I don't object to this patch being squashed into the patch "rc: img-ir:
add hardware decoder driver".
---
 drivers/media/rc/img-ir/img-ir-hw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
index 2abf78a89fc5..579a52b3edce 100644
--- a/drivers/media/rc/img-ir/img-ir-hw.c
+++ b/drivers/media/rc/img-ir/img-ir-hw.c
@@ -240,9 +240,9 @@ static u32 img_ir_free_timing(const struct img_ir_free_timing *timing,
 	ft_min = (timing->ft_min*clock_hz + 999999) / 1000000;
 	ft_min = (ft_min + 7) >> 3;
 	/* construct register value */
-	return	(timing->maxlen	<< IMG_IR_MAXLEN_SHIFT)	|
-		(timing->minlen	<< IMG_IR_MINLEN_SHIFT)	|
-		(ft_min		<< IMG_IR_FT_MIN_SHIFT);
+	return	(maxlen << IMG_IR_MAXLEN_SHIFT)	|
+		(minlen << IMG_IR_MINLEN_SHIFT)	|
+		(ft_min << IMG_IR_FT_MIN_SHIFT);
 }
 
 /**
-- 
1.8.1.2

