Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687Ab3CTOCV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 10:02:21 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2KE2LTL010036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 20 Mar 2013 10:02:21 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/5] [media] drxk: remove dummy BER read code
Date: Wed, 20 Mar 2013 11:02:12 -0300
Message-Id: <1363788136-14393-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363788136-14393-1-git-send-email-mchehab@redhat.com>
References: <1363788136-14393-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The BER code does nothing but filling it with zero. Remove it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/drxk_hard.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index c2fc7da0d..0e40832 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -6408,21 +6408,6 @@ static int drxk_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	return 0;
 }
 
-static int drxk_read_ber(struct dvb_frontend *fe, u32 *ber)
-{
-	struct drxk_state *state = fe->demodulator_priv;
-
-	dprintk(1, "\n");
-
-	if (state->m_DrxkState == DRXK_NO_DEV)
-		return -ENODEV;
-	if (state->m_DrxkState == DRXK_UNINITIALIZED)
-		return -EAGAIN;
-
-	*ber = 0;
-	return 0;
-}
-
 static int drxk_read_signal_strength(struct dvb_frontend *fe,
 				     u16 *strength)
 {
@@ -6529,7 +6514,6 @@ static struct dvb_frontend_ops drxk_ops = {
 	.get_tune_settings = drxk_get_tune_settings,
 
 	.read_status = drxk_read_status,
-	.read_ber = drxk_read_ber,
 	.read_signal_strength = drxk_read_signal_strength,
 	.read_snr = drxk_read_snr,
 	.read_ucblocks = drxk_read_ucblocks,
-- 
1.8.1.4

