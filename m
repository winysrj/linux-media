Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:41657 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754861AbbEaM73 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2015 08:59:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/3] DocBook media: xmllint fixes
Date: Sun, 31 May 2015 14:59:11 +0200
Message-Id: <1433077152-18200-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433077152-18200-1-git-send-email-hverkuil@xs4all.nl>
References: <1433077152-18200-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fixes a large number of xmllint errors.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/dvb/dvbproperty.xml    | 20 ++++++++---------
 .../media/dvb/fe-diseqc-recv-slave-reply.xml       |  2 +-
 .../DocBook/media/dvb/fe-diseqc-send-burst.xml     |  8 +++----
 .../media/dvb/fe-diseqc-send-master-cmd.xml        |  2 +-
 .../media/dvb/fe-enable-high-lnb-voltage.xml       |  6 ++---
 Documentation/DocBook/media/dvb/fe-get-info.xml    |  8 +++----
 .../DocBook/media/dvb/fe-get-property.xml          | 26 +++++++++++-----------
 Documentation/DocBook/media/dvb/fe-read-status.xml |  4 ++--
 .../media/dvb/fe-set-frontend-tune-mode.xml        |  6 ++---
 Documentation/DocBook/media/dvb/fe-set-tone.xml    |  8 +++----
 Documentation/DocBook/media/dvb/fe-set-voltage.xml |  6 ++---
 Documentation/DocBook/media/dvb/frontend.xml       | 16 ++++++-------
 .../DocBook/media/dvb/frontend_legacy_api.xml      |  3 +--
 13 files changed, 56 insertions(+), 59 deletions(-)

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index 00bf3ed..5dfde52 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -27,13 +27,13 @@
     rate of 5.217 Mbauds, those properties should be sent to
     <link linkend="FE_GET_PROPERTY"><constant>FE_SET_PROPERTY</constant></link> ioctl:</para>
     <itemizedlist>
-	<listitem>&DTV-DELIVERY-SYSTEM; = SYS_DVBC_ANNEX_A</listitem>
-	<listitem>&DTV-FREQUENCY; = 651000000</listitem>
-	<listitem>&DTV-MODULATION; = QAM_256</listitem>
-	<listitem>&DTV-INVERSION; = INVERSION_AUTO</listitem>
-	<listitem>&DTV-SYMBOL-RATE; = 5217000</listitem>
-	<listitem>&DTV-INNER-FEC; = FEC_3_4</listitem>
-	<listitem>&DTV-TUNE;</listitem>
+	<listitem><para>&DTV-DELIVERY-SYSTEM; = SYS_DVBC_ANNEX_A</para></listitem>
+	<listitem><para>&DTV-FREQUENCY; = 651000000</para></listitem>
+	<listitem><para>&DTV-MODULATION; = QAM_256</para></listitem>
+	<listitem><para>&DTV-INVERSION; = INVERSION_AUTO</para></listitem>
+	<listitem><para>&DTV-SYMBOL-RATE; = 5217000</para></listitem>
+	<listitem><para>&DTV-INNER-FEC; = FEC_3_4</para></listitem>
+	<listitem><para>&DTV-TUNE;</para></listitem>
     </itemizedlist>
 
 <para>The code that would do the above is:</para>
@@ -394,7 +394,6 @@ get/set up to 64 properties. The actual meaning of each property is described on
 	</row><row>
 	    <entry>FEC_3_5</entry>
 	    <entry>Forward Error Correction Code 3/5</entry>
-	</row><row>
 	</row>
         </tbody>
     </tgroup>
@@ -916,7 +915,6 @@ typedef enum atscmh_sccc_code_mode {
         </tbody>
     </tgroup>
 </table>
-</section>
 
 		<para>Notes:</para>
 		<para>1) If <constant>DTV_GUARD_INTERVAL</constant> is set the <constant>GUARD_INTERVAL_AUTO</constant> the hardware will
@@ -924,6 +922,7 @@ typedef enum atscmh_sccc_code_mode {
 			in the missing parameters.</para>
 		<para>2) Intervals 1/128, 19/128 and 19/256 are used only for DVB-T2 at present</para>
 		<para>3) DTMB specifies PN420, PN595 and PN945.</para>
+</section>
 	</section>
 	<section id="DTV-TRANSMISSION-MODE">
 		<title><constant>DTV_TRANSMISSION_MODE</constant></title>
