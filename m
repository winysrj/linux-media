Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33069 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758882Ab2LIT5M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 14:57:12 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 13/17] af9033: update demod init sequence
Date: Sun,  9 Dec 2012 21:56:24 +0200
Message-Id: <1355082988-6211-13-git-send-email-crope@iki.fi>
In-Reply-To: <1355082988-6211-1-git-send-email-crope@iki.fi>
References: <1355082988-6211-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033_priv.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033_priv.h b/drivers/media/dvb-frontends/af9033_priv.h
index 288cd45..d96d128 100644
--- a/drivers/media/dvb-frontends/af9033_priv.h
+++ b/drivers/media/dvb-frontends/af9033_priv.h
@@ -199,10 +199,9 @@ static const struct reg_val ofsm_init[] = {
 	{ 0x8000a6, 0x01 },
 	{ 0x8000a9, 0x00 },
 	{ 0x8000aa, 0x01 },
-	{ 0x8000ab, 0x01 },
 	{ 0x8000b0, 0x01 },
-	{ 0x8000c0, 0x05 },
-	{ 0x8000c4, 0x19 },
+	{ 0x8000c4, 0x05 },
+	{ 0x8000c8, 0x19 },
 	{ 0x80f000, 0x0f },
 	{ 0x80f016, 0x10 },
 	{ 0x80f017, 0x04 },
-- 
1.7.11.7

