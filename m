Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51547 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262AbbE1Vty (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2015 17:49:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 04/35] DocBook: fix emphasis at the DVB documentation
Date: Thu, 28 May 2015 18:49:07 -0300
Message-Id: <6674a17160ba2f80a4537d4dc9e501149c308706.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1432844837.git.mchehab@osg.samsung.com>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, it is using 'role="tt"', but this is not defined at
the DocBook 4.5 spec. The net result is that no emphasis happens.

So, replace them to bold emphasis.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/DocBook/media/dvb/audio.xml b/Documentation/DocBook/media/dvb/audio.xml
index a7ea56c71a27..a853e5b81ec7 100644
--- a/Documentation/DocBook/media/dvb/audio.xml
+++ b/Documentation/DocBook/media/dvb/audio.xml
@@ -1,7 +1,7 @@
 <title>DVB Audio Device</title>
 <para>The DVB audio device controls the MPEG2 audio decoder of the DVB hardware. It
-can be accessed through <emphasis role="tt">/dev/dvb/adapter0/audio0</emphasis>. Data types and and
-ioctl definitions can be accessed by including <emphasis role="tt">linux/dvb/audio.h</emphasis> in your
+can be accessed through <emphasis role="bold">/dev/dvb/adapter0/audio0</emphasis>. Data types and and
+ioctl definitions can be accessed by including <emphasis role="bold">linux/dvb/audio.h</emphasis> in your
 application.
 </para>
 <para>Please note that some DVB cards don&#8217;t have their own MPEG decoder, which results in
@@ -32,7 +32,7 @@ typedef enum {
 </programlisting>
 <para>AUDIO_SOURCE_DEMUX selects the demultiplexer (fed either by the frontend or the
 DVR device) as the source of the video stream. If AUDIO_SOURCE_MEMORY
-is selected the stream comes from the application through the <emphasis role="tt">write()</emphasis> system
+is selected the stream comes from the application through the <emphasis role="bold">write()</emphasis> system
 call.
 </para>
 
diff --git a/Documentation/DocBook/media/dvb/ca.xml b/Documentation/DocBook/media/dvb/ca.xml
index 85eaf4fe2931..bf9e790d674f 100644
--- a/Documentation/DocBook/media/dvb/ca.xml
+++ b/Documentation/DocBook/media/dvb/ca.xml
@@ -1,7 +1,7 @@
 <title>DVB CA Device</title>
 <para>The DVB CA device controls the conditional access hardware. It can be accessed through
-<emphasis role="tt">/dev/dvb/adapter0/ca0</emphasis>. Data types and and ioctl definitions can be accessed by
-including <emphasis role="tt">linux/dvb/ca.h</emphasis> in your application.
+<emphasis role="bold">/dev/dvb/adapter0/ca0</emphasis>. Data types and and ioctl definitions can be accessed by
+including <emphasis role="bold">linux/dvb/ca.h</emphasis> in your application.
 </para>
 
 <section id="ca_data_types">
diff --git a/Documentation/DocBook/media/dvb/demux.xml b/Documentation/DocBook/media/dvb/demux.xml
index c8683d66f059..fae0e0556ca5 100644
--- a/Documentation/DocBook/media/dvb/demux.xml
+++ b/Documentation/DocBook/media/dvb/demux.xml
@@ -1,8 +1,8 @@
 <title>DVB Demux Device</title>
 
 <para>The DVB demux device controls the filters of the DVB hardware/software. It can be
-accessed through <emphasis role="tt">/dev/adapter0/demux0</emphasis>. Data types and and ioctl definitions can be
-accessed by including <emphasis role="tt">linux/dvb/dmx.h</emphasis> in your application.
+accessed through <emphasis role="bold">/dev/adapter0/demux0</emphasis>. Data types and and ioctl definitions can be
+accessed by including <emphasis role="bold">linux/dvb/dmx.h</emphasis> in your application.
 </para>
 <section id="dmx_types">
 <title>Demux Data Types</title>
@@ -21,11 +21,11 @@ typedef enum
 	DMX_OUT_TSDEMUX_TAP /&#x22C6; Like TS_TAP but retrieved from the DMX device &#x22C6;/
 } dmx_output_t;
 </programlisting>
-<para><emphasis role="tt">DMX_OUT_TAP</emphasis> delivers the stream output to the demux device on which the ioctl is
+<para><emphasis role="bold">DMX_OUT_TAP</emphasis> delivers the stream output to the demux device on which the ioctl is
 called.
 </para>
