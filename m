Return-path: <linux-media-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:29964 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbZARXb0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2009 18:31:26 -0500
Received: by nf-out-0910.google.com with SMTP id d3so379097nfc.21
        for <linux-media@vger.kernel.org>; Sun, 18 Jan 2009 15:31:24 -0800 (PST)
Message-ID: <4973BBCE.8090602@gmail.com>
Date: Mon, 19 Jan 2009 00:31:26 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: [PATCH] DVB: negative internal->sub_range won't get noticed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

internal->sub_range is unsigned, a negative won't get noticed.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/dvb/frontends/stb0899_algo.c b/drivers/media/dvb/frontends/stb0899_algo.c
index 83dc7e1..2ea32da 100644
--- a/drivers/media/dvb/frontends/stb0899_algo.c
+++ b/drivers/media/dvb/frontends/stb0899_algo.c
@@ -464,13 +464,14 @@ static void next_sub_range(struct stb0899_state *state)
 
 	if (internal->sub_dir > 0) {
 		old_sub_range = internal->sub_range;
-		internal->sub_range = MIN((internal->srch_range / 2) -
+		if (internal->tuner_offst + internal->sub_range / 2 >=
+				internal->srch_range / 2)
+			internal->sub_range = 0;
+		else
+			internal->sub_range = MIN((internal->srch_range / 2) -
 					  (internal->tuner_offst + internal->sub_range / 2),
 					   internal->sub_range);
 
-		if (internal->sub_range < 0)
-			internal->sub_range = 0;
-
 		internal->tuner_offst += (old_sub_range + internal->sub_range) / 2;
 	}
 
