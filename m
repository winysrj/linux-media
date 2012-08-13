Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51793 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857Ab2HMCdt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 22:33:49 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Andreas Oberritter <obi@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 1/2] add DTMB support for DVB API
Date: Mon, 13 Aug 2012 05:33:21 +0300
Message-Id: <1344825202-2296-2-git-send-email-crope@iki.fi>
In-Reply-To: <1344825202-2296-1-git-send-email-crope@iki.fi>
References: <1344825202-2296-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Andreas Oberritter <obi@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Patrick Boettcher <pboettcher@kernellabs.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml | 40 ++++++++++++++++++++++++-
 drivers/media/dvb/dvb-core/dvb_frontend.c       | 14 +++++++--
 drivers/media/dvb/dvb-core/dvb_frontend.h       |  2 ++
 drivers/media/dvb/frontends/atbm8830.c          |  2 +-
 drivers/media/dvb/frontends/lgs8gl5.c           |  2 +-
 drivers/media/dvb/frontends/lgs8gxx.c           |  2 +-
 include/linux/dvb/frontend.h                    | 21 +++++++++++--
 include/linux/dvb/version.h                     |  2 +-
 8 files changed, 74 insertions(+), 11 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index bb4777a..5aea35e 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -194,6 +194,7 @@ get/set up to 64 properties. The actual meaning of each property is described on
 	APSK_16,
 	APSK_32,
 	DQPSK,
+	QAM_4_NR,
  } fe_modulation_t;
 </programlisting>
 	</section>
@@ -265,6 +266,7 @@ typedef enum fe_code_rate {
 	FEC_AUTO,
 	FEC_3_5,
 	FEC_9_10,
+	FEC_2_5,
 } fe_code_rate_t;
 	</programlisting>
 	<para>which correspond to error correction rates of 1/2, 2/3, etc.,
@@ -351,7 +353,7 @@ typedef enum fe_delivery_system {
 	SYS_ISDBC,
 	SYS_ATSC,
 	SYS_ATSCMH,
-	SYS_DMBTH,
+	SYS_DTMB,
 	SYS_CMMB,
 	SYS_DAB,
 	SYS_DVBT2,
@@ -735,6 +737,9 @@ typedef enum fe_guard_interval {
 	GUARD_INTERVAL_1_128,
 	GUARD_INTERVAL_19_128,
 	GUARD_INTERVAL_19_256,
+	GUARD_INTERVAL_PN420,
+	GUARD_INTERVAL_PN595,
+	GUARD_INTERVAL_PN945,
 } fe_guard_interval_t;
 </programlisting>
 
@@ -743,6 +748,7 @@ typedef enum fe_guard_interval {
 			try to find the correct guard interval (if capable) and will use TMCC to fill
 			in the missing parameters.</para>
 		<para>2) Intervals 1/128, 19/128 and 19/256 are used only for DVB-T2 at present</para>
+		<para>3) DTMB specifies PN420, PN595 and PN945.</para>
 	</section>
 	<section id="DTV-TRANSMISSION-MODE">
 		<title><constant>DTV_TRANSMISSION_MODE</constant></title>
@@ -759,6 +765,8 @@ typedef enum fe_transmit_mode {
 	TRANSMISSION_MODE_1K,
 	TRANSMISSION_MODE_16K,
 	TRANSMISSION_MODE_32K,
+	TRANSMISSION_MODE_C1,
+	TRANSMISSION_MODE_C3780,
 } fe_transmit_mode_t;
 </programlisting>
 		<para>Notes:</para>
@@ -770,6 +778,7 @@ typedef enum fe_transmit_mode {
 			use TMCC to fill in the missing parameters.</para>
 		<para>3) DVB-T specifies 2K and 8K as valid sizes.</para>
 		<para>4) DVB-T2 specifies 1K, 2K, 4K, 8K, 16K and 32K.</para>
+		<para>5) DTMB specifies C1 and C3780.</para>
 	</section>
 	<section id="DTV-HIERARCHY">
 	<title><constant>DTV_HIERARCHY</constant></title>
