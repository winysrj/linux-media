Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757668Ab2J0Umb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:42:31 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKgV39020502
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:42:31 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 46/68] [media] drxk: get rid of some unused vars
Date: Sat, 27 Oct 2012 18:41:04 -0200
Message-Id: <1351370486-29040-47-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/drxk_hard.c:68:13: warning: 'IsA1WithPatchCode' defined but not used [-Wunused-function]
drivers/media/dvb-frontends/drxk_hard.c:73:13: warning: 'IsA1WithRomCode' defined but not used [-Wunused-function]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/drxk_hard.c | 15 ---------------
 drivers/media/dvb-frontends/drxk_hard.h |  6 +-----
 2 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index fb23496..59382fb 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -65,16 +65,6 @@ static bool IsQAM(struct drxk_state *state)
 	    state->m_OperationMode == OM_QAM_ITU_C;
 }
 
-static bool IsA1WithPatchCode(struct drxk_state *state)
-{
-	return state->m_DRXK_A1_PATCH_CODE;
-}
-
-static bool IsA1WithRomCode(struct drxk_state *state)
-{
-	return state->m_DRXK_A1_ROM_CODE;
-}
-
 #define NOA1ROM 0
 
 #define DRXDAP_FASI_SHORT_FORMAT(addr) (((addr) & 0xFC30FF80) == 0)
@@ -720,11 +710,6 @@ static int init_state(struct drxk_state *state)
 
 	state->m_bPowerDown = (ulPowerDown != 0);
 
-	state->m_DRXK_A1_PATCH_CODE = false;
-	state->m_DRXK_A1_ROM_CODE = false;
-	state->m_DRXK_A2_ROM_CODE = false;
-	state->m_DRXK_A3_ROM_CODE = false;
-	state->m_DRXK_A2_PATCH_CODE = false;
 	state->m_DRXK_A3_PATCH_CODE = false;
 
 	/* Init AGC and PGA parameters */
diff --git a/drivers/media/dvb-frontends/drxk_hard.h b/drivers/media/dvb-frontends/drxk_hard.h
index 6bb9fc4..d18a896 100644
--- a/drivers/media/dvb-frontends/drxk_hard.h
+++ b/drivers/media/dvb-frontends/drxk_hard.h
@@ -320,11 +320,7 @@ struct drxk_state {
 
 	u8               *m_microcode;
 	int               m_microcode_length;
-	bool              m_DRXK_A1_PATCH_CODE;
-	bool              m_DRXK_A1_ROM_CODE;
-	bool              m_DRXK_A2_ROM_CODE;
-	bool              m_DRXK_A3_ROM_CODE;
-	bool              m_DRXK_A2_PATCH_CODE;
+	bool		  m_DRXK_A3_ROM_CODE;
 	bool              m_DRXK_A3_PATCH_CODE;
 
 	bool              m_rfmirror;
-- 
1.7.11.7

