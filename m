Return-path: <mchehab@pedra>
Received: from smtp.gentoo.org ([140.211.166.183]:57022 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab0KGOAQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Nov 2010 09:00:16 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH] IX2505V: i2c transfer error code ignored
Date: Sun, 7 Nov 2010 14:57:13 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_6Ar1May+vnJzvRC"
Message-Id: <201011071457.14929.zzam@gentoo.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_6Ar1May+vnJzvRC
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

Hello Malcolm!

It seems that ix2505v driver ignores a i2c error in ix2505v_read_status_reg.
This looks like a typing error using (ret = 1) instead of correct (ret == 1).

The attached patch fixes this.

Regards
Matthias

--Boundary-00=_6Ar1May+vnJzvRC
Content-Type: text/x-patch;
  charset="UTF-8";
  name="ix2505-error-code-ignored.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ix2505-error-code-ignored.patch"

diff --git a/drivers/media/dvb/frontends/ix2505v.c b/drivers/media/dvb/frontends/ix2505v.c
index 55f2eba..6360c68 100644
--- a/drivers/media/dvb/frontends/ix2505v.c
+++ b/drivers/media/dvb/frontends/ix2505v.c
@@ -72,7 +72,7 @@ static int ix2505v_read_status_reg(struct ix2505v_state *state)
 	ret = i2c_transfer(state->i2c, msg, 1);
 	deb_i2c("Read %s ", __func__);
 
-	return (ret = 1) ? (int) b2[0] : -1;
+	return (ret == 1) ? (int) b2[0] : -1;
 }
 
 static int ix2505v_write(struct ix2505v_state *state, u8 buf[], u8 count)

--Boundary-00=_6Ar1May+vnJzvRC--
