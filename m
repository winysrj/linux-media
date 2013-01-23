Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab3AWS5y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 13:57:54 -0500
Date: Wed, 23 Jan 2013 16:57:32 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Manu Abraham <abraham.manu@gmail.com>,
	Simon Farnsworth <simon.farnsworth@onelan.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
Message-ID: <20130123165732.0e8e74bb@redhat.com>
In-Reply-To: <20130123161801.764495e5@redhat.com>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<20130116152151.5461221c@redhat.com>
	<CAHFNz9KjG-qO5WoCMzPtcdb6d-4iZk695zp_L3iSeb=ZiWKhQw@mail.gmail.com>
	<2817386.vHx2V41lNt@f17simon>
	<20130116200153.3ec3ee7d@redhat.com>
	<CAHFNz9L-Dzrv=+Z01ndrfK3GmvFyxT6941W4-_63bwn1HrQBYQ@mail.gmail.com>
	<50F7C57A.6090703@iki.fi>
	<20130117145036.55745a60@redhat.com>
	<50F831AA.8010708@iki.fi>
	<20130117161126.6b2e809d@redhat.com>
	<50F84276.3080909@iki.fi>
	<CAHFNz9JDqYnrmNDt0_nBJMgzAymZSCXBbwY5MHR8AkMopPPQOA@mail.gmail.com>
	<20130117165037.6ed80366@redhat.com>
	<50F84CCC.5040103@iki.fi>
	<20130122101626.006d2d87@redhat.com>
	<50FFFD0B.30701@iki.fi>
	<20130123161801.764495e5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 23 Jan 2013 16:18:01 -0200
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> I'll soon post patches 1 and 2 after those changes. The remaining 4 patches
> don't likely need any change.

Actually, it sounds better to just do a diff between the two versions.
Each individual patch on v13 is at:
	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/stats_v13

Cheers,
Mauro