@@ -806,6 +815,17 @@ typedef enum fe_hierarchy {
 			FE_GET_INFO. In the case of a legacy frontend, the result is just the same
 			as with FE_GET_INFO, but in a more structured format </para>
 	</section>
+	<section id="DTV-INTERLEAVING">
+	<title><constant>DTV_INTERLEAVING</constant></title>
+	<para>Interleaving mode</para>
+	<programlisting>
+enum fe_interleaving {
+	INTERLEAVING_NONE,
+	INTERLEAVING_240,
+	INTERLEAVING_720,
+};
+	</programlisting>
+	</section>
 </section>
 	<section id="frontend-property-terrestrial-systems">
 	<title>Properties used on terrestrial delivery systems</title>
@@ -944,6 +964,24 @@ typedef enum fe_hierarchy {
 				<listitem><para><link linkend="DTV-ATSCMH-SCCC-CODE-MODE-D"><constant>DTV_ATSCMH_SCCC_CODE_MODE_D</constant></link></para></listitem>
 			</itemizedlist>
 		</section>
+		<section id="dtmb-params">
+			<title>DTMB delivery system</title>
+			<para>The following parameters are valid for DTMB:</para>
+			<itemizedlist mark='opencircle'>
+				<listitem><para><link linkend="DTV-API-VERSION"><constant>DTV_API_VERSION</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-DELIVERY-SYSTEM"><constant>DTV_DELIVERY_SYSTEM</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-TUNE"><constant>DTV_TUNE</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-CLEAR"><constant>DTV_CLEAR</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-FREQUENCY"><constant>DTV_FREQUENCY</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-MODULATION"><constant>DTV_MODULATION</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-BANDWIDTH-HZ"><constant>DTV_BANDWIDTH_HZ</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-INVERSION"><constant>DTV_INVERSION</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-INNER-FEC"><constant>DTV_INNER_FEC</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-GUARD-INTERVAL"><constant>DTV_GUARD_INTERVAL</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-TRANSMISSION-MODE"><constant>DTV_TRANSMISSION_MODE</constant></link></para></listitem>
+				<listitem><para><link linkend="DTV-INTERLEAVING"><constant>DTV_INTERLEAVING</constant></link></para></listitem>
+			</itemizedlist>
+		</section>
 	</section>
 	<section id="frontend-property-cable-systems">
 	<title>Properties used on cable delivery systems</title>
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 746dfd8..3a0f245 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -179,7 +179,7 @@ static enum dvbv3_emulation_type dvbv3_type(u32 delivery_system)
 	case SYS_DVBT:
 	case SYS_DVBT2:
 	case SYS_ISDBT:
-	case SYS_DMBTH:
+	case SYS_DTMB:
 		return DVBV3_OFDM;
 	case SYS_ATSC:
 	case SYS_ATSCMH:
@@ -997,6 +997,7 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
 	_DTV_CMD(DTV_CODE_RATE_LP, 1, 0),
 	_DTV_CMD(DTV_GUARD_INTERVAL, 1, 0),
 	_DTV_CMD(DTV_TRANSMISSION_MODE, 1, 0),
+	_DTV_CMD(DTV_INTERLEAVING, 1, 0),
 
 	_DTV_CMD(DTV_ISDBT_PARTIAL_RECEPTION, 1, 0),
 	_DTV_CMD(DTV_ISDBT_SOUND_BROADCASTING, 1, 0),
@@ -1028,6 +1029,7 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
 	_DTV_CMD(DTV_GUARD_INTERVAL, 0, 0),
 	_DTV_CMD(DTV_TRANSMISSION_MODE, 0, 0),
 	_DTV_CMD(DTV_HIERARCHY, 0, 0),
+	_DTV_CMD(DTV_INTERLEAVING, 0, 0),
 
 	_DTV_CMD(DTV_ENUM_DELSYS, 0, 0),
 
@@ -1326,6 +1328,9 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
 	case DTV_HIERARCHY:
 		tvp->u.data = c->hierarchy;
 		break;
+	case DTV_INTERLEAVING:
+		tvp->u.data = c->interleaving;
+		break;
 
 	/* ISDB-T Support here */
 	case DTV_ISDBT_PARTIAL_RECEPTION:
@@ -1593,7 +1598,7 @@ static int set_delivery_system(struct dvb_frontend *fe, u32 desired_system)
 	 * The DVBv3 or DVBv5 call is requesting a different system. So,
 	 * emulation is needed.
 	 *
-	 * Emulate newer delivery systems like ISDBT, DVBT and DMBTH
+	 * Emulate newer delivery systems like ISDBT, DVBT and DTMB
 	 * for older DVBv5 applications. The emulation will try to use
 	 * the auto mode for most things, and will assume that the desired
 	 * delivery system is the last one at the ops.delsys[] array
@@ -1715,6 +1720,9 @@ static int dtv_property_process_set(struct dvb_frontend *fe,
 	case DTV_HIERARCHY:
 		c->hierarchy = tvp->u.data;
 		break;
+	case DTV_INTERLEAVING:
+		c->interleaving = tvp->u.data;
+		break;
 
 	/* ISDB-T Support here */
 	case DTV_ISDBT_PARTIAL_RECEPTION:
@@ -2012,7 +2020,7 @@ static int dtv_set_frontend(struct dvb_frontend *fe)
 		case SYS_DVBT:
 		case SYS_DVBT2:
 		case SYS_ISDBT:
-		case SYS_DMBTH:
+		case SYS_DTMB:
 			fepriv->min_delay = HZ / 20;
 			fepriv->step_size = fe->ops.info.frequency_stepsize * 2;
 			fepriv->max_drift = (fe->ops.info.frequency_stepsize * 2) + 1;
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 7c64c09..de410cc 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -354,6 +354,8 @@ struct dtv_frontend_properties {
 
 	fe_delivery_system_t	delivery_system;
 
+	enum fe_interleaving	interleaving;
+
 	/* ISDB-T specifics */
 	u8			isdbt_partial_reception;
 	u8			isdbt_sb_mode;
diff --git a/drivers/media/dvb/frontends/atbm8830.c b/drivers/media/dvb/frontends/atbm8830.c
index a2261ea..4e11dc4 100644
--- a/drivers/media/dvb/frontends/atbm8830.c
+++ b/drivers/media/dvb/frontends/atbm8830.c
@@ -428,7 +428,7 @@ static int atbm8830_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 }
 
 static struct dvb_frontend_ops atbm8830_ops = {
-	.delsys = { SYS_DMBTH },
+	.delsys = { SYS_DTMB },
 	.info = {
 		.name = "AltoBeam ATBM8830/8831 DMB-TH",
 		.frequency_min = 474000000,
diff --git a/drivers/media/dvb/frontends/lgs8gl5.c b/drivers/media/dvb/frontends/lgs8gl5.c
index 2cec804..416cce3 100644
--- a/drivers/media/dvb/frontends/lgs8gl5.c
+++ b/drivers/media/dvb/frontends/lgs8gl5.c
@@ -412,7 +412,7 @@ EXPORT_SYMBOL(lgs8gl5_attach);
 
 
 static struct dvb_frontend_ops lgs8gl5_ops = {
-	.delsys = { SYS_DMBTH },
+	.delsys = { SYS_DTMB },
 	.info = {
 		.name			= "Legend Silicon LGS-8GL5 DMB-TH",
 		.frequency_min		= 474000000,
diff --git a/drivers/media/dvb/frontends/lgs8gxx.c b/drivers/media/dvb/frontends/lgs8gxx.c
index c2ea274..3c92f36 100644
--- a/drivers/media/dvb/frontends/lgs8gxx.c
+++ b/drivers/media/dvb/frontends/lgs8gxx.c
@@ -995,7 +995,7 @@ static int lgs8gxx_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 }
 
 static struct dvb_frontend_ops lgs8gxx_ops = {
-	.delsys = { SYS_DMBTH },
+	.delsys = { SYS_DTMB },
 	.info = {
 		.name = "Legend Silicon LGS8913/LGS8GXX DMB-TH",
 		.frequency_min = 474000000,
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index f50d405..2dd5823 100644
--- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -152,6 +152,7 @@ typedef enum fe_code_rate {
 	FEC_AUTO,
 	FEC_3_5,
 	FEC_9_10,
+	FEC_2_5,
 } fe_code_rate_t;
 
 
@@ -169,6 +170,7 @@ typedef enum fe_modulation {
 	APSK_16,
 	APSK_32,
 	DQPSK,
+	QAM_4_NR,
 } fe_modulation_t;
 
 typedef enum fe_transmit_mode {
@@ -179,6 +181,8 @@ typedef enum fe_transmit_mode {
 	TRANSMISSION_MODE_1K,
 	TRANSMISSION_MODE_16K,
 	TRANSMISSION_MODE_32K,
+	TRANSMISSION_MODE_C1,
+	TRANSMISSION_MODE_C3780,
 } fe_transmit_mode_t;
 
 #if defined(__DVB_CORE__) || !defined (__KERNEL__)
@@ -202,6 +206,9 @@ typedef enum fe_guard_interval {
 	GUARD_INTERVAL_1_128,
 	GUARD_INTERVAL_19_128,
 	GUARD_INTERVAL_19_256,
+	GUARD_INTERVAL_PN420,
+	GUARD_INTERVAL_PN595,
+	GUARD_INTERVAL_PN945,
 } fe_guard_interval_t;
 
 
@@ -213,6 +220,11 @@ typedef enum fe_hierarchy {
 	HIERARCHY_AUTO
 } fe_hierarchy_t;
 
+enum fe_interleaving {
+	INTERLEAVING_NONE,
+	INTERLEAVING_240,
+	INTERLEAVING_720,
+};
 
 #if defined(__DVB_CORE__) || !defined (__KERNEL__)
 struct dvb_qpsk_parameters {
@@ -337,7 +349,9 @@ struct dvb_frontend_event {
 #define DTV_ATSCMH_SCCC_CODE_MODE_C	58
 #define DTV_ATSCMH_SCCC_CODE_MODE_D	59
 
-#define DTV_MAX_COMMAND				DTV_ATSCMH_SCCC_CODE_MODE_D
+#define DTV_INTERLEAVING			60
+
+#define DTV_MAX_COMMAND				DTV_INTERLEAVING
 
 typedef enum fe_pilot {
 	PILOT_ON,
@@ -366,7 +380,7 @@ typedef enum fe_delivery_system {
 	SYS_ISDBC,
 	SYS_ATSC,
 	SYS_ATSCMH,
-	SYS_DMBTH,
+	SYS_DTMB,
 	SYS_CMMB,
 	SYS_DAB,
 	SYS_DVBT2,
@@ -374,8 +388,9 @@ typedef enum fe_delivery_system {
 	SYS_DVBC_ANNEX_C,
 } fe_delivery_system_t;
 
-
+/* backward compatibility */
 #define SYS_DVBC_ANNEX_AC	SYS_DVBC_ANNEX_A
+#define SYS_DMBTH SYS_DTMB /* DMB-TH is legacy name, use DTMB instead */
 
 /* ATSC-MH */
 
diff --git a/include/linux/dvb/version.h b/include/linux/dvb/version.h
index 43d9e8d..70c2c7e 100644
--- a/include/linux/dvb/version.h
+++ b/include/linux/dvb/version.h
@@ -24,6 +24,6 @@
 #define _DVBVERSION_H_
 
 #define DVB_API_VERSION 5
-#define DVB_API_VERSION_MINOR 6
+#define DVB_API_VERSION_MINOR 7
 
 #endif /*_DVBVERSION_H_*/
-- 
1.7.11.2

