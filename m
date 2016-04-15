Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:49209 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbcDOPfp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 11:35:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/3] dib0090: fix smatch error
Date: Fri, 15 Apr 2016 17:35:33 +0200
Message-Id: <1460734533-34191-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1460734533-34191-1-git-send-email-hverkuil@xs4all.nl>
References: <1460734533-34191-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fix this smatch error:

dib0090.c:1124 dib0090_pwm_gain_reset() error: we previously assumed 'state->rf_ramp' could be null (see line 1086)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/dvb-frontends/dib0090.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
index dc2d41e..d879dc0 100644
--- a/drivers/media/dvb-frontends/dib0090.c
+++ b/drivers/media/dvb-frontends/dib0090.c
@@ -1121,7 +1121,7 @@ void dib0090_pwm_gain_reset(struct dvb_frontend *fe)
 				(state->current_band == BAND_CBAND) ? "CBAND" : "NOT CBAND",
 				state->identity.version & 0x1f);
 
-		if (rf_ramp && ((state->rf_ramp[0] == 0) ||
+		if (rf_ramp && ((state->rf_ramp && state->rf_ramp[0] == 0) ||
 		    (state->current_band == BAND_CBAND &&
 		    (state->identity.version & 0x1f) <= P1D_E_F))) {
 			dprintk("DE-Engage mux for direct gain reg control");
-- 
2.8.0.rc3

