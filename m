Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51339 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbbE1Vto (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:44 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 05/35] DocBook: Improve DVB frontend description
Date: Thu, 28 May 2015 18:49:08 -0300
Message-Id: <800c52e10f2a35749a916b5b09954f170b6d2fcb.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DVB frontend API got bitrotten. Update it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 956b8f6882e0..98443c4c2818 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -1,30 +1,42 @@
 <title>DVB Frontend API</title>
 
-<para>The DVB frontend device controls the tuner and DVB demodulator
-hardware. It can be accessed through <emphasis
-role="bold">/dev/dvb/adapter0/frontend0</emphasis>. Data types and and
-ioctl definitions can be accessed by including <emphasis
-role="bold">linux/dvb/frontend.h</emphasis> in your application.</para>
+<para>The DVB frontend API was designed to support three types of delivery systems:</para>
+<itemizedlist>
+    <listitem>Terrestrial systems: DVB-T, DVB-T2, ATSC, ATSC M/H, ISDB-T, DVB-H, DTMB, CMMB</listitem>
+    <listitem>Cable systems: DVB-C Annex A/C, ClearQAM (DVB-C Annex B), ISDB-C</listitem>
+    <listitem>Satellital systems: DVB-S, DVB-S2, DVB Turbo, ISDB-S, DSS</listitem>
+</itemizedlist>
+<para>The DVB frontend controls several sub-devices including:</para>
+<itemizedlist>
+    <listitem>Tuner</listitem>,
+    <listitem>Digital TV demodulator</listitem>
+    <listitem>Low noise amplifier (LNA)</listitem>
+    <listitem>Satellite Equipment Control (SEC) hardware (only for Satellite).</listitem>
+</itemizedlist>
+<para>The frontend can be accessed through
+    <emphasis role="bold">/dev/dvb/adapter?/frontend?</emphasis>. Data types and
+    ioctl definitions can be accessed by including
+    <emphasis role="bold">linux/dvb/frontend.h</emphasis> in your application.
+</para>
 
-<para>DVB frontends come in three varieties: DVB-S (satellite), DVB-C
-(cable) and DVB-T (terrestrial). Transmission via the internet (DVB-IP)
-is not yet handled by this API but a future extension is possible. For
-DVB-S the frontend device also supports satellite equipment control
-(SEC) via DiSEqC and V-SEC protocols. The DiSEqC (digital SEC)
-specification is available from
+<para>NOTE: Transmission via the internet (DVB-IP)
+    is not yet handled by this API but a future extension is possible.</para>
+<para>On Satellital systems, the API support for the Satellite Equipment Control
+    (SEC) allows to power control and to send/receive signals to control the
+    antenna subsystem, selecting the polarization and choosing the Intermediate
+    Frequency IF) of the Low Noise Block Converter Feed Horn (LNBf). It
+    supports the DiSEqC and V-SEC protocols. The DiSEqC (digital SEC)
+specification is available at
 <ulink url="http://www.eutelsat.com/satellites/4_5_5.html">Eutelsat</ulink>.</para>
 
-<para>Note that the DVB API may also be used for MPEG decoder-only PCI
-cards, in which case there exists no frontend device.</para>
-
 <section id="frontend_types">
 <title>Frontend Data Types</title>
 
 <section id="fe-type-t">
 <title>Frontend type</title>
 
-<para>For historical reasons, frontend types are named by the type of modulation used in
-transmission. The fontend types are given by fe_type_t type, defined as:</para>
+<para>For historical reasons, frontend types are named by the type of modulation
+    used in transmission. The fontend types are given by fe_type_t type, defined as:</para>
 
 <table pgwide="1" frame="none" id="fe-type">
 <title>Frontend types</title>
-- 
2.4.1

