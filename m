Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54817 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbbFHTyh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 15:54:37 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 14/26] [media] DocBook: Remove duplicated documentation for SEC_VOLTAGE_*
Date: Mon,  8 Jun 2015 16:53:58 -0300
Message-Id: <4adeb80b377c2408df51e2658ac758367cc244b8.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433792665.git.mchehab@osg.samsung.com>
References: <cover.1433792665.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The table were documented at the legacy ioctl call. Move it
to the DVBv5 ioctl, and add a cross ref link on the legacy
section.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/dvbproperty.xml b/Documentation/DocBook/media/dvb/dvbproperty.xml
index e31d9457671f..e1d1e2469029 100644
--- a/Documentation/DocBook/media/dvb/dvbproperty.xml
+++ b/Documentation/DocBook/media/dvb/dvbproperty.xml
@@ -401,12 +401,31 @@ get/set up to 64 properties. The actual meaning of each property is described on
 	the polarzation (horizontal/vertical). When using DiSEqC epuipment this
 	voltage has to be switched consistently to the DiSEqC commands as
 	described in the DiSEqC spec.</para>
-	<programlisting>
-		typedef enum fe_sec_voltage {
-		SEC_VOLTAGE_13,
-		SEC_VOLTAGE_18
-		} fe_sec_voltage_t;
-	</programlisting>
+
+<table pgwide="1" frame="none" id="fe-sec-voltage">
+    <title id="fe-sec-voltage-t">enum fe_sec_voltage</title>
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
+	    <entry align="char" id="SEC-VOLTAGE-13"><constant>SEC_VOLTAGE_13</constant></entry>
+	    <entry align="char">Set DC voltage level to 13V</entry>
+	</row><row>
+	    <entry align="char" id="SEC-VOLTAGE-18"><constant>SEC_VOLTAGE_18</constant></entry>
+	    <entry align="char">Set DC voltage level to 18V</entry>
+	</row><row>
+	    <entry align="char" id="SEC-VOLTAGE-OFF"><constant>SEC_VOLTAGE_OFF</constant></entry>
+	    <entry align="char">Don't send any voltage to the antenna</entry>
+	</row>
+        </tbody>
+    </tgroup>
+</table>
 	</section>
 	<section id="DTV-TONE">
 	<title><constant>DTV_TONE</constant></title>
diff --git a/Documentation/DocBook/media/dvb/fe-set-voltage.xml b/Documentation/DocBook/media/dvb/fe-set-voltage.xml
index 053c4cb0f540..c89a6f79b5af 100644
--- a/Documentation/DocBook/media/dvb/fe-set-voltage.xml
+++ b/Documentation/DocBook/media/dvb/fe-set-voltage.xml
@@ -39,6 +39,7 @@
 	<term><parameter>voltage</parameter></term>
 	<listitem>
 	  <para>pointer to &fe-sec-voltage;</para>
+	  <para>Valid values are described at &fe-sec-voltage;.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
@@ -65,33 +66,4 @@
 &return-value-dvb;
 </refsect1>
 
-<refsect1 id="fe-sec-voltage-t">
-<title>enum fe_sec_voltage</title>
-
-<table pgwide="1" frame="none" id="fe-sec-voltage">
-    <title>enum fe_status</title>
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
-	    <entry align="char" id="SEC-VOLTAGE-13"><constant>SEC_VOLTAGE_13</constant></entry>
-	    <entry align="char">Set DC voltage level to 13V</entry>
-	</row><row>
-	    <entry align="char" id="SEC-VOLTAGE-18"><constant>SEC_VOLTAGE_18</constant></entry>
-	    <entry align="char">Set DC voltage level to 18V</entry>
-	</row><row>
-	    <entry align="char" id="SEC-VOLTAGE-OFF"><constant>SEC_VOLTAGE_OFF</constant></entry>
-	    <entry align="char">Don't send any voltage to the antenna</entry>
-	</row>
-        </tbody>
-    </tgroup>
-</table>
-</refsect1>
-
 </refentry>
-- 
2.4.2

