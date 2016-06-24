Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40648 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbcFXPcR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 11:32:17 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 14/19] r820t: comment out two ancillary tables
Date: Fri, 24 Jun 2016 12:31:55 -0300
Message-Id: <29025f69bb8aa0900ed89bd3abbe97ea85ff760a.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As Gcc6.1 warned, those tables are currently unused:
	drivers/media/tuners/r820t.c:349:18: warning: 'r820t_mixer_gain_steps' defined but not used [-Wunused-const-variable=]
	 static const int r820t_mixer_gain_steps[]  = {
	                  ^~~~~~~~~~~~~~~~~~~~~~
	drivers/media/tuners/r820t.c:345:18: warning: 'r820t_lna_gain_steps' defined but not used [-Wunused-const-variable=]
	 static const int r820t_lna_gain_steps[]  = {
	                  ^~~~~~~~~~~~~~~~~~~~

They're actually used only by a routine that it is currently
commented out. So, move those tables to be together with such
code and comment them out.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/tuners/r820t.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 6ab35e315fe7..08dca40356d2 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -337,20 +337,6 @@ static int r820t_xtal_capacitor[][2] = {
 };
 
 /*
- * measured with a Racal 6103E GSM test set at 928 MHz with -60 dBm
- * input power, for raw results see:
- *	http://steve-m.de/projects/rtl-sdr/gain_measurement/r820t/
- */
-
-static const int r820t_lna_gain_steps[]  = {
-	0, 9, 13, 40, 38, 13, 31, 22, 26, 31, 26, 14, 19, 5, 35, 13
-};
-
-static const int r820t_mixer_gain_steps[]  = {
-	0, 5, 10, 10, 19, 9, 10, 25, 17, 10, 8, 16, 13, 6, 3, -8
-};
-
-/*
  * I2C read/write code and shadow registers logic
  */
 static void shadow_store(struct r820t_priv *priv, u8 reg, const u8 *val,
@@ -1216,6 +1202,21 @@ static int r820t_read_gain(struct r820t_priv *priv)
 
 #if 0
 /* FIXME: This routine requires more testing */
+
+/*
+ * measured with a Racal 6103E GSM test set at 928 MHz with -60 dBm
+ * input power, for raw results see:
+ *	http://steve-m.de/projects/rtl-sdr/gain_measurement/r820t/
+ */
+
+static const int r820t_lna_gain_steps[]  = {
+	0, 9, 13, 40, 38, 13, 31, 22, 26, 31, 26, 14, 19, 5, 35, 13
+};
+
+static const int r820t_mixer_gain_steps[]  = {
+	0, 5, 10, 10, 19, 9, 10, 25, 17, 10, 8, 16, 13, 6, 3, -8
+};
+
 static int r820t_set_gain_mode(struct r820t_priv *priv,
 			       bool set_manual_gain,
 			       int gain)
-- 
2.7.4


