Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:34503 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754395Ab2B0UmY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Feb 2012 15:42:24 -0500
Message-ID: <4F4BEAAB.3000603@gmx.de>
Date: Mon, 27 Feb 2012 21:42:19 +0100
From: Andreas Regel <andreas.regel@gmx.de>
MIME-Version: 1.0
To: abraham.manu@gmail.com
CC: linux-media@vger.kernel.org
Subject: [PATCH 1/3] stv090x: Fix typo in register macros
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix typo in register macros of ERRCNT2.

Signed-off-by: Andreas Regel <andreas.regel@gmx.de>
---
  drivers/media/dvb/frontends/stv090x.c     |    2 +-
  drivers/media/dvb/frontends/stv090x_reg.h |    4 ++--
  2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv090x.c 
b/drivers/media/dvb/frontends/stv090x.c
index 4aef187..6c3c095 100644
--- a/drivers/media/dvb/frontends/stv090x.c
+++ b/drivers/media/dvb/frontends/stv090x.c
@@ -3526,7 +3526,7 @@ static int stv090x_read_per(struct dvb_frontend 
*fe, u32 *per)
  	} else {
  		/* Counter 2 */
  		reg = STV090x_READ_DEMOD(state, ERRCNT22);
-		h = STV090x_GETFIELD_Px(reg, ERR_CNT2_FIELD);
+		h = STV090x_GETFIELD_Px(reg, ERR_CNT22_FIELD);
   		reg = STV090x_READ_DEMOD(state, ERRCNT21);
  		m = STV090x_GETFIELD_Px(reg, ERR_CNT21_FIELD);
diff --git a/drivers/media/dvb/frontends/stv090x_reg.h 
b/drivers/media/dvb/frontends/stv090x_reg.h
index 93741ee..26c8885 100644
--- a/drivers/media/dvb/frontends/stv090x_reg.h
+++ b/drivers/media/dvb/frontends/stv090x_reg.h
@@ -2232,8 +2232,8 @@
  #define STV090x_P2_ERRCNT22				STV090x_Px_ERRCNT22(2)
  #define STV090x_OFFST_Px_ERRCNT2_OLDVALUE_FIELD		7
  #define STV090x_WIDTH_Px_ERRCNT2_OLDVALUE_FIELD		1
-#define STV090x_OFFST_Px_ERR_CNT2_FIELD			0
-#define STV090x_WIDTH_Px_ERR_CNT2_FIELD			7
+#define STV090x_OFFST_Px_ERR_CNT22_FIELD		0
+#define STV090x_WIDTH_Px_ERR_CNT22_FIELD		7
   #define STV090x_Px_ERRCNT21(__x)			(0xF59E - (__x - 1) * 0x200)
  #define STV090x_P1_ERRCNT21				STV090x_Px_ERRCNT21(1)
-- 
1.7.2.5

