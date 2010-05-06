Return-path: <linux-media-owner@vger.kernel.org>
Received: from 25.mail-out.ovh.net ([91.121.27.228]:40413 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757821Ab0EFMHF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 May 2010 08:07:05 -0400
Message-ID: <274b73596d167cb0762196603a4e481d.squirrel@webmail.ovh.net>
Date: Thu, 6 May 2010 07:07:04 -0500 (GMT+5)
Subject: [PATCH] tda10048: clear the uncorrected packet registers when
     saturated
From: "Guillaume Audirac" <guillaume.audirac@webag.fr>
To: linux-media@vger.kernel.org
Reply-To: guillaume.audirac@webag.fr
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,


Use the register CLUNC to reset the CPTU registers (LSB & MSB) when they
saturate at 0xFFFF. Fixes as well a few register typos.

Signed-off-by: Guillaume Audirac <guillaume.audirac@webag.fr>
---
 drivers/media/dvb/frontends/tda10048.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda10048.c
b/drivers/media/dvb/frontends/tda10048.c
index 9a0ba30..93f6a75 100644
--- a/drivers/media/dvb/frontends/tda10048.c
+++ b/drivers/media/dvb/frontends/tda10048.c
@@ -50,8 +50,8 @@
 #define TDA10048_CONF_C4_1         0x1E
 #define TDA10048_CONF_C4_2         0x1F
 #define TDA10048_CODE_IN_RAM       0x20
-#define TDA10048_CHANNEL_INFO_1_R  0x22
-#define TDA10048_CHANNEL_INFO_2_R  0x23
+#define TDA10048_CHANNEL_INFO1_R   0x22
+#define TDA10048_CHANNEL_INFO2_R   0x23
 #define TDA10048_CHANNEL_INFO1     0x24
 #define TDA10048_CHANNEL_INFO2     0x25
 #define TDA10048_TIME_ERROR_R      0x26
@@ -64,8 +64,8 @@
 #define TDA10048_IT_STAT           0x32
 #define TDA10048_DSP_AD_LSB        0x3C
 #define TDA10048_DSP_AD_MSB        0x3D
-#define TDA10048_DSP_REF_LSB       0x3E
-#define TDA10048_DSP_REF_MSB       0x3F
+#define TDA10048_DSP_REG_LSB       0x3E
+#define TDA10048_DSP_REG_MSB       0x3F
 #define TDA10048_CONF_TRISTATE1    0x44
 #define TDA10048_CONF_TRISTATE2    0x45
 #define TDA10048_CONF_POLARITY     0x46
@@ -1033,6 +1033,9 @@ static int tda10048_read_ucblocks(struct
dvb_frontend *fe, u32 *ucblocks)

 	*ucblocks = tda10048_readreg(state, TDA10048_UNCOR_CPT_MSB) << 8 |
 		tda10048_readreg(state, TDA10048_UNCOR_CPT_LSB);
+	/* clear the uncorrected TS packets counter when saturated */
+	if (*ucblocks == 0xFFFF)
+		tda10048_writereg(state, TDA10048_UNCOR_CTRL, 0x80);

 	return 0;
 }
-- 
1.6.3.3

-- 
Guillaume

