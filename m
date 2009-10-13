Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.renesas.com ([202.234.163.13]:33998 "EHLO
	mail02.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754576AbZJMFuG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 01:50:06 -0400
Date: Tue, 13 Oct 2009 14:49:24 +0900
From: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Subject: [PATCH 2/5] soc-camera: tw9910: Add output signal control
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-id: <ufx9nkfmj.wl%morimoto.kuninori@renesas.com>
MIME-version: 1.0 (generated by SEMI 1.14.6 - "Maruoka")
Content-type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tw9910 can control output signal.
This patch will stop all signal when video was stopped.

Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
---
 drivers/media/video/tw9910.c |   35 ++++++++++++++++++++++++-----------
 1 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 5152d56..8bda689 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -152,7 +152,8 @@
 			 /* 1 : non-auto */
 #define VSCTL       0x08 /* 1 : Vertical out ctrl by DVALID */
 			 /* 0 : Vertical out ctrl by HACTIVE and DVALID */
-#define OEN         0x04 /* Output Enable together with TRI_SEL. */
+#define OEN         0x00 /* Enable output */
+#define EN_TRI_SEL  0x04 /* TRI_SEL output */
 
 /* OUTCTR1 */
 #define VSP_LO      0x00 /* 0 : VS pin output polarity is active low */
@@ -236,7 +237,6 @@ struct tw9910_priv {
 
 static const struct regval_list tw9910_default_regs[] =
 {
-	{ OPFORM,  0x00 },
 	{ OUTCTR1, VSP_LO | VSSL_VVALID | HSP_HI | HSSL_HSYNC },
 	ENDMARKER,
 };
@@ -513,19 +513,32 @@ static int tw9910_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct i2c_client *client = sd->priv;
 	struct tw9910_priv *priv = to_tw9910(client);
+	u8 val;
 
-	if (!enable)
+	if (!enable) {
+		switch (priv->rev) {
+		case 0:
+			val = EN_TRI_SEL | 0x2;
+			break;
+		case 1:
+			val = EN_TRI_SEL | 0x3;
+			break;
+		}
 		return 0;
+	} else {
 
-	if (!priv->scale) {
-		dev_err(&client->dev, "norm select error\n");
-		return -EPERM;
+		if (!priv->scale) {
+			dev_err(&client->dev, "norm select error\n");
+			return -EPERM;
+		}
+
+		dev_dbg(&client->dev, "%s %dx%d\n",
+			priv->scale->name,
+			priv->scale->width,
+			priv->scale->height);
 	}
 
-	dev_dbg(&client->dev, "%s %dx%d\n",
-		 priv->scale->name,
-		 priv->scale->width,
-		 priv->scale->height);
+	tw9910_mask_set(client, OPFORM, 0x7, val);
 
 	return 0;
 }
-- 
1.6.0.4

