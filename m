Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:44093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806Ab1GKCAF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 22:00:05 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B203Bk014342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 22:00:05 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKi030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 22:00:02 -0400
Date: Sun, 10 Jul 2011 22:59:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 14/21] [media] drxk: change mode before calling the set mode
 routines
Message-ID: <20110710225904.6ba84629@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

The set mode routines assume that state were changed to the
new mode, otherwise, they'll fail.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 74e986f..1d29ed2 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -1837,17 +1837,17 @@ static int SetOperationMode(struct drxk_state *state,
 			*/
 		switch (oMode) {
 		case OM_DVBT:
+			state->m_OperationMode = oMode;
 			status = SetDVBTStandard(state, oMode);
 			if (status < 0)
 				goto error;
-			state->m_OperationMode = oMode;
 			break;
 		case OM_QAM_ITU_A:	/* fallthrough */
 		case OM_QAM_ITU_C:
+			state->m_OperationMode = oMode;
 			status = SetQAMStandard(state, oMode);
 			if (status < 0)
 				goto error;
-			state->m_OperationMode = oMode;
 			break;
 		case OM_QAM_ITU_B:
 		default:
-- 
1.7.1


