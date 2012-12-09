Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51137 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758883Ab2LIT5M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 14:57:12 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 14/17] af9033: update tua9001 init sequence
Date: Sun,  9 Dec 2012 21:56:25 +0200
Message-Id: <1355082988-6211-14-git-send-email-crope@iki.fi>
In-Reply-To: <1355082988-6211-1-git-send-email-crope@iki.fi>
References: <1355082988-6211-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033_priv.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
index d96d128..e0be040 100644
--- a/drivers/media/dvb-frontends/af9033_priv.h
+++ b/drivers/media/dvb-frontends/af9033_priv.h
@@ -321,8 +321,9 @@ static const struct reg_val tuner_init_tua9001[] = {
 	{ 0x80009b, 0x05 },
 	{ 0x80009c, 0x80 },
 	{ 0x8000b3, 0x00 },
-	{ 0x8000c1, 0x01 },
-	{ 0x8000c2, 0x00 },
+	{ 0x8000c5, 0x01 },
+	{ 0x8000c6, 0x00 },
+	{ 0x8000c9, 0x5d },
 	{ 0x80f007, 0x00 },
 	{ 0x80f01f, 0x82 },
 	{ 0x80f020, 0x00 },
-- 
1.7.11.7

