Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49405 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbcGLJb2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 05:31:28 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] mb86a20s: remove redundant check if val is less than zero
Date: Tue, 12 Jul 2016 10:30:51 +0100
Message-Id: <1468315851-9179-1-git-send-email-colin.king@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The result of mb86a20s_readreg(state, 0x0a) & 0xf is always in the range
0x00 to 0x0f and can never be negative, so remove the redundant check
of the result being less than zero.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index fb88ddd..0205846 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -302,8 +302,6 @@ static int mb86a20s_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	*status = 0;
 
 	val = mb86a20s_readreg(state, 0x0a) & 0xf;
-	if (val < 0)
-		return val;
 
 	if (val >= 2)
 		*status |= FE_HAS_SIGNAL;
-- 
2.8.1

