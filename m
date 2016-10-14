Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48669 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755285AbcJNRrI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 20/25] [media] mt20xx: use %*ph to do small hexa dumps
Date: Fri, 14 Oct 2016 14:45:58 -0300
Message-Id: <72e71dbee6ca5d41d96a50ffbc5c170e8f8654b8.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit 563873318d32 ("Merge branch 'printk-cleanups"),
continuation lines require KERN_CONT. Instead, let's just
use %*ph to print the buffer.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/tuners/mt20xx.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/media/tuners/mt20xx.c b/drivers/media/tuners/mt20xx.c
index 52da4671b0e0..29dadd171b31 100644
--- a/drivers/media/tuners/mt20xx.c
+++ b/drivers/media/tuners/mt20xx.c
@@ -487,13 +487,8 @@ static void mt2050_set_if_freq(struct dvb_frontend *fe,unsigned int freq, unsign
 	buf[5]=div2a;
 	if(num2!=0) buf[5]=buf[5]|0x40;
 
-	if (debug > 1) {
-		int i;
-		tuner_dbg("bufs is: ");
-		for(i=0;i<6;i++)
-			printk("%x ",buf[i]);
-		printk("\n");
-	}
+	if (debug > 1)
+		tuner_dbg("bufs is: %*ph\n", 6, buf);
 
 	ret=tuner_i2c_xfer_send(&priv->i2c_props,buf,6);
 	if (ret!=6)
@@ -619,15 +614,9 @@ struct dvb_frontend *microtune_attach(struct dvb_frontend *fe,
 
 	tuner_i2c_xfer_send(&priv->i2c_props,buf,1);
 	tuner_i2c_xfer_recv(&priv->i2c_props,buf,21);
-	if (debug) {
-		int i;
-		tuner_dbg("MT20xx hexdump:");
-		for(i=0;i<21;i++) {
-			printk(" %02x",buf[i]);
-			if(((i+1)%8)==0) printk(" ");
-		}
-		printk("\n");
-	}
+	if (debug)
+		tuner_dbg("MT20xx hexdump: %*ph\n", 21, buf);
+
 	company_code = buf[0x11] << 8 | buf[0x12];
 	tuner_info("microtune: companycode=%04x part=%02x rev=%02x\n",
 		   company_code,buf[0x13],buf[0x14]);
-- 
2.7.4


