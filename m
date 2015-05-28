Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51506 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240AbbE1Vtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 09/35] DocBook: move FE_GET_INFO to a separate xml file
Date: Thu, 28 May 2015 18:49:12 -0300
Message-Id: <d669d929c0a87a3aace98ddbe6cf2772876608c3.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Keeping everything altogether makes harder to reorganize the
DocBook. So, move the FE_GET_INFO ioctl and the associated structures
into a separate file.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

 create mode 100644 Documentation/DocBook/media/dvb/frontend_get_info.xml

diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index e8032127886b..86346189e8fb 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -37,271 +37,7 @@ specification is available at
 	<link linkend="FE_GET_INFO">FE_GET_INFO</link>.</para>
 </section>
 
-<refentry id="FE_GET_INFO">
-  <refmeta>
-    <refentrytitle>ioctl FE_GET_INFO</refentrytitle>
-    &manvol;
-  </refmeta>
-
-  <refnamediv>
-    <refname>FE_GET_INFO</refname>
-    <refpurpose>Query DVB frontend capabilities and returns information about
-	the front-end. This call only requires read-only access to the device</refpurpose>
-  </refnamediv>
-
-  <refsynopsisdiv>
-    <funcsynopsis>
-      <funcprototype>
-	<funcdef>int <function>ioctl</function></funcdef>
-	<paramdef>int <parameter>fd</parameter></paramdef>
-	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>struct dvb_frontend_info *<parameter>argp</parameter></paramdef>
-      </funcprototype>
-    </funcsynopsis>
-  </refsynopsisdiv>
-
-  <refsect1>
-    <title>Arguments</title>
-        <variablelist>
-      <varlistentry>
-	<term><parameter>fd</parameter></term>
-	<listitem>
-	  <para>&fd;</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><parameter>request</parameter></term>
-	<listitem>
-	  <para>FE_GET_INFO</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><parameter>argp</parameter></term>
-	<listitem>
-	    <para>pointer to struct &dvb-frontend-info;</para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
-  </refsect1>
-
-  <refsect1>
-    <title>Description</title>
-
-    <para>All DVB frontend devices support the
-<constant>FE_GET_INFO</constant> ioctl. It is used to identify
-kernel devices compatible with this specification and to obtain
-information about driver and hardware capabilities. The ioctl takes a
-pointer to dvb_frontend_info which is filled by the driver. When the
-driver is not compatible with this specification the ioctl returns an error &return-value-dvb;.
-</para>
-
-    <table pgwide="1" frame="none" id="dvb-frontend-info">
-      <title>struct <structname>dvb_frontend_info</structname></title>
-      <tgroup cols="3">
-	&cs-str;
-	<tbody valign="top">
-	  <row>
-	    <entry>char *</entry>
-	    <entry>name[128]</entry>
-	    <entry>Name of the frontend</entry>
-	  </row><row>
-	    <entry>fe_type_t</entry>
-	    <entry>type</entry>
-	    <entry>DVBv3 type. Should not be used on modern programs, as a
-		frontend may have more than one type. So, the DVBv5 API should
-		be used instead to enumerate and select the frontend type.</entry>
-	  </row><row>
-	    <entry>uint32_t</entry>
-	    <entry>frequency_min</entry>
-	    <entry>Minimal frequency supported by the frontend</entry>
-	  </row><row>
-	    <entry>uint32_t</entry>
-	    <entry>frequency_max</entry>
-	    <entry>Maximal frequency supported by the frontend</entry>
-	  </row><row>
-	    <entry>uint32_t</entry>
-	    <entry>frequency_stepsize</entry>
-	    <entry>Frequency step - all frequencies are multiple of this value</entry>
-	  </row><row>
-	    <entry>uint32_t</entry>
-	    <entry>frequency_tolerance</entry>
-	    <entry>Tolerance of the frequency</entry>
-	  </row><row>
-	    <entry>uint32_t</entry>
-	    <entry>symbol_rate_min</entry>
-	    <entry>Minimal symbol rate (for Cable/Satellite systems), in bauds</entry>
-	  </row><row>
-	    <entry>uint32_t</entry>
-	    <entry>symbol_rate_max</entry>
-	    <entry>Maximal symbol rate (for Cable/Satellite systems), in bauds</entry>
-	  </row><row>
-	    <entry>uint32_t</entry>
-	    <entry>symbol_rate_tolerance</entry>
-	    <entry>Maximal symbol rate tolerance, in ppm</entry>
-	  </row><row>
-	    <entry>uint32_t</entry>
-	    <entry>notifier_delay</entry>
-	    <entry>Deprecated. Not used by any driver.</entry>
-	  </row><row>
-	    <entry>&fe-caps;</entry>
-	    <entry>caps</entry>
-	    <entry>Capabilities supported by the frontend</entry>
-          </row>
-	</tbody>
-      </tgroup>
-    </table>
-  </refsect1>
-
-  <para>NOTE: The frequencies are specified in Hz for Terrestrial and Cable
-      systems. They're specified in kHz for Satellite systems</para>
-
-<section id="fe-caps-t">
-<title>frontend capabilities</title>
-
-<para>Capabilities describe what a frontend can do. Some capabilities are
-    supported only on some specific frontend types.</para>
-
-<table pgwide="1" frame="none" id="fe-caps">
-    <title>enum fe_caps</title>
-    <tgroup cols="2">
-	&cs-def;
-	<thead>
-	<row>
-	    <entry>ID</entry>
-	    <entry>Description</entry>
-	</row>
-	</thead>
-	<tbody valign="top">
-	<row>
-	<entry><constant>FE_IS_STUPID</constant></entry>
-	<entry>There's something wrong at the frontend, and it can't
-	    report its capabilities</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_INVERSION_AUTO</constant></entry>
-	<entry>The frontend is capable of auto-detecting inversion</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_FEC_1_2</constant></entry>
-	<entry>The frontend supports FEC 1/2</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_FEC_2_3</constant></entry>
-	<entry>The frontend supports FEC 2/3</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_FEC_3_4</constant></entry>
-	<entry>The frontend supports FEC 3/4</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_FEC_4_5</constant></entry>
-	<entry>The frontend supports FEC 4/5</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_FEC_5_6</constant></entry>
-	<entry>The frontend supports FEC 5/6</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_FEC_6_7</constant></entry>
-	<entry>The frontend supports FEC 6/7</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_FEC_7_8</constant></entry>
-	<entry>The frontend supports FEC 7/8</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_FEC_8_9</constant></entry>
-	<entry>The frontend supports FEC 8/9</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_FEC_AUTO</constant></entry>
-	<entry>The frontend can autodetect FEC.</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_QPSK</constant></entry>
-	<entry>The frontend supports QPSK modulation</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_QAM_16</constant></entry>
-	<entry>The frontend supports 16-QAM modulation</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_QAM_32</constant></entry>
-	<entry>The frontend supports 32-QAM modulation</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_QAM_64</constant></entry>
-	<entry>The frontend supports 64-QAM modulation</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_QAM_128</constant></entry>
-	<entry>The frontend supports 128-QAM modulation</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_QAM_256</constant></entry>
-	<entry>The frontend supports 256-QAM modulation</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_QAM_AUTO</constant></entry>
-	<entry>The frontend can autodetect modulation</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_TRANSMISSION_MODE_AUTO</constant></entry>
-	<entry>The frontend can autodetect the transmission mode</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_BANDWIDTH_AUTO</constant></entry>
-	<entry>The frontend can autodetect the bandwidth</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_GUARD_INTERVAL_AUTO</constant></entry>
-	<entry>The frontend can autodetect the guard interval</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_HIERARCHY_AUTO</constant></entry>
-	<entry>The frontend can autodetect hierarch</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_8VSB</constant></entry>
-	<entry>The frontend supports 8-VSB modulation</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_16VSB</constant></entry>
-	<entry>The frontend supports 16-VSB modulation</entry>
-	</row>
-	<row>
-	<entry><constant>FE_HAS_EXTENDED_CAPS</constant></entry>
-	<entry>Currently, unused</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_MULTISTREAM</constant></entry>
-	<entry>The frontend supports multistream filtering</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_TURBO_FEC</constant></entry>
-	<entry>The frontend supports turbo FEC modulation</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_2G_MODULATION</constant></entry>
-	<entry>The frontend supports "2nd generation modulation" (DVB-S2/T2)></entry>
-	</row>
-	<row>
-	<entry><constant>FE_NEEDS_BENDING</constant></entry>
-	<entry>Not supported anymore, don't use it</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_RECOVER</constant></entry>
-	<entry>The frontend can recover from a cable unplug automatically</entry>
-	</row>
-	<row>
-	<entry><constant>FE_CAN_MUTE_TS</constant></entry>
-	<entry>The frontend can stop spurious TS data output</entry>
-	</row>
-        </tbody>
-    </tgroup>
-</table>
-</section>
-</refentry>
+&sub-frontend_get_info;
 
 <section id="dvb-diseqc-master-cmd">
 <title>diseqc master command</title>
