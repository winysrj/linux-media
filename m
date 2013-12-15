Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33577 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab3LOODV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Dec 2013 09:03:21 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Olivier GRENIE <olivier.grenie@parrot.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	stable@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 1/3] [media] dib8000: fix regression with dib807x
Date: Sun, 15 Dec 2013 09:00:08 -0200
Message-Id: <1387105210-6893-2-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1387105210-6893-1-git-send-email-m.chehab@samsung.com>
References: <1387105210-6893-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Olivier Grenie <olivier.grenie@parrot.com>

Commit 173a64cb3fcf broke support for some dib807x versions.

Fix it by providing backward compatibility with the older versions.

[mkrufky@linuxtv.org: conflict handling and CodingStyle fixes]
Signed-off-by: Olivier Grenie <olivier.grenie@parrot.com>
Cc: stable@vger.kernel.org

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 6dbbee453ee1..1e03961135ac 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -2445,7 +2445,8 @@ static int dib8000_autosearch_start(struct dvb_frontend *fe)
 	if (state->revision == 0x8090)
 		internal = dib8000_read32(state, 23) / 1000;
 
-	if (state->autosearch_state == AS_SEARCHING_FFT) {
+	if ((state->revision >= 0x8002) &&
+	    (state->autosearch_state == AS_SEARCHING_FFT)) {
 		dib8000_write_word(state,  37, 0x0065); /* P_ctrl_pha_off_max default values */
 		dib8000_write_word(state, 116, 0x0000); /* P_ana_gain to 0 */
 
@@ -2481,7 +2482,8 @@ static int dib8000_autosearch_start(struct dvb_frontend *fe)
 		dib8000_write_word(state, 770, (dib8000_read_word(state, 770) & 0xdfff) | (1 << 13)); /* P_restart_ccg = 1 */
 		dib8000_write_word(state, 770, (dib8000_read_word(state, 770) & 0xdfff) | (0 << 13)); /* P_restart_ccg = 0 */
 		dib8000_write_word(state, 0, (dib8000_read_word(state, 0) & 0x7ff) | (0 << 15) | (1 << 13)); /* P_restart_search = 0; */
-	} else if (state->autosearch_state == AS_SEARCHING_GUARD) {
+	} else if ((state->revision >= 0x8002) &&
+		   (state->autosearch_state == AS_SEARCHING_GUARD)) {
 		c->transmission_mode = TRANSMISSION_MODE_8K;
 		c->guard_interval = GUARD_INTERVAL_1_8;
 		c->inversion = 0;
@@ -2583,7 +2585,8 @@ static int dib8000_autosearch_irq(struct dvb_frontend *fe)
 	struct dib8000_state *state = fe->demodulator_priv;
 	u16 irq_pending = dib8000_read_word(state, 1284);
 
-	if (state->autosearch_state == AS_SEARCHING_FFT) {
+	if ((state->revision >= 0x8002) &&
+	    (state->autosearch_state == AS_SEARCHING_FFT)) {
 		if (irq_pending & 0x1) {
 			dprintk("dib8000_autosearch_irq: max correlation result available");
 			return 3;
-- 
1.8.3.1

