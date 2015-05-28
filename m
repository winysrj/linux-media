Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51521 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbbE1Vtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 06/35] DocBook: move DVBv3 frontend bits to a separate section
Date: Thu, 28 May 2015 18:49:09 -0300
Message-Id: <dd39c693289437db4097b64441e499983466273d.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Although the recommended usage is the DVBv5 API calls, the
documentation doesn't make it clear about what's the recommended
calls and what's legacy.

So, move the legacy API bits to a separate xml, putting them into
a new section.

Please notice that more changes are needed, since some of the
bits there are cross-referenced elsewhere.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

 create mode 100644 Documentation/DocBook/media/dvb/frontend_legacy_api.xml

diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 98443c4c2818..3b3973aee8eb 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -29,58 +29,6 @@
 specification is available at
 <ulink url="http://www.eutelsat.com/satellites/4_5_5.html">Eutelsat</ulink>.</para>
 
-<section id="frontend_types">
-<title>Frontend Data Types</title>
-
-<section id="fe-type-t">
-<title>Frontend type</title>
-
-<para>For historical reasons, frontend types are named by the type of modulation
-    used in transmission. The fontend types are given by fe_type_t type, defined as:</para>
-
-<table pgwide="1" frame="none" id="fe-type">
-<title>Frontend types</title>
-<tgroup cols="3">
-   &cs-def;
-   <thead>
-     <row>
-       <entry>fe_type</entry>
-       <entry>Description</entry>
-       <entry><link linkend="DTV-DELIVERY-SYSTEM">DTV_DELIVERY_SYSTEM</link> equivalent type</entry>
-     </row>
-  </thead>
-  <tbody valign="top">
-  <row>
-     <entry id="FE_QPSK"><constant>FE_QPSK</constant></entry>
-     <entry>For DVB-S standard</entry>
-     <entry><constant>SYS_DVBS</constant></entry>
-  </row>
-  <row>
-     <entry id="FE_QAM"><constant>FE_QAM</constant></entry>
-     <entry>For DVB-C annex A standard</entry>
-     <entry><constant>SYS_DVBC_ANNEX_A</constant></entry>
-  </row>
-  <row>
-     <entry id="FE_OFDM"><constant>FE_OFDM</constant></entry>
-     <entry>For DVB-T standard</entry>
-     <entry><constant>SYS_DVBT</constant></entry>
-  </row>
-  <row>
-     <entry id="FE_ATSC"><constant>FE_ATSC</constant></entry>
-     <entry>For ATSC standard (terrestrial) or for DVB-C Annex B (cable) used in US.</entry>
-     <entry><constant>SYS_ATSC</constant> (terrestrial) or <constant>SYS_DVBC_ANNEX_B</constant> (cable)</entry>
-  </row>
-</tbody></tgroup></table>
-
-<para>Newer formats like DVB-S2, ISDB-T, ISDB-S and DVB-T2 are not described at the above, as they're
-supported via the new <link linkend="FE_GET_SET_PROPERTY">FE_GET_PROPERTY/FE_GET_SET_PROPERTY</link> ioctl's, using the <link linkend="DTV-DELIVERY-SYSTEM">DTV_DELIVERY_SYSTEM</link> parameter.
-</para>
-
-<para>The usage of this field is deprecated, as it doesn't report all supported standards, and
-will provide an incomplete information for frontends that support multiple delivery systems.
-Please use <link linkend="DTV-ENUM-DELSYS">DTV_ENUM_DELSYS</link> instead.</para>
-</section>
-
 <section id="fe-caps-t">
 <title>frontend capabilities</title>
 
@@ -157,6 +105,7 @@ a specific frontend type.</para>
 	};
 </programlisting>
 </section>
+
 <section role="subsection" id="dvb-diseqc-slave-reply">
 <title>diseqc slave reply</title>
 