@@ -975,12 +974,10 @@ typedef enum atscmh_sccc_code_mode {
 	</row><row>
 	    <entry>TRANSMISSION_MODE_C3780</entry>
 	    <entry>Multi Carrier (C=3780) transmission mode (DTMB)</entry>
-	</row><row>
 	</row>
         </tbody>
     </tgroup>
 </table>
-</section>
 
 
 		<para>Notes:</para>
@@ -993,6 +990,7 @@ typedef enum atscmh_sccc_code_mode {
 		<para>3) DVB-T specifies 2K and 8K as valid sizes.</para>
 		<para>4) DVB-T2 specifies 1K, 2K, 4K, 8K, 16K and 32K.</para>
 		<para>5) DTMB specifies C1 and C3780.</para>
+</section>
 	</section>
 	<section id="DTV-HIERARCHY">
 	<title><constant>DTV_HIERARCHY</constant></title>
diff --git a/Documentation/DocBook/media/dvb/fe-diseqc-recv-slave-reply.xml b/Documentation/DocBook/media/dvb/fe-diseqc-recv-slave-reply.xml
index de68b5b..4595dbf 100644
--- a/Documentation/DocBook/media/dvb/fe-diseqc-recv-slave-reply.xml
+++ b/Documentation/DocBook/media/dvb/fe-diseqc-recv-slave-reply.xml
@@ -15,7 +15,7 @@
 	<funcdef>int <function>ioctl</function></funcdef>
 	<paramdef>int <parameter>fd</parameter></paramdef>
 	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>&dvb-diseqc-slave-reply; *<parameter>argp</parameter></paramdef>
+	<paramdef>struct dvb_diseqc_slave_reply *<parameter>argp</parameter></paramdef>
       </funcprototype>
     </funcsynopsis>
   </refsynopsisdiv>
diff --git a/Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml b/Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml
index f79c3f2..91dd207 100644
--- a/Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml
+++ b/Documentation/DocBook/media/dvb/fe-diseqc-send-burst.xml
@@ -15,7 +15,7 @@
 	<funcdef>int <function>ioctl</function></funcdef>
 	<paramdef>int <parameter>fd</parameter></paramdef>
 	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>&fe-sec-mini-cmd; *<parameter>tone</parameter></paramdef>
+	<paramdef>enum fe_sec_mini_cmd *<parameter>tone</parameter></paramdef>
       </funcprototype>
     </funcsynopsis>
   </refsynopsisdiv>
@@ -58,11 +58,11 @@
 &return-value-dvb;
 </refsect1>
 
-<section id="fe-sec-mini-cmd-t">
+<refsect1 id="fe-sec-mini-cmd-t">
 <title>enum fe_sec_mini_cmd</title>
 
 <table pgwide="1" frame="none" id="fe-sec-mini-cmd">
-    <title>enum fe_sec_tone_mode</title>
+    <title>enum fe_sec_mini_cmd</title>
     <tgroup cols="2">
 	&cs-def;
 	<thead>
@@ -84,6 +84,6 @@
         </tbody>
     </tgroup>
 </table>
-</section>
+</refsect1>
 
 </refentry>
diff --git a/Documentation/DocBook/media/dvb/fe-diseqc-send-master-cmd.xml b/Documentation/DocBook/media/dvb/fe-diseqc-send-master-cmd.xml
index d4d6cd8..38cf313 100644
--- a/Documentation/DocBook/media/dvb/fe-diseqc-send-master-cmd.xml
+++ b/Documentation/DocBook/media/dvb/fe-diseqc-send-master-cmd.xml
@@ -15,7 +15,7 @@
 	<funcdef>int <function>ioctl</function></funcdef>
 	<paramdef>int <parameter>fd</parameter></paramdef>
 	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>&dvb-diseqc-master-cmd; *<parameter>argp</parameter></paramdef>
+	<paramdef>struct dvb_diseqc_master_cmd *<parameter>argp</parameter></paramdef>
       </funcprototype>
     </funcsynopsis>
   </refsynopsisdiv>
