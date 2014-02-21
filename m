Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24504 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbaBUIuW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Feb 2014 03:50:22 -0500
Date: Fri, 21 Feb 2014 11:50:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>,
	kernel-janitors@vger.kernel.org
Subject: [patch v2] [media] stv090x: remove indent levels in
 stv090x_get_coldlock()
Message-ID: <20140221085001.GA13078@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5305D7D5.8080906@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This code is needlessly complicated and checkpatch.pl complains that we
go over the 80 characters per line limit.

If we flip the "if (!lock) {" test to "if (lock) return;" then we can
remove an indent level from the rest of the function.

We can add two returns in the "if (state->srate >= 10000000) {"
condition and move the else statement back an additional indent level.

There is another "if (!lock) {" check which can be removed since we have
already checked "lock" and know it is zero at this point.  This second
check on "lock" is also a problem because it sets off a static checker
warning.  I have reviewed this code for some time to see if something
else was intended, but have concluded that it was simply an oversight
and should be removed.  Removing this duplicative check gains us an
third indent level.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: add the returns in the "if (state->srate >= 10000000) {" condition.

diff --git a/drivers/media/dvb-frontends/stv090x.c b/drivers/media/dvb-frontends/stv090x.c
index 23e872f84742..93f4979ea6e9 100644
--- a/drivers/media/dvb-frontends/stv090x.c
+++ b/drivers/media/dvb-frontends/stv090x.c
@@ -2146,7 +2146,7 @@ static int stv090x_get_coldlock(struct stv090x_state *state, s32 timeout_dmd)
 
 	u32 reg;
 	s32 car_step, steps, cur_step, dir, freq, timeout_lock;
-	int lock = 0;
+	int lock;
 
 	if (state->srate >= 10000000)
 		timeout_lock = timeout_dmd / 3;
@@ -2154,98 +2154,96 @@ static int stv090x_get_coldlock(struct stv090x_state *state, s32 timeout_dmd)
 		timeout_lock = timeout_dmd / 2;
 
 	lock = stv090x_get_dmdlock(state, timeout_lock); /* cold start wait */
-	if (!lock) {
-		if (state->srate >= 10000000) {
-			if (stv090x_chk_tmg(state)) {
-				if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x1f) < 0)
-					goto err;
-				if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x15) < 0)
-					goto err;
-				lock = stv090x_get_dmdlock(state, timeout_dmd);
-			} else {
-				lock = 0;
-			}
-		} else {
-			if (state->srate <= 4000000)
-				car_step = 1000;
-			else if (state->srate <= 7000000)
-				car_step = 2000;
-			else if (state->srate <= 10000000)
-				car_step = 3000;
-			else
-				car_step = 5000;
-
-			steps  = (state->search_range / 1000) / car_step;
-			steps /= 2;
-			steps  = 2 * (steps + 1);
-			if (steps < 0)
-				steps = 2;
-			else if (steps > 12)
-				steps = 12;
-
-			cur_step = 1;
-			dir = 1;
-
-			if (!lock) {
-				freq = state->frequency;
-				state->tuner_bw = stv090x_car_width(state->srate, state->rolloff) + state->srate;
-				while ((cur_step <= steps) && (!lock)) {
-					if (dir > 0)
-						freq += cur_step * car_step;
-					else
-						freq -= cur_step * car_step;
-
-					/* Setup tuner */
-					if (stv090x_i2c_gate_ctrl(state, 1) < 0)
-						goto err;
+	if (lock)
+		return lock;
 
-					if (state->config->tuner_set_frequency) {
-						if (state->config->tuner_set_frequency(fe, freq) < 0)
-							goto err_gateoff;
-					}
+	if (state->srate >= 10000000) {
+		if (stv090x_chk_tmg(state)) {
+			if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x1f) < 0)
+				goto err;
+			if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x15) < 0)
+				goto err;
+			return stv090x_get_dmdlock(state, timeout_dmd);
+		}
+		return 0;
+	}
 
