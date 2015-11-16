Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44893 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbbKPKVX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 05:21:23 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 14/16] stb6100: get rid of get_state()/set_state()
Date: Mon, 16 Nov 2015 08:21:11 -0200
Message-Id: <d72f9dc7938f42bcce7cbc784f276cbb61bb8501.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
In-Reply-To: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
References: <838f46d5554501921ca2d809691437118e59dd14.1447668702.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is tricky to get rid of those ops here, as the stv0299 driver
wants to set frequency in separate from setting the bandwidth.

So, we use a small trick: we temporarely fill the cache with
0 for either frequency or bandwidth and add some logic at
set_params to only change the property(ies) that aren't zero.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-frontends/stb6100.c      | 46 +++++++-----------------------
 drivers/media/dvb-frontends/stb6100_cfg.h  | 37 +++++++++++++-----------
 drivers/media/dvb-frontends/stb6100_proc.h | 43 +++++++++++++++-------------
 3 files changed, 54 insertions(+), 72 deletions(-)

diff --git a/drivers/media/dvb-frontends/stb6100.c b/drivers/media/dvb-frontends/stb6100.c
index 5d8dbde03249..c978c801c7aa 100644
--- a/drivers/media/dvb-frontends/stb6100.c
+++ b/drivers/media/dvb-frontends/stb6100.c
@@ -502,49 +502,22 @@ static int stb6100_init(struct dvb_frontend *fe)
 	 * iqsense = 1
 	 * tunerstep = 125000
 	 */
-	state->bandwidth	= 36000000;	/* Hz	*/
+	state->bandwidth        = 36000000;		/* Hz	*/
 	state->reference	= refclk / 1000;	/* kHz	*/
 
 	/* Set default bandwidth. Modified, PN 13-May-10	*/
 	return 0;
 }
 
-static int stb6100_get_state(struct dvb_frontend *fe,
-			     enum tuner_param param,
-			     struct tuner_state *state)
+static int stb6100_set_params(struct dvb_frontend *fe)
 {
-	switch (param) {
-	case DVBFE_TUNER_FREQUENCY:
-		stb6100_get_frequency(fe, &state->frequency);
-		break;
-	case DVBFE_TUNER_BANDWIDTH:
-		stb6100_get_bandwidth(fe, &state->bandwidth);
-		break;
-	default:
-		break;
-	}
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	return 0;
-}
+	if (c->frequency > 0)
+		stb6100_set_frequency(fe, c->frequency);
 
-static int stb6100_set_state(struct dvb_frontend *fe,
-			     enum tuner_param param,
-			     struct tuner_state *state)
-{
-	struct stb6100_state *tstate = fe->tuner_priv;
-
-	switch (param) {
-	case DVBFE_TUNER_FREQUENCY:
-		stb6100_set_frequency(fe, state->frequency);
-		tstate->frequency = state->frequency;
-		break;
-	case DVBFE_TUNER_BANDWIDTH:
-		stb6100_set_bandwidth(fe, state->bandwidth);
-		tstate->bandwidth = state->bandwidth;
-		break;
-	default:
-		break;
-	}
+	if (c->bandwidth_hz > 0)
+		stb6100_set_bandwidth(fe, c->bandwidth_hz);
 
 	return 0;
 }
@@ -560,8 +533,9 @@ static struct dvb_tuner_ops stb6100_ops = {
 	.init		= stb6100_init,
 	.sleep          = stb6100_sleep,
 	.get_status	= stb6100_get_status,
-	.get_state	= stb6100_get_state,
-	.set_state	= stb6100_set_state,
+	.set_params	= stb6100_set_params,
+	.get_frequency  = stb6100_get_frequency,
+	.get_bandwidth  = stb6100_get_bandwidth,
 	.release	= stb6100_release
 };
 
