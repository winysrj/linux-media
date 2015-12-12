Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42748 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbbLLNlC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Dec 2015 08:41:02 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 3/6] [media] DocBook: move data types to a separate section
Date: Sat, 12 Dec 2015 11:40:42 -0200
Message-Id: <5de53b1c2c5a509bf28c22b8db98800c2e303c1d.1449927561.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449927561.git.mchehab@osg.samsung.com>
References: <cover.1449927561.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449927561.git.mchehab@osg.samsung.com>
References: <cover.1449927561.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As MEDIA_IOC_G_TOPOLOGY shares the data types already declared
for entities, pads and links, we should move those to a separate
part of the document, and use cross-references where needed.

So, move the following tables to a separate section at the
DocBook:
	media-entity-type
	media-entity-flag
	media-pad-flag
	media-link-flag

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 .../DocBook/media/v4l/media-controller.xml         |   3 +
 .../DocBook/media/v4l/media-ioc-enum-entities.xml  | 104 -------------
 .../DocBook/media/v4l/media-ioc-enum-links.xml     |  56 -------
 Documentation/DocBook/media/v4l/media-types.xml    | 166 +++++++++++++++++++++
 4 files changed, 169 insertions(+), 160 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/media-types.xml

diff --git a/Documentation/DocBook/media/v4l/media-controller.xml b/Documentation/DocBook/media/v4l/media-controller.xml
index def4a27aadef..63d48decaa6f 100644
--- a/Documentation/DocBook/media/v4l/media-controller.xml
+++ b/Documentation/DocBook/media/v4l/media-controller.xml
@@ -85,6 +85,9 @@
     Kernel interface and an entity.m</para></listitem>
     </itemizedlist>
   </section>
+
+  <!-- All non-ioctl specific data types go here. -->
+  &sub-media-types;
 </chapter>
 
 <appendix id="media-user-func">
diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
index 9f7614a01234..0c4f96bfc2de 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
@@ -162,110 +162,6 @@
 	</tbody>
       </tgroup>
     </table>
-
-    <table frame="none" pgwide="1" id="media-entity-type">
-      <title>Media entity types</title>
-      <tgroup cols="2">
-        <colspec colname="c1"/>
-        <colspec colname="c2"/>
-	<tbody valign="top">
-	  <row>
-	    <entry><constant>MEDIA_ENT_F_UNKNOWN</constant> and <constant>MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN</constant></entry>
-	    <entry>Unknown entity. That generally indicates that
-	    a driver didn't initialize properly the entity, with is a Kernel bug</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_F_IO_V4L</constant></entry>
-	    <entry>Data streaming input and/or output entity.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_F_IO_VBI</constant></entry>
-	    <entry>V4L VBI streaming input or output entity</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_F_IO_SWRADIO</constant></entry>
-	    <entry>V4L Software Digital Radio (SDR) streaming input or output entity</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_F_IO_DTV</constant></entry>
-	    <entry>DVB Digital TV streaming input or output entity</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_F_DTV_DEMOD</constant></entry>
-	    <entry>Digital TV demodulator entity.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_F_MPEG_TS_DEMUX</constant></entry>
-	    <entry>MPEG Transport stream demux entity. Could be implemented on hardware or in Kernelspace by the Linux DVB subsystem.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_F_DTV_CA</constant></entry>
-	    <entry>Digital TV Conditional Access module (CAM) entity</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_F_DTV_NET_DECAP</constant></entry>
-	    <entry>Digital TV network ULE/MLE desencapsulation entity. Could be implemented on hardware or in Kernelspace</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_F_CONN_RF</constant></entry>
-	    <entry>Connector for a Radio Frequency (RF) signal.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_F_CONN_SVIDEO</constant></entry>
-	    <entry>Connector for a S-Video signal.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_F_CONN_COMPOSITE</constant></entry>
-	    <entry>Connector for a RGB composite signal.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_F_CONN_TEST</constant></entry>
-	    <entry>Connector for a test generator.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_F_CAM_SENSOR</constant></entry>
-	    <entry>Camera video sensor entity.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_F_FLASH</constant></entry>
-	    <entry>Flash controller entity.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_F_LENS</constant></entry>
-	    <entry>Lens controller entity.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_F_ATV_DECODER</constant></entry>
-	    <entry>Analog video decoder, the basic function of the video decoder
-	    is to accept analogue video from a wide variety of sources such as
-	    broadcast, DVD players, cameras and video cassette recorders, in
-	    either NTSC, PAL, SECAM or HD format, separating the stream
-	    into its component parts, luminance and chrominance, and output
-	    it in some digital video standard, with appropriate timing
-	    signals.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_ENT_F_TUNER</constant></entry>
-	    <entry>Digital TV, analog TV, radio and/or software radio tuner.</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
-
-    <table frame="none" pgwide="1" id="media-entity-flag">
-      <title>Media entity flags</title>
-      <tgroup cols="2">
-        <colspec colname="c1"/>
-        <colspec colname="c2"/>
-	<tbody valign="top">
-	  <row>
-	    <entry><constant>MEDIA_ENT_FL_DEFAULT</constant></entry>
-	    <entry>Default entity for its type. Used to discover the default
-	    audio, VBI and video devices, the default camera sensor, ...</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
   </refsect1>
 
   <refsect1>
diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
index 74fb394ec667..2bbeea9f3e18 100644
--- a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
+++ b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
@@ -118,35 +118,6 @@
       </tgroup>
     </table>
 
-    <table frame="none" pgwide="1" id="media-pad-flag">
-      <title>Media pad flags</title>
-      <tgroup cols="2">
-        <colspec colname="c1"/>
-        <colspec colname="c2"/>
-	<tbody valign="top">
-	  <row>
-	    <entry><constant>MEDIA_PAD_FL_SINK</constant></entry>
-	    <entry>Input pad, relative to the entity. Input pads sink data and
-	    are targets of links.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_PAD_FL_SOURCE</constant></entry>
-	    <entry>Output pad, relative to the entity. Output pads source data
-	    and are origins of links.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_PAD_FL_MUST_CONNECT</constant></entry>
-	    <entry>If this flag is set and the pad is linked to any other
-	    pad, then at least one of those links must be enabled for the
-	    entity to be able to stream. There could be temporary reasons
-	    (e.g. device configuration dependent) for the pad to need
-	    enabled links even when this flag isn't set; the absence of the
-	    flag doesn't imply there is none.</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
-
     <table pgwide="1" frame="none" id="media-link-desc">
       <title>struct <structname>media_link_desc</structname></title>
       <tgroup cols="3">
@@ -171,33 +142,6 @@
       </tgroup>
     </table>
 
-    <table frame="none" pgwide="1" id="media-link-flag">
-      <title>Media link flags</title>
-      <tgroup cols="2">
-        <colspec colname="c1"/>
-        <colspec colname="c2"/>
-	<tbody valign="top">
-	  <row>
-	    <entry><constant>MEDIA_LNK_FL_ENABLED</constant></entry>
-	    <entry>The link is enabled and can be used to transfer media data.
-	    When two or more links target a sink pad, only one of them can be
-	    enabled at a time.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_LNK_FL_IMMUTABLE</constant></entry>
-	    <entry>The link enabled state can't be modified at runtime. An
-	    immutable link is always enabled.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>MEDIA_LNK_FL_DYNAMIC</constant></entry>
-	    <entry>The link enabled state can be modified during streaming. This
-	    flag is set by drivers and is read-only for applications.</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
-    <para>One and only one of <constant>MEDIA_PAD_FL_SINK</constant> and
-    <constant>MEDIA_PAD_FL_SOURCE</constant> must be set for every pad.</para>
   </refsect1>
 
   <refsect1>
