Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35715 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060AbaGBPwd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jul 2014 11:52:33 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC 4/9] dib8000: remove a double call for dib8000_get_symbol_duration()
Date: Wed,  2 Jul 2014 12:52:18 -0300
Message-Id: <1404316343-23856-5-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1404316343-23856-1-git-send-email-m.chehab@samsung.com>
References: <1404316343-23856-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The symbol duration was already obtained at CT_DEMOD_START.
No need to do it again at CT_DEMOD_STEP_3.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 273e7a9d78a2..3de8934a5b3d 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -3155,7 +3155,6 @@ static int dib8000_tune(struct dvb_frontend *fe)
 		break;
 
 	case CT_DEMOD_STEP_3: /* 33 */
-		state->symbol_duration = dib8000_get_symbol_duration(state);
 		dib8000_set_isdbt_loop_params(state, LOOP_TUNE_1);
 		dib8000_set_isdbt_common_channel(state, 0, 0);/* setting the known channel parameters here */
 		*tune_state = CT_DEMOD_STEP_4;
-- 
1.9.3