diff --git a/drivers/media/dvb-frontends/stb6100_cfg.h b/drivers/media/dvb-frontends/stb6100_cfg.h
index 6edc15365847..2ef67aa768b9 100644
--- a/drivers/media/dvb-frontends/stb6100_cfg.h
+++ b/drivers/media/dvb-frontends/stb6100_cfg.h
@@ -19,20 +19,21 @@
 	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#include <linux/dvb/frontend.h>
+#include "dvb_frontend.h"
+
 static int stb6100_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
 	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
-	struct tuner_state	t_state;
 	int err = 0;
 
-	if (tuner_ops->get_state) {
-		err = tuner_ops->get_state(fe, DVBFE_TUNER_FREQUENCY, &t_state);
+	if (tuner_ops->get_frequency) {
+		err = tuner_ops->get_frequency(fe, frequency);
 		if (err < 0) {
 			printk("%s: Invalid parameter\n", __func__);
 			return err;
 		}
-		*frequency = t_state.frequency;
 	}
 	return 0;
 }
@@ -41,13 +42,16 @@ static int stb6100_set_frequency(struct dvb_frontend *fe, u32 frequency)
 {
 	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
 	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
-	struct tuner_state	t_state;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 bw = c->bandwidth_hz;
 	int err = 0;
 
-	t_state.frequency = frequency;
+	c->frequency = frequency;
+	c->bandwidth_hz = 0;		/* Don't adjust the bandwidth */
 
-	if (tuner_ops->set_state) {
-		err = tuner_ops->set_state(fe, DVBFE_TUNER_FREQUENCY, &t_state);
+	if (tuner_ops->set_params) {
+		err = tuner_ops->set_params(fe);
+		c->bandwidth_hz = bw;
 		if (err < 0) {
 			printk("%s: Invalid parameter\n", __func__);
 			return err;
@@ -60,16 +64,14 @@ static int stb6100_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 {
 	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
 	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
-	struct tuner_state	t_state;
 	int err = 0;
 
-	if (tuner_ops->get_state) {
-		err = tuner_ops->get_state(fe, DVBFE_TUNER_BANDWIDTH, &t_state);
+	if (tuner_ops->get_bandwidth) {
+		err = tuner_ops->get_bandwidth(fe, bandwidth);
 		if (err < 0) {
 			printk("%s: Invalid parameter\n", __func__);
 			return err;
 		}
-		*bandwidth = t_state.bandwidth;
 	}
 	return 0;
 }
@@ -78,13 +80,16 @@ static int stb6100_set_bandwidth(struct dvb_frontend *fe, u32 bandwidth)
 {
 	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
 	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
-	struct tuner_state	t_state;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 freq = c->frequency;
 	int err = 0;
 
-	t_state.bandwidth = bandwidth;
+	c->bandwidth_hz = bandwidth;
+	c->frequency = 0;		/* Don't adjust the frequency */
 
-	if (tuner_ops->set_state) {
-		err = tuner_ops->set_state(fe, DVBFE_TUNER_BANDWIDTH, &t_state);
+	if (tuner_ops->set_params) {
+		err = tuner_ops->set_params(fe);
+		c->frequency = freq;
 		if (err < 0) {
 			printk("%s: Invalid parameter\n", __func__);
 			return err;
diff --git a/drivers/media/dvb-frontends/stb6100_proc.h b/drivers/media/dvb-frontends/stb6100_proc.h
index bd8a0ec9e2cc..50ffa21e3871 100644
--- a/drivers/media/dvb-frontends/stb6100_proc.h
+++ b/drivers/media/dvb-frontends/stb6100_proc.h
@@ -17,27 +17,27 @@
 	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#include <linux/dvb/frontend.h>
+#include "dvb_frontend.h"
+
 static int stb6100_get_freq(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
 	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
-	struct tuner_state	state;
 	int err = 0;
 
-	if (tuner_ops->get_state) {
+	if (tuner_ops->get_frequency) {
 		if (frontend_ops->i2c_gate_ctrl)
 			frontend_ops->i2c_gate_ctrl(fe, 1);
 
-		err = tuner_ops->get_state(fe, DVBFE_TUNER_FREQUENCY, &state);
+		err = tuner_ops->get_frequency(fe, frequency);
 		if (err < 0) {
-			printk(KERN_ERR "%s: Invalid parameter\n", __func__);
+			printk("%s: Invalid parameter\n", __func__);
 			return err;
 		}
 
 		if (frontend_ops->i2c_gate_ctrl)
 			frontend_ops->i2c_gate_ctrl(fe, 0);
-
-		*frequency = state.frequency;
 	}
 
 	return 0;
@@ -47,18 +47,21 @@ static int stb6100_set_freq(struct dvb_frontend *fe, u32 frequency)
 {
 	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
 	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
-	struct tuner_state	state;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 bw = c->bandwidth_hz;
 	int err = 0;
 
-	state.frequency = frequency;
+	c->frequency = frequency;
+	c->bandwidth_hz = 0;		/* Don't adjust the bandwidth */
 
-	if (tuner_ops->set_state) {
+	if (tuner_ops->set_params) {
 		if (frontend_ops->i2c_gate_ctrl)
 			frontend_ops->i2c_gate_ctrl(fe, 1);
 
-		err = tuner_ops->set_state(fe, DVBFE_TUNER_FREQUENCY, &state);
+		err = tuner_ops->set_params(fe);
+		c->bandwidth_hz = bw;
 		if (err < 0) {
-			printk(KERN_ERR "%s: Invalid parameter\n", __func__);
+			printk("%s: Invalid parameter\n", __func__);
 			return err;
 		}
 
@@ -74,14 +77,13 @@ static int stb6100_get_bandw(struct dvb_frontend *fe, u32 *bandwidth)
 {
 	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
 	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
-	struct tuner_state	state;
 	int err = 0;
 
-	if (tuner_ops->get_state) {
+	if (tuner_ops->get_bandwidth) {
 		if (frontend_ops->i2c_gate_ctrl)
 			frontend_ops->i2c_gate_ctrl(fe, 1);
 
-		err = tuner_ops->get_state(fe, DVBFE_TUNER_BANDWIDTH, &state);
+		err = tuner_ops->get_bandwidth(fe, bandwidth);
 		if (err < 0) {
 			printk(KERN_ERR "%s: Invalid parameter\n", __func__);
 			return err;
@@ -89,8 +91,6 @@ static int stb6100_get_bandw(struct dvb_frontend *fe, u32 *bandwidth)
 
 		if (frontend_ops->i2c_gate_ctrl)
 			frontend_ops->i2c_gate_ctrl(fe, 0);
-
-		*bandwidth = state.bandwidth;
 	}
 
 	return 0;
@@ -100,16 +100,19 @@ static int stb6100_set_bandw(struct dvb_frontend *fe, u32 bandwidth)
 {
 	struct dvb_frontend_ops	*frontend_ops = &fe->ops;
 	struct dvb_tuner_ops	*tuner_ops = &frontend_ops->tuner_ops;
-	struct tuner_state	state;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 freq = c->frequency;
 	int err = 0;
 
-	state.bandwidth = bandwidth;
+	c->bandwidth_hz = bandwidth;
+	c->frequency = 0;		/* Don't adjust the frequency */
 
-	if (tuner_ops->set_state) {
+	if (tuner_ops->set_params) {
 		if (frontend_ops->i2c_gate_ctrl)
 			frontend_ops->i2c_gate_ctrl(fe, 1);
 
-		err = tuner_ops->set_state(fe, DVBFE_TUNER_BANDWIDTH, &state);
+		err = tuner_ops->set_params(fe);
+		c->frequency = freq;
 		if (err < 0) {
 			printk(KERN_ERR "%s: Invalid parameter\n", __func__);
 			return err;
-- 
2.5.0