diff --git a/Documentation/DocBook/media/dvb/frontend_get_info.xml b/Documentation/DocBook/media/dvb/frontend_get_info.xml
new file mode 100644
index 000000000000..d569e386fb15
--- /dev/null
+++ b/Documentation/DocBook/media/dvb/frontend_get_info.xml
@@ -0,0 +1,265 @@
+<refentry id="FE_GET_INFO">
+  <refmeta>
+    <refentrytitle>ioctl FE_GET_INFO</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>FE_GET_INFO</refname>
+    <refpurpose>Query DVB frontend capabilities and returns information about
+	the front-end. This call only requires read-only access to the device</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>&dvb-frontend-info; *<parameter>argp</parameter></paramdef>
+      </funcprototype>
+    </funcsynopsis>
+  </refsynopsisdiv>
+
+  <refsect1>
+    <title>Arguments</title>
+        <variablelist>
+      <varlistentry>
+	<term><parameter>fd</parameter></term>
+	<listitem>
+	  <para>&fd;</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>FE_GET_INFO</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>argp</parameter></term>
+	<listitem>
+	    <para>pointer to struct &dvb-frontend-info;</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+    <para>All DVB frontend devices support the
+<constant>FE_GET_INFO</constant> ioctl. It is used to identify
+kernel devices compatible with this specification and to obtain
+information about driver and hardware capabilities. The ioctl takes a
+pointer to dvb_frontend_info which is filled by the driver. When the
+driver is not compatible with this specification the ioctl returns an error &return-value-dvb;.
+</para>
+
+    <table pgwide="1" frame="none" id="dvb-frontend-info">
+      <title>struct <structname>dvb_frontend_info</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>char *</entry>
+	    <entry>name[128]</entry>
+	    <entry>Name of the frontend</entry>
+	  </row><row>
+	    <entry>fe_type_t</entry>
+	    <entry>type</entry>
+	    <entry>DVBv3 type. Should not be used on modern programs, as a
+		frontend may have more than one type. So, the DVBv5 API should
+		be used instead to enumerate and select the frontend type.</entry>
+	  </row><row>
+	    <entry>uint32_t</entry>
+	    <entry>frequency_min</entry>
+	    <entry>Minimal frequency supported by the frontend</entry>
+	  </row><row>
+	    <entry>uint32_t</entry>
+	    <entry>frequency_max</entry>
+	    <entry>Maximal frequency supported by the frontend</entry>
+	  </row><row>
+	    <entry>uint32_t</entry>
+	    <entry>frequency_stepsize</entry>
+	    <entry>Frequency step - all frequencies are multiple of this value</entry>
+	  </row><row>
+	    <entry>uint32_t</entry>
+	    <entry>frequency_tolerance</entry>
+	    <entry>Tolerance of the frequency</entry>
+	  </row><row>
+	    <entry>uint32_t</entry>
+	    <entry>symbol_rate_min</entry>
+	    <entry>Minimal symbol rate (for Cable/Satellite systems), in bauds</entry>
+	  </row><row>
+	    <entry>uint32_t</entry>
+	    <entry>symbol_rate_max</entry>
+	    <entry>Maximal symbol rate (for Cable/Satellite systems), in bauds</entry>
+	  </row><row>
+	    <entry>uint32_t</entry>
+	    <entry>symbol_rate_tolerance</entry>
+	    <entry>Maximal symbol rate tolerance, in ppm</entry>
+	  </row><row>
+	    <entry>uint32_t</entry>
+	    <entry>notifier_delay</entry>
+	    <entry>Deprecated. Not used by any driver.</entry>
+	  </row><row>
+	    <entry>&fe-caps;</entry>
+	    <entry>caps</entry>
+	    <entry>Capabilities supported by the frontend</entry>
+          </row>
+	</tbody>
+      </tgroup>
+    </table>
+  </refsect1>
+
+  <para>NOTE: The frequencies are specified in Hz for Terrestrial and Cable
+      systems. They're specified in kHz for Satellite systems</para>
+
+<section id="fe-caps-t">
+<title>frontend capabilities</title>
+
+<para>Capabilities describe what a frontend can do. Some capabilities are
+    supported only on some specific frontend types.</para>
+
+<table pgwide="1" frame="none" id="fe-caps">
+    <title>enum fe_caps</title>
+    <tgroup cols="2">
+	&cs-def;
+	<thead>
+	<row>
+	    <entry>ID</entry>
+	    <entry>Description</entry>
+	</row>
+	</thead>
+	<tbody valign="top">
+	<row>
+	<entry><constant>FE_IS_STUPID</constant></entry>
+	<entry>There's something wrong at the frontend, and it can't
+	    report its capabilities</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_INVERSION_AUTO</constant></entry>
+	<entry>The frontend is capable of auto-detecting inversion</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_FEC_1_2</constant></entry>
+	<entry>The frontend supports FEC 1/2</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_FEC_2_3</constant></entry>
+	<entry>The frontend supports FEC 2/3</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_FEC_3_4</constant></entry>
+	<entry>The frontend supports FEC 3/4</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_FEC_4_5</constant></entry>
+	<entry>The frontend supports FEC 4/5</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_FEC_5_6</constant></entry>
+	<entry>The frontend supports FEC 5/6</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_FEC_6_7</constant></entry>
+	<entry>The frontend supports FEC 6/7</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_FEC_7_8</constant></entry>
+	<entry>The frontend supports FEC 7/8</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_FEC_8_9</constant></entry>
+	<entry>The frontend supports FEC 8/9</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_FEC_AUTO</constant></entry>
+	<entry>The frontend can autodetect FEC.</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_QPSK</constant></entry>
+	<entry>The frontend supports QPSK modulation</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_QAM_16</constant></entry>
+	<entry>The frontend supports 16-QAM modulation</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_QAM_32</constant></entry>
+	<entry>The frontend supports 32-QAM modulation</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_QAM_64</constant></entry>
+	<entry>The frontend supports 64-QAM modulation</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_QAM_128</constant></entry>
+	<entry>The frontend supports 128-QAM modulation</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_QAM_256</constant></entry>
+	<entry>The frontend supports 256-QAM modulation</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_QAM_AUTO</constant></entry>
+	<entry>The frontend can autodetect modulation</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_TRANSMISSION_MODE_AUTO</constant></entry>
+	<entry>The frontend can autodetect the transmission mode</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_BANDWIDTH_AUTO</constant></entry>
+	<entry>The frontend can autodetect the bandwidth</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_GUARD_INTERVAL_AUTO</constant></entry>
+	<entry>The frontend can autodetect the guard interval</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_HIERARCHY_AUTO</constant></entry>
+	<entry>The frontend can autodetect hierarch</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_8VSB</constant></entry>
+	<entry>The frontend supports 8-VSB modulation</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_16VSB</constant></entry>
+	<entry>The frontend supports 16-VSB modulation</entry>
+	</row>
+	<row>
+	<entry><constant>FE_HAS_EXTENDED_CAPS</constant></entry>
+	<entry>Currently, unused</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_MULTISTREAM</constant></entry>
+	<entry>The frontend supports multistream filtering</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_TURBO_FEC</constant></entry>
+	<entry>The frontend supports turbo FEC modulation</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_2G_MODULATION</constant></entry>
+	<entry>The frontend supports "2nd generation modulation" (DVB-S2/T2)></entry>
+	</row>
+	<row>
+	<entry><constant>FE_NEEDS_BENDING</constant></entry>
+	<entry>Not supported anymore, don't use it</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_RECOVER</constant></entry>
+	<entry>The frontend can recover from a cable unplug automatically</entry>
+	</row>
+	<row>
+	<entry><constant>FE_CAN_MUTE_TS</constant></entry>
+	<entry>The frontend can stop spurious TS data output</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
+</section>
+</refentry>
-- 
2.4.1

