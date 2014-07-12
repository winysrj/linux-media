Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52303 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030AbaGLAh5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 20:37:57 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/3] mb86a20s: Fix Interleaving
Date: Fri, 11 Jul 2014 21:37:47 -0300
Message-Id: <1405125468-4748-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1405125468-4748-1-git-send-email-m.chehab@samsung.com>
References: <1405125468-4748-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Interleaving code was wrong at mb86a20s: instead, it was looking
at the Guard Interval. Fix it.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 2f458bb188c7..2de0e59bd243 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -459,6 +459,9 @@ static int mb86a20s_get_interleaving(struct mb86a20s_state *state,
 				     unsigned layer)
 {
 	int rc;
+	int interleaving[] = {
+		0, 1, 2, 4, 8
+	};
 
 	static unsigned char reg[] = {
 		[0] = 0x88,	/* Layer A */
@@ -475,20 +478,7 @@ static int mb86a20s_get_interleaving(struct mb86a20s_state *state,
 	if (rc < 0)
 		return rc;
 
-	switch ((rc >> 4) & 0x07) {
-	case 1:
-		return GUARD_INTERVAL_1_4;
-	case 2:
-		return GUARD_INTERVAL_1_8;
-	case 3:
-		return GUARD_INTERVAL_1_16;
-	case 4:
-		return GUARD_INTERVAL_1_32;
-
-	default:
-	case 0:
-		return GUARD_INTERVAL_AUTO;
-	}
+	return interleaving[(rc >> 4) & 0x07];
 }
 
 static int mb86a20s_get_segment_count(struct mb86a20s_state *state,
-- 
1.9.3

