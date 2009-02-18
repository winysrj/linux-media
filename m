Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38271 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbZBRKuv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 05:50:51 -0500
Date: Wed, 18 Feb 2009 07:50:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roel Kluin <roel.kluin@gmail.com>
Subject: Fw: [PATCH] V4L: missing parentheses?
Message-ID: <20090218075024.1fa03027@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch resent to the proper ML, in order to be handled by patchwork.

Michael,
The patch seems ok to my eyes. Please ack if ok for you to apply it.

Forwarded message:

Date: Wed, 18 Feb 2009 10:11:10 +0100
From: Roel Kluin <roel.kluin@gmail.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,  video4linux-list@redhat.com, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] V4L: missing parentheses?


Please review.
--------------------------->8-------------8<------------------------------
Add missing parentheses

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/common/tuners/tda18271-common.c b/drivers/media/common/tuners/tda18271-common.c
index 6fb5b45..fc76c30 100644
--- a/drivers/media/common/tuners/tda18271-common.c
+++ b/drivers/media/common/tuners/tda18271-common.c
@@ -490,9 +490,9 @@ int tda18271_set_standby_mode(struct dvb_frontend *fe,
 		tda_dbg("sm = %d, sm_lt = %d, sm_xt = %d\n", sm, sm_lt, sm_xt);
 
 	regs[R_EP3]  &= ~0xe0; /* clear sm, sm_lt, sm_xt */
-	regs[R_EP3]  |= sm    ? (1 << 7) : 0 |
-			sm_lt ? (1 << 6) : 0 |
-			sm_xt ? (1 << 5) : 0;
+	regs[R_EP3]  |= (sm    ? (1 << 7) : 0) |
+			(sm_lt ? (1 << 6) : 0) |
+			(sm_xt ? (1 << 5) : 0);
 
 	return tda18271_write_regs(fe, R_EP3, 1);
 }




Cheers,
Mauro
