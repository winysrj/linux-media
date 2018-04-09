Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39642 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752432AbeDIMQf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 08:16:35 -0400
In-Reply-To: <20180409121529.GA31403@n2100.armlinux.org.uk>
References: <20180409121529.GA31403@n2100.armlinux.org.uk>
From: Russell King <rmk+kernel@armlinux.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v3 4/7] drm/i2c: tda998x: always disable and clear interrupts
 at probe
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1f5Vil-0002Lc-OH@rmk-PC.armlinux.org.uk>
Date: Mon, 09 Apr 2018 13:16:27 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Always disable and clear interrupts at probe time to ensure that the
TDA998x is in a sane state.  This ensures that the interrupt line,
which is also the CEC clock calibration signal, is always deasserted.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 7f2762fab5c9..16e0439cad44 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1546,6 +1546,15 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 	cec_write(priv, REG_CEC_FRO_IM_CLK_CTRL,
 			CEC_FRO_IM_CLK_CTRL_GHOST_DIS | CEC_FRO_IM_CLK_CTRL_IMCLK_SEL);
 
+	/* ensure interrupts are disabled */
+	cec_write(priv, REG_CEC_RXSHPDINTENA, 0);
+
+	/* clear pending interrupts */
+	cec_read(priv, REG_CEC_RXSHPDINT);
+	reg_read(priv, REG_INT_FLAGS_0);
+	reg_read(priv, REG_INT_FLAGS_1);
+	reg_read(priv, REG_INT_FLAGS_2);
+
 	/* initialize the optional IRQ */
 	if (client->irq) {
 		unsigned long irq_flags;
@@ -1553,11 +1562,6 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 		/* init read EDID waitqueue and HDP work */
 		init_waitqueue_head(&priv->wq_edid);
 
-		/* clear pending interrupts */
-		reg_read(priv, REG_INT_FLAGS_0);
-		reg_read(priv, REG_INT_FLAGS_1);
-		reg_read(priv, REG_INT_FLAGS_2);
-
 		irq_flags =
 			irqd_get_trigger_type(irq_get_irq_data(client->irq));
 		irq_flags |= IRQF_SHARED | IRQF_ONESHOT;
-- 
2.7.4
