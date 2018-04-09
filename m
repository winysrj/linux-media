Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39604 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752064AbeDIMQS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 08:16:18 -0400
In-Reply-To: <20180409121529.GA31403@n2100.armlinux.org.uk>
References: <20180409121529.GA31403@n2100.armlinux.org.uk>
From: Russell King <rmk+kernel@armlinux.org.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v3 1/7] drm/i2c: tda998x: move mutex/waitqueue/timer/work init
 early
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1f5ViW-0002LF-BQ@rmk-PC.armlinux.org.uk>
Date: Mon, 09 Apr 2018 13:16:12 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the mutex, waitqueue, timer and detect work initialisation early
in the driver's initialisation, rather than being after we've registered
the CEC device.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index cd3f0873bbdd..83407159e957 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1475,7 +1475,11 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 	u32 video;
 	int rev_lo, rev_hi, ret;
 
-	mutex_init(&priv->audio_mutex); /* Protect access from audio thread */
+	mutex_init(&priv->mutex);	/* protect the page access */
+	mutex_init(&priv->audio_mutex); /* protect access from audio thread */
+	init_waitqueue_head(&priv->edid_delay_waitq);
+	timer_setup(&priv->edid_delay_timer, tda998x_edid_delay_done, 0);
+	INIT_WORK(&priv->detect_work, tda998x_detect_work);
 
 	priv->vip_cntrl_0 = VIP_CNTRL_0_SWAP_A(2) | VIP_CNTRL_0_SWAP_B(3);
 	priv->vip_cntrl_1 = VIP_CNTRL_1_SWAP_C(0) | VIP_CNTRL_1_SWAP_D(1);
@@ -1489,11 +1493,6 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 	if (!priv->cec)
 		return -ENODEV;
 
-	mutex_init(&priv->mutex);	/* protect the page access */
-	init_waitqueue_head(&priv->edid_delay_waitq);
-	timer_setup(&priv->edid_delay_timer, tda998x_edid_delay_done, 0);
-	INIT_WORK(&priv->detect_work, tda998x_detect_work);
-
 	/* wake up the device: */
 	cec_write(priv, REG_CEC_ENAMODS,
 			CEC_ENAMODS_EN_RXSENS | CEC_ENAMODS_EN_HDMI);
-- 
2.7.4
