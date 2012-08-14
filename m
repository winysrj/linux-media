Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4889 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab2HNKKM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 06:10:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/2] DocBook validation fixes.
Date: Tue, 14 Aug 2012 12:10:01 +0200
Message-Id: <c074996da4c197148a64fceefa6aac5090707691.1344938890.git.hans.verkuil@cisco.com>
In-Reply-To: <1344939002-2059-1-git-send-email-hverkuil@xs4all.nl>
References: <1344939002-2059-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

More validation fixes as reported by xmllint.

There are still three xmllint errors after this remaining regarding SVG file support.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/Makefile               |    2 +-
 Documentation/DocBook/media/dvb/dvbproperty.xml    |   22 +-
 Documentation/DocBook/media/dvb/frontend.xml       |   20 +-
 Documentation/DocBook/media/v4l/controls.xml       |  447 ++++++++++----------
 Documentation/DocBook/media/v4l/dev-subdev.xml     |   20 +-
 .../DocBook/media/v4l/pixfmt-srggb10dpcm8.xml      |    3 +-
 Documentation/DocBook/media/v4l/selection-api.xml  |   22 +-
 .../DocBook/media/v4l/vidioc-g-selection.xml       |    9 +-
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |    2 +
 .../media/v4l/vidioc-subdev-g-selection.xml        |    8 +-
 10 files changed, 278 insertions(+), 277 deletions(-)

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 3625209..9b7e4c5 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -300,7 +300,7 @@ $(MEDIA_OBJ_DIR)/media-entities.tmpl: $(MEDIA_OBJ_DIR)/v4l2.xml
 	@(								\
 	for ident in $(IOCTLS) ; do					\
 	  entity=`echo $$ident | tr _ -` ;				\
-	  id=`grep "<refname>$$ident" $(MEDIA_OBJ_DIR)/vidioc-*.xml | sed -r s,"^.*/(.*).xml.*","\1",` ; \
+	  id=`grep "<refname>$$ident" $(MEDIA_OBJ_DIR)/vidioc-*.xml $(MEDIA_OBJ_DIR)/media-ioc-*.xml | sed -r s,"^.*/(.*).xml.*","\1",` ; \
 	  echo "<!ENTITY $$entity \"<link"				\
 	    "linkend='$$id'><constant>$$ident</constant></link>\">"	\
 	  >>$@ ;							\
diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index eddfe6f..d188be9 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -569,33 +569,33 @@ typedef enum fe_delivery_system {
 			<title><constant>DTV_ATSCMH_RS_FRAME_MODE</constant></title>
 			<para>RS frame mode.</para>
 			<para>Possible values are:</para>
-		  <section id="atscmh-rs-frame-mode">
+		  <para id="atscmh-rs-frame-mode">
 <programlisting>
 typedef enum atscmh_rs_frame_mode {
 	ATSCMH_RSFRAME_PRI_ONLY  = 0,
 	ATSCMH_RSFRAME_PRI_SEC   = 1,
 } atscmh_rs_frame_mode_t;
 </programlisting>
-		  </section>
+		  </para>
 		</section>
 		<section id="DTV-ATSCMH-RS-FRAME-ENSEMBLE">
 			<title><constant>DTV_ATSCMH_RS_FRAME_ENSEMBLE</constant></title>
 			<para>RS frame ensemble.</para>
 			<para>Possible values are:</para>
-		  <section id="atscmh-rs-frame-ensemble">
+		  <para id="atscmh-rs-frame-ensemble">
 <programlisting>
 typedef enum atscmh_rs_frame_ensemble {
 	ATSCMH_RSFRAME_ENS_PRI   = 0,
 	ATSCMH_RSFRAME_ENS_SEC   = 1,
 } atscmh_rs_frame_ensemble_t;
 </programlisting>
-		  </section>
+		  </para>
 		</section>
 		<section id="DTV-ATSCMH-RS-CODE-MODE-PRI">
 			<title><constant>DTV_ATSCMH_RS_CODE_MODE_PRI</constant></title>
 			<para>RS code mode (primary).</para>
 			<para>Possible values are:</para>
-		  <section id="atscmh-rs-code-mode">
+		  <para id="atscmh-rs-code-mode">
 <programlisting>
 typedef enum atscmh_rs_code_mode {
 	ATSCMH_RSCODE_211_187    = 0,
@@ -603,7 +603,7 @@ typedef enum atscmh_rs_code_mode {
 	ATSCMH_RSCODE_235_187    = 2,
 } atscmh_rs_code_mode_t;
 </programlisting>
-		  </section>
+		  </para>
 		</section>
 		<section id="DTV-ATSCMH-RS-CODE-MODE-SEC">
 			<title><constant>DTV_ATSCMH_RS_CODE_MODE_SEC</constant></title>
@@ -621,27 +621,27 @@ typedef enum atscmh_rs_code_mode {
 			<title><constant>DTV_ATSCMH_SCCC_BLOCK_MODE</constant></title>
 			<para>Series Concatenated Convolutional Code Block Mode.</para>
 			<para>Possible values are:</para>
-		  <section id="atscmh-sccc-block-mode">
+		  <para id="atscmh-sccc-block-mode">
 <programlisting>
 typedef enum atscmh_sccc_block_mode {
 	ATSCMH_SCCC_BLK_SEP      = 0,
 	ATSCMH_SCCC_BLK_COMB     = 1,
 } atscmh_sccc_block_mode_t;
 </programlisting>
-		  </section>
+		  </para>
 		</section>
 		<section id="DTV-ATSCMH-SCCC-CODE-MODE-A">
 			<title><constant>DTV_ATSCMH_SCCC_CODE_MODE_A</constant></title>
 			<para>Series Concatenated Convolutional Code Rate.</para>
 			<para>Possible values are:</para>
-		  <section id="atscmh-sccc-code-mode">
+		  <para id="atscmh-sccc-code-mode">
 <programlisting>
 typedef enum atscmh_sccc_code_mode {
 	ATSCMH_SCCC_CODE_HLF     = 0,
 	ATSCMH_SCCC_CODE_QTR     = 1,
 } atscmh_sccc_code_mode_t;
 </programlisting>
-		  </section>
+		  </para>
 		</section>
 		<section id="DTV-ATSCMH-SCCC-CODE-MODE-B">
 			<title><constant>DTV_ATSCMH_SCCC_CODE_MODE_B</constant></title>
@@ -817,7 +817,7 @@ typedef enum fe_hierarchy {
 	</section>
 	<section id="DTV-INTERLEAVING">
 	<title><constant>DTV_INTERLEAVING</constant></title>
-	<para>Interleaving mode</para>
+	<para id="fe-interleaving">Interleaving mode</para>
 	<programlisting>
 enum fe_interleaving {
 	INTERLEAVING_NONE,
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 1ab2e1a..950bdfb 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -264,7 +264,7 @@ and to add newer delivery systems.</para>
 <constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant></link> instead, in
 order to be able to support the newer System Delivery like  DVB-S2, DVB-T2,
 DVB-C2, ISDB, etc.</para>
-<para>All kinds of parameters are combined as an union in the FrontendParameters structure:</para>
+<para>All kinds of parameters are combined as an union in the FrontendParameters structure:
 <programlisting>
 struct dvb_frontend_parameters {
 	uint32_t frequency;     /&#x22C6; (absolute) frequency in Hz for QAM/OFDM &#x22C6;/
@@ -277,12 +277,13 @@ struct dvb_frontend_parameters {
 		struct dvb_vsb_parameters  vsb;
 	} u;
 };
-</programlisting>
+</programlisting></para>
 <para>In the case of QPSK frontends the <constant>frequency</constant> field specifies the intermediate
 frequency, i.e. the offset which is effectively added to the local oscillator frequency (LOF) of
 the LNB. The intermediate frequency has to be specified in units of kHz. For QAM and
 OFDM frontends the <constant>frequency</constant> specifies the absolute frequency and is given in Hz.
 </para>
+
 <section id="dvb-qpsk-parameters">
 <title>QPSK parameters</title>
 <para>For satellite QPSK frontends you have to use the <constant>dvb_qpsk_parameters</constant> structure:</para>
@@ -347,8 +348,8 @@ itself.
 <section id="fe-code-rate-t">
 <title>frontend code rate</title>
 <para>The possible values for the <constant>fec_inner</constant> field used on
-<link refend="dvb-qpsk-parameters"><constant>struct dvb_qpsk_parameters</constant></link> and
-<link refend="dvb-qam-parameters"><constant>struct dvb_qam_parameters</constant></link> are:
+<link linkend="dvb-qpsk-parameters"><constant>struct dvb_qpsk_parameters</constant></link> and
+<link linkend="dvb-qam-parameters"><constant>struct dvb_qam_parameters</constant></link> are:
 </para>
 <programlisting>
 typedef enum fe_code_rate {
@@ -373,9 +374,9 @@ detection.
 <section id="fe-modulation-t">
 <title>frontend modulation type for QAM, OFDM and VSB</title>
 <para>For cable and terrestrial frontends, e. g. for
-<link refend="dvb-qam-parameters"><constant>struct dvb_qpsk_parameters</constant></link>,
-<link refend="dvb-ofdm-parameters"><constant>struct dvb_qam_parameters</constant></link> and
-<link refend="dvb-vsb-parameters"><constant>struct dvb_qam_parameters</constant></link>,
+<link linkend="dvb-qam-parameters"><constant>struct dvb_qpsk_parameters</constant></link>,
+<link linkend="dvb-ofdm-parameters"><constant>struct dvb_qam_parameters</constant></link> and
+<link linkend="dvb-vsb-parameters"><constant>struct dvb_qam_parameters</constant></link>,
 it needs to specify the quadrature modulation mode which can be one of the following:
 </para>
 <programlisting>
@@ -396,8 +397,8 @@ it needs to specify the quadrature modulation mode which can be one of the follo
  } fe_modulation_t;
 </programlisting>
 </section>
-<para>Finally, there are several more parameters for OFDM:
-</para>
+<section>
+<title>More OFDM parameters</title>
 <section id="fe-transmit-mode-t">
 <title>Number of carriers per channel</title>
 <programlisting>
@@ -453,6 +454,7 @@ typedef enum fe_hierarchy {
  } fe_hierarchy_t;
 </programlisting>
 </section>
+</section>
 
 </section>
 
diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index b0964fb..93dc48b 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3717,232 +3717,231 @@ interface and may change in the future.</para>
 	    use case involving camera or individually.
 	  </para>
 
-	</section>
 
+          <table pgwide="1" frame="none" id="flash-control-id">
+          <title>Flash Control IDs</title>
+    
+          <tgroup cols="4">
+    	<colspec colname="c1" colwidth="1*" />
+    	<colspec colname="c2" colwidth="6*" />
+    	<colspec colname="c3" colwidth="2*" />
+    	<colspec colname="c4" colwidth="6*" />
+    	<spanspec namest="c1" nameend="c2" spanname="id" />
+    	<spanspec namest="c2" nameend="c4" spanname="descr" />
+    	<thead>
+    	  <row>
+    	    <entry spanname="id" align="left">ID</entry>
+    	    <entry align="left">Type</entry>
+    	  </row><row rowsep="1"><entry spanname="descr" align="left">Description</entry>
+    	  </row>
+    	</thead>
+    	<tbody valign="top">
+    	  <row><entry></entry></row>
+    	  <row>
+    	    <entry spanname="id"><constant>V4L2_CID_FLASH_CLASS</constant></entry>
+    	    <entry>class</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="descr">The FLASH class descriptor.</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="id"><constant>V4L2_CID_FLASH_LED_MODE</constant></entry>
+    	    <entry>menu</entry>
+    	  </row>
+    	  <row id="v4l2-flash-led-mode">
+    	    <entry spanname="descr">Defines the mode of the flash LED,
+    	    the high-power white LED attached to the flash controller.
+    	    Setting this control may not be possible in presence of
+    	    some faults. See V4L2_CID_FLASH_FAULT.</entry>
+    	  </row>
+    	  <row>
+    	    <entrytbl spanname="descr" cols="2">
+    	      <tbody valign="top">
+    		<row>
+    		  <entry><constant>V4L2_FLASH_LED_MODE_NONE</constant></entry>
+    		  <entry>Off.</entry>
+    		</row>
+    		<row>
+    		  <entry><constant>V4L2_FLASH_LED_MODE_FLASH</constant></entry>
+    		  <entry>Flash mode.</entry>
+    		</row>
+    		<row>
+    		  <entry><constant>V4L2_FLASH_LED_MODE_TORCH</constant></entry>
+    		  <entry>Torch mode. See V4L2_CID_FLASH_TORCH_INTENSITY.</entry>
+    		</row>
+    	      </tbody>
+    	    </entrytbl>
+    	  </row>
+    	  <row>
+    	    <entry spanname="id"><constant>V4L2_CID_FLASH_STROBE_SOURCE</constant></entry>
+    	    <entry>menu</entry>
+    	  </row>
+    	  <row id="v4l2-flash-strobe-source"><entry
+    	  spanname="descr">Defines the source of the flash LED
+    	  strobe.</entry>
+    	  </row>
+    	  <row>
+    	    <entrytbl spanname="descr" cols="2">
+    	      <tbody valign="top">
+    		<row>
+    		  <entry><constant>V4L2_FLASH_STROBE_SOURCE_SOFTWARE</constant></entry>
+    		  <entry>The flash strobe is triggered by using
+    		  the V4L2_CID_FLASH_STROBE control.</entry>
+    		</row>
+    		<row>
+    		  <entry><constant>V4L2_FLASH_STROBE_SOURCE_EXTERNAL</constant></entry>
+    		  <entry>The flash strobe is triggered by an
+    		  external source. Typically this is a sensor,
+    		  which makes it possible to synchronises the
+    		  flash strobe start to exposure start.</entry>
+    		</row>
+    	      </tbody>
+    	    </entrytbl>
+    	  </row>
+    	  <row>
+    	    <entry spanname="id"><constant>V4L2_CID_FLASH_STROBE</constant></entry>
+    	    <entry>button</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="descr">Strobe flash. Valid when
+    	    V4L2_CID_FLASH_LED_MODE is set to
+    	    V4L2_FLASH_LED_MODE_FLASH and V4L2_CID_FLASH_STROBE_SOURCE
+    	    is set to V4L2_FLASH_STROBE_SOURCE_SOFTWARE. Setting this
+    	    control may not be possible in presence of some faults.
+    	    See V4L2_CID_FLASH_FAULT.</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="id"><constant>V4L2_CID_FLASH_STROBE_STOP</constant></entry>
+    	    <entry>button</entry>
+    	  </row>
+    	  <row><entry spanname="descr">Stop flash strobe immediately.</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="id"><constant>V4L2_CID_FLASH_STROBE_STATUS</constant></entry>
+    	    <entry>boolean</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="descr">Strobe status: whether the flash
+    	    is strobing at the moment or not. This is a read-only
+    	    control.</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="id"><constant>V4L2_CID_FLASH_TIMEOUT</constant></entry>
+    	    <entry>integer</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="descr">Hardware timeout for flash. The
+    	    flash strobe is stopped after this period of time has
+    	    passed from the start of the strobe.</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="id"><constant>V4L2_CID_FLASH_INTENSITY</constant></entry>
+    	    <entry>integer</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="descr">Intensity of the flash strobe when
+    	    the flash LED is in flash mode
+    	    (V4L2_FLASH_LED_MODE_FLASH). The unit should be milliamps
+    	    (mA) if possible.</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="id"><constant>V4L2_CID_FLASH_TORCH_INTENSITY</constant></entry>
+    	    <entry>integer</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="descr">Intensity of the flash LED in
+    	    torch mode (V4L2_FLASH_LED_MODE_TORCH). The unit should be
+    	    milliamps (mA) if possible. Setting this control may not
+    	    be possible in presence of some faults. See
+    	    V4L2_CID_FLASH_FAULT.</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="id"><constant>V4L2_CID_FLASH_INDICATOR_INTENSITY</constant></entry>
+    	    <entry>integer</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="descr">Intensity of the indicator LED.
+    	    The indicator LED may be fully independent of the flash
+    	    LED. The unit should be microamps (uA) if possible.</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="id"><constant>V4L2_CID_FLASH_FAULT</constant></entry>
+    	    <entry>bitmask</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="descr">Faults related to the flash. The
+    	    faults tell about specific problems in the flash chip
+    	    itself or the LEDs attached to it. Faults may prevent
+    	    further use of some of the flash controls. In particular,
+    	    V4L2_CID_FLASH_LED_MODE is set to V4L2_FLASH_LED_MODE_NONE
+    	    if the fault affects the flash LED. Exactly which faults
+    	    have such an effect is chip dependent. Reading the faults
+    	    resets the control and returns the chip to a usable state
+    	    if possible.</entry>
+    	  </row>
+    	  <row>
+    	    <entrytbl spanname="descr" cols="2">
+    	      <tbody valign="top">
+    		<row>
+    		  <entry><constant>V4L2_FLASH_FAULT_OVER_VOLTAGE</constant></entry>
+    		  <entry>Flash controller voltage to the flash LED
+    		  has exceeded the limit specific to the flash
+    		  controller.</entry>
+    		</row>
+    		<row>
+    		  <entry><constant>V4L2_FLASH_FAULT_TIMEOUT</constant></entry>
+    		  <entry>The flash strobe was still on when
+    		  the timeout set by the user ---
+    		  V4L2_CID_FLASH_TIMEOUT control --- has expired.
+    		  Not all flash controllers may set this in all
+    		  such conditions.</entry>
+    		</row>
+    		<row>
+    		  <entry><constant>V4L2_FLASH_FAULT_OVER_TEMPERATURE</constant></entry>
+    		  <entry>The flash controller has overheated.</entry>
+    		</row>
+    		<row>
+    		  <entry><constant>V4L2_FLASH_FAULT_SHORT_CIRCUIT</constant></entry>
+    		  <entry>The short circuit protection of the flash
+    		  controller has been triggered.</entry>
+    		</row>
+    		<row>
+    		  <entry><constant>V4L2_FLASH_FAULT_OVER_CURRENT</constant></entry>
+    		  <entry>Current in the LED power supply has exceeded the limit
+    		  specific to the flash controller.</entry>
+    		</row>
+    		<row>
+    		  <entry><constant>V4L2_FLASH_FAULT_INDICATOR</constant></entry>
+    		  <entry>The flash controller has detected a short or open
+    		  circuit condition on the indicator LED.</entry>
+    		</row>
+    	      </tbody>
+    	    </entrytbl>
+    	  </row>
+    	  <row>
+    	    <entry spanname="id"><constant>V4L2_CID_FLASH_CHARGE</constant></entry>
+    	    <entry>boolean</entry>
+    	  </row>
+    	  <row><entry spanname="descr">Enable or disable charging of the xenon
+    	  flash capacitor.</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="id"><constant>V4L2_CID_FLASH_READY</constant></entry>
+    	    <entry>boolean</entry>
+    	  </row>
+    	  <row>
+    	    <entry spanname="descr">Is the flash ready to strobe?
+    	    Xenon flashes require their capacitors charged before
+    	    strobing. LED flashes often require a cooldown period
+    	    after strobe during which another strobe will not be
+    	    possible. This is a read-only control.</entry>
+    	  </row>
+    	  <row><entry></entry></row>
+    	</tbody>
+          </tgroup>
+          </table>
+	</section>
       </section>
-
-      <table pgwide="1" frame="none" id="flash-control-id">
-      <title>Flash Control IDs</title>
-
-      <tgroup cols="4">
-	<colspec colname="c1" colwidth="1*" />
-	<colspec colname="c2" colwidth="6*" />
-	<colspec colname="c3" colwidth="2*" />
-	<colspec colname="c4" colwidth="6*" />
-	<spanspec namest="c1" nameend="c2" spanname="id" />
-	<spanspec namest="c2" nameend="c4" spanname="descr" />
-	<thead>
-	  <row>
-	    <entry spanname="id" align="left">ID</entry>
-	    <entry align="left">Type</entry>
-	  </row><row rowsep="1"><entry spanname="descr" align="left">Description</entry>
-	  </row>
-	</thead>
-	<tbody valign="top">
-	  <row><entry></entry></row>
-	  <row>
-	    <entry spanname="id"><constant>V4L2_CID_FLASH_CLASS</constant></entry>
-	    <entry>class</entry>
-	  </row>
-	  <row>
-	    <entry spanname="descr">The FLASH class descriptor.</entry>
-	  </row>
-	  <row>
-	    <entry spanname="id"><constant>V4L2_CID_FLASH_LED_MODE</constant></entry>
-	    <entry>menu</entry>
-	  </row>
-	  <row id="v4l2-flash-led-mode">
-	    <entry spanname="descr">Defines the mode of the flash LED,
-	    the high-power white LED attached to the flash controller.
-	    Setting this control may not be possible in presence of
-	    some faults. See V4L2_CID_FLASH_FAULT.</entry>
-	  </row>
-	  <row>
-	    <entrytbl spanname="descr" cols="2">
-	      <tbody valign="top">
-		<row>
-		  <entry><constant>V4L2_FLASH_LED_MODE_NONE</constant></entry>
-		  <entry>Off.</entry>
-		</row>
-		<row>
-		  <entry><constant>V4L2_FLASH_LED_MODE_FLASH</constant></entry>
-		  <entry>Flash mode.</entry>
-		</row>
-		<row>
-		  <entry><constant>V4L2_FLASH_LED_MODE_TORCH</constant></entry>
-		  <entry>Torch mode. See V4L2_CID_FLASH_TORCH_INTENSITY.</entry>
-		</row>
-	      </tbody>
-	    </entrytbl>
-	  </row>
-	  <row>
-	    <entry spanname="id"><constant>V4L2_CID_FLASH_STROBE_SOURCE</constant></entry>
-	    <entry>menu</entry>
-	  </row>
-	  <row id="v4l2-flash-strobe-source"><entry
-	  spanname="descr">Defines the source of the flash LED
-	  strobe.</entry>
-	  </row>
-	  <row>
-	    <entrytbl spanname="descr" cols="2">
-	      <tbody valign="top">
-		<row>
-		  <entry><constant>V4L2_FLASH_STROBE_SOURCE_SOFTWARE</constant></entry>
-		  <entry>The flash strobe is triggered by using
-		  the V4L2_CID_FLASH_STROBE control.</entry>
-		</row>
-		<row>
-		  <entry><constant>V4L2_FLASH_STROBE_SOURCE_EXTERNAL</constant></entry>
-		  <entry>The flash strobe is triggered by an
-		  external source. Typically this is a sensor,
-		  which makes it possible to synchronises the
-		  flash strobe start to exposure start.</entry>
-		</row>
-	      </tbody>
-	    </entrytbl>
-	  </row>
-	  <row>
-	    <entry spanname="id"><constant>V4L2_CID_FLASH_STROBE</constant></entry>
-	    <entry>button</entry>
-	  </row>
-	  <row>
-	    <entry spanname="descr">Strobe flash. Valid when
-	    V4L2_CID_FLASH_LED_MODE is set to
-	    V4L2_FLASH_LED_MODE_FLASH and V4L2_CID_FLASH_STROBE_SOURCE
-	    is set to V4L2_FLASH_STROBE_SOURCE_SOFTWARE. Setting this
-	    control may not be possible in presence of some faults.
-	    See V4L2_CID_FLASH_FAULT.</entry>
-	  </row>
-	  <row>
-	    <entry spanname="id"><constant>V4L2_CID_FLASH_STROBE_STOP</constant></entry>
-	    <entry>button</entry>
-	  </row>
-	  <row><entry spanname="descr">Stop flash strobe immediately.</entry>
-	  </row>
-	  <row>
-	    <entry spanname="id"><constant>V4L2_CID_FLASH_STROBE_STATUS</constant></entry>
-	    <entry>boolean</entry>
-	  </row>
-	  <row>
-	    <entry spanname="descr">Strobe status: whether the flash
-	    is strobing at the moment or not. This is a read-only
-	    control.</entry>
-	  </row>
-	  <row>
-	    <entry spanname="id"><constant>V4L2_CID_FLASH_TIMEOUT</constant></entry>
-	    <entry>integer</entry>
-	  </row>
-	  <row>
-	    <entry spanname="descr">Hardware timeout for flash. The
-	    flash strobe is stopped after this period of time has
-	    passed from the start of the strobe.</entry>
-	  </row>
-	  <row>
-	    <entry spanname="id"><constant>V4L2_CID_FLASH_INTENSITY</constant></entry>
-	    <entry>integer</entry>
-	  </row>
-	  <row>
-	    <entry spanname="descr">Intensity of the flash strobe when
-	    the flash LED is in flash mode
-	    (V4L2_FLASH_LED_MODE_FLASH). The unit should be milliamps
-	    (mA) if possible.</entry>
-	  </row>
-	  <row>
-	    <entry spanname="id"><constant>V4L2_CID_FLASH_TORCH_INTENSITY</constant></entry>
-	    <entry>integer</entry>
-	  </row>
-	  <row>
-	    <entry spanname="descr">Intensity of the flash LED in
-	    torch mode (V4L2_FLASH_LED_MODE_TORCH). The unit should be
-	    milliamps (mA) if possible. Setting this control may not
-	    be possible in presence of some faults. See
-	    V4L2_CID_FLASH_FAULT.</entry>
-	  </row>
-	  <row>
-	    <entry spanname="id"><constant>V4L2_CID_FLASH_INDICATOR_INTENSITY</constant></entry>
-	    <entry>integer</entry>
-	  </row>
-	  <row>
-	    <entry spanname="descr">Intensity of the indicator LED.
-	    The indicator LED may be fully independent of the flash
-	    LED. The unit should be microamps (uA) if possible.</entry>
-	  </row>
-	  <row>
-	    <entry spanname="id"><constant>V4L2_CID_FLASH_FAULT</constant></entry>
-	    <entry>bitmask</entry>
-	  </row>
-	  <row>
-	    <entry spanname="descr">Faults related to the flash. The
-	    faults tell about specific problems in the flash chip
-	    itself or the LEDs attached to it. Faults may prevent
-	    further use of some of the flash controls. In particular,
-	    V4L2_CID_FLASH_LED_MODE is set to V4L2_FLASH_LED_MODE_NONE
-	    if the fault affects the flash LED. Exactly which faults
-	    have such an effect is chip dependent. Reading the faults
-	    resets the control and returns the chip to a usable state
-	    if possible.</entry>
-	  </row>
-	  <row>
-	    <entrytbl spanname="descr" cols="2">
-	      <tbody valign="top">
-		<row>
-		  <entry><constant>V4L2_FLASH_FAULT_OVER_VOLTAGE</constant></entry>
-		  <entry>Flash controller voltage to the flash LED
-		  has exceeded the limit specific to the flash
-		  controller.</entry>
-		</row>
-		<row>
-		  <entry><constant>V4L2_FLASH_FAULT_TIMEOUT</constant></entry>
-		  <entry>The flash strobe was still on when
-		  the timeout set by the user ---
-		  V4L2_CID_FLASH_TIMEOUT control --- has expired.
-		  Not all flash controllers may set this in all
-		  such conditions.</entry>
-		</row>
-		<row>
-		  <entry><constant>V4L2_FLASH_FAULT_OVER_TEMPERATURE</constant></entry>
-		  <entry>The flash controller has overheated.</entry>
-		</row>
-		<row>
-		  <entry><constant>V4L2_FLASH_FAULT_SHORT_CIRCUIT</constant></entry>
-		  <entry>The short circuit protection of the flash
-		  controller has been triggered.</entry>
-		</row>
-		<row>
-		  <entry><constant>V4L2_FLASH_FAULT_OVER_CURRENT</constant></entry>
-		  <entry>Current in the LED power supply has exceeded the limit
-		  specific to the flash controller.</entry>
-		</row>
-		<row>
-		  <entry><constant>V4L2_FLASH_FAULT_INDICATOR</constant></entry>
-		  <entry>The flash controller has detected a short or open
-		  circuit condition on the indicator LED.</entry>
-		</row>
-	      </tbody>
-	    </entrytbl>
-	  </row>
-	  <row>
-	    <entry spanname="id"><constant>V4L2_CID_FLASH_CHARGE</constant></entry>
-	    <entry>boolean</entry>
-	  </row>
-	  <row><entry spanname="descr">Enable or disable charging of the xenon
-	  flash capacitor.</entry>
-	  </row>
-	  <row>
-	    <entry spanname="id"><constant>V4L2_CID_FLASH_READY</constant></entry>
-	    <entry>boolean</entry>
-	  </row>
-	  <row>
-	    <entry spanname="descr">Is the flash ready to strobe?
-	    Xenon flashes require their capacitors charged before
-	    strobing. LED flashes often require a cooldown period
-	    after strobe during which another strobe will not be
-	    possible. This is a read-only control.</entry>
-	  </row>
-	  <row><entry></entry></row>
-	</tbody>
-      </tgroup>
-      </table>
     </section>
 
     <section id="jpeg-controls">
diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml b/Documentation/DocBook/media/v4l/dev-subdev.xml
index a3d9dd0..d15aaf8 100644
--- a/Documentation/DocBook/media/v4l/dev-subdev.xml
+++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
@@ -374,29 +374,29 @@
       rectangle --- if it is supported by the hardware.</para>
 
       <orderedlist>
-	<listitem>Sink pad format. The user configures the sink pad
+	<listitem><para>Sink pad format. The user configures the sink pad
 	format. This format defines the parameters of the image the
-	entity receives through the pad for further processing.</listitem>
+	entity receives through the pad for further processing.</para></listitem>
 
-	<listitem>Sink pad actual crop selection. The sink pad crop
-	defines the crop performed to the sink pad format.</listitem>
+	<listitem><para>Sink pad actual crop selection. The sink pad crop
+	defines the crop performed to the sink pad format.</para></listitem>
 
-	<listitem>Sink pad actual compose selection. The size of the
+	<listitem><para>Sink pad actual compose selection. The size of the
 	sink pad compose rectangle defines the scaling ratio compared
 	to the size of the sink pad crop rectangle. The location of
 	the compose rectangle specifies the location of the actual
 	sink compose rectangle in the sink compose bounds
-	rectangle.</listitem>
+	rectangle.</para></listitem>
 
-	<listitem>Source pad actual crop selection. Crop on the source
+	<listitem><para>Source pad actual crop selection. Crop on the source
 	pad defines crop performed to the image in the sink compose
-	bounds rectangle.</listitem>
+	bounds rectangle.</para></listitem>
 
-	<listitem>Source pad format. The source pad format defines the
+	<listitem><para>Source pad format. The source pad format defines the
 	output pixel format of the subdev, as well as the other
 	parameters with the exception of the image width and height.
 	Width and height are defined by the size of the source pad
-	actual crop selection.</listitem>
+	actual crop selection.</para></listitem>
       </orderedlist>
 
       <para>Accessing any of the above rectangles not supported by the
diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
index 8eace3e..2d3f0b1a 100644
--- a/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10dpcm8.xml
@@ -22,8 +22,7 @@
 	with 10 bits per colour compressed to 8 bits each, using DPCM
 	compression. DPCM, differential pulse-code modulation, is lossy.
 	Each colour component consumes 8 bits of memory. In other respects
-	this format is similar to <xref
-	linkend="pixfmt-srggb10">.</xref></para>
+	this format is similar to <xref linkend="pixfmt-srggb10" />.</para>
 
       </refsect1>
     </refentry>
diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
index e7ed507..4c238ce 100644
--- a/Documentation/DocBook/media/v4l/selection-api.xml
+++ b/Documentation/DocBook/media/v4l/selection-api.xml
@@ -40,6 +40,7 @@ cropping and composing rectangles have the same size.</para>
     <section>
       <title>Selection targets</title>
 
+      <para>
       <figure id="sel-targets-capture">
 	<title>Cropping and composing targets</title>
 	<mediaobject>
@@ -52,12 +53,12 @@ cropping and composing rectangles have the same size.</para>
 	  </textobject>
 	</mediaobject>
       </figure>
+      </para>
 
+      <para>See <xref linkend="v4l2-selection-targets" /> for more
+    information.</para>
     </section>
 
-    See <xref linkend="v4l2-selection-targets" /> for more
-    information.
-
   <section>
 
   <title>Configuration</title>
@@ -216,18 +217,17 @@ composing and cropping operations by setting the appropriate targets.  The V4L2
 API lacks any support for composing to and cropping from an image inside a
 memory buffer.  The application could configure a capture device to fill only a
 part of an image by abusing V4L2 API.  Cropping a smaller image from a larger
-one is achieved by setting the field <structfield>
-&v4l2-pix-format;::bytesperline </structfield>.  Introducing an image offsets
-could be done by modifying field <structfield> &v4l2-buffer;::m:userptr
-</structfield> before calling <constant> VIDIOC_QBUF </constant>. Those
+one is achieved by setting the field
+&v4l2-pix-format;<structfield>::bytesperline</structfield>.  Introducing an image offsets
+could be done by modifying field &v4l2-buffer;<structfield>::m_userptr</structfield>
+before calling <constant> VIDIOC_QBUF </constant>. Those
 operations should be avoided because they are not portable (endianness), and do
 not work for macroblock and Bayer formats and mmap buffers.  The selection API
 deals with configuration of buffer cropping/composing in a clear, intuitive and
 portable way.  Next, with the selection API the concepts of the padded target
-and constraints flags are introduced.  Finally, <structname> &v4l2-crop;
-</structname> and <structname> &v4l2-cropcap; </structname> have no reserved
-fields. Therefore there is no way to extend their functionality.  The new
-<structname> &v4l2-selection; </structname> provides a lot of place for future
+and constraints flags are introduced.  Finally, &v4l2-crop; and &v4l2-cropcap;
+have no reserved fields. Therefore there is no way to extend their functionality.
+The new &v4l2-selection; provides a lot of place for future
 extensions.  Driver developers are encouraged to implement only selection API.
 The former cropping API would be simulated using the new one. </para>
 
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
index f76d8a6..b11ec75 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
@@ -152,12 +152,10 @@ satisfactory parameters have been negotiated. If constraints flags have to be
 violated at then ERANGE is returned. The error indicates that <emphasis> there
 exist no rectangle </emphasis> that satisfies the constraints.</para>
 
-  </refsect1>
-
   <para>Selection targets and flags are documented in <xref
   linkend="v4l2-selections-common"/>.</para>
 
-    <section>
+    <para>
       <figure id="sel-const-adjust">
 	<title>Size adjustments with constraint flags.</title>
 	<mediaobject>
@@ -170,9 +168,9 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
 	  </textobject>
 	</mediaobject>
       </figure>
-    </section>
+    </para>
 
-  <refsect1>
+  <para>
     <table pgwide="1" frame="none" id="v4l2-selection">
       <title>struct <structname>v4l2_selection</structname></title>
       <tgroup cols="3">
@@ -208,6 +206,7 @@ exist no rectangle </emphasis> that satisfies the constraints.</para>
 	</tbody>
       </tgroup>
     </table>
+  </para>
   </refsect1>
 
   <refsect1>
diff --git a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
index 77ff5be..6a821a6 100644
--- a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
@@ -155,6 +155,8 @@ or no buffers have been allocated yet, or the
 <structfield>userptr</structfield> or
 <structfield>length</structfield> are invalid.</para>
 	</listitem>
+      </varlistentry>
+      <varlistentry>
 	<term><errorcode>EIO</errorcode></term>
 	<listitem>
 	  <para><constant>VIDIOC_DQBUF</constant> failed due to an
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
index f33cc81..1ba9e99 100644
--- a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
@@ -69,23 +69,22 @@
     more information on how each selection target affects the image
     processing pipeline inside the subdevice.</para>
 
-    <section>
+    <refsect2>
       <title>Types of selection targets</title>
 
       <para>There are two types of selection targets: actual and bounds. The
       actual targets are the targets which configure the hardware. The BOUNDS
       target will return a rectangle that contain all possible actual
       rectangles.</para>
-    </section>
+    </refsect2>
 
-    <section>
+    <refsect2>
       <title>Discovering supported features</title>
 
       <para>To discover which targets are supported, the user can
       perform <constant>VIDIOC_SUBDEV_G_SELECTION</constant> on them.
       Any unsupported target will return
       <constant>EINVAL</constant>.</para>
-    </section>
 
     <para>Selection targets and flags are documented in <xref
     linkend="v4l2-selections-common"/>.</para>
@@ -132,6 +131,7 @@
 	</tbody>
       </tgroup>
     </table>
+    </refsect2>
 
   </refsect1>
 
-- 
1.7.10.4

