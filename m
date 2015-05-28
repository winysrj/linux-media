Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51347 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbbE1Vtp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:45 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 08/35] DocBook: reformat FE_GET_INFO ioctl documentation
Date: Thu, 28 May 2015 18:49:11 -0300
Message-Id: <12e6a3c2baaadc226293e3418c2f082cab3b416a.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DVB part of the docbook has a completely different format
than the V4L2 part, as it was written as a separate document.

As the V4L2 documentation is on better shape, and its format
allows adding more information, let's use it for FE_GET_INFO
and gradually update the non-legacy DVB ioctls using the new
format.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 3b3973aee8eb..e8032127886b 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -29,70 +29,279 @@
 specification is available at
 <ulink url="http://www.eutelsat.com/satellites/4_5_5.html">Eutelsat</ulink>.</para>
 
-<section id="fe-caps-t">
-<title>frontend capabilities</title>
 
-<para>Capabilities describe what a frontend can do. Some capabilities can only be supported for
-a specific frontend type.</para>
-<programlisting>
-	typedef enum fe_caps {
-	FE_IS_STUPID                  = 0,
-	FE_CAN_INVERSION_AUTO         = 0x1,
-	FE_CAN_FEC_1_2                = 0x2,
-	FE_CAN_FEC_2_3                = 0x4,
-	FE_CAN_FEC_3_4                = 0x8,
-	FE_CAN_FEC_4_5                = 0x10,
-	FE_CAN_FEC_5_6                = 0x20,
-	FE_CAN_FEC_6_7                = 0x40,
-	FE_CAN_FEC_7_8                = 0x80,
-	FE_CAN_FEC_8_9                = 0x100,
-	FE_CAN_FEC_AUTO               = 0x200,
-	FE_CAN_QPSK                   = 0x400,
-	FE_CAN_QAM_16                 = 0x800,
-	FE_CAN_QAM_32                 = 0x1000,
-	FE_CAN_QAM_64                 = 0x2000,
-	FE_CAN_QAM_128                = 0x4000,
-	FE_CAN_QAM_256                = 0x8000,
-	FE_CAN_QAM_AUTO               = 0x10000,
-	FE_CAN_TRANSMISSION_MODE_AUTO = 0x20000,
-	FE_CAN_BANDWIDTH_AUTO         = 0x40000,
-	FE_CAN_GUARD_INTERVAL_AUTO    = 0x80000,
-	FE_CAN_HIERARCHY_AUTO         = 0x100000,
-	FE_CAN_8VSB                   = 0x200000,
-	FE_CAN_16VSB                  = 0x400000,
-	FE_HAS_EXTENDED_CAPS          = 0x800000,
-	FE_CAN_MULTISTREAM            = 0x4000000,
-	FE_CAN_TURBO_FEC              = 0x8000000,
-	FE_CAN_2G_MODULATION          = 0x10000000,
-	FE_NEEDS_BENDING              = 0x20000000,
-	FE_CAN_RECOVER                = 0x40000000,
-	FE_CAN_MUTE_TS                = 0x80000000
-	} fe_caps_t;
-</programlisting>
-</section>
-
-<section id="dvb-frontend-info">
-<title>frontend information</title>
+<section id="query-dvb-frontend-info">
+<title>Querying frontend information</title>
 
 <para>Information about the frontend ca be queried with
 	<link linkend="FE_GET_INFO">FE_GET_INFO</link>.</para>
+</section>
+
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
+	<paramdef>struct dvb_frontend_info *<parameter>argp</parameter></paramdef>
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
 
-<programlisting>
-	struct dvb_frontend_info {
-	char       name[128];
-	fe_type_t  type;
-	uint32_t   frequency_min;
-	uint32_t   frequency_max;
-	uint32_t   frequency_stepsize;
-	uint32_t   frequency_tolerance;
-	uint32_t   symbol_rate_min;
-	uint32_t   symbol_rate_max;
-	uint32_t   symbol_rate_tolerance;     /&#x22C6; ppm &#x22C6;/
-	uint32_t   notifier_delay;            /&#x22C6; ms &#x22C6;/
-	fe_caps_t  caps;
-	};
-</programlisting>
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
 </section>
+</refentry>
 
 <section id="dvb-diseqc-master-cmd">
 <title>diseqc master command</title>
@@ -555,55 +764,6 @@ typedef enum fe_hierarchy {
  </row></tbody></tgroup></informaltable>
 </section>
 
-<section id="FE_GET_INFO">
-<title>FE_GET_INFO</title>
-<para>DESCRIPTION
-</para>
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para>This ioctl call returns information about the front-end. This call only requires
- read-only access to the device.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>SYNOPSIS
-</para>
-
-<informaltable><tgroup cols="1"><tbody><row><entry
- align="char">
-<para> int ioctl(int fd, int request = <link linkend="FE_GET_INFO">FE_GET_INFO</link>, struct
- dvb_frontend_info &#x22C6;info);</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-<para>PARAMETERS
-</para>
-
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
-<para>Equals <link linkend="FE_GET_INFO">FE_GET_INFO</link> for this command.</para>
-</entry>
- </row><row><entry
- align="char">
-<para>struct
- dvb_frontend_info
- *info</para>
-</entry><entry
- align="char">
-<para>Points to the location where the front-end information is
- to be stored.</para>
-</entry>
- </row></tbody></tgroup></informaltable>
-&return-value-dvb;
-</section>
 
 <section id="FE_DISEQC_RESET_OVERLOAD">
 <title>FE_DISEQC_RESET_OVERLOAD</title>
-- 
2.4.1