diff --git a/Documentation/DocBook/media/dvb/fe-enable-high-lnb-voltage.xml b/Documentation/DocBook/media/dvb/fe-enable-high-lnb-voltage.xml
index 3ee08a8..c11890b 100644
--- a/Documentation/DocBook/media/dvb/fe-enable-high-lnb-voltage.xml
+++ b/Documentation/DocBook/media/dvb/fe-enable-high-lnb-voltage.xml
@@ -41,9 +41,9 @@
 	<listitem>
 	    <para>Valid flags:</para>
 	    <itemizedlist>
-		<listitem>0 - normal 13V and 18V.</listitem>
-		<listitem>&gt;0 - enables slightly higher voltages instead of
-		    13/18V, in order to compensate for long antena cables.</listitem>
+		<listitem><para>0 - normal 13V and 18V.</para></listitem>
+		<listitem><para>&gt;0 - enables slightly higher voltages instead of
+		    13/18V, in order to compensate for long antenna cables.</para></listitem>
 	    </itemizedlist>
 	</listitem>
       </varlistentry>
diff --git a/Documentation/DocBook/media/dvb/fe-get-info.xml b/Documentation/DocBook/media/dvb/fe-get-info.xml
index 4400790..0e0245e 100644
--- a/Documentation/DocBook/media/dvb/fe-get-info.xml
+++ b/Documentation/DocBook/media/dvb/fe-get-info.xml
@@ -16,7 +16,7 @@
 	<funcdef>int <function>ioctl</function></funcdef>
 	<paramdef>int <parameter>fd</parameter></paramdef>
 	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>&dvb-frontend-info; *<parameter>argp</parameter></paramdef>
+	<paramdef>struct dvb_frontend_info *<parameter>argp</parameter></paramdef>
       </funcprototype>
     </funcsynopsis>
   </refsynopsisdiv>
@@ -112,12 +112,12 @@ driver is not compatible with this specification the ioctl returns an error.
 	</tbody>
       </tgroup>
     </table>
-  </refsect1>
 
   <para>NOTE: The frequencies are specified in Hz for Terrestrial and Cable
       systems. They're specified in kHz for Satellite systems</para>
+  </refsect1>
 
-<section id="fe-caps-t">
+<refsect1 id="fe-caps-t">
 <title>frontend capabilities</title>
 
 <para>Capabilities describe what a frontend can do. Some capabilities are
@@ -262,5 +262,5 @@ driver is not compatible with this specification the ioctl returns an error.
         </tbody>
     </tgroup>
 </table>
-</section>
+</refsect1>
 </refentry>
diff --git a/Documentation/DocBook/media/dvb/fe-get-property.xml b/Documentation/DocBook/media/dvb/fe-get-property.xml
index 456ed92..7d0bd78 100644
--- a/Documentation/DocBook/media/dvb/fe-get-property.xml
+++ b/Documentation/DocBook/media/dvb/fe-get-property.xml
@@ -17,7 +17,7 @@
 	<funcdef>int <function>ioctl</function></funcdef>
 	<paramdef>int <parameter>fd</parameter></paramdef>
 	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>&dtv-properties; *<parameter>argp</parameter></paramdef>
+	<paramdef>struct dtv_property *<parameter>argp</parameter></paramdef>
       </funcprototype>
     </funcsynopsis>
   </refsynopsisdiv>
@@ -57,25 +57,25 @@ and on the device:</para>
 <listitem>
     <para><constant>FE_SET_PROPERTY:</constant></para>
 <itemizedlist>
-<listitem>This ioctl is used to set one or more
-	frontend properties.</listitem>
-<listitem>This is the basic command to request the frontend to tune into some
-    frequency and to start decoding the digital TV signal.</listitem>
-<listitem>This call requires read/write access to the device.</listitem>
-<listitem>At return, the values are updated to reflect the
-    actual parameters used.</listitem>
+<listitem><para>This ioctl is used to set one or more
+	frontend properties.</para></listitem>
+<listitem><para>This is the basic command to request the frontend to tune into some
+    frequency and to start decoding the digital TV signal.</para></listitem>
+<listitem><para>This call requires read/write access to the device.</para></listitem>
+<listitem><para>At return, the values are updated to reflect the
+    actual parameters used.</para></listitem>
 </itemizedlist>
 </listitem>
 <listitem>
     <para><constant>FE_GET_PROPERTY:</constant></para>
 <itemizedlist>
