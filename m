Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39571 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104AbaGDRPz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jul 2014 13:15:55 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [[PATCH v2] 06/14] dib8000: In auto-search, try first with partial reception enabled
Date: Fri,  4 Jul 2014 14:15:32 -0300
Message-Id: <1404494140-17777-7-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
References: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TV broadcasters generally use partial reception. So, enable it by
default in auto-search mode. The driver will latter detect if the
transmission is on some other mode.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 5943495068a6..c81808d9b4d5 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -2352,6 +2352,9 @@ static void dib8000_set_isdbt_common_channel(struct dib8000_state *state, u8 seq
 	int init_prbs;
 	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
 
+	if (autosearching)
+		c->isdbt_partial_reception = 1;
+
 	/* P_mode */
 	dib8000_write_word(state, 10, (seq << 4));
 
-- 
1.9.3

