Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43159 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbbFBTwt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2015 15:52:49 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-doc@vger.kernel.org
Subject: [PATCH 5/5] [media] DocBook: Use constant tag for monospaced fonts
Date: Tue,  2 Jun 2015 16:52:43 -0300
Message-Id: <510e418698e9661b2efea6dc107c0d6f158f5b73.1433274739.git.mchehab@osg.samsung.com>
In-Reply-To: <017aba88da8787c41eccd4d1b65506f4e6fa9a83.1433274739.git.mchehab@osg.samsung.com>
References: <017aba88da8787c41eccd4d1b65506f4e6fa9a83.1433274739.git.mchehab@osg.samsung.com>
In-Reply-To: <017aba88da8787c41eccd4d1b65506f4e6fa9a83.1433274739.git.mchehab@osg.samsung.com>
References: <017aba88da8787c41eccd4d1b65506f4e6fa9a83.1433274739.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reminded by Jonathan, several places where emphasys
role="tt" were used are actually trying to change the font to
monospaced.

We do that, on other places, by using the constant tag.

So, use it here too.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/audio.xml b/Documentation/DocBook/media/dvb/audio.xml
index a853e5b81ec7..ea56743ddbe7 100644
--- a/Documentation/DocBook/media/dvb/audio.xml
+++ b/Documentation/DocBook/media/dvb/audio.xml
@@ -1,7 +1,7 @@
 <title>DVB Audio Device</title>
 <para>The DVB audio device controls the MPEG2 audio decoder of the DVB hardware. It
-can be accessed through <emphasis role="bold">/dev/dvb/adapter0/audio0</emphasis>. Data types and and
-ioctl definitions can be accessed by including <emphasis role="bold">linux/dvb/audio.h</emphasis> in your
+can be accessed through <constant>/dev/dvb/adapter?/audio?</constant>. Data types and and
+ioctl definitions can be accessed by including <constant>linux/dvb/audio.h</constant> in your
 application.
 </para>
 <para>Please note that some DVB cards don&#8217;t have their own MPEG decoder, which results in
@@ -32,7 +32,7 @@ typedef enum {
 </programlisting>
 <para>AUDIO_SOURCE_DEMUX selects the demultiplexer (fed either by the frontend or the
 DVR device) as the source of the video stream. If AUDIO_SOURCE_MEMORY
-is selected the stream comes from the application through the <emphasis role="bold">write()</emphasis> system
+is selected the stream comes from the application through the <constant>write()</constant> system
 call.
 </para>
 
diff --git a/Documentation/DocBook/media/dvb/ca.xml b/Documentation/DocBook/media/dvb/ca.xml
index bf9e790d674f..d0b07e763908 100644
--- a/Documentation/DocBook/media/dvb/ca.xml
+++ b/Documentation/DocBook/media/dvb/ca.xml
@@ -1,7 +1,7 @@
 <title>DVB CA Device</title>
 <para>The DVB CA device controls the conditional access hardware. It can be accessed through
-<emphasis role="bold">/dev/dvb/adapter0/ca0</emphasis>. Data types and and ioctl definitions can be accessed by
-including <emphasis role="bold">linux/dvb/ca.h</emphasis> in your application.
+<constant>/dev/dvb/adapter?/ca?</constant>. Data types and and ioctl definitions can be accessed by
+including <constant>linux/dvb/ca.h</constant> in your application.
 </para>
 
 <section id="ca_data_types">
diff --git a/Documentation/DocBook/media/dvb/demux.xml b/Documentation/DocBook/media/dvb/demux.xml
index fae0e0556ca5..11a831d58643 100644
--- a/Documentation/DocBook/media/dvb/demux.xml
+++ b/Documentation/DocBook/media/dvb/demux.xml
@@ -1,8 +1,8 @@
 <title>DVB Demux Device</title>
 
 <para>The DVB demux device controls the filters of the DVB hardware/software. It can be
-accessed through <emphasis role="bold">/dev/adapter0/demux0</emphasis>. Data types and and ioctl definitions can be
-accessed by including <emphasis role="bold">linux/dvb/dmx.h</emphasis> in your application.
+accessed through <constant>/dev/adapter?/demux?</constant>. Data types and and ioctl definitions can be
+accessed by including <constant>linux/dvb/dmx.h</constant> in your application.
 </para>
 <section id="dmx_types">
 <title>Demux Data Types</title>
@@ -21,11 +21,11 @@ typedef enum
 	DMX_OUT_TSDEMUX_TAP /&#x22C6; Like TS_TAP but retrieved from the DMX device &#x22C6;/
 } dmx_output_t;
 </programlisting>