-<listitem>This ioctl is used to get properties and
-statistics from the frontend.</listitem>
-<listitem>No properties are changed, and statistics aren't reset.</listitem>
-<listitem>This call only requires read-only access to the device.</listitem>
+<listitem><para>This ioctl is used to get properties and
+statistics from the frontend.</para></listitem>
+<listitem><para>No properties are changed, and statistics aren't reset.</para></listitem>
+<listitem><para>This call only requires read-only access to the device.</para></listitem>
 </itemizedlist>
 </listitem>
 </itemizedlist>
-&return-value-dvb;.
+&return-value-dvb;
 </refsect1>
 </refentry>
diff --git a/Documentation/DocBook/media/dvb/fe-read-status.xml b/Documentation/DocBook/media/dvb/fe-read-status.xml
index bbd0b5b..3e4c794 100644
--- a/Documentation/DocBook/media/dvb/fe-read-status.xml
+++ b/Documentation/DocBook/media/dvb/fe-read-status.xml
@@ -59,7 +59,7 @@ pointer to an integer where the status will be written.
 &return-value-dvb;
 </refsect1>
 
-<section id="fe-status-t">
+<refsect1 id="fe-status-t">
 <title>int fe_status</title>
 
 <para>The fe_status parameter is used to indicate the current state
@@ -103,5 +103,5 @@ pointer to an integer where the status will be written.
         </tbody>
     </tgroup>
 </table>
-</section>
+</refsect1>
 </refentry>
diff --git a/Documentation/DocBook/media/dvb/fe-set-frontend-tune-mode.xml b/Documentation/DocBook/media/dvb/fe-set-frontend-tune-mode.xml
index 30bc99d..99fa8a0 100644
--- a/Documentation/DocBook/media/dvb/fe-set-frontend-tune-mode.xml
+++ b/Documentation/DocBook/media/dvb/fe-set-frontend-tune-mode.xml
@@ -40,14 +40,14 @@
 	<listitem>
 	    <para>Valid flags:</para>
 	    <itemizedlist>
-		<listitem>0 - normal tune mode</listitem>
-		<listitem>FE_TUNE_MODE_ONESHOT - When set, this flag will
+		<listitem><para>0 - normal tune mode</para></listitem>
+		<listitem><para>FE_TUNE_MODE_ONESHOT - When set, this flag will
 		    disable any zigzagging or other "normal" tuning behaviour.
 		    Additionally, there will be no automatic monitoring of the
 		    lock status, and hence no frontend events will be
 		    generated. If a frontend device is closed, this flag will
 		    be automatically turned off when the device is reopened
-		    read-write.</listitem>
+		    read-write.</para></listitem>
 	    </itemizedlist>
 	</listitem>
       </varlistentry>
diff --git a/Documentation/DocBook/media/dvb/fe-set-tone.xml b/Documentation/DocBook/media/dvb/fe-set-tone.xml
index 4ef6c74..12cd4dd 100644
--- a/Documentation/DocBook/media/dvb/fe-set-tone.xml
+++ b/Documentation/DocBook/media/dvb/fe-set-tone.xml
@@ -15,7 +15,7 @@
 	<funcdef>int <function>ioctl</function></funcdef>
 	<paramdef>int <parameter>fd</parameter></paramdef>
 	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>&fe-sec-tone-mode; *<parameter>tone</parameter></paramdef>
+	<paramdef>enum fe_sec_tone_mode *<parameter>tone</parameter></paramdef>
       </funcprototype>
     </funcsynopsis>
   </refsynopsisdiv>
@@ -61,8 +61,8 @@
 &return-value-dvb;
 </refsect1>
 
-<section id="fe-sec-tone-mode-t">
-<title>enum fe_sec_voltage</title>
+<refsect1 id="fe-sec-tone-mode-t">
+<title>enum fe_sec_tone_mode</title>
 
 <table pgwide="1" frame="none" id="fe-sec-tone-mode">
     <title>enum fe_sec_tone_mode</title>
@@ -86,6 +86,6 @@
         </tbody>
     </tgroup>
 </table>
-</section>
+</refsect1>
 
 </refentry>
