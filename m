Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:15285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217Ab1FHBqA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 21:46:00 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p581k0Ah030495
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:46:00 -0400
Received: from pedra (vpn-236-210.phx2.redhat.com [10.3.236.210])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p581jnc8007506
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:45:59 -0400
Date: Tue, 7 Jun 2011 22:45:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 07/15] [media] DocBook/dvbproperty.xml: Document the
 remaining S2API parameters
Message-ID: <20110607224534.0f4c5eae@pedra>
In-Reply-To: <cover.1307496835.git.mchehab@redhat.com>
References: <cover.1307496835.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There were lots of DVB S2API parameters that were never documented.
Let's add a definition for all of them, based on what's currently
used inside the core and the drivers.

The description here is not complete nor perfect, so patches
improving it are welcome.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 3a1ecb2..67a2deb 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -199,6 +199,208 @@ get/set up to 64 properties. The actual meaning of each property is described on
 
 <section id="fe_property_common">
 	<title>Parameters that are common to all Digital TV standards</title>
+	<section id="DTV-UNDEFINED">
+	<title><constant>DTV_UNDEFINED</constant></title>
+	<para>Used internally. A GET/SET operation for it won't change or return anything.</para>
+	</section>
+	<section id="DTV-TUNE">
+	<title><constant>DTV_TUNE</constant></title>
+	<para>Interpret the cache of data, build either a traditional frontend tunerequest so we can pass validation in the <constant>FE_SET_FRONTEND</constant> ioctl.</para>
+	</section>
+	<section id="DTV-CLEAR">
+	<title><constant>DTV_CLEAR</constant></title>
+	<para>Reset a cache of data specific to the frontend here. This does not effect hardware.</para>
+	</section>
+	<section id="DTV-MODULATION">
+	<title><constant>DTV_MODULATION</constant></title>
+<para>Specifies the frontend modulation type for cable and satellite types. The modulation can be one of the types bellow:</para>
+<programlisting>
+ typedef enum fe_modulation {
+	QPSK,
+	QAM_16,
+	QAM_32,
+	QAM_64,
+	QAM_128,
+	QAM_256,
+	QAM_AUTO,
+	VSB_8,
+	VSB_16,
+	PSK_8,
+	APSK_16,
+	APSK_32,
+	DQPSK,
+ } fe_modulation_t;
+</programlisting>
+	</section>
+	<section id="DTV-INVERSION">
+	<title><constant>DTV_INVERSION</constant></title>
+	<para>The Inversion field can take one of these values:
+	</para>
+	<programlisting>
+	typedef enum fe_spectral_inversion {
+		INVERSION_OFF,
+		INVERSION_ON,
+		INVERSION_AUTO
+	} fe_spectral_inversion_t;
+	</programlisting>
+	<para>It indicates if spectral inversion should be presumed or not. In the automatic setting
+	(<constant>INVERSION_AUTO</constant>) the hardware will try to figure out the correct setting by
+	itself.
+	</para>
+	</section>
+	<section id="DTV-DISEQC-MASTER">
+	<title><constant>DTV_DISEQC_MASTER</constant></title>
+	<para>Currently not implemented.</para>
+	</section>
+	<section id="DTV-SYMBOL-RATE">
+	<title><constant>DTV_SYMBOL_RATE</constant></title>
+	<para>Digital TV symbol rate, in bauds (symbols/second). Used on cable standards.</para>
+	</section>
+	<section id="DTV-INNER-FEC">
+	<title><constant>DTV_INNER_FEC</constant></title>
+	<para>Used cable/satellite transmissions. The acceptable values are:
+	</para>
+	<programlisting>
+typedef enum fe_code_rate {
+	FEC_NONE = 0,
+	FEC_1_2,
+	FEC_2_3,
+	FEC_3_4,
+	FEC_4_5,
+	FEC_5_6,
+	FEC_6_7,
+	FEC_7_8,
+	FEC_8_9,
+	FEC_AUTO,
+	FEC_3_5,
+	FEC_9_10,
+} fe_code_rate_t;
+	</programlisting>
+	<para>which correspond to error correction rates of 1/2, 2/3, etc.,
+	no error correction or auto detection.</para>
+	</section>
+	<section id="DTV-VOLTAGE">
+	<title><constant>DTV_VOLTAGE</constant></title>
+	<para>The voltage is usually used with non-DiSEqC capable LNBs to switch
+	the polarzation (horizontal/vertical). When using DiSEqC epuipment this
+	voltage has to be switched consistently to the DiSEqC commands as
+	described in the DiSEqC spec.</para>
+	<programlisting>
+		typedef enum fe_sec_voltage {
+		SEC_VOLTAGE_13,
+		SEC_VOLTAGE_18
+		} fe_sec_voltage_t;
+	</programlisting>
+	</section>
+	<section id="DTV-TONE">
+	<title><constant>DTV_TONE</constant></title>
+	<para>Currently not used.</para>
+	</section>
+	<section id="DTV-PILOT">
+	<title><constant>DTV_PILOT</constant></title>
+	<para>Sets DVB-S2 pilot</para>
+	<section id="fe-pilot-t">
+		<title>fe_pilot type</title>
+		<programlisting>
+typedef enum fe_pilot {
+	PILOT_ON,
+	PILOT_OFF,
+	PILOT_AUTO,
+} fe_pilot_t;
+		</programlisting>
+		</section>
+	</section>
+	<section id="DTV-ROLLOFF">
+	<title><constant>DTV_ROLLOFF</constant></title>
+		<para>Sets DVB-S2 rolloff</para>
+
+	<section id="fe-rolloff-t">
+		<title>fe_rolloff type</title>
+		<programlisting>
+typedef enum fe_rolloff {
+	ROLLOFF_35, /* Implied value in DVB-S, default for DVB-S2 */
+	ROLLOFF_20,
+	ROLLOFF_25,
+	ROLLOFF_AUTO,
+} fe_rolloff_t;
+		</programlisting>
+		</section>
+	</section>
+	<section id="DTV-DISEQC-SLAVE-REPLY">
+	<title><constant>DTV_DISEQC_SLAVE_REPLY</constant></title>
+	<para>Currently not implemented.</para>
+	</section>
+	<section id="DTV-FE-CAPABILITY-COUNT">
+	<title><constant>DTV_FE_CAPABILITY_COUNT</constant></title>
+	<para>Currently not implemented.</para>
+	</section>
+	<section id="DTV-FE-CAPABILITY">
+	<title><constant>DTV_FE_CAPABILITY</constant></title>
+	<para>Currently not implemented.</para>
+	</section>
+	<section id="DTV-API-VERSION">
+	<title><constant>DTV_API_VERSION</constant></title>
+	<para>Returns the major/minor version of the DVB API</para>
+	</section>
+	<section id="DTV-CODE-RATE-HP">
+	<title><constant>DTV_CODE_RATE_HP</constant></title>
+	<para>Used on terrestrial transmissions. The acceptable values are:
+	</para>
+	<programlisting>
+typedef enum fe_code_rate {
+	FEC_NONE = 0,
+	FEC_1_2,
+	FEC_2_3,
+	FEC_3_4,
+	FEC_4_5,
+	FEC_5_6,
+	FEC_6_7,
+	FEC_7_8,
+	FEC_8_9,
+	FEC_AUTO,
+	FEC_3_5,
+	FEC_9_10,
+} fe_code_rate_t;
+	</programlisting>
+	</section>
+	<section id="DTV-CODE-RATE-LP">
+	<title><constant>DTV_CODE_RATE_LP</constant></title>
+	<para>Used on terrestrial transmissions. The acceptable values are:
+	</para>
+	<programlisting>
+typedef enum fe_code_rate {
+	FEC_NONE = 0,
+	FEC_1_2,
+	FEC_2_3,
+	FEC_3_4,
+	FEC_4_5,
+	FEC_5_6,
+	FEC_6_7,
+	FEC_7_8,
+	FEC_8_9,
+	FEC_AUTO,
+	FEC_3_5,
+	FEC_9_10,
+} fe_code_rate_t;
+	</programlisting>
+	</section>
+	<section id="DTV-HIERARCHY">
+	<title><constant>DTV_HIERARCHY</constant></title>
+	<para>Frontend hierarchy</para>
+	<programlisting>
+typedef enum fe_hierarchy {
+	 HIERARCHY_NONE,
+	 HIERARCHY_1,
+	 HIERARCHY_2,
+	 HIERARCHY_4,
+	 HIERARCHY_AUTO
+ } fe_hierarchy_t;
+	</programlisting>
+	</section>
+	<section id="DTV-ISDBS-TS-ID">
+	<title><constant>DTV_ISDBS_TS_ID</constant></title>
+	<para>Currently unused.</para>
+	</section>
 	<section id="DTV-FREQUENCY">
 		<title><constant>DTV_FREQUENCY</constant></title>
 
@@ -573,7 +775,7 @@ typedef enum fe_guard_interval {
 	</section>
 	<section id="dvbt2-params">
 		<title>DVB-T2 parameters</title>
-		
+
 		<para>This section covers parameters that apply only to the DVB-T2 delivery method. DVB-T2
 			support is currently in the early stages development so expect this section to grow
 			and become more detailed with time.</para>
-- 
1.7.1