-<para><emphasis role="tt">DMX_OUT_TS_TAP</emphasis> routes output to the logical DVR device <emphasis role="tt">/dev/dvb/adapter0/dvr0</emphasis>,
-which delivers a TS multiplexed from all filters for which <emphasis role="tt">DMX_OUT_TS_TAP</emphasis> was
+<para><emphasis role="bold">DMX_OUT_TS_TAP</emphasis> routes output to the logical DVR device <emphasis role="bold">/dev/dvb/adapter0/dvr0</emphasis>,
+which delivers a TS multiplexed from all filters for which <emphasis role="bold">DMX_OUT_TS_TAP</emphasis> was
 specified.
 </para>
 </section>
diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index 8a6a6ff27af5..956b8f6882e0 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -2,9 +2,9 @@
 
 <para>The DVB frontend device controls the tuner and DVB demodulator
 hardware. It can be accessed through <emphasis
-role="tt">/dev/dvb/adapter0/frontend0</emphasis>. Data types and and
+role="bold">/dev/dvb/adapter0/frontend0</emphasis>. Data types and and
 ioctl definitions can be accessed by including <emphasis
-role="tt">linux/dvb/frontend.h</emphasis> in your application.</para>
+role="bold">linux/dvb/frontend.h</emphasis> in your application.</para>
 
 <para>DVB frontends come in three varieties: DVB-S (satellite), DVB-C
 (cable) and DVB-T (terrestrial). Transmission via the internet (DVB-IP)
diff --git a/Documentation/DocBook/media/dvb/intro.xml b/Documentation/DocBook/media/dvb/intro.xml
index 2048b53d19b9..4a34ef4783a4 100644
--- a/Documentation/DocBook/media/dvb/intro.xml
+++ b/Documentation/DocBook/media/dvb/intro.xml
@@ -129,41 +129,41 @@ hardware. It can depend on the individual security requirements of the
 platform, if and how many of the CA functions are made available to the
 application through this device.</para>
 
-<para>All devices can be found in the <emphasis role="tt">/dev</emphasis>
-tree under <emphasis role="tt">/dev/dvb</emphasis>. The individual devices
+<para>All devices can be found in the <emphasis role="bold">/dev</emphasis>
+tree under <emphasis role="bold">/dev/dvb</emphasis>. The individual devices
 are called:</para>
 
 <itemizedlist>
 <listitem>
 
-<para><emphasis role="tt">/dev/dvb/adapterN/audioM</emphasis>,</para>
+<para><emphasis role="bold">/dev/dvb/adapterN/audioM</emphasis>,</para>
 </listitem>
 <listitem>
-<para><emphasis role="tt">/dev/dvb/adapterN/videoM</emphasis>,</para>
+<para><emphasis role="bold">/dev/dvb/adapterN/videoM</emphasis>,</para>
 </listitem>
 <listitem>
-<para><emphasis role="tt">/dev/dvb/adapterN/frontendM</emphasis>,</para>
+<para><emphasis role="bold">/dev/dvb/adapterN/frontendM</emphasis>,</para>
 </listitem>
  <listitem>
 
-<para><emphasis role="tt">/dev/dvb/adapterN/netM</emphasis>,</para>
+<para><emphasis role="bold">/dev/dvb/adapterN/netM</emphasis>,</para>
 </listitem>
  <listitem>
 
-<para><emphasis role="tt">/dev/dvb/adapterN/demuxM</emphasis>,</para>
+<para><emphasis role="bold">/dev/dvb/adapterN/demuxM</emphasis>,</para>
 </listitem>
  <listitem>
 
-<para><emphasis role="tt">/dev/dvb/adapterN/dvrM</emphasis>,</para>
+<para><emphasis role="bold">/dev/dvb/adapterN/dvrM</emphasis>,</para>
 </listitem>
  <listitem>
 
-<para><emphasis role="tt">/dev/dvb/adapterN/caM</emphasis>,</para></listitem></itemizedlist>
+<para><emphasis role="bold">/dev/dvb/adapterN/caM</emphasis>,</para></listitem></itemizedlist>
 
 <para>where N enumerates the DVB PCI cards in a system starting
 from&#x00A0;0, and M enumerates the devices of each type within each
 adapter, starting from&#x00A0;0, too. We will omit the &#8220;<emphasis
-role="tt">/dev/dvb/adapterN/</emphasis>&#8221; in the further dicussion
+role="bold">/dev/dvb/adapterN/</emphasis>&#8221; in the further dicussion
 of these devices. The naming scheme for the devices is the same wheter
 devfs is used or not.</para>
 
@@ -203,9 +203,9 @@ a partial path like:</para>
 
 <para>To enable applications to support different API version, an
 additional include file <emphasis
