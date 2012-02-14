Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:28272 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282Ab2BNVs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:48:28 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 16/22] mt2063: add hybrid stuff in release function
Date: Tue, 14 Feb 2012 22:47:40 +0100
Message-Id: <1329256066-8844-16-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/common/tuners/mt2063.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 0e26744..e5d96e9 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -486,10 +486,16 @@ static int mt2063_release(struct dvb_frontend *fe)
 {
 	struct mt2063_state *state = fe->tuner_priv;
 
-	dprintk(2, "\n");
+	dprintk(1,"\n");
+
+	mutex_lock(&mt2063_list_mutex);
+
+	if (state)
+		hybrid_tuner_release_state(state);
+
+	mutex_unlock(&mt2063_list_mutex);
 
 	fe->tuner_priv = NULL;
-	kfree(state);
 
 	return 0;
 }
-- 
1.7.7.6

