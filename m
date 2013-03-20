Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab3CTOCW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 10:02:22 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2KE2M7N014309
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 20 Mar 2013 10:02:22 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/5] [media] drxk: Fix bogus signal strength indicator
Date: Wed, 20 Mar 2013 11:02:15 -0300
Message-Id: <1363788136-14393-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363788136-14393-1-git-send-email-mchehab@redhat.com>
References: <1363788136-14393-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DVBv3 signal strength indicator is bogus: it doesn't range
from 0 to 65535 as it would be expected. Also, 0 means the max
signal strength.

Now that a better way to estimate it was added, use the new
way.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/drxk_hard.c | 33 +++------------------------------
 1 file changed, 3 insertions(+), 30 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 8a5b2cc..fbd11e4 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -2490,32 +2490,6 @@ error:
 	return status;
 }
 
-static int ReadIFAgc(struct drxk_state *state, u32 *pValue)
-{
-	u16 agcDacLvl;
-	int status;
-	u16 Level = 0;
-
-	dprintk(1, "\n");
-
-	status = read16(state, IQM_AF_AGC_IF__A, &agcDacLvl);
-	if (status < 0) {
-		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
-		return status;
-	}
-
-	*pValue = 0;
-
-	if (agcDacLvl > DRXK_AGC_DAC_OFFSET)
-		Level = agcDacLvl - DRXK_AGC_DAC_OFFSET;
-	if (Level < 14000)
-		*pValue = (14000 - Level) / 4;
-	else
-		*pValue = 0;
-
-	return status;
-}
-
 static int GetQAMSignalToNoise(struct drxk_state *state,
 			       s32 *pSignalToNoise)
 {
@@ -6484,7 +6458,7 @@ static int get_strength(struct drxk_state *state, u64 *strength)
 	 * If it can't be measured (AGC is disabled), just show 100%.
 	 */
 	if (totalGain > 0)
-		*strength = (65535UL * atten / totalGain);
+		*strength = (65535UL * atten / totalGain / 100);
 	else
 		*strength = 65535;
 
@@ -6633,7 +6607,7 @@ static int drxk_read_signal_strength(struct dvb_frontend *fe,
 				     u16 *strength)
 {
 	struct drxk_state *state = fe->demodulator_priv;
-	u32 val = 0;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
 	dprintk(1, "\n");
 
@@ -6642,8 +6616,7 @@ static int drxk_read_signal_strength(struct dvb_frontend *fe,
 	if (state->m_DrxkState == DRXK_UNINITIALIZED)
 		return -EAGAIN;
 
-	ReadIFAgc(state, &val);
-	*strength = val & 0xffff;
+	*strength = c->strength.stat[0].uvalue;
 	return 0;
 }
 
-- 
1.8.1.4

