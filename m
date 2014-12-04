Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41400 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaLDQwJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Dec 2014 11:52:09 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] stv090x: add an extra protetion against buffer overflow
Date: Thu,  4 Dec 2014 14:52:02 -0200
Message-Id: <b09b7612af46a26444a79f7b10cc45eb48c12104.1417711918.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As pointed by smatch:
	drivers/media/dvb-frontends/stv090x.c:2787 stv090x_optimize_carloop() error: buffer overflow 'car_loop_apsk_low' 11 <= 13
	drivers/media/dvb-frontends/stv090x.c:2789 stv090x_optimize_carloop() error: buffer overflow 'car_loop_apsk_low' 11 <= 13
	drivers/media/dvb-frontends/stv090x.c:2791 stv090x_optimize_carloop() error: buffer overflow 'car_loop_apsk_low' 11 <= 13
	drivers/media/dvb-frontends/stv090x.c:2793 stv090x_optimize_carloop() error: buffer overflow 'car_loop_apsk_low' 11 <= 13
	drivers/media/dvb-frontends/stv090x.c:2795 stv090x_optimize_carloop() error: buffer overflow 'car_loop_apsk_low' 11 <= 13

The situation of a buffer overflow won't happen, in practice,
with the current values of car_loop table. Yet, the entire logic
that checks for those registration values is too complex. So,
better to add an explicit check, just in case someone changes
the car_loop tables causing a buffer overflow by mistake.

This also helps to remove several smatch warnings, with is good.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
index bce9cc1072aa..0b2a934f53e5 100644
--- a/drivers/media/dvb-frontends/stv090x.c
+++ b/drivers/media/dvb-frontends/stv090x.c
@@ -2783,6 +2783,12 @@ static u8 stv090x_optimize_carloop(struct stv090x_state *state, enum stv090x_mod
 				aclc = car_loop[i].crl_pilots_off_30;
 		}
 	} else { /* 16APSK and 32APSK */
+		/*
+		 * This should never happen in practice, except if
+		 * something is really wrong at the car_loop table.
+		 */
+		if (i >= 11)
+			i = 10;
 		if (state->srate <= 3000000)
 			aclc = car_loop_apsk_low[i].crl_pilots_on_2;
 		else if (state->srate <= 7000000)
-- 
1.9.3

