Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35227 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932138AbdC2QnZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 12:43:25 -0400
Received: by mail-wr0-f193.google.com with SMTP id p52so4573708wrc.2
        for <linux-media@vger.kernel.org>; Wed, 29 Mar 2017 09:43:24 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org
Cc: liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi
Subject: [PATCH v3 09/13] [media] dvb-frontends/stv0367: fix symbol rate conditions in cab_SetQamSize()
Date: Wed, 29 Mar 2017 18:43:09 +0200
Message-Id: <20170329164313.14636-10-d.scheller.oss@gmail.com>
In-Reply-To: <20170329164313.14636-1-d.scheller.oss@gmail.com>
References: <20170329164313.14636-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The values used for comparing symbol rates and the resulting conditional
reg writes seem wrong (rates multiplied by ten), so fix those values.
While this doesn't seem to influence operation, it should be fixed anyway.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0367.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index fb41c7b..ffc046a 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -1838,11 +1838,11 @@ static enum stv0367cab_mod stv0367cab_SetQamSize(struct stv0367_state *state,
 	case FE_CAB_MOD_QAM64:
 		stv0367_writereg(state, R367CAB_IQDEM_ADJ_AGC_REF, 0x82);
 		stv0367_writereg(state, R367CAB_AGC_PWR_REF_L, 0x5a);
-		if (SymbolRate > 45000000) {
+		if (SymbolRate > 4500000) {
 			stv0367_writereg(state, R367CAB_FSM_STATE, 0xb0);
 			stv0367_writereg(state, R367CAB_EQU_CTR_LPF_GAIN, 0xc1);
 			stv0367_writereg(state, R367CAB_EQU_CRL_LPF_GAIN, 0xa5);
-		} else if (SymbolRate > 25000000) {
+		} else if (SymbolRate > 2500000) {
 			stv0367_writereg(state, R367CAB_FSM_STATE, 0xa0);
 			stv0367_writereg(state, R367CAB_EQU_CTR_LPF_GAIN, 0xc1);
 			stv0367_writereg(state, R367CAB_EQU_CRL_LPF_GAIN, 0xa6);
@@ -1860,9 +1860,9 @@ static enum stv0367cab_mod stv0367cab_SetQamSize(struct stv0367_state *state,
 		stv0367_writereg(state, R367CAB_AGC_PWR_REF_L, 0x76);
 		stv0367_writereg(state, R367CAB_FSM_STATE, 0x90);
 		stv0367_writereg(state, R367CAB_EQU_CTR_LPF_GAIN, 0xb1);
-		if (SymbolRate > 45000000)
+		if (SymbolRate > 4500000)
 			stv0367_writereg(state, R367CAB_EQU_CRL_LPF_GAIN, 0xa7);
-		else if (SymbolRate > 25000000)
+		else if (SymbolRate > 2500000)
 			stv0367_writereg(state, R367CAB_EQU_CRL_LPF_GAIN, 0xa6);
 		else
 			stv0367_writereg(state, R367CAB_EQU_CRL_LPF_GAIN, 0x97);
@@ -1875,9 +1875,9 @@ static enum stv0367cab_mod stv0367cab_SetQamSize(struct stv0367_state *state,
 		stv0367_writereg(state, R367CAB_IQDEM_ADJ_AGC_REF, 0x94);
 		stv0367_writereg(state, R367CAB_AGC_PWR_REF_L, 0x5a);
 		stv0367_writereg(state, R367CAB_FSM_STATE, 0xa0);
-		if (SymbolRate > 45000000)
+		if (SymbolRate > 4500000)
 			stv0367_writereg(state, R367CAB_EQU_CTR_LPF_GAIN, 0xc1);
-		else if (SymbolRate > 25000000)
+		else if (SymbolRate > 2500000)
 			stv0367_writereg(state, R367CAB_EQU_CTR_LPF_GAIN, 0xc1);
 		else
 			stv0367_writereg(state, R367CAB_EQU_CTR_LPF_GAIN, 0xd1);
-- 
2.10.2
