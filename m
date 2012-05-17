Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34757 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030224Ab2EQWea (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 18:34:30 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Oliver Endriss <o.endriss@gmx.de>,
	Ralph Metzler <rjkm@metzlerbros.de>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] drxk: fix GPIOs
Date: Fri, 18 May 2012 01:34:10 +0300
Message-Id: <1337294051-20363-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

UIO-2 and UIO-3 were broken.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb/frontends/drxk_hard.c |    4 ++--
 drivers/media/dvb/frontends/drxk_map.h  |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 8d99ac1..60b868f 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -5835,7 +5835,7 @@ static int WriteGPIO(struct drxk_state *state)
 		}
 		if (state->UIO_mask & 0x0002) { /* UIO-2 */
 			/* write to io pad configuration register - output mode */
-			status = write16(state, SIO_PDR_SMA_TX_CFG__A, state->m_GPIOCfg);
+			status = write16(state, SIO_PDR_SMA_RX_CFG__A, state->m_GPIOCfg);
 			if (status < 0)
 				goto error;
 
@@ -5854,7 +5854,7 @@ static int WriteGPIO(struct drxk_state *state)
 		}
 		if (state->UIO_mask & 0x0004) { /* UIO-3 */
 			/* write to io pad configuration register - output mode */
-			status = write16(state, SIO_PDR_SMA_TX_CFG__A, state->m_GPIOCfg);
+			status = write16(state, SIO_PDR_GPIO_CFG__A, state->m_GPIOCfg);
 			if (status < 0)
 				goto error;
 
diff --git a/drivers/media/dvb/frontends/drxk_map.h b/drivers/media/dvb/frontends/drxk_map.h
index 9b11a83..23e16c1 100644
--- a/drivers/media/dvb/frontends/drxk_map.h
+++ b/drivers/media/dvb/frontends/drxk_map.h
@@ -432,6 +432,7 @@
 #define  SIO_PDR_UIO_OUT_LO__A                                             0x7F0016
 #define  SIO_PDR_OHW_CFG__A                                                0x7F001F
 #define    SIO_PDR_OHW_CFG_FREF_SEL__M                                     0x3
+#define  SIO_PDR_GPIO_CFG__A                                               0x7F0021
 #define  SIO_PDR_MSTRT_CFG__A                                              0x7F0025
 #define  SIO_PDR_MERR_CFG__A                                               0x7F0026
 #define  SIO_PDR_MCLK_CFG__A                                               0x7F0028
@@ -446,4 +447,5 @@
 #define  SIO_PDR_MD5_CFG__A                                                0x7F0030
 #define  SIO_PDR_MD6_CFG__A                                                0x7F0031
 #define  SIO_PDR_MD7_CFG__A                                                0x7F0032
+#define  SIO_PDR_SMA_RX_CFG__A                                             0x7F0037
 #define  SIO_PDR_SMA_TX_CFG__A                                             0x7F0038
-- 
1.7.7.6

