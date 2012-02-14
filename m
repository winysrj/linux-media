Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:28276 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761246Ab2BNVs2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:48:28 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 18/22] mt2063: add get_if_frequency
Date: Tue, 14 Feb 2012 22:47:42 +0100
Message-Id: <1329256066-8844-18-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 drivers/media/common/tuners/mt2063.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
index 2a2cce3..8d8e638 100644
--- a/drivers/media/common/tuners/mt2063.c
+++ b/drivers/media/common/tuners/mt2063.c
@@ -541,11 +541,15 @@ static int mt2063_release(struct dvb_frontend *fe)
 	return 0;
 }
 
+static int mt2063_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct mt2063_state *state = fe->tuner_priv;
 
+	dprintk(1, "\n");
 
+	*frequency = state->if2 * 1000;
 
+	dprintk(2, "if frequency is %d kHz\n", state->if2);
 
 	return 0;
 }
-- 
1.7.7.6

