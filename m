Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48670 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755296AbcJNRrI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 24/25] [media] dvb-pll: use pr_foo() macros instead of printk()
Date: Fri, 14 Oct 2016 14:46:02 -0300
Message-Id: <ca6853a8320c9c2530379862703ee1f2c6d87100.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace printk() macros by their pr_foo() counterparts.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/dvb-pll.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/dvb-pll.c b/drivers/media/dvb-frontends/dvb-pll.c
index 735a96662022..b6d199196b83 100644
--- a/drivers/media/dvb-frontends/dvb-pll.c
+++ b/drivers/media/dvb-frontends/dvb-pll.c
@@ -18,6 +18,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/dvb/frontend.h>
@@ -25,6 +27,9 @@
 
 #include "dvb-pll.h"
 
+#define dprintk(fmt, arg...) \
+	printk(KERN_DEBUG pr_fmt("%s: " fmt), __func__, ##arg)
+
 struct dvb_pll_priv {
 	/* pll number */
 	int nr;
@@ -362,7 +367,7 @@ static void opera1_bw(struct dvb_frontend *fe, u8 *buf)
 
 	result = i2c_transfer(priv->i2c, &msg, 1);
 	if (result != 1)
-		printk(KERN_ERR "%s: i2c_transfer failed:%d",
+		pr_err("%s: i2c_transfer failed:%d",
 			__func__, result);
 
 	if (b_w <= 10000)
@@ -432,7 +437,7 @@ static void samsung_dtos403ih102a_set(struct dvb_frontend *fe, u8 *buf)
 
 	result = i2c_transfer(priv->i2c, &msg, 1);
 	if (result != 1)
-		printk(KERN_ERR "%s: i2c_transfer failed:%d",
+		pr_err("%s: i2c_transfer failed:%d",
 			__func__, result);
 
 	buf[2] = 0x9e;
@@ -578,7 +583,7 @@ static int dvb_pll_configure(struct dvb_frontend *fe, u8 *buf,
 	}
 
 	if (debug)
-		printk("pll: %s: freq=%d | i=%d/%d\n", desc->name,
+		dprintk("pll: %s: freq=%d | i=%d/%d\n", desc->name,
 		       frequency, i, desc->count);
 	if (i == desc->count)
 		return -EINVAL;
@@ -594,7 +599,7 @@ static int dvb_pll_configure(struct dvb_frontend *fe, u8 *buf,
 		desc->set(fe, buf);
 
 	if (debug)
-		printk("pll: %s: div=%d | buf=0x%02x,0x%02x,0x%02x,0x%02x\n",
+		dprintk("pll: %s: div=%d | buf=0x%02x,0x%02x,0x%02x,0x%02x\n",
 		       desc->name, div, buf[0], buf[1], buf[2], buf[3]);
 
 	// calculate the frequency we set it to
@@ -803,10 +808,10 @@ struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe, int pll_addr,
 	fe->tuner_priv = priv;
 
 	if ((debug) || (id[priv->nr] == pll_desc_id)) {
-		printk("dvb-pll[%d]", priv->nr);
+		dprintk("dvb-pll[%d]", priv->nr);
 		if (i2c != NULL)
-			printk(" %d-%04x", i2c_adapter_id(i2c), pll_addr);
-		printk(": id# %d (%s) attached, %s\n", pll_desc_id, desc->name,
+			pr_cont(" %d-%04x", i2c_adapter_id(i2c), pll_addr);
+		pr_cont(": id# %d (%s) attached, %s\n", pll_desc_id, desc->name,
 		       id[priv->nr] == pll_desc_id ?
 				"insmod option" : "autodetected");
 	}
-- 
2.7.4


