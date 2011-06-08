Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:50392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab1FHBp6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 21:45:58 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p581jvU0001152
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:45:57 -0400
Received: from pedra (vpn-236-210.phx2.redhat.com [10.3.236.210])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p581jnc6007506
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:45:56 -0400
Date: Tue, 7 Jun 2011 22:45:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 05/15] [media] DocBook/frontend.xml: add references for some
 missing info
Message-ID: <20110607224533.20707706@pedra>
In-Reply-To: <cover.1307496835.git.mchehab@redhat.com>
References: <cover.1307496835.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The frontend.h.xml now references to the main document. However,
several references are missed.

Links the trivial ones with the corresponding API descriptions.

While here, updates the main API to reflect the API improvements.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 3036070..f2216b0 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -120,13 +120,13 @@ DOCUMENTED = \
 	-e "s/v4l2\-mpeg\-vbi\-ITV0/v4l2-mpeg-vbi-itv0-1/g"
 
 DVB_DOCUMENTED = \
-	-e "s,\(define\s\+\)\([A-Z0-9_]\+\)\(\s\+_IO\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 	-e "s/\(linkend\=\"\)FE_SET_PROPERTY/\1FE_GET_PROPERTY/g" \
 	-e "s,\(struct\s\+\)\([a-z0-9_]\+\)\(\s\+{\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 	-e "s,\(}\s\+\)\([a-z0-9_]\+_t\+\),\1\<link linkend=\"\2\">\2\<\/link\>,g" \
 	-e "s,\(define\s\+\)\(DTV_[A-Z0-9_]\+\)\(\s\+[0-9]\+\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 	-e ":a;s/\(linkend=\".*\)_\(.*\">\)/\1-\2/;ta" \
 	-e "s,DTV-ISDBT-LAYER[A-C],DTV-ISDBT-LAYER,g" \
+	-e "s,\(define\s\+\)\([A-Z0-9_]\+\)\(\s\+_IO\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 #	-e "s,\(\s\+\)\(FE_[A-Z0-9_]\+\)\([\s\=\,]*\),\1\<link linkend=\"\2\">\2\<\/link\>\3,g" \
 
 #
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 65a790e..a925b45 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -65,7 +65,7 @@ supported via the new <link linkend="FE_GET_SET_PROPERTY">FE_GET_PROPERTY/FE_GET
 </para>
 </section>
 
-<section id="frontend_caps">
+<section id="fe-caps-t">
 <title>frontend capabilities</title>
 
 <para>Capabilities describe what a frontend can do. Some capabilities can only be supported for
@@ -106,7 +106,7 @@ a specific frontend type.</para>
 </programlisting>
 </section>
 
-<section id="frontend_info">
+<section id="dvb-frontend-info">
 <title>frontend information</title>
 
 <para>Information about the frontend ca be queried with
@@ -129,7 +129,7 @@ a specific frontend type.</para>
 </programlisting>
 </section>
 
-<section id="frontend_diseqc">
+<section id="dvb-diseqc-master-cmd">
 <title>diseqc master command</title>
 
 <para>A message sent from the frontend to DiSEqC capable equipment.</para>
@@ -153,7 +153,7 @@ a specific frontend type.</para>
 </programlisting>
 </section>
 
-<section id="frontend_diseqc_slave_reply">
+<section id="fe-sec-voltage-t">
 <title>diseqc slave reply</title>
 <para>The voltage is usually used with non-DiSEqC capable LNBs to switch the polarzation
 (horizontal/vertical). When using DiSEqC epuipment this voltage has to be switched
@@ -166,7 +166,7 @@ consistently to the DiSEqC commands as described in the DiSEqC spec.</para>
 </programlisting>
 </section>
 
-<section id="frontend_sec_tone">
+<section id="fe-sec-tone-mode-t">
 <title>SEC continuous tone</title>
 
 <para>The continuous 22KHz tone is usually used with non-DiSEqC capable LNBs to switch the
@@ -181,7 +181,7 @@ spec.</para>
 </programlisting>
 </section>
 
-<section id="frontend_sec_burst">
+<section id="fe-sec-mini-cmd-t">
 <title>SEC tone burst</title>
 
 <para>The 22KHz tone burst is usually used with non-DiSEqC capable switches to select
@@ -198,7 +198,7 @@ spec.</para>
 <para></para>
 </section>
 
-<section id="frontend_status">
+<section id="fe-status-t">
 <title>frontend status</title>
 <para>Several functions of the frontend device use the fe_status data type defined
 by</para>
@@ -218,31 +218,42 @@ by</para>
 
 </section>
 
-<section id="frontend_params">
+<section id="dvb-frontend-parameters">
 <title>frontend parameters</title>
 <para>The kind of parameters passed to the frontend device for tuning depend on
 the kind of hardware you are using. All kinds of parameters are combined as an
 union in the FrontendParameters structure:</para>
 <programlisting>
- struct dvb_frontend_parameters {
-	 uint32_t frequency;       /&#x22C6; (absolute) frequency in Hz for QAM/OFDM &#x22C6;/
-				   /&#x22C6; intermediate frequency in kHz for QPSK &#x22C6;/
-	 fe_spectral_inversion_t inversion;
-	 union {
-		 struct dvb_qpsk_parameters qpsk;
-		 struct dvb_qam_parameters  qam;
-		 struct dvb_ofdm_parameters ofdm;
-	 } u;
- };
+struct dvb_frontend_parameters {
+	uint32_t frequency;     /&#x22C6; (absolute) frequency in Hz for QAM/OFDM &#x22C6;/
+				/&#x22C6; intermediate frequency in kHz for QPSK &#x22C6;/
+	fe_spectral_inversion_t inversion;
+	union {
+		struct dvb_qpsk_parameters qpsk;
+		struct dvb_qam_parameters  qam;
+		struct dvb_ofdm_parameters ofdm;
+		struct dvb_vsb_parameters  vsb;
+	} u;
+};
 </programlisting>
-<para>For satellite QPSK frontends you have to use the <constant>QPSKParameters</constant> member defined by</para>
+<para>In the case of QPSK frontends the <constant>frequency</constant> field specifies the intermediate
+frequency, i.e. the offset which is effectively added to the local oscillator frequency (LOF) of
+the LNB. The intermediate frequency has to be specified in units of kHz. For QAM and
+OFDM frontends the <constant>frequency</constant> specifies the absolute frequency and is given in Hz.
+</para>
+<section id="dvb-qpsk-parameters">
+<title>QPSK parameters</title>
+<para>For satellite QPSK frontends you have to use the <constant>dvb_qpsk_parameters</constant> structure:</para>
 <programlisting>
  struct dvb_qpsk_parameters {
 	 uint32_t        symbol_rate;  /&#x22C6; symbol rate in Symbols per second &#x22C6;/
 	 fe_code_rate_t  fec_inner;    /&#x22C6; forward error correction (see above) &#x22C6;/
  };
 </programlisting>
-<para>for cable QAM frontend you use the <constant>QAMParameters</constant> structure</para>
+</section>
+<section id="dvb-qam-parameters">
+<title>QAM parameters</title>
+<para>for cable QAM frontend you use the <constant>dvb_qam_parameters</constant> structure:</para>
 <programlisting>
  struct dvb_qam_parameters {
 	 uint32_t         symbol_rate; /&#x22C6; symbol rate in Symbols per second &#x22C6;/
@@ -250,8 +261,10 @@ union in the FrontendParameters structure:</para>
 	 fe_modulation_t  modulation;  /&#x22C6; modulation type (see above) &#x22C6;/
  };
 </programlisting>
-<para>DVB-T frontends are supported by the <constant>OFDMParamters</constant> structure
-</para>
+</section>
+<section id="dvb-ofdm-parameters">
+<title>OFDM parameters</title>
+<para>DVB-T frontends are supported by the <constant>dvb_ofdm_parameters</constant> structure:</para>
 <programlisting>
  struct dvb_ofdm_parameters {
 	 fe_bandwidth_t      bandwidth;
@@ -263,86 +276,128 @@ union in the FrontendParameters structure:</para>
 	 fe_hierarchy_t      hierarchy_information;
  };
 </programlisting>
-<para>In the case of QPSK frontends the <constant>Frequency</constant> field specifies the intermediate
-frequency, i.e. the offset which is effectively added to the local oscillator frequency (LOF) of
-the LNB. The intermediate frequency has to be specified in units of kHz. For QAM and
-OFDM frontends the Frequency specifies the absolute frequency and is given in
-Hz.
-</para>
+</section>
+<section id="dvb-vsb-parameters">
+<title>VSB parameters</title>
+<para>DVB-T frontends are supported by the <constant>dvb_vsb_parameters</constant> structure:</para>
+<programlisting>
+struct dvb_vsb_parameters {
+	fe_modulation_t modulation;	/&#x22C6; modulation type (see above) &#x22C6;/
+};
+</programlisting>
+</section>
+<section id="fe-spectral-inversion-t">
+<title>frontend spectral inversion</title>
 <para>The Inversion field can take one of these values:
 </para>
 <programlisting>
- typedef enum fe_spectral_inversion {
-	 INVERSION_OFF,
-	 INVERSION_ON,
-	 INVERSION_AUTO
- } fe_spectral_inversion_t;
+typedef enum fe_spectral_inversion {
+	INVERSION_OFF,
+	INVERSION_ON,
+	INVERSION_AUTO
+} fe_spectral_inversion_t;
 </programlisting>
 <para>It indicates if spectral inversion should be presumed or not. In the automatic setting
 (<constant>INVERSION_AUTO</constant>) the hardware will try to figure out the correct setting by
 itself.
 </para>
+</section>
+<section id="fe-code-rate-t">
+<title>frontend code rate</title>
 <para>The possible values for the <constant>FEC_inner</constant> field are
 </para>
 <programlisting>
- typedef enum fe_code_rate {
-	 FEC_NONE = 0,
-	 FEC_1_2,
-	 FEC_2_3,
-	 FEC_3_4,
-	 FEC_4_5,
-	 FEC_5_6,
-	 FEC_6_7,
-	 FEC_7_8,
-	 FEC_8_9,
-	 FEC_AUTO
- } fe_code_rate_t;
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
 </programlisting>
 <para>which correspond to error correction rates of 1/2, 2/3, etc., no error correction or auto
 detection.
 </para>
+</section>
+<section id="fe-modulation-t">
+<title>frontend modulation type for QAM and OFDM</title>
 <para>For cable and terrestrial frontends (QAM and OFDM) one also has to specify the quadrature
 modulation mode which can be one of the following:
 </para>
 <programlisting>
  typedef enum fe_modulation {
- QPSK,
-	 QAM_16,
-	 QAM_32,
-	 QAM_64,
-	 QAM_128,
-	 QAM_256,
-	 QAM_AUTO
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
  } fe_modulation_t;
 </programlisting>
+</section>
 <para>Finally, there are several more parameters for OFDM:
 </para>
+<section id="fe-transmit-mode-t">
+<title>Number of carriers per channel, on OFTM modulation</title>
 <programlisting>
- typedef enum fe_transmit_mode {
-	 TRANSMISSION_MODE_2K,
-	 TRANSMISSION_MODE_8K,
-	 TRANSMISSION_MODE_AUTO
+typedef enum fe_transmit_mode {
+	TRANSMISSION_MODE_2K,
+	TRANSMISSION_MODE_8K,
+	TRANSMISSION_MODE_AUTO,
+	TRANSMISSION_MODE_4K,
+	TRANSMISSION_MODE_1K,
+	TRANSMISSION_MODE_16K,
+	TRANSMISSION_MODE_32K,
  } fe_transmit_mode_t;
 </programlisting>
- <programlisting>
- typedef enum fe_bandwidth {
-	 BANDWIDTH_8_MHZ,
-	 BANDWIDTH_7_MHZ,
-	 BANDWIDTH_6_MHZ,
-	 BANDWIDTH_AUTO
- } fe_bandwidth_t;
+</section>
+<section id="fe-bandwidth-t">
+<title>frontend bandwidth</title>
+<programlisting>
+typedef enum fe_bandwidth {
+	BANDWIDTH_8_MHZ,
+	BANDWIDTH_7_MHZ,
+	BANDWIDTH_6_MHZ,
+	BANDWIDTH_AUTO,
+	BANDWIDTH_5_MHZ,
+	BANDWIDTH_10_MHZ,
+	BANDWIDTH_1_712_MHZ,
+} fe_bandwidth_t;
 </programlisting>
- <programlisting>
- typedef enum fe_guard_interval {
-	 GUARD_INTERVAL_1_32,
-	 GUARD_INTERVAL_1_16,
-	 GUARD_INTERVAL_1_8,
-	 GUARD_INTERVAL_1_4,
-	 GUARD_INTERVAL_AUTO
- } fe_guard_interval_t;
+</section>
+<section id="fe-guard-interval-t">
+<title>frontend guard inverval</title>
+<programlisting>
+typedef enum fe_guard_interval {
+	GUARD_INTERVAL_1_32,
+	GUARD_INTERVAL_1_16,
+	GUARD_INTERVAL_1_8,
+	GUARD_INTERVAL_1_4,
+	GUARD_INTERVAL_AUTO,
+	GUARD_INTERVAL_1_128,
+	GUARD_INTERVAL_19_128,
+	GUARD_INTERVAL_19_256,
+} fe_guard_interval_t;
 </programlisting>
- <programlisting>
- typedef enum fe_hierarchy {
+</section>
+<section id="fe-hierarchy-t">
+<title>frontend hierarchy</title>
+<programlisting>
+typedef enum fe_hierarchy {
 	 HIERARCHY_NONE,
 	 HIERARCHY_1,
 	 HIERARCHY_2,
@@ -350,10 +405,11 @@ modulation mode which can be one of the following:
 	 HIERARCHY_AUTO
  } fe_hierarchy_t;
 </programlisting>
+</section>
 
 </section>
 
-<section id="frontend_events">
+<section id="dvb-frontend-event">
 <title>frontend events</title>
  <programlisting>
  struct dvb_frontend_event {
-- 
1.7.1


