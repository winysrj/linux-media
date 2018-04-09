Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39630 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752422AbeDIMQ3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 08:16:29 -0400
In-Reply-To: <20180409121529.GA31403@n2100.armlinux.org.uk>
References: <20180409121529.GA31403@n2100.armlinux.org.uk>
From: Russell King <rmk+kernel@armlinux.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v3 3/7] drm/i2c: tda998x: move CEC device initialisation later
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1f5Vig-0002LV-Ju@rmk-PC.armlinux.org.uk>
Date: Mon, 09 Apr 2018 13:16:22 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We no longer use the CEC client to access the CEC part itself, so we can
move this later in the initialisation sequence.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 2a99930f1bda..7f2762fab5c9 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1489,9 +1489,6 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 	priv->cec_addr = 0x34 + (client->addr & 0x03);
 	priv->current_page = 0xff;
 	priv->hdmi = client;
-	priv->cec = i2c_new_dummy(client->adapter, priv->cec_addr);
-	if (!priv->cec)
-		return -ENODEV;
 
 	/* wake up the device: */
 	cec_write(priv, REG_CEC_ENAMODS,
@@ -1578,6 +1575,12 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 		cec_write(priv, REG_CEC_RXSHPDINTENA, CEC_RXSHPDLEV_HPD);
 	}
 
+	priv->cec = i2c_new_dummy(client->adapter, priv->cec_addr);
+	if (!priv->cec) {
+		ret = -ENODEV;
+		goto fail;
+	}
+
 	/* enable EDID read irq: */
 	reg_set(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
 
@@ -1594,14 +1597,14 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 
 	ret = tda998x_get_audio_ports(priv, np);
 	if (ret)
-		goto err_audio;
+		goto fail;
 
 	if (priv->audio_port[0].format != AFMT_UNUSED)
 		tda998x_audio_codec_init(priv, &client->dev);
 
 	return 0;
 
-err_audio:
+fail:
 	if (client->irq)
 		free_irq(client->irq, priv);
 err_irq:
-- 
2.7.4
