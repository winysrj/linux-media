Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932678Ab2JYPy4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 11:54:56 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9PFsunP008309
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 25 Oct 2012 11:54:56 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] drxk_hard: fix a few warnings
Date: Thu, 25 Oct 2012 13:54:53 -0200
Message-Id: <1351180493-6547-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/drxk_hard.c:68:6: warning: no previous prototype for 'IsA1WithPatchCode' [-Wmissing-prototypes]
drivers/media/dvb-frontends/drxk_hard.c:73:6: warning: no previous prototype for 'IsA1WithRomCode' [-Wmissing-prototypes]
drivers/media/dvb-frontends/drxk_hard.c:192:12: warning: no previous prototype for 'Frac28a' [-Wmissing-prototypes]
drivers/media/dvb-frontends/drxk_hard.c:590:5: warning: no previous prototype for 'PowerUpDevice' [-Wmissing-prototypes]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/drxk_hard.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index 894b6eca..fb23496 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -65,12 +65,12 @@ static bool IsQAM(struct drxk_state *state)
 	    state->m_OperationMode == OM_QAM_ITU_C;
 }
 
-bool IsA1WithPatchCode(struct drxk_state *state)
+static bool IsA1WithPatchCode(struct drxk_state *state)
 {
 	return state->m_DRXK_A1_PATCH_CODE;
 }
 
-bool IsA1WithRomCode(struct drxk_state *state)
+static bool IsA1WithRomCode(struct drxk_state *state)
 {
 	return state->m_DRXK_A1_ROM_CODE;
 }
@@ -189,7 +189,7 @@ static inline u32 MulDiv32(u32 a, u32 b, u32 c)
 	return (u32) tmp64;
 }
 
-inline u32 Frac28a(u32 a, u32 c)
+static inline u32 Frac28a(u32 a, u32 c)
 {
 	int i = 0;
 	u32 Q1 = 0;
@@ -587,7 +587,7 @@ static int write_block(struct drxk_state *state, u32 Address,
 #define DRXK_MAX_RETRIES_POWERUP 20
 #endif
 
-int PowerUpDevice(struct drxk_state *state)
+static int PowerUpDevice(struct drxk_state *state)
 {
 	int status;
 	u8 data = 0;
-- 
1.7.11.7