diff --git a/Documentation/DocBook/media/dvb/fe-set-voltage.xml b/Documentation/DocBook/media/dvb/fe-set-voltage.xml
index 688fbc2..73710f8 100644
--- a/Documentation/DocBook/media/dvb/fe-set-voltage.xml
+++ b/Documentation/DocBook/media/dvb/fe-set-voltage.xml
@@ -15,7 +15,7 @@
 	<funcdef>int <function>ioctl</function></funcdef>
 	<paramdef>int <parameter>fd</parameter></paramdef>
 	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>&fe-sec-voltage; *<parameter>voltage</parameter></paramdef>
+	<paramdef>enum fe_sec_voltage *<parameter>voltage</parameter></paramdef>
       </funcprototype>
     </funcsynopsis>
   </refsynopsisdiv>
@@ -65,7 +65,7 @@
 &return-value-dvb;
 </refsect1>
 
-<section id="fe-sec-voltage-t">
+<refsect1 id="fe-sec-voltage-t">
 <title>enum fe_sec_voltage</title>
 
 <table pgwide="1" frame="none" id="fe-sec-voltage">
@@ -92,6 +92,6 @@
         </tbody>
     </tgroup>
 </table>
-</section>
+</refsect1>
 
 </refentry>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 9eda6c0..ab42d8c 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -2,16 +2,16 @@
 
 <para>The DVB frontend API was designed to support three types of delivery systems:</para>
 <itemizedlist>
-    <listitem>Terrestrial systems: DVB-T, DVB-T2, ATSC, ATSC M/H, ISDB-T, DVB-H, DTMB, CMMB</listitem>
-    <listitem>Cable systems: DVB-C Annex A/C, ClearQAM (DVB-C Annex B), ISDB-C</listitem>
-    <listitem>Satellite systems: DVB-S, DVB-S2, DVB Turbo, ISDB-S, DSS</listitem>
+    <listitem><para>Terrestrial systems: DVB-T, DVB-T2, ATSC, ATSC M/H, ISDB-T, DVB-H, DTMB, CMMB</para></listitem>
+    <listitem><para>Cable systems: DVB-C Annex A/C, ClearQAM (DVB-C Annex B), ISDB-C</para></listitem>
+    <listitem><para>Satellite systems: DVB-S, DVB-S2, DVB Turbo, ISDB-S, DSS</para></listitem>
 </itemizedlist>
 <para>The DVB frontend controls several sub-devices including:</para>
 <itemizedlist>
-    <listitem>Tuner</listitem>,
-    <listitem>Digital TV demodulator</listitem>
-    <listitem>Low noise amplifier (LNA)</listitem>
-    <listitem>Satellite Equipment Control (SEC) hardware (only for Satellite).</listitem>
+    <listitem><para>Tuner</para></listitem>
+    <listitem><para>Digital TV demodulator</para></listitem>
+    <listitem><para>Low noise amplifier (LNA)</para></listitem>
+    <listitem><para>Satellite Equipment Control (SEC) hardware (only for Satellite).</para></listitem>
 </itemizedlist>
 <para>The frontend can be accessed through
     <emphasis role="bold">/dev/dvb/adapter?/frontend?</emphasis>. Data types and
@@ -50,7 +50,7 @@ specification is available at
 <para>Signal statistics are provided via <link linkend="FE_GET_PROPERTY"><constant>FE_GET_PROPERTY</constant></link>.
     Please notice that several statistics require the demodulator to be fully
     locked (e. g. with FE_HAS_LOCK bit set). See
-    <xref linkend="frontend-stat-properties">Frontend statistics indicators</xref>
+    <link linkend="frontend-stat-properties">Frontend statistics indicators</link>
     for more details.</para>
 </section>
 
diff --git a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
index cb2e183..3005cec 100644
--- a/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
+++ b/Documentation/DocBook/media/dvb/frontend_legacy_api.xml
@@ -95,7 +95,6 @@ supported via the new <link linkend="FE_GET_PROPERTY">FE_GET_PROPERTY/FE_GET_SET
 	</row><row>
 	    <entry>BANDWIDTH_10_MHZ</entry>
 	    <entry>10 MHz</entry>
-	</row><row>
 	</row>
         </tbody>
     </tgroup>
@@ -200,7 +199,7 @@ struct dvb_vsb_parameters {
  </section>
 </section>
 
-<section id="frontend_fcalls">
+<section id="frontend_legacy_fcalls">
 <title>Frontend Legacy Function Calls</title>
 
 <para>Those functions are defined at DVB version 3. The support is kept in
-- 
2.1.4

