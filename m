Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37695 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933262AbdKAVGM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH v2 06/26] media: xc5000: better handle I2C error messages
Date: Wed,  1 Nov 2017 17:05:43 -0400
Message-Id: <2849e18196b46bf89516ee5c9077c7f0468e89ed.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch, there are several places where the I2C
transfer may fail, leading into inconsistent behavior:

	drivers/media/tuners/xc5000.c:689 xc_debug_dump() error: uninitialized symbol 'regval'.
	drivers/media/tuners/xc5000.c:841 xc5000_is_firmware_loaded() error: uninitialized symbol 'id'.
	drivers/media/tuners/xc5000.c:939 xc5000_set_tv_freq() error: uninitialized symbol 'pll_lock_status'.
	drivers/media/tuners/xc5000.c:1195 xc_load_fw_and_init_tuner() error: uninitialized symbol 'pll_lock_status'.

Handle the return codes from the I2C transfer, in order to
address those issues.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/tuners/xc5000.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index 0e7e4fdf9e50..98ba177dbc29 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -685,8 +685,8 @@ static void xc_debug_dump(struct xc5000_priv *priv)
 		(totalgain % 256) * 100 / 256);
 
 	if (priv->pll_register_no) {
-		xc5000_readreg(priv, priv->pll_register_no, &regval);
-		dprintk(1, "*** PLL lock status = 0x%04x\n", regval);
+		if (!xc5000_readreg(priv, priv->pll_register_no, &regval))
+			dprintk(1, "*** PLL lock status = 0x%04x\n", regval);
 	}
 }
 
@@ -831,15 +831,16 @@ static int xc5000_is_firmware_loaded(struct dvb_frontend *fe)
 	u16 id;
 
 	ret = xc5000_readreg(priv, XREG_PRODUCT_ID, &id);
-	if (ret == 0) {
+	if (!ret) {
 		if (id == XC_PRODUCT_ID_FW_NOT_LOADED)
 			ret = -ENOENT;
 		else
 			ret = 0;
+		dprintk(1, "%s() returns id = 0x%x\n", __func__, id);
+	} else {
+		dprintk(1, "%s() returns error %d\n", __func__, ret);
 	}
 
-	dprintk(1, "%s() returns %s id = 0x%x\n", __func__,
-		ret == 0 ? "True" : "False", id);
 	return ret;
 }
 
@@ -935,7 +936,10 @@ static int xc5000_set_tv_freq(struct dvb_frontend *fe)
 
 	if (priv->pll_register_no != 0) {
 		msleep(20);
-		xc5000_readreg(priv, priv->pll_register_no, &pll_lock_status);
+		ret = xc5000_readreg(priv, priv->pll_register_no,
+				     &pll_lock_status);
+		if (ret)
+			return ret;
 		if (pll_lock_status > 63) {
 			/* PLL is unlocked, force reload of the firmware */
 			dprintk(1, "xc5000: PLL not locked (0x%x).  Reloading...\n",
@@ -1190,8 +1194,10 @@ static int xc_load_fw_and_init_tuner(struct dvb_frontend *fe, int force)
 		}
 
 		if (priv->pll_register_no) {
-			xc5000_readreg(priv, priv->pll_register_no,
-				       &pll_lock_status);
+			ret = xc5000_readreg(priv, priv->pll_register_no,
+					     &pll_lock_status);
+			if (ret)
+				continue;
 			if (pll_lock_status > 63) {
 				/* PLL is unlocked, force reload of the firmware */
 				printk(KERN_ERR
-- 
2.13.6
