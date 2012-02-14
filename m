Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:28274 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309Ab2BNVs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:48:28 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 19/22] mt2063: remove old get_if_frequency
Date: Tue, 14 Feb 2012 22:47:43 +0100
Message-Id: <1329256066-8844-19-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/common/tuners/mt2063.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 8d8e638..fb0a38b 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -643,22 +643,8 @@ static int mt2063_set_params(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int mt2063_get_if_frequency(struct dvb_frontend *fe, u32 *freq)
-{
-	struct mt2063_state *state = fe->tuner_priv;
-
-	dprintk(2, "\n");
-
-	if (!state->init)
 		return -ENODEV;
 
-	*freq = state->AS_Data.f_out;
-
-	dprintk(1, "IF frequency: %d\n", *freq);
-
-	return 0;
-}
-
 		return -ENODEV;
 
 
-- 
1.7.7.6

