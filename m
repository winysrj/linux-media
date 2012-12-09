Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36973 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758887Ab2LIT5N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 14:57:13 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 16/17] af9033: update fc2580 init sequence
Date: Sun,  9 Dec 2012 21:56:27 +0200
Message-Id: <1355082988-6211-16-git-send-email-crope@iki.fi>
In-Reply-To: <1355082988-6211-1-git-send-email-crope@iki.fi>
References: <1355082988-6211-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033_priv.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
index 1fb84a2..e9bd782 100644
--- a/drivers/media/dvb-frontends/af9033_priv.h
+++ b/drivers/media/dvb-frontends/af9033_priv.h
@@ -525,11 +525,12 @@ static const struct reg_val tuner_init_fc2580[] = {
 	{ 0x800095, 0x00 },
 	{ 0x800096, 0x05 },
 	{ 0x8000b3, 0x01 },
-	{ 0x8000c3, 0x01 },
-	{ 0x8000c4, 0x00 },
+	{ 0x8000c5, 0x01 },
+	{ 0x8000c6, 0x00 },
+	{ 0x8000d1, 0x01 },
 	{ 0x80f007, 0x00 },
 	{ 0x80f00c, 0x19 },
-	{ 0x80f00d, 0x1A },
+	{ 0x80f00d, 0x1a },
 	{ 0x80f00e, 0x00 },
 	{ 0x80f00f, 0x02 },
 	{ 0x80f010, 0x00 },
-- 
1.7.11.7