-<para><emphasis role="bold">DMX_OUT_TAP</emphasis> delivers the stream output to the demux device on which the ioctl is
+<para><constant>DMX_OUT_TAP</constant> delivers the stream output to the demux device on which the ioctl is
 called.
 </para>
-<para><emphasis role="bold">DMX_OUT_TS_TAP</emphasis> routes output to the logical DVR device <emphasis role="bold">/dev/dvb/adapter0/dvr0</emphasis>,
-which delivers a TS multiplexed from all filters for which <emphasis role="bold">DMX_OUT_TS_TAP</emphasis> was
+<para><constant>DMX_OUT_TS_TAP</constant> routes output to the logical DVR device <constant>/dev/dvb/adapter?/dvr?</constant>,
+which delivers a TS multiplexed from all filters for which <constant>DMX_OUT_TS_TAP</constant> was
 specified.
 </para>
 </section>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index dc6a1134478d..01210b33c130 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -14,9 +14,9 @@
     <listitem><para>Satellite Equipment Control (SEC) hardware (only for Satellite).</para></listitem>
 </itemizedlist>
 <para>The frontend can be accessed through
-    <emphasis role="bold">/dev/dvb/adapter?/frontend?</emphasis>. Data types and
+    <constant>/dev/dvb/adapter?/frontend?</constant>. Data types and
     ioctl definitions can be accessed by including
-    <emphasis role="bold">linux/dvb/frontend.h</emphasis> in your application.
+    <constant>linux/dvb/frontend.h</constant> in your application.
 </para>
 
 <para>NOTE: Transmission via the internet (DVB-IP)
diff --git a/Documentation/DocBook/media/dvb/intro.xml b/Documentation/DocBook/media/dvb/intro.xml
index 1f7a35a2b365..bcc72c216402 100644
--- a/Documentation/DocBook/media/dvb/intro.xml
+++ b/Documentation/DocBook/media/dvb/intro.xml
@@ -129,41 +129,41 @@ hardware. It can depend on the individual security requirements of the
 platform, if and how many of the CA functions are made available to the
 application through this device.</para>
 
-<para>All devices can be found in the <emphasis role="bold">/dev</emphasis>
-tree under <emphasis role="bold">/dev/dvb</emphasis>. The individual devices
+<para>All devices can be found in the <constant>/dev</constant>
+tree under <constant>/dev/dvb</constant>. The individual devices
 are called:</para>
 
 <itemizedlist>
 <listitem>
 
-<para><emphasis role="bold">/dev/dvb/adapterN/audioM</emphasis>,</para>
+<para><constant>/dev/dvb/adapterN/audioM</constant>,</para>
 </listitem>
 <listitem>
-<para><emphasis role="bold">/dev/dvb/adapterN/videoM</emphasis>,</para>
+<para><constant>/dev/dvb/adapterN/videoM</constant>,</para>
 </listitem>
 <listitem>
-<para><emphasis role="bold">/dev/dvb/adapterN/frontendM</emphasis>,</para>
+<para><constant>/dev/dvb/adapterN/frontendM</constant>,</para>
 </listitem>
  <listitem>
 
-<para><emphasis role="bold">/dev/dvb/adapterN/netM</emphasis>,</para>
+<para><constant>/dev/dvb/adapterN/netM</constant>,</para>
 </listitem>
  <listitem>
 
-<para><emphasis role="bold">/dev/dvb/adapterN/demuxM</emphasis>,</para>
+<para><constant>/dev/dvb/adapterN/demuxM</constant>,</para>
 </listitem>
  <listitem>
 
-<para><emphasis role="bold">/dev/dvb/adapterN/dvrM</emphasis>,</para>
+<para><constant>/dev/dvb/adapterN/dvrM</constant>,</para>
 </listitem>
  <listitem>
 