-role="tt">linux/dvb/version.h</emphasis> exists, which defines the
-constant <emphasis role="tt">DVB_API_VERSION</emphasis>. This document
-describes <emphasis role="tt">DVB_API_VERSION 5.8</emphasis>.
+role="bold">linux/dvb/version.h</emphasis> exists, which defines the
+constant <emphasis role="bold">DVB_API_VERSION</emphasis>. This document
+describes <emphasis role="bold">DVB_API_VERSION 5.8</emphasis>.
 </para>
 
 </section>
diff --git a/Documentation/DocBook/media/dvb/kdapi.xml b/Documentation/DocBook/media/dvb/kdapi.xml
index 6c11ec52cbee..f648115f7149 100644
--- a/Documentation/DocBook/media/dvb/kdapi.xml
+++ b/Documentation/DocBook/media/dvb/kdapi.xml
@@ -1,8 +1,8 @@
 <title>Kernel Demux API</title>
 <para>The kernel demux API defines a driver-internal interface for registering low-level,
 hardware specific driver to a hardware independent demux layer. It is only of interest for
-DVB device driver writers. The header file for this API is named <emphasis role="tt">demux.h</emphasis> and located in
-<emphasis role="tt">drivers/media/dvb-core</emphasis>.
+DVB device driver writers. The header file for this API is named <emphasis role="bold">demux.h</emphasis> and located in
+<emphasis role="bold">drivers/media/dvb-core</emphasis>.
 </para>
 <para>Maintainer note: This section must be reviewed. It is probably out of date.
 </para>
diff --git a/Documentation/DocBook/media/dvb/net.xml b/Documentation/DocBook/media/dvb/net.xml
index a193e86941b5..d4ef21764959 100644
--- a/Documentation/DocBook/media/dvb/net.xml
+++ b/Documentation/DocBook/media/dvb/net.xml
@@ -1,8 +1,8 @@
 <title>DVB Network API</title>
 <para>The DVB net device enables feeding of MPE (multi protocol encapsulation) packets
 received via DVB into the Linux network protocol stack, e.g. for internet via satellite
-applications. It can be accessed through <emphasis role="tt">/dev/dvb/adapter0/net0</emphasis>. Data types and
-and ioctl definitions can be accessed by including <emphasis role="tt">linux/dvb/net.h</emphasis> in your
+applications. It can be accessed through <emphasis role="bold">/dev/dvb/adapter0/net0</emphasis>. Data types and
+and ioctl definitions can be accessed by including <emphasis role="bold">linux/dvb/net.h</emphasis> in your
 application.
 </para>
 <section id="dvb_net_types">
diff --git a/Documentation/DocBook/media/dvb/video.xml b/Documentation/DocBook/media/dvb/video.xml
index 3ea1ca7e785e..1ea786f9b798 100644
--- a/Documentation/DocBook/media/dvb/video.xml
+++ b/Documentation/DocBook/media/dvb/video.xml
@@ -1,12 +1,12 @@
 <title>DVB Video Device</title>
 <para>The DVB video device controls the MPEG2 video decoder of the DVB hardware. It
-can be accessed through <emphasis role="tt">/dev/dvb/adapter0/video0</emphasis>. Data types and and
-ioctl definitions can be accessed by including <emphasis role="tt">linux/dvb/video.h</emphasis> in your
+can be accessed through <emphasis role="bold">/dev/dvb/adapter0/video0</emphasis>. Data types and and
+ioctl definitions can be accessed by including <emphasis role="bold">linux/dvb/video.h</emphasis> in your
 application.
 </para>
 <para>Note that the DVB video device only controls decoding of the MPEG video stream, not
 its presentation on the TV or computer screen. On PCs this is typically handled by an
-associated video4linux device, e.g. <emphasis role="tt">/dev/video</emphasis>, which allows scaling and defining output
+associated video4linux device, e.g. <emphasis role="bold">/dev/video</emphasis>, which allows scaling and defining output
 windows.
 </para>
 <para>Some DVB cards don&#8217;t have their own MPEG decoder, which results in the omission of
@@ -24,7 +24,7 @@ have been created to replace that functionality.</para>
 
 <section id="video-format-t">
 <title>video_format_t</title>
-<para>The <emphasis role="tt">video_format_t</emphasis> data type defined by
+<para>The <emphasis role="bold">video_format_t</emphasis> data type defined by
 </para>
 <programlisting>
 typedef enum {
@@ -74,7 +74,7 @@ typedef enum {
 </programlisting>
 <para>VIDEO_SOURCE_DEMUX selects the demultiplexer (fed either by the frontend or the
 DVR device) as the source of the video stream. If VIDEO_SOURCE_MEMORY
-is selected the stream comes from the application through the <emphasis role="tt">write()</emphasis> system
+is selected the stream comes from the application through the <emphasis role="bold">write()</emphasis> system
 call.
 </para>
 </section>
-- 
2.4.1

