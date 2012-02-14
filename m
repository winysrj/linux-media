Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:28277 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761231Ab2BNVs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:48:28 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 14/22] mt2063: remove get_status
Date: Tue, 14 Feb 2012 22:47:38 +0100
Message-Id: <1329256066-8844-14-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/common/tuners/mt2063.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 452c517..3af5242 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -460,24 +460,12 @@ static int mt2063_init(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int mt2063_get_status(struct dvb_frontend *fe, u32 *tuner_status)
 {
 	struct mt2063_state *state = fe->tuner_priv;
-	int status;
 
-	dprintk(2, "\n");
 
-	if (!state->init)
-		return -ENODEV;
 
-	*tuner_status = 0;
-	status = mt2063_lockStatus(state);
-	if (status < 0)
-		return status;
-	if (status)
-		*tuner_status = TUNER_STATUS_LOCKED;
 
-	dprintk(1, "Tuner status: %d", *tuner_status);
 
 	return 0;
 }
-- 
1.7.7.6

