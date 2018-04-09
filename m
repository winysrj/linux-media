Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39618 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752334AbeDIMQY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 08:16:24 -0400
In-Reply-To: <20180409121529.GA31403@n2100.armlinux.org.uk>
References: <20180409121529.GA31403@n2100.armlinux.org.uk>
From: Russell King <rmk+kernel@armlinux.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v3 2/7] drm/i2c: tda998x: fix error cleanup paths
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1f5Vib-0002LO-Fv@rmk-PC.armlinux.org.uk>
Date: Mon, 09 Apr 2018 13:16:17 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If tda998x_get_audio_ports() fails, and we requested the interrupt, we
fail to free the interrupt before returning failure.  Rework the failure
cleanup code and exit paths so that we always clean up properly after an
error, and always propagate the error code.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 83407159e957..2a99930f1bda 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1501,10 +1501,15 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 
 	/* read version: */
 	rev_lo = reg_read(priv, REG_VERSION_LSB);
+	if (rev_lo < 0) {
+		dev_err(&client->dev, "failed to read version: %d\n", rev_lo);
+		return rev_lo;
+	}
+
 	rev_hi = reg_read(priv, REG_VERSION_MSB);
-	if (rev_lo < 0 || rev_hi < 0) {
-		ret = rev_lo < 0 ? rev_lo : rev_hi;
-		goto fail;
+	if (rev_hi < 0) {
+		dev_err(&client->dev, "failed to read version: %d\n", rev_hi);
+		return rev_hi;
 	}
 
 	priv->rev = rev_lo | rev_hi << 8;
@@ -1528,7 +1533,7 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 	default:
 		dev_err(&client->dev, "found unsupported device: %04x\n",
 			priv->rev);
-		goto fail;
+		return -ENXIO;
 	}
 
 	/* after reset, enable DDC: */
@@ -1566,7 +1571,7 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 			dev_err(&client->dev,
 				"failed to request IRQ#%u: %d\n",
 				client->irq, ret);
-			goto fail;
+			goto err_irq;
 		}
 
 		/* enable HPD irq */
@@ -1589,19 +1594,19 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 
 	ret = tda998x_get_audio_ports(priv, np);
 	if (ret)
-		goto fail;
+		goto err_audio;
 
 	if (priv->audio_port[0].format != AFMT_UNUSED)
 		tda998x_audio_codec_init(priv, &client->dev);
 
 	return 0;
-fail:
-	/* if encoder_init fails, the encoder slave is never registered,
-	 * so cleanup here:
-	 */
-	if (priv->cec)
-		i2c_unregister_device(priv->cec);
-	return -ENXIO;
+
+err_audio:
+	if (client->irq)
+		free_irq(client->irq, priv);
+err_irq:
+	i2c_unregister_device(priv->cec);
+	return ret;
 }
 
 static void tda998x_encoder_prepare(struct drm_encoder *encoder)
-- 
2.7.4