-					if (state->config->tuner_set_bandwidth) {
-						if (state->config->tuner_set_bandwidth(fe, state->tuner_bw) < 0)
-							goto err_gateoff;
-					}
+	if (state->srate <= 4000000)
+		car_step = 1000;
+	else if (state->srate <= 7000000)
+		car_step = 2000;
+	else if (state->srate <= 10000000)
+		car_step = 3000;
+	else
+		car_step = 5000;
 
-					if (stv090x_i2c_gate_ctrl(state, 0) < 0)
-						goto err;
+	steps  = (state->search_range / 1000) / car_step;
+	steps /= 2;
+	steps  = 2 * (steps + 1);
+	if (steps < 0)
+		steps = 2;
+	else if (steps > 12)
+		steps = 12;
 
-					msleep(50);
+	cur_step = 1;
+	dir = 1;
 
-					if (stv090x_i2c_gate_ctrl(state, 1) < 0)
-						goto err;
+	freq = state->frequency;
+	state->tuner_bw = stv090x_car_width(state->srate, state->rolloff) + state->srate;
+	while ((cur_step <= steps) && (!lock)) {
+		if (dir > 0)
+			freq += cur_step * car_step;
+		else
+			freq -= cur_step * car_step;
 
-					if (state->config->tuner_get_status) {
-						if (state->config->tuner_get_status(fe, &reg) < 0)
-							goto err_gateoff;
-					}
+		/* Setup tuner */
+		if (stv090x_i2c_gate_ctrl(state, 1) < 0)
+			goto err;
 
-					if (reg)
-						dprintk(FE_DEBUG, 1, "Tuner phase locked");
-					else
-						dprintk(FE_DEBUG, 1, "Tuner unlocked");
+		if (state->config->tuner_set_frequency) {
+			if (state->config->tuner_set_frequency(fe, freq) < 0)
+				goto err_gateoff;
+		}
 
-					if (stv090x_i2c_gate_ctrl(state, 0) < 0)
-						goto err;
+		if (state->config->tuner_set_bandwidth) {
+			if (state->config->tuner_set_bandwidth(fe, state->tuner_bw) < 0)
+				goto err_gateoff;
+		}
 
-					STV090x_WRITE_DEMOD(state, DMDISTATE, 0x1c);
-					if (STV090x_WRITE_DEMOD(state, CFRINIT1, 0x00) < 0)
-						goto err;
-					if (STV090x_WRITE_DEMOD(state, CFRINIT0, 0x00) < 0)
-						goto err;
-					if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x1f) < 0)
-						goto err;
-					if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x15) < 0)
-						goto err;
-					lock = stv090x_get_dmdlock(state, (timeout_dmd / 3));
+		if (stv090x_i2c_gate_ctrl(state, 0) < 0)
+			goto err;
 
-					dir *= -1;
-					cur_step++;
-				}
-			}
+		msleep(50);
+
+		if (stv090x_i2c_gate_ctrl(state, 1) < 0)
+			goto err;
+
+		if (state->config->tuner_get_status) {
+			if (state->config->tuner_get_status(fe, &reg) < 0)
+				goto err_gateoff;
 		}
+
+		if (reg)
+			dprintk(FE_DEBUG, 1, "Tuner phase locked");
+		else
+			dprintk(FE_DEBUG, 1, "Tuner unlocked");
+
+		if (stv090x_i2c_gate_ctrl(state, 0) < 0)
+			goto err;
+
+		STV090x_WRITE_DEMOD(state, DMDISTATE, 0x1c);
+		if (STV090x_WRITE_DEMOD(state, CFRINIT1, 0x00) < 0)
+			goto err;
+		if (STV090x_WRITE_DEMOD(state, CFRINIT0, 0x00) < 0)
+			goto err;
+		if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x1f) < 0)
+			goto err;
+		if (STV090x_WRITE_DEMOD(state, DMDISTATE, 0x15) < 0)
+			goto err;
+		lock = stv090x_get_dmdlock(state, (timeout_dmd / 3));
+
+		dir *= -1;
+		cur_step++;
 	}
 
 	return lock;
