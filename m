Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:8227 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247Ab2AKPg6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 10:36:58 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 1/2] dvbv5-scan: correction frequency parsing
Date: Wed, 11 Jan 2012 16:36:35 +0100
Message-Id: <1326296196-2331-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 utils/dvb/descriptors.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/utils/dvb/descriptors.c b/utils/dvb/descriptors.c
index a492b6c..fcad464 100644
--- a/utils/dvb/descriptors.c
+++ b/utils/dvb/descriptors.c
@@ -365,7 +365,7 @@ static void parse_NIT_DVBT(struct nit_table *nit_table,
 
 	*freq = realloc(*freq, 1);
 	nit_table->frequency_len = 1;
-	nit_table->frequency[0] = bcd_to_int(&buf[2], 32) * 10; /* KHz */
+	nit_table->frequency[0] = ((buf[2] << 24) | (buf[3] << 16) | (buf[4] << 8) | (buf[5])) * 10; /* KHz */
 
 	nit_table->has_dvbt = 1;
 	if (nit_table->delivery_system != SYS_DVBT2)
-- 
1.7.7