-<para><emphasis role="bold">/dev/dvb/adapterN/caM</emphasis>,</para></listitem></itemizedlist>
+<para><constant>/dev/dvb/adapterN/caM</constant>,</para></listitem></itemizedlist>
 
 <para>where N enumerates the DVB PCI cards in a system starting
 from&#x00A0;0, and M enumerates the devices of each type within each
-adapter, starting from&#x00A0;0, too. We will omit the &#8220;<emphasis
-role="bold">/dev/dvb/adapterN/</emphasis>&#8221; in the further dicussion
+adapter, starting from&#x00A0;0, too. We will omit the &#8220;
+<constant>/dev/dvb/adapterN/</constant>&#8221; in the further dicussion
 of these devices. The naming scheme for the devices is the same wheter
 devfs is used or not.</para>
 
@@ -202,10 +202,10 @@ a partial path like:</para>
 </programlisting>
 
 <para>To enable applications to support different API version, an
-additional include file <emphasis
-role="bold">linux/dvb/version.h</emphasis> exists, which defines the
-constant <emphasis role="bold">DVB_API_VERSION</emphasis>. This document
-describes <emphasis role="bold">DVB_API_VERSION 5.10</emphasis>.
+additional include file
+<constant>linux/dvb/version.h</constant> exists, which defines the
+constant <constant>DVB_API_VERSION</constant>. This document
+describes <constant>DVB_API_VERSION 5.10</constant>.
 </para>
 
 </section>
diff --git a/Documentation/DocBook/media/dvb/kdapi.xml b/Documentation/DocBook/media/dvb/kdapi.xml
index f648115f7149..68bcd33a82c3 100644
--- a/Documentation/DocBook/media/dvb/kdapi.xml
+++ b/Documentation/DocBook/media/dvb/kdapi.xml
@@ -1,8 +1,8 @@
 <title>Kernel Demux API</title>
 <para>The kernel demux API defines a driver-internal interface for registering low-level,
 hardware specific driver to a hardware independent demux layer. It is only of interest for
-DVB device driver writers. The header file for this API is named <emphasis role="bold">demux.h</emphasis> and located in
-<emphasis role="bold">drivers/media/dvb-core</emphasis>.
+DVB device driver writers. The header file for this API is named <constant>demux.h</constant> and located in
+<constant>">drivers/media/dvb-core</constant>.
 </para>
 <para>Maintainer note: This section must be reviewed. It is probably out of date.
 </para>
diff --git a/Documentation/DocBook/media/dvb/net.xml b/Documentation/DocBook/media/dvb/net.xml
index aeac41ca7eae..d2e44b7e07df 100644
--- a/Documentation/DocBook/media/dvb/net.xml
+++ b/Documentation/DocBook/media/dvb/net.xml
@@ -13,12 +13,12 @@
 <para>In order to create the Linux virtual network interfaces, an application
     needs to tell to the Kernel what are the PIDs and the encapsulation types
     that are present on the transport stream. This is done through
-    <emphasis role="bold">/dev/dvb/adapter?/net?</emphasis> device node.
+    <constant>/dev/dvb/adapter?/net?</constant> device node.
     The data will be available via virtual <constant>dvb?_?</constant>
     network interfaces, and will be controled/routed via the standard
     ip tools (like ip, route, netstat, ifconfig, etc).</para>
 <para> Data types and and ioctl definitions are defined via
-    <emphasis role="bold">linux/dvb/net.h</emphasis> header.</para>
+    <constant>linux/dvb/net.h</constant> header.</para>
 
 <section id="net_fcalls">
 <title>DVB net Function Calls</title>
diff --git a/Documentation/DocBook/media/dvb/video.xml b/Documentation/DocBook/media/dvb/video.xml
index 1ea786f9b798..71547fcd7ba0 100644
--- a/Documentation/DocBook/media/dvb/video.xml
+++ b/Documentation/DocBook/media/dvb/video.xml
@@ -24,7 +24,7 @@ have been created to replace that functionality.</para>
 
 <section id="video-format-t">
 <title>video_format_t</title>
-<para>The <emphasis role="bold">video_format_t</emphasis> data type defined by
+<para>The <constant>video_format_t</constant> data type defined by
 </para>
 <programlisting>
 typedef enum {
-- 
2.4.1