@@ -258,90 +207,8 @@ typedef enum fe_status {
 recommended to reset DiSEqC, tone and parameters</entry>
 </row>
 </tbody></tgroup></informaltable>
-
 </section>
 
-<section id="dvb-frontend-parameters">
-<title>frontend parameters</title>
-<para>The kind of parameters passed to the frontend device for tuning depend on
-the kind of hardware you are using.</para>
-<para>The struct <constant>dvb_frontend_parameters</constant> uses an
-union with specific per-system parameters. However, as newer delivery systems
-required more data, the structure size weren't enough to fit, and just
-extending its size would break the existing applications. So, those parameters
-were replaced by the usage of <link linkend="FE_GET_SET_PROPERTY">
-<constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant></link> ioctl's. The
-new API is flexible enough to add new parameters to existing delivery systems,
-and to add newer delivery systems.</para>
-<para>So, newer applications should use <link linkend="FE_GET_SET_PROPERTY">
-<constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant></link> instead, in
-order to be able to support the newer System Delivery like  DVB-S2, DVB-T2,
-DVB-C2, ISDB, etc.</para>
-<para>All kinds of parameters are combined as an union in the FrontendParameters structure:
-<programlisting>
-struct dvb_frontend_parameters {
-	uint32_t frequency;     /&#x22C6; (absolute) frequency in Hz for QAM/OFDM &#x22C6;/
-				/&#x22C6; intermediate frequency in kHz for QPSK &#x22C6;/
-	fe_spectral_inversion_t inversion;
-	union {
-		struct dvb_qpsk_parameters qpsk;
-		struct dvb_qam_parameters  qam;
-		struct dvb_ofdm_parameters ofdm;
-		struct dvb_vsb_parameters  vsb;
-	} u;
-};
-</programlisting></para>
-<para>In the case of QPSK frontends the <constant>frequency</constant> field specifies the intermediate
-frequency, i.e. the offset which is effectively added to the local oscillator frequency (LOF) of
-the LNB. The intermediate frequency has to be specified in units of kHz. For QAM and
-OFDM frontends the <constant>frequency</constant> specifies the absolute frequency and is given in Hz.
-</para>
-
-<section id="dvb-qpsk-parameters">
-<title>QPSK parameters</title>
-<para>For satellite QPSK frontends you have to use the <constant>dvb_qpsk_parameters</constant> structure:</para>
-<programlisting>
- struct dvb_qpsk_parameters {
-	 uint32_t        symbol_rate;  /&#x22C6; symbol rate in Symbols per second &#x22C6;/
-	 fe_code_rate_t  fec_inner;    /&#x22C6; forward error correction (see above) &#x22C6;/
- };
-</programlisting>
-</section>
-<section id="dvb-qam-parameters">
-<title>QAM parameters</title>
-<para>for cable QAM frontend you use the <constant>dvb_qam_parameters</constant> structure:</para>
-<programlisting>
- struct dvb_qam_parameters {
-	 uint32_t         symbol_rate; /&#x22C6; symbol rate in Symbols per second &#x22C6;/
-	 fe_code_rate_t   fec_inner;   /&#x22C6; forward error correction (see above) &#x22C6;/
-	 fe_modulation_t  modulation;  /&#x22C6; modulation type (see above) &#x22C6;/
- };
-</programlisting>
-</section>
-<section id="dvb-vsb-parameters">
-<title>VSB parameters</title>
-<para>ATSC frontends are supported by the <constant>dvb_vsb_parameters</constant> structure:</para>
-<programlisting>
-struct dvb_vsb_parameters {
-	fe_modulation_t modulation;	/&#x22C6; modulation type (see above) &#x22C6;/
-};
-</programlisting>
-</section>
-<section id="dvb-ofdm-parameters">
-<title>OFDM parameters</title>
-<para>DVB-T frontends are supported by the <constant>dvb_ofdm_parameters</constant> structure:</para>
-<programlisting>
- struct dvb_ofdm_parameters {
-	 fe_bandwidth_t      bandwidth;
-	 fe_code_rate_t      code_rate_HP;  /&#x22C6; high priority stream code rate &#x22C6;/
-	 fe_code_rate_t      code_rate_LP;  /&#x22C6; low priority stream code rate &#x22C6;/
-	 fe_modulation_t     constellation; /&#x22C6; modulation type (see above) &#x22C6;/
-	 fe_transmit_mode_t  transmission_mode;
-	 fe_guard_interval_t guard_interval;
-	 fe_hierarchy_t      hierarchy_information;
- };
-</programlisting>
-</section>
 <section id="fe-spectral-inversion-t">
 <title>frontend spectral inversion</title>
 <para>The Inversion field can take one of these values:
@@ -358,6 +225,7 @@ typedef enum fe_spectral_inversion {
 itself.
 </para>
 </section>
+
 <section id="fe-code-rate-t">
 <title>frontend code rate</title>
 <para>The possible values for the <constant>fec_inner</constant> field used on
@@ -384,6 +252,7 @@ typedef enum fe_code_rate {
 detection.
 </para>
 </section>
+
 <section id="fe-modulation-t">
 <title>frontend modulation type for QAM, OFDM and VSB</title>
 <para>For cable and terrestrial frontends, e. g. for
@@ -410,8 +279,10 @@ it needs to specify the quadrature modulation mode which can be one of the follo
  } fe_modulation_t;
 </programlisting>
 </section>
+
 <section>
 <title>More OFDM parameters</title>
+
 <section id="fe-transmit-mode-t">
 <title>Number of carriers per channel</title>
 <programlisting>
@@ -426,6 +297,7 @@ typedef enum fe_transmit_mode {
  } fe_transmit_mode_t;
 </programlisting>
 </section>
+
 <section id="fe-bandwidth-t">
 <title>frontend bandwidth</title>
 <programlisting>
@@ -440,6 +312,7 @@ typedef enum fe_bandwidth {
 } fe_bandwidth_t;
 </programlisting>
 </section>
+
 <section id="fe-guard-interval-t">
 <title>frontend guard inverval</title>
 <programlisting>
@@ -455,6 +328,7 @@ typedef enum fe_guard_interval {
 } fe_guard_interval_t;
 </programlisting>
 </section>
+
 <section id="fe-hierarchy-t">
 <title>frontend hierarchy</title>
 <programlisting>
@@ -467,22 +341,9 @@ typedef enum fe_hierarchy {
  } fe_hierarchy_t;
 </programlisting>
 </section>
-</section>
-
-</section>
 
-<section id="dvb-frontend-event">
-<title>frontend events</title>
- <programlisting>
- struct dvb_frontend_event {
-	 fe_status_t status;
-	 struct dvb_frontend_parameters parameters;
- };
-</programlisting>
- </section>
 </section>
 
-
 <section id="frontend_fcalls">
 <title>Frontend Function Calls</title>
 
@@ -694,417 +555,6 @@ typedef enum fe_hierarchy {
  </row></tbody></tgroup></informaltable>
 </section>
 
-<section id="FE_READ_BER">
-<title>FE_READ_BER</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This ioctl call returns the bit error rate for the signal currently
- received/demodulated by the front-end. For this command, read-only access to
- the device is sufficient.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int ioctl(int fd, int request = <link linkend="FE_READ_BER">FE_READ_BER</link>,
- uint32_t &#x22C6;ber);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>int fd</para>
-</entry><entry
- align="char">
-<para>File descriptor returned by a previous call to open().</para>
-</entry>
- </row><row><entry
- align="char">
-<para>int request</para>
-</entry><entry
- align="char">
-<para>Equals <link linkend="FE_READ_BER">FE_READ_BER</link> for this command.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>uint32_t *ber</para>
-</entry><entry
- align="char">
-<para>The bit error rate is stored into *ber.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-&return-value-dvb;
-</section>
-
-<section id="FE_READ_SNR">
-<title>FE_READ_SNR</title>
-
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This ioctl call returns the signal-to-noise ratio for the signal currently received
- by the front-end. For this command, read-only access to the device is sufficient.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int ioctl(int fd, int request = <link linkend="FE_READ_SNR">FE_READ_SNR</link>, uint16_t
- &#x22C6;snr);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>int fd</para>
-</entry><entry
- align="char">
-<para>File descriptor returned by a previous call to open().</para>
-</entry>
- </row><row><entry
- align="char">
-<para>int request</para>
-</entry><entry
- align="char">
-<para>Equals <link linkend="FE_READ_SNR">FE_READ_SNR</link> for this command.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>uint16_t *snr</para>
-</entry><entry
- align="char">
-<para>The signal-to-noise ratio is stored into *snr.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-&return-value-dvb;
-</section>
-
-<section id="FE_READ_SIGNAL_STRENGTH">
-<title>FE_READ_SIGNAL_STRENGTH</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This ioctl call returns the signal strength value for the signal currently received
- by the front-end. For this command, read-only access to the device is sufficient.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int ioctl( int fd, int request =
- <link linkend="FE_READ_SIGNAL_STRENGTH">FE_READ_SIGNAL_STRENGTH</link>, uint16_t &#x22C6;strength);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>int fd</para>
-</entry><entry
- align="char">
-<para>File descriptor returned by a previous call to open().</para>
-</entry>
- </row><row><entry
- align="char">
-<para>int request</para>
-</entry><entry
- align="char">
-<para>Equals <link linkend="FE_READ_SIGNAL_STRENGTH">FE_READ_SIGNAL_STRENGTH</link> for this
- command.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>uint16_t *strength</para>
-</entry><entry
- align="char">
-<para>The signal strength value is stored into *strength.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-&return-value-dvb;
-</section>
-
-<section id="FE_READ_UNCORRECTED_BLOCKS">
-<title>FE_READ_UNCORRECTED_BLOCKS</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This ioctl call returns the number of uncorrected blocks detected by the device
- driver during its lifetime. For meaningful measurements, the increment in block
- count during a specific time interval should be calculated. For this command,
- read-only access to the device is sufficient.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>Note that the counter will wrap to zero after its maximum count has been
- reached.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int ioctl( int fd, int request =
- <link linkend="FE_READ_UNCORRECTED_BLOCKS">FE_READ_UNCORRECTED_BLOCKS</link>, uint32_t &#x22C6;ublocks);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>int fd</para>
-</entry><entry
- align="char">
-<para>File descriptor returned by a previous call to open().</para>
-</entry>
- </row><row><entry
- align="char">
-<para>int request</para>
-</entry><entry
- align="char">
-<para>Equals <link linkend="FE_READ_UNCORRECTED_BLOCKS">FE_READ_UNCORRECTED_BLOCKS</link> for this
- command.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>uint32_t *ublocks</para>
-</entry><entry
- align="char">
-<para>The total number of uncorrected blocks seen by the driver
- so far.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-&return-value-dvb;
-</section>
-
-<section id="FE_SET_FRONTEND">
-<title>FE_SET_FRONTEND</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This ioctl call starts a tuning operation using specified parameters. The result
- of this call will be successful if the parameters were valid and the tuning could
- be initiated. The result of the tuning operation in itself, however, will arrive
- asynchronously as an event (see documentation for <link linkend="FE_GET_EVENT">FE_GET_EVENT</link> and
- FrontendEvent.) If a new <link linkend="FE_SET_FRONTEND">FE_SET_FRONTEND</link> operation is initiated before
- the previous one was completed, the previous operation will be aborted in favor
- of the new one. This command requires read/write access to the device.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int ioctl(int fd, int request = <link linkend="FE_SET_FRONTEND">FE_SET_FRONTEND</link>,
- struct dvb_frontend_parameters &#x22C6;p);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>int fd</para>
-</entry><entry
- align="char">
-<para>File descriptor returned by a previous call to open().</para>
-</entry>
- </row><row><entry
- align="char">
-<para>int request</para>
-</entry><entry
- align="char">
-<para>Equals <link linkend="FE_SET_FRONTEND">FE_SET_FRONTEND</link> for this command.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>struct
- dvb_frontend_parameters
- *p</para>
-</entry><entry
- align="char">
-<para>Points to parameters for tuning operation.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-&return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>Maximum supported symbol rate reached.</para>
-</entry>
-</row></tbody></tgroup></informaltable>
-</section>
-
-<section id="FE_GET_FRONTEND">
-<title>FE_GET_FRONTEND</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This ioctl call queries the currently effective frontend parameters. For this
- command, read-only access to the device is sufficient.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int ioctl(int fd, int request = <link linkend="FE_GET_FRONTEND">FE_GET_FRONTEND</link>,
- struct dvb_frontend_parameters &#x22C6;p);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>int fd</para>
-</entry><entry
- align="char">
-<para>File descriptor returned by a previous call to open().</para>
-</entry>
- </row><row><entry
- align="char">
-<para>int request</para>
-</entry><entry
- align="char">
-<para>Equals <link linkend="FE_SET_FRONTEND">FE_SET_FRONTEND</link> for this command.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>struct
- dvb_frontend_parameters
- *p</para>
-</entry><entry
- align="char">
-<para>Points to parameters for tuning operation.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-&return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EINVAL</para>
-</entry><entry
- align="char">
-<para>Maximum supported symbol rate reached.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-</section>
-
-<section id="FE_GET_EVENT">
-<title>FE_GET_EVENT</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This ioctl call returns a frontend event if available. If an event is not
- available, the behavior depends on whether the device is in blocking or
- non-blocking mode. In the latter case, the call fails immediately with errno
- set to EWOULDBLOCK. In the former case, the call blocks until an event
- becomes available.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>The standard Linux poll() and/or select() system calls can be used with the
- device file descriptor to watch for new events. For select(), the file descriptor
- should be included in the exceptfds argument, and for poll(), POLLPRI should
- be specified as the wake-up condition. Since the event queue allocated is
- rather small (room for 8 events), the queue must be serviced regularly to avoid
- overflow. If an overflow happens, the oldest event is discarded from the queue,
- and an error (EOVERFLOW) occurs the next time the queue is read. After
- reporting the error condition in this fashion, subsequent
- <link linkend="FE_GET_EVENT">FE_GET_EVENT</link>
- calls will return events from the queue as usual.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>For the sake of implementation simplicity, this command requires read/write
- access to the device.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-<para>SYNOPSIS
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>int ioctl(int fd, int request = QPSK_GET_EVENT,
- struct dvb_frontend_event &#x22C6;ev);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-<para>PARAMETERS
-</para>
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>int fd</para>
-</entry><entry
- align="char">
-<para>File descriptor returned by a previous call to open().</para>
-</entry>
- </row><row><entry
- align="char">
-<para>int request</para>
-</entry><entry
- align="char">
-<para>Equals <link linkend="FE_GET_EVENT">FE_GET_EVENT</link> for this command.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>struct
- dvb_frontend_event
- *ev</para>
-</entry><entry
- align="char">
-<para>Points to the location where the event,</para>
-</entry>
- </row><row><entry
- align="char">
-</entry><entry
- align="char">
-<para>if any, is to be stored.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-&return-value-dvb;
-<informaltable><tgroup cols="2"><tbody><row><entry
- align="char">
-<para>EWOULDBLOCK</para>
-</entry><entry
- align="char">
-<para>There is no event pending, and the device is in
- non-blocking mode.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>EOVERFLOW</para>
-</entry><entry
- align="char">
-<para>Overflow in event queue - one or more events were lost.</para>
-</entry>
-</row></tbody></tgroup></informaltable>
-</section>
-
 <section id="FE_GET_INFO">
 <title>FE_GET_INFO</title>
 <para>DESCRIPTION
@@ -1521,40 +971,15 @@ FE_TUNE_MODE_ONESHOT When set, this flag will disable any zigzagging or other "n
 &return-value-dvb;
 </section>
 
-<section id="FE_DISHNETWORK_SEND_LEGACY_CMD">
-	<title>FE_DISHNETWORK_SEND_LEGACY_CMD</title>
-<para>DESCRIPTION</para>
-<informaltable><tgroup cols="1"><tbody><row>
-<entry align="char">
-<para>WARNING: This is a very obscure legacy command, used only at stv0299 driver. Should not be used on newer drivers.</para>
-<para>It provides a non-standard method for selecting Diseqc voltage on the frontend, for Dish Network legacy switches.</para>
-<para>As support for this ioctl were added in 2004, this means that such dishes were already legacy in 2004.</para>
-</entry>
-</row></tbody></tgroup></informaltable>
-
-<para>SYNOPSIS</para>
-<informaltable><tgroup cols="1"><tbody><row>
-<entry align="char">
-<para>int ioctl(int fd, int request =
-	<link linkend="FE_DISHNETWORK_SEND_LEGACY_CMD">FE_DISHNETWORK_SEND_LEGACY_CMD</link>, unsigned long cmd);</para>
-</entry>
-</row></tbody></tgroup></informaltable>
-
-<para>PARAMETERS</para>
-<informaltable><tgroup cols="2"><tbody><row>
-<entry align="char">
-	<para>unsigned long cmd</para>
-</entry>
-<entry align="char">
-<para>
-sends the specified raw cmd to the dish via DISEqC.
-</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-
-&return-value-dvb;
 </section>
 
+<section id="frontend_legacy_dvbv3_api">
+<title>DVB Frontend legacy API (a. k. a. DVBv3)</title>
+<para>The usage of this API is deprecated, as it doesn't support all digital
+    TV standards, doesn't provide good statistics measurements and provides
+    incomplete information. This is kept only to support legacy applications.</para>
+
+&sub-frontend_legacy_api;
 </section>
 
 &sub-dvbproperty;
diff --git a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
new file mode 100644
index 000000000000..f4d300488d12
--- /dev/null
+++ b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
@@ -0,0 +1,603 @@
+<section id="frontend_legacy_types">
+<title>Frontend Legacy Data Types</title>
+
+<section id="fe-type-t">
+<title>Frontend type</title>
+
+<para>For historical reasons, frontend types are named by the type of modulation
+    used in transmission. The fontend types are given by fe_type_t type, defined as:</para>
+
+<table pgwide="1" frame="none" id="fe-type">
+<title>Frontend types</title>
+<tgroup cols="3">
+   &cs-def;
+   <thead>
+     <row>
+       <entry>fe_type</entry>
+       <entry>Description</entry>
+       <entry><link linkend="DTV-DELIVERY-SYSTEM">DTV_DELIVERY_SYSTEM</link> equivalent type</entry>
+     </row>
+  </thead>
+  <tbody valign="top">
+  <row>
+     <entry id="FE_QPSK"><constant>FE_QPSK</constant></entry>
+     <entry>For DVB-S standard</entry>
+     <entry><constant>SYS_DVBS</constant></entry>
+  </row>
+  <row>
+     <entry id="FE_QAM"><constant>FE_QAM</constant></entry>
+     <entry>For DVB-C annex A standard</entry>
+     <entry><constant>SYS_DVBC_ANNEX_A</constant></entry>
+  </row>
+  <row>
+     <entry id="FE_OFDM"><constant>FE_OFDM</constant></entry>
+     <entry>For DVB-T standard</entry>
+     <entry><constant>SYS_DVBT</constant></entry>
+  </row>
+  <row>
+     <entry id="FE_ATSC"><constant>FE_ATSC</constant></entry>
+     <entry>For ATSC standard (terrestrial) or for DVB-C Annex B (cable) used in US.</entry>
+     <entry><constant>SYS_ATSC</constant> (terrestrial) or <constant>SYS_DVBC_ANNEX_B</constant> (cable)</entry>
+  </row>
+</tbody></tgroup></table>
+
+<para>Newer formats like DVB-S2, ISDB-T, ISDB-S and DVB-T2 are not described at the above, as they're
+supported via the new <link linkend="FE_GET_SET_PROPERTY">FE_GET_PROPERTY/FE_GET_SET_PROPERTY</link> ioctl's, using the <link linkend="DTV-DELIVERY-SYSTEM">DTV_DELIVERY_SYSTEM</link> parameter.
+</para>
+
+<para>The usage of this field is deprecated, as it doesn't report all supported standards, and
+will provide an incomplete information for frontends that support multiple delivery systems.
+Please use <link linkend="DTV-ENUM-DELSYS">DTV_ENUM_DELSYS</link> instead.</para>
+</section>
+
+
+<section id="dvb-frontend-parameters">
+<title>frontend parameters</title>
+<para>The kind of parameters passed to the frontend device for tuning depend on
+the kind of hardware you are using.</para>
+<para>The struct <constant>dvb_frontend_parameters</constant> uses an
+union with specific per-system parameters. However, as newer delivery systems
+required more data, the structure size weren't enough to fit, and just
+extending its size would break the existing applications. So, those parameters
+were replaced by the usage of <link linkend="FE_GET_SET_PROPERTY">
+<constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant></link> ioctl's. The
+new API is flexible enough to add new parameters to existing delivery systems,
+and to add newer delivery systems.</para>
+<para>So, newer applications should use <link linkend="FE_GET_SET_PROPERTY">
+<constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant></link> instead, in
+order to be able to support the newer System Delivery like  DVB-S2, DVB-T2,
+DVB-C2, ISDB, etc.</para>
+<para>All kinds of parameters are combined as an union in the FrontendParameters structure:
+<programlisting>
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
+</programlisting></para>
+<para>In the case of QPSK frontends the <constant>frequency</constant> field specifies the intermediate
+frequency, i.e. the offset which is effectively added to the local oscillator frequency (LOF) of
+the LNB. The intermediate frequency has to be specified in units of kHz. For QAM and
+OFDM frontends the <constant>frequency</constant> specifies the absolute frequency and is given in Hz.
+</para>
+
+<section id="dvb-qpsk-parameters">
+<title>QPSK parameters</title>
+<para>For satellite QPSK frontends you have to use the <constant>dvb_qpsk_parameters</constant> structure:</para>
+<programlisting>
+ struct dvb_qpsk_parameters {
+	 uint32_t        symbol_rate;  /&#x22C6; symbol rate in Symbols per second &#x22C6;/
+	 fe_code_rate_t  fec_inner;    /&#x22C6; forward error correction (see above) &#x22C6;/
+ };
+</programlisting>
+</section>
+
+<section id="dvb-qam-parameters">
+<title>QAM parameters</title>
+<para>for cable QAM frontend you use the <constant>dvb_qam_parameters</constant> structure:</para>
+<programlisting>
+ struct dvb_qam_parameters {
+	 uint32_t         symbol_rate; /&#x22C6; symbol rate in Symbols per second &#x22C6;/
+	 fe_code_rate_t   fec_inner;   /&#x22C6; forward error correction (see above) &#x22C6;/
+	 fe_modulation_t  modulation;  /&#x22C6; modulation type (see above) &#x22C6;/
+ };
+</programlisting>
+</section>
+
+<section id="dvb-vsb-parameters">
+<title>VSB parameters</title>
+<para>ATSC frontends are supported by the <constant>dvb_vsb_parameters</constant> structure:</para>
+<programlisting>
+struct dvb_vsb_parameters {
+	fe_modulation_t modulation;	/&#x22C6; modulation type (see above) &#x22C6;/
+};
+</programlisting>
+</section>
+
+<section id="dvb-ofdm-parameters">
+<title>OFDM parameters</title>
+<para>DVB-T frontends are supported by the <constant>dvb_ofdm_parameters</constant> structure:</para>
+<programlisting>
+ struct dvb_ofdm_parameters {
+	 fe_bandwidth_t      bandwidth;
+	 fe_code_rate_t      code_rate_HP;  /&#x22C6; high priority stream code rate &#x22C6;/
+	 fe_code_rate_t      code_rate_LP;  /&#x22C6; low priority stream code rate &#x22C6;/
+	 fe_modulation_t     constellation; /&#x22C6; modulation type (see above) &#x22C6;/
+	 fe_transmit_mode_t  transmission_mode;
+	 fe_guard_interval_t guard_interval;
+	 fe_hierarchy_t      hierarchy_information;
+ };
+</programlisting>
+</section>
+</section>
+
+<section id="dvb-frontend-event">
+<title>frontend events</title>
+ <programlisting>
+ struct dvb_frontend_event {
+	 fe_status_t status;
+	 struct dvb_frontend_parameters parameters;
+ };
+</programlisting>
+ </section>
+</section>
+
+<section id="frontend_fcalls">
+<title>Frontend Legacy Function Calls</title>
+
+<para>Those functions are defined at DVB version 3. The support is kept in
+    the kernel due to compatibility issues only. Their usage is strongly
+    not recommended</para>
+
+<section id="FE_READ_BER">
+<title>FE_READ_BER</title>
+<para>DESCRIPTION
+</para>
+<informaltable><tgroup cols="1"><tbody><row><entry
+ align="char">
+<para>This ioctl call returns the bit error rate for the signal currently
+ received/demodulated by the front-end. For this command, read-only access to
+ the device is sufficient.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+<para>SYNOPSIS
+</para>
+<informaltable><tgroup cols="1"><tbody><row><entry
+ align="char">
+<para>int ioctl(int fd, int request = <link linkend="FE_READ_BER">FE_READ_BER</link>,
+ uint32_t &#x22C6;ber);</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+<para>PARAMETERS
+</para>
+<informaltable><tgroup cols="2"><tbody><row><entry
+ align="char">
+<para>int fd</para>
+</entry><entry
+ align="char">
+<para>File descriptor returned by a previous call to open().</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>int request</para>
+</entry><entry
+ align="char">
+<para>Equals <link linkend="FE_READ_BER">FE_READ_BER</link> for this command.</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>uint32_t *ber</para>
+</entry><entry
+ align="char">
+<para>The bit error rate is stored into *ber.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+
+&return-value-dvb;
+</section>
+
+<section id="FE_READ_SNR">
+<title>FE_READ_SNR</title>
+
+<para>DESCRIPTION
+</para>
+<informaltable><tgroup cols="1"><tbody><row><entry
+ align="char">
+<para>This ioctl call returns the signal-to-noise ratio for the signal currently received
+ by the front-end. For this command, read-only access to the device is sufficient.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+<para>SYNOPSIS
+</para>
+<informaltable><tgroup cols="1"><tbody><row><entry
+ align="char">
+<para>int ioctl(int fd, int request = <link linkend="FE_READ_SNR">FE_READ_SNR</link>, uint16_t
+ &#x22C6;snr);</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+<para>PARAMETERS
+</para>
+<informaltable><tgroup cols="2"><tbody><row><entry
+ align="char">
+<para>int fd</para>
+</entry><entry
+ align="char">
+<para>File descriptor returned by a previous call to open().</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>int request</para>
+</entry><entry
+ align="char">
+<para>Equals <link linkend="FE_READ_SNR">FE_READ_SNR</link> for this command.</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>uint16_t *snr</para>
+</entry><entry
+ align="char">
+<para>The signal-to-noise ratio is stored into *snr.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+
+&return-value-dvb;
+</section>
+
+<section id="FE_READ_SIGNAL_STRENGTH">
+<title>FE_READ_SIGNAL_STRENGTH</title>
+<para>DESCRIPTION
+</para>
+<informaltable><tgroup cols="1"><tbody><row><entry
+ align="char">
+<para>This ioctl call returns the signal strength value for the signal currently received
+ by the front-end. For this command, read-only access to the device is sufficient.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+<para>SYNOPSIS
+</para>
+<informaltable><tgroup cols="1"><tbody><row><entry
+ align="char">
+<para>int ioctl( int fd, int request =
+ <link linkend="FE_READ_SIGNAL_STRENGTH">FE_READ_SIGNAL_STRENGTH</link>, uint16_t &#x22C6;strength);</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+
+<para>PARAMETERS
+</para>
+<informaltable><tgroup cols="2"><tbody><row><entry
+ align="char">
+<para>int fd</para>
+</entry><entry
+ align="char">
+<para>File descriptor returned by a previous call to open().</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>int request</para>
+</entry><entry
+ align="char">
+<para>Equals <link linkend="FE_READ_SIGNAL_STRENGTH">FE_READ_SIGNAL_STRENGTH</link> for this
+ command.</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>uint16_t *strength</para>
+</entry><entry
+ align="char">
+<para>The signal strength value is stored into *strength.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+
+&return-value-dvb;
+</section>
+
+<section id="FE_READ_UNCORRECTED_BLOCKS">
+<title>FE_READ_UNCORRECTED_BLOCKS</title>
+<para>DESCRIPTION
+</para>
+<informaltable><tgroup cols="1"><tbody><row><entry
+ align="char">
+<para>This ioctl call returns the number of uncorrected blocks detected by the device
+ driver during its lifetime. For meaningful measurements, the increment in block
+ count during a specific time interval should be calculated. For this command,
+ read-only access to the device is sufficient.</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>Note that the counter will wrap to zero after its maximum count has been
+ reached.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+<para>SYNOPSIS
+</para>
+<informaltable><tgroup cols="1"><tbody><row><entry
+ align="char">
+<para>int ioctl( int fd, int request =
+ <link linkend="FE_READ_UNCORRECTED_BLOCKS">FE_READ_UNCORRECTED_BLOCKS</link>, uint32_t &#x22C6;ublocks);</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+<para>PARAMETERS
+</para>
+<informaltable><tgroup cols="2"><tbody><row><entry
+ align="char">
+<para>int fd</para>
+</entry><entry
+ align="char">
+<para>File descriptor returned by a previous call to open().</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>int request</para>
+</entry><entry
+ align="char">
+<para>Equals <link linkend="FE_READ_UNCORRECTED_BLOCKS">FE_READ_UNCORRECTED_BLOCKS</link> for this
+ command.</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>uint32_t *ublocks</para>
+</entry><entry
+ align="char">
+<para>The total number of uncorrected blocks seen by the driver
+ so far.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+
+&return-value-dvb;
+</section>
+
+<section id="FE_SET_FRONTEND">
+<title>FE_SET_FRONTEND</title>
+<para>DESCRIPTION
+</para>
+<informaltable><tgroup cols="1"><tbody><row><entry
+ align="char">
+<para>This ioctl call starts a tuning operation using specified parameters. The result
+ of this call will be successful if the parameters were valid and the tuning could
+ be initiated. The result of the tuning operation in itself, however, will arrive
+ asynchronously as an event (see documentation for <link linkend="FE_GET_EVENT">FE_GET_EVENT</link> and
+ FrontendEvent.) If a new <link linkend="FE_SET_FRONTEND">FE_SET_FRONTEND</link> operation is initiated before
+ the previous one was completed, the previous operation will be aborted in favor
+ of the new one. This command requires read/write access to the device.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+
+<para>SYNOPSIS
+</para>
+<informaltable><tgroup cols="1"><tbody><row><entry
+ align="char">
+<para>int ioctl(int fd, int request = <link linkend="FE_SET_FRONTEND">FE_SET_FRONTEND</link>,
+ struct dvb_frontend_parameters &#x22C6;p);</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+<para>PARAMETERS
+</para>
+<informaltable><tgroup cols="2"><tbody><row><entry
+ align="char">
+<para>int fd</para>
+</entry><entry
+ align="char">
+<para>File descriptor returned by a previous call to open().</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>int request</para>
+</entry><entry
+ align="char">
+<para>Equals <link linkend="FE_SET_FRONTEND">FE_SET_FRONTEND</link> for this command.</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>struct
+ dvb_frontend_parameters
+ *p</para>
+</entry><entry
+ align="char">
+<para>Points to parameters for tuning operation.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+
+&return-value-dvb;
+<informaltable><tgroup cols="2"><tbody><row><entry
+ align="char">
+<para>EINVAL</para>
+</entry><entry
+ align="char">
+<para>Maximum supported symbol rate reached.</para>
+</entry>
+</row></tbody></tgroup></informaltable>
+</section>
+
+<section id="FE_GET_FRONTEND">
+<title>FE_GET_FRONTEND</title>
+<para>DESCRIPTION
+</para>
+<informaltable><tgroup cols="1"><tbody><row><entry
+ align="char">
+<para>This ioctl call queries the currently effective frontend parameters. For this
+ command, read-only access to the device is sufficient.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+
+<para>SYNOPSIS
+</para>
+<informaltable><tgroup cols="1"><tbody><row><entry
+ align="char">
+<para>int ioctl(int fd, int request = <link linkend="FE_GET_FRONTEND">FE_GET_FRONTEND</link>,
+ struct dvb_frontend_parameters &#x22C6;p);</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+
+<para>PARAMETERS
+</para>
+<informaltable><tgroup cols="2"><tbody><row><entry
+ align="char">
+<para>int fd</para>
+</entry><entry
+ align="char">
+<para>File descriptor returned by a previous call to open().</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>int request</para>
+</entry><entry
+ align="char">
+<para>Equals <link linkend="FE_SET_FRONTEND">FE_SET_FRONTEND</link> for this command.</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>struct
+ dvb_frontend_parameters
+ *p</para>
+</entry><entry
+ align="char">
+<para>Points to parameters for tuning operation.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+
+&return-value-dvb;
+<informaltable><tgroup cols="2"><tbody><row><entry
+ align="char">
+<para>EINVAL</para>
+</entry><entry
+ align="char">
+<para>Maximum supported symbol rate reached.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+
+</section>
+
+<section id="FE_GET_EVENT">
+<title>FE_GET_EVENT</title>
+<para>DESCRIPTION
+</para>
+<informaltable><tgroup cols="1"><tbody><row><entry
+ align="char">
+<para>This ioctl call returns a frontend event if available. If an event is not
+ available, the behavior depends on whether the device is in blocking or
+ non-blocking mode. In the latter case, the call fails immediately with errno
+ set to EWOULDBLOCK. In the former case, the call blocks until an event
+ becomes available.</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>The standard Linux poll() and/or select() system calls can be used with the
+ device file descriptor to watch for new events. For select(), the file descriptor
+ should be included in the exceptfds argument, and for poll(), POLLPRI should
+ be specified as the wake-up condition. Since the event queue allocated is
+ rather small (room for 8 events), the queue must be serviced regularly to avoid
+ overflow. If an overflow happens, the oldest event is discarded from the queue,
+ and an error (EOVERFLOW) occurs the next time the queue is read. After
+ reporting the error condition in this fashion, subsequent
+ <link linkend="FE_GET_EVENT">FE_GET_EVENT</link>
+ calls will return events from the queue as usual.</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>For the sake of implementation simplicity, this command requires read/write
+ access to the device.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+
+<para>SYNOPSIS
+</para>
+<informaltable><tgroup cols="1"><tbody><row><entry
+ align="char">
+<para>int ioctl(int fd, int request = QPSK_GET_EVENT,
+ struct dvb_frontend_event &#x22C6;ev);</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+
+<para>PARAMETERS
+</para>
+<informaltable><tgroup cols="2"><tbody><row><entry
+ align="char">
+<para>int fd</para>
+</entry><entry
+ align="char">
+<para>File descriptor returned by a previous call to open().</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>int request</para>
+</entry><entry
+ align="char">
+<para>Equals <link linkend="FE_GET_EVENT">FE_GET_EVENT</link> for this command.</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>struct
+ dvb_frontend_event
+ *ev</para>
+</entry><entry
+ align="char">
+<para>Points to the location where the event,</para>
+</entry>
+ </row><row><entry
+ align="char">
+</entry><entry
+ align="char">
+<para>if any, is to be stored.</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+
+&return-value-dvb;
+<informaltable><tgroup cols="2"><tbody><row><entry
+ align="char">
+<para>EWOULDBLOCK</para>
+</entry><entry
+ align="char">
+<para>There is no event pending, and the device is in
+ non-blocking mode.</para>
+</entry>
+ </row><row><entry
+ align="char">
+<para>EOVERFLOW</para>
+</entry><entry
+ align="char">
+<para>Overflow in event queue - one or more events were lost.</para>
+</entry>
+</row></tbody></tgroup></informaltable>
+</section>
+
+<section id="FE_DISHNETWORK_SEND_LEGACY_CMD">
+	<title>FE_DISHNETWORK_SEND_LEGACY_CMD</title>
+<para>DESCRIPTION</para>
+<informaltable><tgroup cols="1"><tbody><row>
+<entry align="char">
+<para>WARNING: This is a very obscure legacy command, used only at stv0299 driver. Should not be used on newer drivers.</para>
+<para>It provides a non-standard method for selecting Diseqc voltage on the frontend, for Dish Network legacy switches.</para>
+<para>As support for this ioctl were added in 2004, this means that such dishes were already legacy in 2004.</para>
+</entry>
+</row></tbody></tgroup></informaltable>
+
+<para>SYNOPSIS</para>
+<informaltable><tgroup cols="1"><tbody><row>
+<entry align="char">
+<para>int ioctl(int fd, int request =
+	<link linkend="FE_DISHNETWORK_SEND_LEGACY_CMD">FE_DISHNETWORK_SEND_LEGACY_CMD</link>, unsigned long cmd);</para>
+</entry>
+</row></tbody></tgroup></informaltable>
+
+<para>PARAMETERS</para>
+<informaltable><tgroup cols="2"><tbody><row>
+<entry align="char">
+	<para>unsigned long cmd</para>
+</entry>
+<entry align="char">
+<para>
+sends the specified raw cmd to the dish via DISEqC.
+</para>
+</entry>
+ </row></tbody></tgroup></informaltable>
+
+&return-value-dvb;
+</section>
+
+</section>
-- 
2.4.1

