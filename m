Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:28275 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761237Ab2BNVs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:48:28 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 11/22] mt2063: remove get_bandwidth
Date: Tue, 14 Feb 2012 22:47:35 +0100
Message-Id: <1329256066-8844-11-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/common/tuners/mt2063.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index dfa2e28..24c2c93 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -773,18 +773,9 @@ static int mt2063_get_if_frequency(struct dvb_frontend *fe, u32 *freq)
 	return 0;
 }
 
-static int mt2063_get_bandwidth(struct dvb_frontend *fe, u32 *bw)
-{
-	struct mt2063_state *state = fe->tuner_priv;
-
-	dprintk(2, "\n");
-
-	if (!state->init)
 		return -ENODEV;
 
-	*bw = state->AS_Data.f_out_bw - 750000;
 
-	dprintk(1, "bandwidth: %d\n", *bw);
 
 	return 0;
 }
-- 
1.7.7.6