v13:
- Add post-Viterbi BER on the API
- Some documentation adjustments as suggested by Antti

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 3f9f451..772314a 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -467,7 +467,7 @@ typedef enum fe_delivery_system {
 		<title><constant>DTV-ISDBT-LAYER*</constant> parameters</title>
 		<para>ISDB-T channels can be coded hierarchically. As opposed to DVB-T in
 			ISDB-T hierarchical layers can be decoded simultaneously. For that
-			reason a ISDB-T demodulator has 3 viterbi and 3 reed-solomon-decoders.</para>
+			reason a ISDB-T demodulator has 3 Viterbi and 3 Reed-Solomon decoders.</para>
 		<para>ISDB-T has 3 hierarchical layers which each can use a part of the
 			available segments. The total number of segments over all layers has
 			to 13 in ISDB-T.</para>
@@ -933,24 +933,24 @@ enum fe_interleaving {
 			<listitem><constant>FE_SCALE_RELATIVE</constant> - The frontend provides a 0% to 100% measurement for Signal/Noise (actually, 0 to 65535).</listitem>
 		</itemizedlist>
 	</section>
-	<section id="DTV-STAT-BIT-ERROR-COUNT">
-		<title><constant>DTV_STAT_BIT_ERROR_COUNT</constant></title>
-		<para>Measures the number of bit errors before Viterbi.</para>
-		<para>This measure is taken during the same interval as <constant>DTV_STAT_TOTAL_BITS_COUNT</constant>.</para>
+	<section id="DTV-STAT-PRE-BIT-ERROR-COUNT">
+		<title><constant>DTV_STAT_PRE_BIT_ERROR_COUNT</constant></title>
+		<para>Measures the number of bit errors before the forward error correction (FEC) on the inner coding block (before Viterbi, LDPC or other inner code).</para>
+		<para>This measure is taken during the same interval as <constant>DTV_STAT_PRE_TOTAL_BIT_COUNT</constant>.</para>
 		<para>In order to get the BER (Bit Error Rate) measurement, it should be divided by
-		<link linkend="DTV-STAT-TOTAL-BITS-COUNT"><constant>DTV_STAT_TOTAL_BITS_COUNT</constant></link>.</para>
+		<link linkend="DTV-STAT-PRE-TOTAL-BIT-COUNT"><constant>DTV_STAT_PRE_TOTAL_BIT_COUNT</constant></link>.</para>
 		<para>This measurement is monotonically increased, as the frontend gets more bit count measurements.
 		      The frontend may reset it when a channel/transponder is tuned.</para>
 		<para>Possible scales for this metric are:</para>
 		<itemizedlist mark='bullet'>
 			<listitem><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</listitem>
-			<listitem><constant>FE_SCALE_COUNTER</constant> - Number of error bits counted before Viterbi.</listitem>
+			<listitem><constant>FE_SCALE_COUNTER</constant> - Number of error bits counted before the inner coding.</listitem>
 		</itemizedlist>
 	</section>
-	<section id="DTV-STAT-TOTAL-BITS-COUNT">
-		<title><constant>DTV_STAT_TOTAL_BITS_COUNT</constant></title>
-		<para>Measures the amount of bits received before the Viterbi block, during the same period as
-		<link linkend="DTV-STAT-BIT-ERROR-COUNT"><constant>DTV_STAT_BIT_ERROR_COUNT</constant></link> measurement was taken.</para>
+	<section id="DTV-STAT-PRE-TOTAL-BIT-COUNT">
+		<title><constant>DTV_STAT_PRE_TOTAL_BIT_COUNT</constant></title>
+		<para>Measures the amount of bits received before the inner code block, during the same period as
+		<link linkend="DTV-STAT-PRE-BIT-ERROR-COUNT"><constant>DTV_STAT_PRE_BIT_ERROR_COUNT</constant></link> measurement was taken.</para>
 		<para>It should be noticed that this measurement can be smaller than the total amount of bits on the transport stream,
 		      as the frontend may need to manually restart the measurement, loosing some data between each measurement interval.</para>
 		<para>This measurement is monotonically increased, as the frontend gets more bit count measurements.
@@ -959,27 +959,56 @@ enum fe_interleaving {
 		<itemizedlist mark='bullet'>
 			<listitem><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</listitem>
 			<listitem><constant>FE_SCALE_COUNTER</constant> - Number of bits counted while measuring
-				 <link linkend="DTV-STAT-BIT-ERROR-COUNT"><constant>DTV_STAT_BIT_ERROR_COUNT</constant></link>.</listitem>
+				 <link linkend="DTV-STAT-PRE-BIT-ERROR-COUNT"><constant>DTV_STAT_PRE_BIT_ERROR_COUNT</constant></link>.</listitem>
+		</itemizedlist>
+	</section>
+	<section id="DTV-STAT-POST-BIT-ERROR-COUNT">
+		<title><constant>DTV_STAT_POST_BIT_ERROR_COUNT</constant></title>
+		<para>Measures the number of bit errors after the forward error correction (FEC) done by inner code block (after Viterbi, LDPC or other inner code).</para>
+		<para>This measure is taken during the same interval as <constant>DTV_STAT_POST_TOTAL_BIT_COUNT</constant>.</para>
+		<para>In order to get the BER (Bit Error Rate) measurement, it should be divided by
+		<link linkend="DTV-STAT-POST-TOTAL-BIT-COUNT"><constant>DTV_STAT_POST_TOTAL_BIT_COUNT</constant></link>.</para>
+		<para>This measurement is monotonically increased, as the frontend gets more bit count measurements.
+		      The frontend may reset it when a channel/transponder is tuned.</para>
+		<para>Possible scales for this metric are:</para>
+		<itemizedlist mark='bullet'>
+			<listitem><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</listitem>
+			<listitem><constant>FE_SCALE_COUNTER</constant> - Number of error bits counted after the inner coding.</listitem>
+		</itemizedlist>
+	</section>
+	<section id="DTV-STAT-POST-TOTAL-BIT-COUNT">
+		<title><constant>DTV_STAT_POST_TOTAL_BIT_COUNT</constant></title>
+		<para>Measures the amount of bits received after the inner coding, during the same period as
+		<link linkend="DTV-STAT-POST-BIT-ERROR-COUNT"><constant>DTV_STAT_POST_BIT_ERROR_COUNT</constant></link> measurement was taken.</para>
+		<para>It should be noticed that this measurement can be smaller than the total amount of bits on the transport stream,
+		      as the frontend may need to manually restart the measurement, loosing some data between each measurement interval.</para>
+		<para>This measurement is monotonically increased, as the frontend gets more bit count measurements.
+		      The frontend may reset it when a channel/transponder is tuned.</para>
+		<para>Possible scales for this metric are:</para>
+		<itemizedlist mark='bullet'>
+			<listitem><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</listitem>
+			<listitem><constant>FE_SCALE_COUNTER</constant> - Number of bits counted while measuring
+				 <link linkend="DTV-STAT-POST-BIT-ERROR-COUNT"><constant>DTV_STAT_POST_BIT_ERROR_COUNT</constant></link>.</listitem>
 		</itemizedlist>
 	</section>
 	<section id="DTV-STAT-ERROR-BLOCK-COUNT">
 		<title><constant>DTV_STAT_ERROR_BLOCK_COUNT</constant></title>
-		<para>Measures the number of block errors.</para>
+		<para>Measures the number of block errors after the outer forward error correction coding (after Reed-Solomon or other outer code).</para>
 		<para>This measurement is monotonically increased, as the frontend gets more bit count measurements.
 		      The frontend may reset it when a channel/transponder is tuned.</para>
 		<para>Possible scales for this metric are:</para>
 		<itemizedlist mark='bullet'>
 			<listitem><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</listitem>
-			<listitem><constant>FE_SCALE_COUNTER</constant> - Number of error blocks counted after Red Salomon.</listitem>
+			<listitem><constant>FE_SCALE_COUNTER</constant> - Number of error blocks counted after the outer coding.</listitem>
 		</itemizedlist>
 	</section>
-	<section id="DTV-STAT-TOTAL-BLOCKS-COUNT">
-		<title><constant>DTV-STAT_TOTAL_BLOCKS_COUNT</constant></title>
+	<section id="DTV-STAT-TOTAL-BLOCK-COUNT">
+		<title><constant>DTV-STAT_TOTAL_BLOCK_COUNT</constant></title>
 		<para>Measures the total number of blocks received during the same period as
 		<link linkend="DTV-STAT-ERROR-BLOCK-COUNT"><constant>DTV_STAT_ERROR_BLOCK_COUNT</constant></link> measurement was taken.</para>
 		<para>It can be used to calculate the PER indicator, by dividing
 		<link linkend="DTV-STAT-ERROR-BLOCK-COUNT"><constant>DTV_STAT_ERROR_BLOCK_COUNT</constant></link>
-		by <link linkend="DTV-STAT-TOTAL-BLOCKS-COUNT"><constant>DTV-STAT-TOTAL-BLOCKS-COUNT</constant></link>.</para>
+		by <link linkend="DTV-STAT-TOTAL-BLOCK-COUNT"><constant>DTV-STAT-TOTAL-BLOCK-COUNT</constant></link>.</para>
 		<para>Possible scales for this metric are:</para>
 		<itemizedlist mark='bullet'>
 			<listitem><constant>FE_SCALE_NOT_AVAILABLE</constant> - it failed to measure it, or the measurement was not complete yet.</listitem>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 426c252..df39ba3 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -230,7 +230,7 @@ typedef enum fe_status {
 <entry align="char">The frontend has found a DVB signal</entry>
 </row><row>
 <entry align="char">FE_HAS_VITERBI</entry>
-<entry align="char">The frontend FEC code is stable</entry>
+<entry align="char">The frontend FEC inner coding (Viterbi, LDPC or other inner code) is stable</entry>
 </row><row>
 <entry align="char">FE_HAS_SYNC</entry>
 <entry align="char">Syncronization bytes was found</entry>
diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 66be7f7..f8943c2 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -1057,10 +1057,12 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
 	/* Statistics API */
 	_DTV_CMD(DTV_STAT_SIGNAL_STRENGTH, 0, 0),
 	_DTV_CMD(DTV_STAT_CNR, 0, 0),
-	_DTV_CMD(DTV_STAT_BIT_ERROR_COUNT, 0, 0),
-	_DTV_CMD(DTV_STAT_TOTAL_BITS_COUNT, 0, 0),
+	_DTV_CMD(DTV_STAT_PRE_BIT_ERROR_COUNT, 0, 0),
+	_DTV_CMD(DTV_STAT_PRE_TOTAL_BIT_COUNT, 0, 0),
+	_DTV_CMD(DTV_STAT_POST_BIT_ERROR_COUNT, 0, 0),
+	_DTV_CMD(DTV_STAT_POST_TOTAL_BIT_COUNT, 0, 0),
 	_DTV_CMD(DTV_STAT_ERROR_BLOCK_COUNT, 0, 0),
-	_DTV_CMD(DTV_STAT_TOTAL_BLOCKS_COUNT, 0, 0),
+	_DTV_CMD(DTV_STAT_TOTAL_BLOCK_COUNT, 0, 0),
 };
 
 static void dtv_property_dump(struct dvb_frontend *fe, struct dtv_property *tvp)
@@ -1458,16 +1460,22 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 	case DTV_STAT_CNR:
 		tvp->u.st = c->cnr;
 		break;
-	case DTV_STAT_BIT_ERROR_COUNT:
-		tvp->u.st = c->bit_error;
+	case DTV_STAT_PRE_BIT_ERROR_COUNT:
+		tvp->u.st = c->pre_bit_error;
 		break;
-	case DTV_STAT_TOTAL_BITS_COUNT:
-		tvp->u.st = c->bit_count;
+	case DTV_STAT_PRE_TOTAL_BIT_COUNT:
+		tvp->u.st = c->pre_bit_count;
+		break;
+	case DTV_STAT_POST_BIT_ERROR_COUNT:
+		tvp->u.st = c->post_bit_error;
+		break;
+	case DTV_STAT_POST_TOTAL_BIT_COUNT:
+		tvp->u.st = c->post_bit_count;
 		break;
 	case DTV_STAT_ERROR_BLOCK_COUNT:
 		tvp->u.st = c->block_error;
 		break;
-	case DTV_STAT_TOTAL_BLOCKS_COUNT:
+	case DTV_STAT_TOTAL_BLOCK_COUNT:
 		tvp->u.st = c->block_count;
 		break;
 	default:
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 47952c5..b34922a 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -397,8 +397,10 @@ struct dtv_frontend_properties {
 	/* statistics data */
 	struct dtv_fe_stats	strength;
 	struct dtv_fe_stats	cnr;
-	struct dtv_fe_stats	bit_error;
-	struct dtv_fe_stats	bit_count;
+	struct dtv_fe_stats	pre_bit_error;
+	struct dtv_fe_stats	pre_bit_count;
+	struct dtv_fe_stats	post_bit_error;
+	struct dtv_fe_stats	post_bit_count;
 	struct dtv_fe_stats	block_error;
 	struct dtv_fe_stats	block_count;
 };
diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 56a027c..4f3e222 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -721,8 +721,8 @@ static int mb86a20s_reset_counters(struct dvb_frontend *fe)
 	if (state->last_frequency != c->frequency) {
 		memset(&c->strength, 0, sizeof(c->strength));
 		memset(&c->cnr, 0, sizeof(c->cnr));
-		memset(&c->bit_error, 0, sizeof(c->bit_error));
-		memset(&c->bit_count, 0, sizeof(c->bit_count));
+		memset(&c->pre_bit_error, 0, sizeof(c->pre_bit_error));
+		memset(&c->pre_bit_count, 0, sizeof(c->pre_bit_count));
 		memset(&c->block_error, 0, sizeof(c->block_error));
 		memset(&c->block_count, 0, sizeof(c->block_count));
 
@@ -1232,8 +1232,8 @@ static void mb86a20s_stats_not_ready(struct dvb_frontend *fe)
 
 	/* Per-layer stats - 3 layers + global */
 	c->cnr.len = 4;
-	c->bit_error.len = 4;
-	c->bit_count.len = 4;
+	c->pre_bit_error.len = 4;
+	c->pre_bit_count.len = 4;
 	c->block_error.len = 4;
 	c->block_count.len = 4;
 
@@ -1244,8 +1244,8 @@ static void mb86a20s_stats_not_ready(struct dvb_frontend *fe)
 	/* Put all of them at FE_SCALE_NOT_AVAILABLE */
 	for (i = 0; i < 4; i++) {
 		c->cnr.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
-		c->bit_error.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
-		c->bit_count.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
+		c->pre_bit_error.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
+		c->pre_bit_count.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
 		c->block_error.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
 		c->block_count.stat[i].scale = FE_SCALE_NOT_AVAILABLE;
 	}
@@ -1257,7 +1257,7 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int rc = 0, i;
 	u32 bit_error = 0, bit_count = 0;
-	u32 t_bit_error = 0, t_bit_count = 0;
+	u32 t_pre_bit_error = 0, t_pre_bit_count = 0;
 	int active_layers = 0, ber_layers = 0;
 
 	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
@@ -1278,17 +1278,17 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 							&bit_error,
 							&bit_count);
 			if (rc >= 0) {
-				c->bit_error.stat[1 + i].scale = FE_SCALE_COUNTER;
-				c->bit_error.stat[1 + i].uvalue += bit_error;
-				c->bit_count.stat[1 + i].scale = FE_SCALE_COUNTER;
-				c->bit_count.stat[1 + i].uvalue += bit_count;
+				c->pre_bit_error.stat[1 + i].scale = FE_SCALE_COUNTER;
+				c->pre_bit_error.stat[1 + i].uvalue += bit_error;
+				c->pre_bit_count.stat[1 + i].scale = FE_SCALE_COUNTER;
+				c->pre_bit_count.stat[1 + i].uvalue += bit_count;
 			} else if (rc != -EBUSY) {
 				/*
 					* If an I/O error happened,
 					* measures are now unavailable
 					*/
-				c->bit_error.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
-				c->bit_count.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
+				c->pre_bit_error.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
+				c->pre_bit_count.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
 				dev_err(&state->i2c->dev,
 					"%s: Can't get BER for layer %c (error %d).\n",
 					__func__, 'A' + i, rc);
@@ -1298,8 +1298,8 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 				ber_layers++;
 
 			/* Update total BER */
-			t_bit_error += c->bit_error.stat[1 + i].uvalue;
-			t_bit_count += c->bit_count.stat[1 + i].uvalue;
+			t_pre_bit_error += c->pre_bit_error.stat[1 + i].uvalue;
+			t_pre_bit_count += c->pre_bit_count.stat[1 + i].uvalue;
 		}
 	}
 
@@ -1315,10 +1315,10 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 		 * Total Bit Error/Count is calculated as the sum of the
 		 * bit errors on all active layers.
 		 */
-		c->bit_error.stat[0].scale = FE_SCALE_COUNTER;
-		c->bit_error.stat[0].uvalue = t_bit_error;
-		c->bit_count.stat[0].scale = FE_SCALE_COUNTER;
-		c->bit_count.stat[0].uvalue = t_bit_count;
+		c->pre_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->pre_bit_error.stat[0].uvalue = t_pre_bit_error;
+		c->pre_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->pre_bit_count.stat[0].uvalue = t_pre_bit_count;
 	}
 
 	return rc;
@@ -1544,12 +1544,12 @@ struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
 	struct mb86a20s_state *state;
 	u8	rev;
 
+	dev_dbg(&i2c->dev, "%s called.\n", __func__);
+
 	/* allocate memory for the internal state */
 	state = kzalloc(sizeof(struct mb86a20s_state), GFP_KERNEL);
-
-	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 	if (state == NULL) {
-		dev_err(&state->i2c->dev,
+		dev_err(&i2c->dev,
 			"%s: unable to allocate memory for state\n", __func__);
 		goto error;
 	}
@@ -1567,10 +1567,10 @@ struct dvb_frontend *mb86a20s_attach(const struct mb86a20s_config *config,
 	rev = mb86a20s_readreg(state, 0);
 
 	if (rev == 0x13) {
-		dev_info(&state->i2c->dev,
+		dev_info(&i2c->dev,
 			 "Detected a Fujitsu mb86a20s frontend\n");
 	} else {
-		dev_dbg(&state->i2c->dev,
+		dev_dbg(&i2c->dev,
 			"Frontend revision %d is unknown - aborting.\n",
 		       rev);
 		goto error;
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 0cd62bd..1913a36 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -368,12 +368,14 @@ struct dvb_frontend_event {
 /* Quality parameters */
 #define DTV_STAT_SIGNAL_STRENGTH	62
 #define DTV_STAT_CNR			63
-#define DTV_STAT_BIT_ERROR_COUNT	64
-#define DTV_STAT_TOTAL_BITS_COUNT	65
-#define DTV_STAT_ERROR_BLOCK_COUNT	66
-#define DTV_STAT_TOTAL_BLOCKS_COUNT	67
-
-#define DTV_MAX_COMMAND		DTV_STAT_TOTAL_BLOCKS_COUNT
+#define DTV_STAT_PRE_BIT_ERROR_COUNT	64
+#define DTV_STAT_PRE_TOTAL_BIT_COUNT	65
+#define DTV_STAT_POST_BIT_ERROR_COUNT	66
+#define DTV_STAT_POST_TOTAL_BIT_COUNT	67
+#define DTV_STAT_ERROR_BLOCK_COUNT	68
+#define DTV_STAT_TOTAL_BLOCK_COUNT	69
+
+#define DTV_MAX_COMMAND		DTV_STAT_TOTAL_BLOCK_COUNT
 
 typedef enum fe_pilot {
 	PILOT_ON,
