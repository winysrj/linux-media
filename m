Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:34332 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab2GTLMd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 07:12:33 -0400
Date: Fri, 20 Jul 2012 14:11:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Patrick Boettcher <patrick.boettcher@dibcom.fr>,
	Olivier Grenie <olivier.grenie@dibcom.fr>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] dib8000: move dereference after check for NULL
Message-ID: <20120720111157.GA22245@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My static checker complains that we dereference "state" inside the call
to fft_to_mode() before checking for NULL.  The comments say that it is
possible for "state" to be NULL so I have moved the dereference after
the check.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb/frontends/dib8000.c b/drivers/media/dvb/frontends/dib8000.c
index 9ca34f4..1f3bcb5 100644
--- a/drivers/media/dvb/frontends/dib8000.c
+++ b/drivers/media/dvb/frontends/dib8000.c
@@ -2680,12 +2680,14 @@ static int dib8000_tune(struct dvb_frontend *fe)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 	int ret = 0;
-	u16 lock, value, mode = fft_to_mode(state);
+	u16 lock, value, mode;
 
 	// we are already tuned - just resuming from suspend
 	if (state == NULL)
 		return -EINVAL;
 
+	mode = fft_to_mode(state);
+
 	dib8000_set_bandwidth(fe, state->fe[0]->dtv_property_cache.bandwidth_hz / 1000);
 	dib8000_set_channel(state, 0, 0);
 
