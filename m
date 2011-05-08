Return-path: <mchehab@gaivota>
Received: from mail.dream-property.net ([82.149.226.172]:52918 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab1EHXNV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 19:13:21 -0400
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: Thierry LELEGARD <tlelegard@logiways.com>
Subject: [PATCH 5/8] DVB: dvb_frontend: remove unused assignments
Date: Sun,  8 May 2011 23:03:38 +0000
Message-Id: <1304895821-21642-6-git-send-email-obi@linuxtv.org>
In-Reply-To: <1304895821-21642-1-git-send-email-obi@linuxtv.org>
References: <1304895821-21642-1-git-send-email-obi@linuxtv.org>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index aca8457..9775cdc 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -612,11 +612,9 @@ restart:
 				dvb_frontend_swzigzag(fe);
 				break;
 			case DVBFE_ALGO_CUSTOM:
-				params = NULL; /* have we been asked to RETUNE ?	*/
 				dprintk("%s: Frontend ALGO = DVBFE_ALGO_CUSTOM, state=%d\n", __func__, fepriv->state);
 				if (fepriv->state & FESTATE_RETUNE) {
 					dprintk("%s: Retune requested, FESTAT_RETUNE\n", __func__);
-					params = &fepriv->parameters_in;
 					fepriv->state = FESTATE_TUNED;
 				}
 				/* Case where we are going to search for a carrier
-- 
1.7.2.5

