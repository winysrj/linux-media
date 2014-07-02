Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35723 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbaGBPwe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jul 2014 11:52:34 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC 6/9] dib8000: Restart sad during dib8000_reset
Date: Wed,  2 Jul 2014 12:52:20 -0300
Message-Id: <1404316343-23856-7-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1404316343-23856-1-git-send-email-m.chehab@samsung.com>
References: <1404316343-23856-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just like the Windows driver, restart SAD during reset

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 4ecf1a6181cc..f657cb510bd1 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -1050,6 +1050,7 @@ static int dib8000_reset(struct dvb_frontend *fe)
 	dib8000_write_word(state, 770, 0xffff);
 	dib8000_write_word(state, 771, 0xffff);
 	dib8000_write_word(state, 772, 0xfffc);
+	dib8000_write_word(state, 898, 0x000c);	/* restart sad */
 	if (state->revision == 0x8090)
 		dib8000_write_word(state, 1280, 0x0045);
 	else
-- 
1.9.3

