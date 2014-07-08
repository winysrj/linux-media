Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60154 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbaGHFx1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jul 2014 01:53:27 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/4] tda10071: add missing DVB-S2/PSK-8 FEC AUTO
Date: Tue,  8 Jul 2014 08:53:04 +0300
Message-Id: <1404798786-28361-2-git-send-email-crope@iki.fi>
In-Reply-To: <1404798786-28361-1-git-send-email-crope@iki.fi>
References: <1404798786-28361-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FEC AUTO is valid for PSK-8 modulation too. Add it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/tda10071_priv.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/tda10071_priv.h b/drivers/media/dvb-frontends/tda10071_priv.h
index 4baf14b..4204861 100644
--- a/drivers/media/dvb-frontends/tda10071_priv.h
+++ b/drivers/media/dvb-frontends/tda10071_priv.h
@@ -55,6 +55,7 @@ static struct tda10071_modcod {
 	{ SYS_DVBS2, QPSK,  FEC_8_9,  0x0a },
 	{ SYS_DVBS2, QPSK,  FEC_9_10, 0x0b },
 	/* 8PSK */
+	{ SYS_DVBS2, PSK_8, FEC_AUTO, 0x00 },
 	{ SYS_DVBS2, PSK_8, FEC_3_5,  0x0c },
 	{ SYS_DVBS2, PSK_8, FEC_2_3,  0x0d },
 	{ SYS_DVBS2, PSK_8, FEC_3_4,  0x0e },
-- 
1.9.3

