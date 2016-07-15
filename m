Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:36218 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbcGOP77 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 11:59:59 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH][media][V2] mb86a20s: apply mask to val after checking for read failure
Date: Fri, 15 Jul 2016 16:59:15 +0100
Message-Id: <1468598355-6970-1-git-send-email-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Appling the mask 0x0f to the immediate return of the call to
mb86a20s_readreg will always result in a positive value, meaning that the
check of ret < 0 will never work.  Instead, check for a -ve return value
first, and then mask val with 0x0f.

Kudos to Mauro Carvalho Chehab for spotting the mistake in my original fix.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index fb88ddd..0fffefd 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -301,10 +301,11 @@ static int mb86a20s_read_status(struct dvb_frontend *fe, enum fe_status *status)
 
 	*status = 0;
 
-	val = mb86a20s_readreg(state, 0x0a) & 0xf;
+	val = mb86a20s_readreg(state, 0x0a);
 	if (val < 0)
 		return val;
 
+	val &= 0xf;
 	if (val >= 2)
 		*status |= FE_HAS_SIGNAL;
 
-- 
2.8.1

