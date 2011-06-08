Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:28302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217Ab1FHBp7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 21:45:59 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p581jwKH006725
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:45:58 -0400
Received: from pedra (vpn-236-210.phx2.redhat.com [10.3.236.210])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p581jnc7007506
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:45:58 -0400
Date: Tue, 7 Jun 2011 22:45:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 06/15] [media] DocBook/frontend.xml: Better describe the
 frontend parameters
Message-ID: <20110607224533.0faaa965@pedra>
In-Reply-To: <cover.1307496835.git.mchehab@redhat.com>
References: <cover.1307496835.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Update the DVB parameter structs to reflect VSB modulation and
improve a few descriptions.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index a925b45..b1f0123 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -262,6 +262,15 @@ OFDM frontends the <constant>frequency</constant> specifies the absolute frequen
  };
 </programlisting>
 </section>
+<section id="dvb-vsb-parameters">
+<title>VSB parameters</title>
+<para>DVB-T frontends are supported by the <constant>dvb_vsb_parameters</constant> structure:</para>
+<programlisting>
+struct dvb_vsb_parameters {
+	fe_modulation_t modulation;	/&#x22C6; modulation type (see above) &#x22C6;/
+};
+</programlisting>
+</section>
 <section id="dvb-ofdm-parameters">
 <title>OFDM parameters</title>
 <para>DVB-T frontends are supported by the <constant>dvb_ofdm_parameters</constant> structure:</para>
@@ -277,15 +286,6 @@ OFDM frontends the <constant>frequency</constant> specifies the absolute frequen
  };
 </programlisting>
 </section>
-<section id="dvb-vsb-parameters">
-<title>VSB parameters</title>
-<para>DVB-T frontends are supported by the <constant>dvb_vsb_parameters</constant> structure:</para>
-<programlisting>
-struct dvb_vsb_parameters {
-	fe_modulation_t modulation;	/&#x22C6; modulation type (see above) &#x22C6;/
-};
-</programlisting>
-</section>
 <section id="fe-spectral-inversion-t">
 <title>frontend spectral inversion</title>
 <para>The Inversion field can take one of these values:
@@ -304,7 +304,9 @@ itself.
 </section>
 <section id="fe-code-rate-t">
 <title>frontend code rate</title>
-<para>The possible values for the <constant>FEC_inner</constant> field are
+<para>The possible values for the <constant>fec_inner</constant> field used on
+<link refend="dvb-qpsk-parameters"><constant>struct dvb_qpsk_parameters</constant></link> and
+<link refend="dvb-qam-parameters"><constant>struct dvb_qam_parameters</constant></link> are:
 </para>
 <programlisting>
 typedef enum fe_code_rate {
@@ -327,9 +329,12 @@ detection.
 </para>
 </section>
 <section id="fe-modulation-t">
-<title>frontend modulation type for QAM and OFDM</title>
-<para>For cable and terrestrial frontends (QAM and OFDM) one also has to specify the quadrature
-modulation mode which can be one of the following:
+<title>frontend modulation type for QAM, OFDM and VSB</title>
+<para>For cable and terrestrial frontends, e. g. for
+<link refend="dvb-qam-parameters"><constant>struct dvb_qpsk_parameters</constant></link>,
+<link refend="dvb-ofdm-parameters"><constant>struct dvb_qam_parameters</constant></link> and
+<link refend="dvb-vsb-parameters"><constant>struct dvb_qam_parameters</constant></link>,
+it needs to specify the quadrature modulation mode which can be one of the following:
 </para>
 <programlisting>
  typedef enum fe_modulation {
@@ -352,7 +357,7 @@ modulation mode which can be one of the following:
 <para>Finally, there are several more parameters for OFDM:
 </para>
 <section id="fe-transmit-mode-t">
-<title>Number of carriers per channel, on OFTM modulation</title>
+<title>Number of carriers per channel</title>
 <programlisting>
 typedef enum fe_transmit_mode {
 	TRANSMISSION_MODE_2K,
-- 
1.7.1


