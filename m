Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3580 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaHTW7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 18:59:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 11/29] dib7000p: fix sparse warning
Date: Thu, 21 Aug 2014 00:59:10 +0200
Message-Id: <1408575568-20562-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/dvb-frontends/dib7000p.c:2562:5: warning: symbol 'dib7090_set_diversity_in' was not declared. Should it be static?

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb-frontends/dib7000p.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index 661760d..589134e 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -2559,7 +2559,7 @@ static void dib7090_setHostBusMux(struct dib7000p_state *state, int mode)
 	dib7000p_write_word(state, 1288, reg_1288);
 }
 
-int dib7090_set_diversity_in(struct dvb_frontend *fe, int onoff)
+static int dib7090_set_diversity_in(struct dvb_frontend *fe, int onoff)
 {
 	struct dib7000p_state *state = fe->demodulator_priv;
 	u16 reg_1287;
-- 
2.1.0.rc1

