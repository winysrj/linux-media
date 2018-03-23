Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47101 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753773AbeCWL5X (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:23 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 09/30] media: sp887x: fix a warning
Date: Fri, 23 Mar 2018 07:56:55 -0400
Message-Id: <89d6e45c8af8b6e9351564a15467c90e862bbfcd.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/dvb-frontends/sp887x.c:179 sp887x_initial_setup() error: memcpy() '&buf[2]' too small (30 vs 16384)

This is actually a false alarm, but reverting the check order
makes not only for humans to review the code, but also cleans
the warning.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/sp887x.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/sp887x.c b/drivers/media/dvb-frontends/sp887x.c
index 572a297811fe..f39d566d7d1d 100644
--- a/drivers/media/dvb-frontends/sp887x.c
+++ b/drivers/media/dvb-frontends/sp887x.c
@@ -136,7 +136,7 @@ static void sp887x_setup_agc (struct sp887x_state* state)
 static int sp887x_initial_setup (struct dvb_frontend* fe, const struct firmware *fw)
 {
 	struct sp887x_state* state = fe->demodulator_priv;
-	u8 buf [BLOCKSIZE+2];
+	u8 buf [BLOCKSIZE + 2];
 	int i;
 	int fw_size = fw->size;
 	const unsigned char *mem = fw->data;
@@ -144,7 +144,7 @@ static int sp887x_initial_setup (struct dvb_frontend* fe, const struct firmware
 	dprintk("%s\n", __func__);
 
 	/* ignore the first 10 bytes, then we expect 0x4000 bytes of firmware */
-	if (fw_size < FW_SIZE+10)
+	if (fw_size < FW_SIZE + 10)
 		return -ENODEV;
 
 	mem = fw->data + 10;
@@ -167,7 +167,7 @@ static int sp887x_initial_setup (struct dvb_frontend* fe, const struct firmware
 		int c = BLOCKSIZE;
 		int err;
 
-		if (i+c > FW_SIZE)
+		if (c > FW_SIZE - i)
 			c = FW_SIZE - i;
 
 		/* bit 0x8000 in address is set to enable 13bit mode */
-- 
2.14.3
