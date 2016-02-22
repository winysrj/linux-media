Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37575 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbcBVTJe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 14:09:34 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Patrick Boettcher <patrick.boettcher@posteo.de>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 5/9] [media] dib9000: read16/write16 could return an error code
Date: Mon, 22 Feb 2016 16:09:19 -0300
Message-Id: <e151c4d64bba4c070ee4e5e444b6683592b628c2.1456167652.git.mchehab@osg.samsung.com>
In-Reply-To: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
References: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
In-Reply-To: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
References: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Both dib9000_read16_attr and dib9000_write16_attr can return an
error code. However, they currently return an u16. This produces the
following warnings on smatch:

	drivers/media/dvb-frontends/dib9000.c:262 dib9000_read16_attr() warn: signedness bug returning '(-121)'
	drivers/media/dvb-frontends/dib9000.c:321 dib9000_write16_attr() warn: signedness bug returning '(-22)'
	drivers/media/dvb-frontends/dib9000.c:353 dib9000_write16_attr() warn: signedness bug returning '(-121)'

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/dib9000.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib9000.c b/drivers/media/dvb-frontends/dib9000.c
index bab8c5a980a2..9f8684f4dd1e 100644
--- a/drivers/media/dvb-frontends/dib9000.c
+++ b/drivers/media/dvb-frontends/dib9000.c
@@ -225,7 +225,7 @@ static u16 to_fw_output_mode(u16 mode)
 	}
 }
 
-static u16 dib9000_read16_attr(struct dib9000_state *state, u16 reg, u8 * b, u32 len, u16 attribute)
+static int dib9000_read16_attr(struct dib9000_state *state, u16 reg, u8 * b, u32 len, u16 attribute)
 {
 	u32 chunk_size = 126;
 	u32 l;
@@ -309,7 +309,7 @@ static inline u16 dib9000_read_word_attr(struct dib9000_state *state, u16 reg, u
 
 #define dib9000_read16_noinc_attr(state, reg, b, len, attribute) dib9000_read16_attr(state, reg, b, len, (attribute) | DATA_BUS_ACCESS_MODE_NO_ADDRESS_INCREMENT)
 
-static u16 dib9000_write16_attr(struct dib9000_state *state, u16 reg, const u8 * buf, u32 len, u16 attribute)
+static int dib9000_write16_attr(struct dib9000_state *state, u16 reg, const u8 * buf, u32 len, u16 attribute)
 {
 	u32 chunk_size = 126;
 	u32 l;
-- 
2.5.0

