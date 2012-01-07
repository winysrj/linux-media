Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab2AGHhk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 02:37:40 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q077beC7019638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 7 Jan 2012 02:37:40 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] drxk_hard: Remove dead code
Date: Sat,  7 Jan 2012 05:37:18 -0200
Message-Id: <1325921838-32535-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by Oliver, some old dead code were preserved there.

Thanks-to: Oliver endriss <o.endriss@gmx.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/drxk_hard.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 97670db..6980ed7 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6236,8 +6236,6 @@ static int drxk_set_parameters(struct dvb_frontend *fe)
 				SetOperationMode(state, OM_QAM_ITU_C);
 			else
 				SetOperationMode(state, OM_QAM_ITU_A);
-				break;
-			state->m_itut_annex_c = true;
 			break;
 		case SYS_DVBT:
 			if (!state->m_hasDVBT)
-- 
1.7.7.5

