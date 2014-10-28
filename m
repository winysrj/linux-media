Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46357 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbaJ1PBC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 11:01:02 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	Fred Richter <frichter@hauppauge.com>
Subject: [PATCH 04/13] [media] lgdt3306a: don't go past the buffer
Date: Tue, 28 Oct 2014 13:00:39 -0200
Message-Id: <e3fbe97e18575d8adef222e3f86590cb1b310766.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/dvb-frontends/lgdt3306a.c:1354 log10_x1000() error: buffer overflow 'valx_x10' 14 <= 14
	drivers/media/dvb-frontends/lgdt3306a.c:1355 log10_x1000() error: buffer overflow 'log10x_x1000' 14 <= 14

There's a potential of returning a value out of the buffer. Fix it.

While here, remove the ugly braced block.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index c8af071ce40b..92affe124a8d 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -1319,6 +1319,7 @@ static u32 log10_x1000(u32 x)
 	static u32 valx_x10[]     = {  10,  11,  13,  15,  17,  20,  25,  33,  41,  50,  59,  73,  87,  100 };
 	static u32 log10x_x1000[] = {   0,  41, 114, 176, 230, 301, 398, 518, 613, 699, 771, 863, 939, 1000 };
 	static u32 nelems = sizeof(valx_x10)/sizeof(valx_x10[0]);
+	u32 diff_val, step_val, step_log10;
 	u32 log_val = 0;
 	u32 i;
 
@@ -1348,15 +1349,16 @@ static u32 log10_x1000(u32 x)
 		if (valx_x10[i] >= x)
 			break;
 	}
+	if (i == nelems)
+		return log_val + log10x_x1000[i - 1];
 
-	{
-		u32 diff_val   = x - valx_x10[i-1];
-		u32 step_val   = valx_x10[i] - valx_x10[i-1];
-		u32 step_log10 = log10x_x1000[i] - log10x_x1000[i-1];
-		/* do a linear interpolation to get in-between values */
-		return log_val + log10x_x1000[i-1] +
-			((diff_val*step_log10) / step_val);
-	}
+	diff_val   = x - valx_x10[i-1];
+	step_val   = valx_x10[i] - valx_x10[i - 1];
+	step_log10 = log10x_x1000[i] - log10x_x1000[i - 1];
+
+	/* do a linear interpolation to get in-between values */
+	return log_val + log10x_x1000[i - 1] +
+		((diff_val*step_log10) / step_val);
 }
 
 static u32 lgdt3306a_calculate_snr_x100(struct lgdt3306a_state *state)
-- 
1.9.3

