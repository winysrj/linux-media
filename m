Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46276 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbaJ1PA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 11:00:59 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	Fred Richter <frichter@hauppauge.com>
Subject: [PATCH 11/13] [media] lgdt3306a: constify log tables
Date: Tue, 28 Oct 2014 13:00:46 -0200
Message-Id: <496635a58bdc8b14a1a784e2d814933e5fc3272a.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ideally, we should be replacing this function by intlog10().

While we don't do that, let's at least constify the tables,
in order to remove its code footfrint, and get rid of nelems.

This also fixes a few 80-cols CodingStyle warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 9c80d4c26381..ad483be1b64e 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -1386,11 +1386,15 @@ static u8 lgdt3306a_get_packet_error(struct lgdt3306a_state *state)
 	return val;
 }
 
+static const u32 valx_x10[] = {
+	10,  11,  13,  15,  17,  20,  25,  33,  41,  50,  59,  73,  87,  100
+};
+static const u32 log10x_x1000[] = {
+	0,  41, 114, 176, 230, 301, 398, 518, 613, 699, 771, 863, 939, 1000
+};
+
 static u32 log10_x1000(u32 x)
 {
-	static u32 valx_x10[]     = {  10,  11,  13,  15,  17,  20,  25,  33,  41,  50,  59,  73,  87,  100 };
-	static u32 log10x_x1000[] = {   0,  41, 114, 176, 230, 301, 398, 518, 613, 699, 771, 863, 939, 1000 };
-	static u32 nelems = sizeof(valx_x10)/sizeof(valx_x10[0]);
 	u32 diff_val, step_val, step_log10;
 	u32 log_val = 0;
 	u32 i;
@@ -1418,11 +1422,11 @@ static u32 log10_x1000(u32 x)
 		return log_val;	/* don't need to interpolate */
 
 	/* find our place on the log curve */
-	for (i = 1; i < nelems; i++) {
+	for (i = 1; i < ARRAY_SIZE(valx_x10); i++) {
 		if (valx_x10[i] >= x)
 			break;
 	}
-	if (i == nelems)
+	if (i == ARRAY_SIZE(valx_x10))
 		return log_val + log10x_x1000[i - 1];
 
 	diff_val   = x - valx_x10[i-1];
-- 
1.9.3

