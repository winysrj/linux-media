Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46376 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbaJ1PBD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 11:01:03 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	Fred Richter <frichter@hauppauge.com>
Subject: [PATCH 09/13] [media] lgdt3306a: Don't use else were not needed
Date: Tue, 28 Oct 2014 13:00:44 -0200
Message-Id: <c69d7ca6f9f920567b3c9dfddd429f3ded29fae0.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get rid of the remaining checkpatch.pl warnings:
	WARNING: braces {} are not necessary for any arm of this statement

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 0356810da444..38b64b2c745c 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -1125,10 +1125,9 @@ static enum lgdt3306a_modulation lgdt3306a_check_oper_mode(struct lgdt3306a_stat
 		if (val & 0x01) {
 			dbg_info("QAM256\n");
 			return LG3306_QAM256;
-		} else {
-			dbg_info("QAM64\n");
-			return LG3306_QAM64;
 		}
+		dbg_info("QAM64\n");
+		return LG3306_QAM64;
 	}
 err:
 	pr_warn("UNKNOWN\n");
@@ -1399,14 +1398,15 @@ static u32 log10_x1000(u32 x)
 	if (x <= 0)
 		return -1000000; /* signal error */
 
+	if (x == 10)
+		return 0; /* log(1)=0 */
+
 	if (x < 10) {
 		while (x < 10) {
 			x = x * 10;
 			log_val--;
 		}
-	} else if (x == 10) {
-		return 0; /* log(1)=0 */
-	} else {
+	} else {	/* x > 10 */
 		while (x >= 100) {
 			x = x / 10;
 			log_val++;
-- 
1.9.3

