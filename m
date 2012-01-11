Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:42704 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab2AKTcQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 14:32:16 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH] dvbv5-scan: parsing going to crash
Date: Wed, 11 Jan 2012 20:31:43 +0100
Message-Id: <1326310303-12421-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 utils/dvb/descriptors.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/utils/dvb/descriptors.c b/utils/dvb/descriptors.c
index b037c97..e9a8e2d 100644
--- a/utils/dvb/descriptors.c
+++ b/utils/dvb/descriptors.c
@@ -511,11 +511,11 @@ static int parse_extension_descriptor(enum dvb_tables type,
 
 	if (dvb_desc->verbose) {
 		printf("Extension descriptor %s (0x%02x), len %d",
-			extension_descriptors[buf[0]], buf[0], buf[1]);
+			extension_descriptors[ext], ext, dlen);
 		for (i = 0; i < dlen; i++) {
 			if (!(i % 16))
 				printf("\n\t");
-			printf("%02x ", (uint8_t) *(buf + i + 2));
+			printf("%02x ", (uint8_t) *(buf + i));
 		}
 		printf("\n");
 	}
-- 
1.7.7

