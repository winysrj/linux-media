Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46355 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbaJ1PBC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 11:01:02 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	Fred Richter <frichter@hauppauge.com>
Subject: [PATCH 13/13] [media] lgdt3306a: Minor source code cleanups
Date: Tue, 28 Oct 2014 13:00:48 -0200
Message-Id: <4dbd68c7a6b13ef1313f51468f1b154d11e5f934.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a few minor CodingStyle issues at the source code:
	- Use proper multi-line comments;
	- Align the log tables;
	- Remove the .type from dvb_frontend_ops, since this is not
	  needed anymore (since the drivers conversion to DVBv5);
	- Remove emacs format macro.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 4e0cf443b9ff..d9a2b0e768e0 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -67,16 +67,17 @@ struct lgdt3306a_state {
 	u32 snr;
 };
 
-/* -----------------------------------------------
- LG3306A Register Usage
-   (LG does not really name the registers, so this code does not either)
- 0000 -> 00FF Common control and status
- 1000 -> 10FF Synchronizer control and status
- 1F00 -> 1FFF Smart Antenna control and status
- 2100 -> 21FF VSB Equalizer control and status
- 2800 -> 28FF QAM Equalizer control and status
- 3000 -> 30FF FEC control and status
- ---------------------------------------------- */
+/*
+ * LG3306A Register Usage
+ *  (LG does not really name the registers, so this code does not either)
+ *
+ * 0000 -> 00FF Common control and status
+ * 1000 -> 10FF Synchronizer control and status
+ * 1F00 -> 1FFF Smart Antenna control and status
+ * 2100 -> 21FF VSB Equalizer control and status
+ * 2800 -> 28FF QAM Equalizer control and status
+ * 3000 -> 30FF FEC control and status
+ */
 
 enum lgdt3306a_lock_status {
 	LG3306_UNLOCK       = 0x00,
@@ -1431,7 +1432,7 @@ static const u32 valx_x10[] = {
 	10,  11,  13,  15,  17,  20,  25,  33,  41,  50,  59,  73,  87,  100
 };
 static const u32 log10x_x1000[] = {
-	0,  41, 114, 176, 230, 301, 398, 518, 613, 699, 771, 863, 939, 1000
+	0,   41, 114, 176, 230, 301, 398, 518, 613, 699, 771, 863, 939, 1000
 };
 
 static u32 log10_x1000(u32 x)
@@ -2113,9 +2114,6 @@ static struct dvb_frontend_ops lgdt3306a_ops = {
 	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name = "LG Electronics LGDT3306A VSB/QAM Frontend",
-#if 0
-		.type               = FE_ATSC,
-#endif
 		.frequency_min      = 54000000,
 		.frequency_max      = 858000000,
 		.frequency_stepsize = 62500,
@@ -2144,9 +2142,3 @@ MODULE_DESCRIPTION("LG Electronics LGDT3306A ATSC/QAM-B Demodulator Driver");
 MODULE_AUTHOR("Fred Richter <frichter@hauppauge.com>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.2");
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/dvb-frontends/lgdt3306a.h b/drivers/media/dvb-frontends/lgdt3306a.h
index 6d7daf6f52de..ed8aa3e7c950 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.h
+++ b/drivers/media/dvb-frontends/lgdt3306a.h
@@ -72,4 +72,3 @@ struct dvb_frontend *lgdt3306a_attach(const struct lgdt3306a_config *config,
 #endif /* CONFIG_DVB_LGDT3306A */
 
 #endif /* _LGDT3306A_H_ */
-
-- 
1.9.3