diff --git a/Documentation/DocBook/media/v4l/media-types.xml b/Documentation/DocBook/media/v4l/media-types.xml
new file mode 100644
index 000000000000..0c5c9c034586
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/media-types.xml
@@ -0,0 +1,166 @@
+<section id="media-controller-types">
+<title>Types and flags used to represent the media graph elements</title>
+
+    <table frame="none" pgwide="1" id="media-entity-type">
+      <title>Media entity types</title>
+      <tgroup cols="2">
+	<colspec colname="c1"/>
+	<colspec colname="c2"/>
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_UNKNOWN</constant> and <constant>MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN</constant></entry>
+	    <entry>Unknown entity. That generally indicates that
+	    a driver didn't initialize properly the entity, with is a Kernel bug</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_IO_V4L</constant></entry>
+	    <entry>Data streaming input and/or output entity.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_IO_VBI</constant></entry>
+	    <entry>V4L VBI streaming input or output entity</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_IO_SWRADIO</constant></entry>
+	    <entry>V4L Software Digital Radio (SDR) streaming input or output entity</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_IO_DTV</constant></entry>
+	    <entry>DVB Digital TV streaming input or output entity</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_DTV_DEMOD</constant></entry>
+	    <entry>Digital TV demodulator entity.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_MPEG_TS_DEMUX</constant></entry>
+	    <entry>MPEG Transport stream demux entity. Could be implemented on hardware or in Kernelspace by the Linux DVB subsystem.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_DTV_CA</constant></entry>
+	    <entry>Digital TV Conditional Access module (CAM) entity</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_DTV_NET_DECAP</constant></entry>
+	    <entry>Digital TV network ULE/MLE desencapsulation entity. Could be implemented on hardware or in Kernelspace</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_CONN_RF</constant></entry>
+	    <entry>Connector for a Radio Frequency (RF) signal.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_CONN_SVIDEO</constant></entry>
+	    <entry>Connector for a S-Video signal.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_CONN_COMPOSITE</constant></entry>
+	    <entry>Connector for a RGB composite signal.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_CONN_TEST</constant></entry>
+	    <entry>Connector for a test generator.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_CAM_SENSOR</constant></entry>
+	    <entry>Camera video sensor entity.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_FLASH</constant></entry>
+	    <entry>Flash controller entity.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_LENS</constant></entry>
+	    <entry>Lens controller entity.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_ATV_DECODER</constant></entry>
+	    <entry>Analog video decoder, the basic function of the video decoder
+	    is to accept analogue video from a wide variety of sources such as
+	    broadcast, DVD players, cameras and video cassette recorders, in
+	    either NTSC, PAL, SECAM or HD format, separating the stream
+	    into its component parts, luminance and chrominance, and output
+	    it in some digital video standard, with appropriate timing
+	    signals.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_ENT_F_TUNER</constant></entry>
+	    <entry>Digital TV, analog TV, radio and/or software radio tuner.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table frame="none" pgwide="1" id="media-entity-flag">
+      <title>Media entity flags</title>
+      <tgroup cols="2">
+	<colspec colname="c1"/>
+	<colspec colname="c2"/>
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>MEDIA_ENT_FL_DEFAULT</constant></entry>
+	    <entry>Default entity for its type. Used to discover the default
+	    audio, VBI and video devices, the default camera sensor, ...</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table frame="none" pgwide="1" id="media-pad-flag">
+      <title>Media pad flags</title>
+      <tgroup cols="2">
+	<colspec colname="c1"/>
+	<colspec colname="c2"/>
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>MEDIA_PAD_FL_SINK</constant></entry>
+	    <entry>Input pad, relative to the entity. Input pads sink data and
+	    are targets of links.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_PAD_FL_SOURCE</constant></entry>
+	    <entry>Output pad, relative to the entity. Output pads source data
+	    and are origins of links.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_PAD_FL_MUST_CONNECT</constant></entry>
+	    <entry>If this flag is set and the pad is linked to any other
+	    pad, then at least one of those links must be enabled for the
+	    entity to be able to stream. There could be temporary reasons
+	    (e.g. device configuration dependent) for the pad to need
+	    enabled links even when this flag isn't set; the absence of the
+	    flag doesn't imply there is none.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <para>One and only one of <constant>MEDIA_PAD_FL_SINK</constant> and
+    <constant>MEDIA_PAD_FL_SOURCE</constant> must be set for every pad.</para>
+
+    <table frame="none" pgwide="1" id="media-link-flag">
+      <title>Media link flags</title>
+      <tgroup cols="2">
+	<colspec colname="c1"/>
+	<colspec colname="c2"/>
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>MEDIA_LNK_FL_ENABLED</constant></entry>
+	    <entry>The link is enabled and can be used to transfer media data.
+	    When two or more links target a sink pad, only one of them can be
+	    enabled at a time.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_LNK_FL_IMMUTABLE</constant></entry>
+	    <entry>The link enabled state can't be modified at runtime. An
+	    immutable link is always enabled.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>MEDIA_LNK_FL_DYNAMIC</constant></entry>
+	    <entry>The link enabled state can be modified during streaming. This
+	    flag is set by drivers and is read-only for applications.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+</section>
-- 
2.5.0


