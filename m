Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573Ab3CDLXS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Mar 2013 06:23:18 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r24BNHrp003231
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 4 Mar 2013 06:23:17 -0500
Date: Mon, 4 Mar 2013 08:23:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 03/11] [media] mb86a20s: provide CNR stats before
 FE_HAS_SYNC
Message-ID: <20130304082313.7acf632e@redhat.com>
In-Reply-To: <1362326331-17541-4-git-send-email-mchehab@redhat.com>
References: <1362326331-17541-1-git-send-email-mchehab@redhat.com>
	<1362326331-17541-4-git-send-email-mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun,  3 Mar 2013 12:58:43 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> State 9 means TS started to be output, and it should be
> associated with FE_HAS_SYNC.
> 
> The mb86a20scan get CNR statistics at state 7, when frame sync
> is obtained.
> 
> As CNR may help to adjust the antenna, provide it earlier.
> 
> A latter patch could eventually start outputing MER measures
> earlier, but that would require a bigger change, and probably
> won't be better than the current way, as the time between
> changing from state 8 to 9 is generally lower than the time
> to get the stats collected.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/dvb-frontends/mb86a20s.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
> index daeee81..e222e55 100644
> --- a/drivers/media/dvb-frontends/mb86a20s.c
> +++ b/drivers/media/dvb-frontends/mb86a20s.c
> @@ -312,7 +312,7 @@ static int mb86a20s_read_status(struct dvb_frontend *fe, fe_status_t *status)
>  	dev_dbg(&state->i2c->dev, "%s: Status = 0x%02x (state = %d)\n",
>  		 __func__, *status, val);
>  
> -	return 0;
> +	return val;
>  }
>  
>  static int mb86a20s_read_signal_strength(struct dvb_frontend *fe)
> @@ -1564,7 +1564,7 @@ static void mb86a20s_stats_not_ready(struct dvb_frontend *fe)
>  	}
>  }
>  
> -static int mb86a20s_get_stats(struct dvb_frontend *fe)
> +static int mb86a20s_get_stats(struct dvb_frontend *fe, int status_nr)
>  {
>  	struct mb86a20s_state *state = fe->demodulator_priv;
>  	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> @@ -1584,6 +1584,14 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
>  	/* Get per-layer stats */
>  	mb86a20s_get_blk_error_layer_CNR(fe);
>  
> +	/*
> +	 * At state 7, only CNR is available
> +	 * For BER measures, state=9 is required
> +	 * FIXME: we may get MER measures with state=8
> +	 */
> +	if (status_nr < 9)
> +		return 0;
> +
>  	for (i = 0; i < 3; i++) {
>  		if (c->isdbt_layer_enabled & (1 << i)) {
>  			/* Layer is active and has rc segments */
> @@ -1875,7 +1883,7 @@ static int mb86a20s_read_status_and_stats(struct dvb_frontend *fe,
>  {
>  	struct mb86a20s_state *state = fe->demodulator_priv;
>  	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> -	int rc;
> +	int rc, status_nr;
>  
>  	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
>  
> @@ -1883,12 +1891,12 @@ static int mb86a20s_read_status_and_stats(struct dvb_frontend *fe,
>  		fe->ops.i2c_gate_ctrl(fe, 0);
>  
>  	/* Get lock */
> -	rc = mb86a20s_read_status(fe, status);
> -	if (!(*status & FE_HAS_LOCK)) {
> +	status_nr = mb86a20s_read_status(fe, status);
> +	if (status_nr < 7) {
>  		mb86a20s_stats_not_ready(fe);
>  		mb86a20s_reset_frontend_cache(fe);
>  	}
> -	if (rc < 0) {
> +	if (state < 0) {

This is obviously wrong ;)

Patch with fixup enclosed.

Cheers,
Mauro

-

[PATCH 03/11v2] [media] mb86a20s: provide CNR stats before FE_HAS_SYNC

State 9 means TS started to be output, and it should be
associated with FE_HAS_SYNC.

The mb86a20scan get CNR statistics at state 7, when frame sync
is obtained.

As CNR may help to adjust the antenna, provide it earlier.

A latter patch could eventually start outputing MER measures
earlier, but that would require a bigger change, and probably
won't be better than the current way, as the time between
changing from state 8 to 9 is generally lower than the time
to get the stats collected.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index daeee81..2720b82 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -312,7 +312,7 @@ static int mb86a20s_read_status(struct dvb_frontend *fe, fe_status_t *status)
 	dev_dbg(&state->i2c->dev, "%s: Status = 0x%02x (state = %d)\n",
 		 __func__, *status, val);
 
-	return 0;
+	return val;
 }
 
 static int mb86a20s_read_signal_strength(struct dvb_frontend *fe)
@@ -1564,7 +1564,7 @@ static void mb86a20s_stats_not_ready(struct dvb_frontend *fe)
 	}
 }
 
-static int mb86a20s_get_stats(struct dvb_frontend *fe)
+static int mb86a20s_get_stats(struct dvb_frontend *fe, int status_nr)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -1584,6 +1584,14 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 	/* Get per-layer stats */
 	mb86a20s_get_blk_error_layer_CNR(fe);
 
+	/*
+	 * At state 7, only CNR is available
+	 * For BER measures, state=9 is required
+	 * FIXME: we may get MER measures with state=8
+	 */
+	if (status_nr < 9)
+		return 0;
+
 	for (i = 0; i < 3; i++) {
 		if (c->isdbt_layer_enabled & (1 << i)) {
 			/* Layer is active and has rc segments */
@@ -1875,7 +1883,7 @@ static int mb86a20s_read_status_and_stats(struct dvb_frontend *fe,
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int rc;
+	int rc, status_nr;
 
 	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
@@ -1883,12 +1891,12 @@ static int mb86a20s_read_status_and_stats(struct dvb_frontend *fe,
 		fe->ops.i2c_gate_ctrl(fe, 0);
 
 	/* Get lock */
-	rc = mb86a20s_read_status(fe, status);
-	if (!(*status & FE_HAS_LOCK)) {
+	status_nr = mb86a20s_read_status(fe, status);
+	if (status_nr < 7) {
 		mb86a20s_stats_not_ready(fe);
 		mb86a20s_reset_frontend_cache(fe);
 	}
-	if (rc < 0) {
+	if (status_nr < 0) {
 		dev_err(&state->i2c->dev,
 			"%s: Can't read frontend lock status\n", __func__);
 		goto error;
@@ -1908,7 +1916,7 @@ static int mb86a20s_read_status_and_stats(struct dvb_frontend *fe,
 	/* Fill signal strength */
 	c->strength.stat[0].uvalue = rc;
 
-	if (*status & FE_HAS_LOCK) {
+	if (status_nr >= 7) {
 		/* Get TMCC info*/
 		rc = mb86a20s_get_frontend(fe);
 		if (rc < 0) {
@@ -1919,7 +1927,7 @@ static int mb86a20s_read_status_and_stats(struct dvb_frontend *fe,
 		}
 
 		/* Get statistics */
-		rc = mb86a20s_get_stats(fe);
+		rc = mb86a20s_get_stats(fe, status_nr);
 		if (rc < 0 && rc != -EBUSY) {
 			dev_err(&state->i2c->dev,
 				"%s: Can't get FE statistics.\n", __func__);


