Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:8228 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab2AKPg6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 10:36:58 -0500
From: linuxtv@stefanringel.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, Stefan Ringel <linuxtv@stefanringel.de>
Subject: [PATCH 2/2] dvbv5-scan: remove pointer shift
Date: Wed, 11 Jan 2012 16:36:36 +0100
Message-Id: <1326296196-2331-2-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1326296196-2331-1-git-send-email-linuxtv@stefanringel.de>
References: <1326296196-2331-1-git-send-email-linuxtv@stefanringel.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <linuxtv@stefanringel.de>

Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>
---
 utils/dvb/descriptors.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/utils/dvb/descriptors.c b/utils/dvb/descriptors.c
index fcad464..d034e8b 100644
--- a/utils/dvb/descriptors.c
+++ b/utils/dvb/descriptors.c
@@ -713,10 +713,9 @@ void parse_descriptor(enum dvb_tables type,
 				&service_table->provider_alias,
 				&buf[4], buf[3],
 				default_charset, output_charset);
-			buf += 4 + buf[3];
 			parse_string(&service_table->service_name,
 				&service_table->service_alias,
-				&buf[1], buf[0],
+				&buf[5 + buf[3]], buf[4 + buf[3]],
 				default_charset, output_charset);
 			if (dvb_desc->verbose) {
 				if (service_table->provider_name)
-- 
1.7.7

