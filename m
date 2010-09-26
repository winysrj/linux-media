Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:36175 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502Ab0IZQN3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Sep 2010 12:13:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, g.liakhovetski@gmx.de
Subject: [RFC/PATCH 7/9] v4l: v4l2_subdev userspace format API
Date: Sun, 26 Sep 2010 18:13:30 +0200
Message-Id: <1285517612-20230-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add a userspace API to get, set and enumerate the media format on a
subdev pad.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 Documentation/DocBook/Makefile                     |    5 +-
 Documentation/DocBook/media-entities.tmpl          |   16 +
 Documentation/DocBook/v4l/bayer.pdf                |  Bin 0 -> 12116 bytes
 Documentation/DocBook/v4l/bayer.png                |  Bin 0 -> 9725 bytes
 Documentation/DocBook/v4l/dev-subdev.xml           |  267 ++++
 Documentation/DocBook/v4l/pipeline.png             |  Bin 0 -> 12130 bytes
 Documentation/DocBook/v4l/subdev-formats.xml       | 1282 ++++++++++++++++++++
 Documentation/DocBook/v4l/v4l2.xml                 |    4 +
 Documentation/DocBook/v4l/vidioc-streamon.xml      |    9 +
 .../DocBook/v4l/vidioc-subdev-enum-frame-size.xml  |  148 +++
 .../DocBook/v4l/vidioc-subdev-enum-mbus-code.xml   |  113 ++
 Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml  |  168 +++
 drivers/media/video/v4l2-subdev.c                  |   51 +
 include/linux/Kbuild                               |    1 +
 include/linux/v4l2-subdev.h                        |   90 ++
 include/media/v4l2-subdev.h                        |   11 +-
 16 files changed, 2159 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/bayer.pdf
 create mode 100644 Documentation/DocBook/v4l/bayer.png
 create mode 100644 Documentation/DocBook/v4l/dev-subdev.xml
 create mode 100644 Documentation/DocBook/v4l/pipeline.png
 create mode 100644 Documentation/DocBook/v4l/subdev-formats.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-enum-frame-size.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-enum-mbus-code.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml
 create mode 100644 include/linux/v4l2-subdev.h

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 34929f2..2ab076a 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -53,7 +53,10 @@ MAN := $(patsubst %.xml, %.9, $(BOOKS))
 mandocs: $(MAN)
 
 build_images = mkdir -p $(objtree)/Documentation/DocBook/media/ && \
-	       cp $(srctree)/Documentation/DocBook/dvb/*.png $(srctree)/Documentation/DocBook/v4l/*.gif $(objtree)/Documentation/DocBook/media/
+	       cp $(srctree)/Documentation/DocBook/dvb/*.png \
+	          $(srctree)/Documentation/DocBook/v4l/*.gif \
+	          $(srctree)/Documentation/DocBook/v4l/*.png \
+		  $(objtree)/Documentation/DocBook/media/
 
 xmldoclinks:
 ifneq ($(objtree),$(srctree))
diff --git a/Documentation/DocBook/media-entities.tmpl b/Documentation/DocBook/media-entities.tmpl
index 19d6497..160bca6 100644
--- a/Documentation/DocBook/media-entities.tmpl
+++ b/Documentation/DocBook/media-entities.tmpl
@@ -86,6 +86,10 @@
 <!ENTITY VIDIOC-S-PRIORITY "<link linkend='vidioc-g-priority'><constant>VIDIOC_S_PRIORITY</constant></link>">
 <!ENTITY VIDIOC-S-STD "<link linkend='vidioc-g-std'><constant>VIDIOC_S_STD</constant></link>">
 <!ENTITY VIDIOC-S-TUNER "<link linkend='vidioc-g-tuner'><constant>VIDIOC_S_TUNER</constant></link>">
+<!ENTITY VIDIOC-SUBDEV-ENUM-FRAME-SIZE "<link linkend='vidioc-subdev-enum-frame-size'><constant>VIDIOC_SUBDEV_ENUM_FRAME_SIZE</constant></link>">
+<!ENTITY VIDIOC-SUBDEV-ENUM-MBUS-CODE "<link linkend='vidioc-subdev-enum-mbus-code'><constant>VIDIOC_SUBDEV_ENUM_MBUS_CODE</constant></link>">
+<!ENTITY VIDIOC-SUBDEV-G-FMT "<link linkend='vidioc-subdev-g-fmt'><constant>VIDIOC_SUBDEV_G_FMT</constant></link>">
+<!ENTITY VIDIOC-SUBDEV-S-FMT "<link linkend='vidioc-subdev-g-fmt'><constant>VIDIOC_SUBDEV_S_FMT</constant></link>">
 <!ENTITY VIDIOC-TRY-ENCODER-CMD "<link linkend='vidioc-encoder-cmd'><constant>VIDIOC_TRY_ENCODER_CMD</constant></link>">
 <!ENTITY VIDIOC-TRY-EXT-CTRLS "<link linkend='vidioc-g-ext-ctrls'><constant>VIDIOC_TRY_EXT_CTRLS</constant></link>">
 <!ENTITY VIDIOC-TRY-FMT "<link linkend='vidioc-g-fmt'><constant>VIDIOC_TRY_FMT</constant></link>">
@@ -107,6 +111,7 @@
 <!ENTITY v4l2-field "enum&nbsp;<link linkend='v4l2-field'>v4l2_field</link>">
 <!ENTITY v4l2-frmivaltypes "enum&nbsp;<link linkend='v4l2-frmivaltypes'>v4l2_frmivaltypes</link>">
 <!ENTITY v4l2-frmsizetypes "enum&nbsp;<link linkend='v4l2-frmsizetypes'>v4l2_frmsizetypes</link>">
+<!ENTITY v4l2-mbus-pixelcode "enum&nbsp;<link linkend='v4l2-mbus-pixelcode'>v4l2_mbus_pixelcode</link>">
 <!ENTITY v4l2-memory "enum&nbsp;<link linkend='v4l2-memory'>v4l2_memory</link>">
 <!ENTITY v4l2-mpeg-audio-ac3-bitrate "enum&nbsp;<link linkend='v4l2-mpeg-audio-ac3-bitrate'>v4l2_mpeg_audio_ac3_bitrate</link>">
 <!ENTITY v4l2-mpeg-audio-crc "enum&nbsp;<link linkend='v4l2-mpeg-audio-crc'>v4l2_mpeg_audio_crc</link>">
@@ -130,6 +135,7 @@
 <!ENTITY v4l2-mpeg-video-encoding "enum&nbsp;<link linkend='v4l2-mpeg-video-encoding'>v4l2_mpeg_video_encoding</link>">
 <!ENTITY v4l2-power-line-frequency "enum&nbsp;<link linkend='v4l2-power-line-frequency'>v4l2_power_line_frequency</link>">
 <!ENTITY v4l2-priority "enum&nbsp;<link linkend='v4l2-priority'>v4l2_priority</link>">
+<!ENTITY v4l2-subdev-format-whence "enum&nbsp;<link linkend='v4l2-subdev-format-whence'>v4l2_subdev_format_whence</link>">
 <!ENTITY v4l2-tuner-type "enum&nbsp;<link linkend='v4l2-tuner-type'>v4l2_tuner_type</link>">
 <!ENTITY v4l2-preemphasis "enum&nbsp;<link linkend='v4l2-preemphasis'>v4l2_preemphasis</link>">
 
@@ -171,6 +177,7 @@
 <!ENTITY v4l2-hw-freq-seek "struct&nbsp;<link linkend='v4l2-hw-freq-seek'>v4l2_hw_freq_seek</link>">
 <!ENTITY v4l2-input "struct&nbsp;<link linkend='v4l2-input'>v4l2_input</link>">
 <!ENTITY v4l2-jpegcompression "struct&nbsp;<link linkend='v4l2-jpegcompression'>v4l2_jpegcompression</link>">
+<!ENTITY v4l2-mbus-framefmt "struct&nbsp;<link linkend='v4l2-mbus-framefmt'>v4l2_mbus_framefmt</link>">
 <!ENTITY v4l2-modulator "struct&nbsp;<link linkend='v4l2-modulator'>v4l2_modulator</link>">
 <!ENTITY v4l2-mpeg-vbi-fmt-ivtv "struct&nbsp;<link linkend='v4l2-mpeg-vbi-fmt-ivtv'>v4l2_mpeg_vbi_fmt_ivtv</link>">
 <!ENTITY v4l2-output "struct&nbsp;<link linkend='v4l2-output'>v4l2_output</link>">
@@ -183,6 +190,9 @@
 <!ENTITY v4l2-sliced-vbi-cap "struct&nbsp;<link linkend='v4l2-sliced-vbi-cap'>v4l2_sliced_vbi_cap</link>">
 <!ENTITY v4l2-sliced-vbi-data "struct&nbsp;<link linkend='v4l2-sliced-vbi-data'>v4l2_sliced_vbi_data</link>">
 <!ENTITY v4l2-sliced-vbi-format "struct&nbsp;<link linkend='v4l2-sliced-vbi-format'>v4l2_sliced_vbi_format</link>">
+<!ENTITY v4l2-subdev-frame-size-enum "struct&nbsp;<link linkend='v4l2-subdev-frame-size-enum'>v4l2_subdev_frame_size_enum</link>">
+<!ENTITY v4l2-subdev-format "struct&nbsp;<link linkend='v4l2-subdev-format'>v4l2_subdev_format</link>">
+<!ENTITY v4l2-subdev-mbus-code-enum "struct&nbsp;<link linkend='v4l2-subdev-mbus-code-enum'>v4l2_subdev_mbus_code_enum</link>">
 <!ENTITY v4l2-standard "struct&nbsp;<link linkend='v4l2-standard'>v4l2_standard</link>">
 <!ENTITY v4l2-streamparm "struct&nbsp;<link linkend='v4l2-streamparm'>v4l2_streamparm</link>">
 <!ENTITY v4l2-timecode "struct&nbsp;<link linkend='v4l2-timecode'>v4l2_timecode</link>">
@@ -212,6 +222,7 @@
 <!ENTITY ENXIO "<errorcode>ENXIO</errorcode> error code">
 <!ENTITY EMFILE "<errorcode>EMFILE</errorcode> error code">
 <!ENTITY EPERM "<errorcode>EPERM</errorcode> error code">
+<!ENTITY EPIPE "<errorcode>EPIPE</errorcode> error code">
 <!ENTITY ERANGE "<errorcode>ERANGE</errorcode> error code">
 
 <!-- Subsections -->
@@ -230,6 +241,7 @@
 <!ENTITY sub-dev-raw-vbi SYSTEM "v4l/dev-raw-vbi.xml">
 <!ENTITY sub-dev-rds SYSTEM "v4l/dev-rds.xml">
 <!ENTITY sub-dev-sliced-vbi SYSTEM "v4l/dev-sliced-vbi.xml">
+<!ENTITY sub-dev-subdev SYSTEM "v4l/dev-subdev.xml">
 <!ENTITY sub-dev-teletext SYSTEM "v4l/dev-teletext.xml">
 <!ENTITY sub-driver SYSTEM "v4l/driver.xml">
 <!ENTITY sub-libv4l SYSTEM "v4l/libv4l.xml">
@@ -310,6 +322,10 @@
 <!ENTITY sub-reqbufs SYSTEM "v4l/vidioc-reqbufs.xml">
 <!ENTITY sub-s-hw-freq-seek SYSTEM "v4l/vidioc-s-hw-freq-seek.xml">
 <!ENTITY sub-streamon SYSTEM "v4l/vidioc-streamon.xml">
+<!ENTITY sub-subdev-enum-frame-size SYSTEM "v4l/vidioc-subdev-enum-frame-size.xml">
+<!ENTITY sub-subdev-enum-mbus-code SYSTEM "v4l/vidioc-subdev-enum-mbus-code.xml">
+<!ENTITY sub-subdev-formats SYSTEM "v4l/subdev-formats.xml">
+<!ENTITY sub-subdev-g-fmt SYSTEM "v4l/vidioc-subdev-g-fmt.xml">
 <!ENTITY sub-capture-c SYSTEM "v4l/capture.c.xml">
 <!ENTITY sub-keytable-c SYSTEM "v4l/keytable.c.xml">
 <!ENTITY sub-v4l2grab-c SYSTEM "v4l/v4l2grab.c.xml">
diff --git a/Documentation/DocBook/v4l/bayer.pdf b/Documentation/DocBook/v4l/bayer.pdf
new file mode 100644
index 0000000000000000000000000000000000000000..905e60e6cd429f026afdfa6fb4dab3f1683adb8a
GIT binary patch
literal 12116
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

literal 0
HcmV?d00001

diff --git a/Documentation/DocBook/v4l/bayer.png b/Documentation/DocBook/v4l/bayer.png
new file mode 100644
index 0000000000000000000000000000000000000000..9b15fb22e8173c83c3da6df73cd7cdc7d8f41736
GIT binary patch
literal 9725
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
Ulq-hwxG4posiv!1sSJ(ye?2;OE&u=k

literal 0
HcmV?d00001

diff --git a/Documentation/DocBook/v4l/dev-subdev.xml b/Documentation/DocBook/v4l/dev-subdev.xml
new file mode 100644
index 0000000..9a691f7
--- /dev/null
+++ b/Documentation/DocBook/v4l/dev-subdev.xml
@@ -0,0 +1,267 @@
+  <title>Sub-device Interface</title>
+
+  <para>The complex nature of V4L2 devices, where hardware is often made of
+  several integrated circuits that need to interact with each other in a
+  controlled way, leads to complex V4L2 drivers. The drivers usually reflect
+  the hardware model in software, and model the different hardware components
+  as software blocks called sub-devices.</para>
+
+  <para>V4L2 sub-devices are usually kernel-only objects. If the V4L2 driver
+  implements the media device API, they will automatically inherit from media
+  entities. Applications will be able to enumerate the sub-devices and discover
+  the hardware topology using the media entities, pads and links enumeration
+  API.</para>
+
+  <para>In addition to make sub-devices discoverable, drivers can also choose
+  to make them directly configurable by applications. When both the sub-device
+  driver and the V4L2 device driver support this, sub-devices will feature a
+  character device node on which ioctls can be called to
+  <itemizedlist>
+    <listitem>query, read and write sub-devices controls</listitem>
+    <listitem>subscribe and unsubscribe to events and retrieve them</listitem>
+    <listitem>negotiate image formats on individual pads</listitem>
+  </itemizedlist>
+  </para>
+
+  <para>Sub-device character device nodes, conventionally named
+  <filename>/dev/v4l-subdev0</filename> to
+  <filename>/dev/v4l-subdev63</filename>, use major number 81 and minor numbers
+  between 128 and 191.</para>
+
+  <section>
+    <title>Controls</title>
+    <para>Most V4L2 controls are implemented by sub-device hardware. Drivers
+    usually merge all controls and expose them through video device nodes.
+    Applications can control all sub-devices through a single interface.</para>
+
+    <para>Complex devices sometimes implement the same control in different
+    pieces of hardware. This situation is common in embedded platforms, where
+    both sensors and image processing hardware implement identical functions,
+    such as contrast adjustment, white balance or faulty pixels correction. As
+    the V4L2 controls API doesn't support several identical controls in a single
+    device, all but one of the identical controls are hidden.</para>
+
+    <para>Applications can access those hidden controls through the sub-device
+    node with the V4L2 control API described in <xref linkend="control" />. The
+    ioctls behave identically as when issued on V4L2 device nodes, with the
+    exception that they deal only with controls implemented in the sub-device.
+    </para>
+
+    <para>Depending on the driver, those controls are also exposed through one
+    (or several) V4L2 device nodes.</para>
+  </section>
+
+  <section>
+    <title>Events</title>
+    <para>V4L2 sub-devices can notify applications of events as described in
+    <xref linkend="event" />. The API behaves identically as when used on V4L2
+    device nodes, with the exception that it only deals with events generated by
+    the sub-device. Depending on the driver, those events can also be reported
+    on one (or several) V4L2 device nodes.</para>
+  </section>
+
+  <section id="pad-level-formats">
+    <title>Pad-level formats</title>
+
+    <note>For the purpose of this section, the term
+    <wordasword>format</wordasword> means the combination of media bus data
+    format, frame width and frame height.</note>
+
+    <para>Image formats are typically negotiated on video capture and output
+    devices using the <link linkend="crop">cropping and scaling</link> ioctls.
+    The driver is responsible for configuring every block in the video pipeline
+    according to the requested format at the pipeline input and/or
+    output.</para>
+
+    <para>For complex devices, such as often found in embedded systems,
+    identical image sizes at the output of a pipeline can be achieved using
+    different hardware configurations. One such exemple is shown on
+    <xref linkend="pipeline-scaling" xrefstyle="template: Figure %n" />, where
+    image scaling can be performed on both the video sensor and the host image
+    processing hardware.</para>
+
+    <figure id="pipeline-scaling">
+      <title>Image format negotation on pipelines</title>
+      <mediaobject>
+	<imageobject>
+	  <imagedata fileref="pipeline.pdf" format="PS" />
+	</imageobject>
+	<imageobject>
+	  <imagedata fileref="pipeline.png" format="PNG" />
+	</imageobject>
+	<textobject>
+	  <phrase>High quality and high speed pipeline configuration</phrase>
+	</textobject>
+      </mediaobject>
+    </figure>
+
+    <para>The sensor scaller is usually of less quality than the host scaler,
+    but scaling on the sensor is required to achieve higher frame rates.
+    Depending on the use case (quality vs. speed), the pipeline must be
+    configured differently. Applications need to configure the formats at every
+    point in the pipeline explictly.</para>
+
+    <para>Drivers that implement the <link linkend="media-controller-intro">media
+    API</link> can expose pad-level image format configuration to applications.
+    When they do, applications can use the &VIDIOC-SUBDEV-G-FMT; and
+    &VIDIOC-SUBDEV-S-FMT; ioctls. to negotiate formats on a per-pad basis.</para>
+
+    <para>Applications are responsible for configuring coherent parameters on
+    the whole pipeline and making sure that connected pads have compatible
+    formats. The pipeline is checked for formats mismatch at &VIDIOC-STREAMON;
+    time, and an &EPIPE; is then returned if the configuration is
+    invalid.</para>
+
+    <section>
+      <title>Format negotiation</title>
+
+      <para>Acceptable formats on pads can (and usually do) depend on a number
+      of external parameters, such as formats on other pads, active links, or
+      even controls. Finding a combination of formats on all pads in a video
+      pipeline, acceptable to both application and driver, can't rely on formats
+      enumeration only. A format negotiation mechanism is required.</para>
+
+      <para>Central to the format negotiation mechanism are the get/set format
+      operations. When called with the <structfield>which</structfield> argument
+      set to <constant>V4L2_SUBDEV_FORMAT_PROBE</constant>, the
+      &VIDIOC-SUBDEV-G-FMT; and &VIDIOC-SUBDEV-S-FMT; ioctls operate on a set of
+      formats parameters that are not connected to the hardware configuration.
+      Modifying those probe formats leaves the device state untouched (this
+      applies to both the software state stored in the driver and the hardware
+      state stored in the device itself).</para>
+
+      <para>While not kept as part of the device state, probe formats are stored
+      in the sub-device file handles. A &VIDIOC-SUBDEV-G-FMT; call will return
+      the last probe format set <emphasis>on the same sub-device file
+      handle</emphasis>. Several applications probing the same sub-device at the
+      same time will thus not interact with each other.</para>
+
+      <para>To find out whether a particular format is supported by the device,
+      applications use the &VIDIOC-SUBDEV-S-FMT; ioctl. Drivers verify and, if
+      needed, mangle the requested <structfield>format</structfield> based on
+      device requirements and return the possibly modified value. Applications
+      can then choose to probe for a different format or accept the returned
+      value and continue.</para>
+
+      <para>Formats returned by the driver during a negotiation iteration are
+      guaranteed to be supported by the device. In particular, drivers guarantee
+      that a returned format will not be further mangled if passed to an
+      &VIDIOC-SUBDEV-S-FMT; call as-is (as long as external parameters, such as
+      formats on other pads or links' configuration are not changed).</para>
+
+      <para>Drivers automatically propagate formats inside sub-devices. When a
+      probe or active format is set on a pad, corresponding formats on other
+      pads of the same sub-device can be modified by the driver. Drivers are
+      free to modify formats as required by the device. However, they should
+      comply with the following rules when possible.
+      <itemizedlist>
+        <listitem>Formats should be propagated from sink pads to source pads.
+	Modifying a format on a source pad should not modify the format on any
+	sink pad.</listitem>
+        <listitem>Sub-devices that scale frames using variable scaling factors
+	should reset the scale factors to default values when sink pads formats
+	are modified. If the 1:1 scaling ratio is supported, this means that
+	source pads formats should be reset to the sink pads formats.</listitem>
+      </itemizedlist>
+      </para>
+
+      <para>Formats are not propagated across links, as that would involve
+      propagating them from one sub-device file handle to another. Applications
+      must then take care to configure both ends of every link explicitly with
+      compatible formats. Identical formats on the two ends of a link are
+      guaranteed to be compatible. Drivers are free to accept different formats
+      matching device requirements as being compatible.</para>
+
+      <para><xref linkend="sample-pipeline-config" xrefstyle="template:Table %n"/>
+      shows a sample configuration sequence for the pipeline described in
+      <xref linkend="pipeline-scaling" xrefstyle="template:Figure %n"/> (table
+      columns list entity names and pad numbers).</para>
+
+      <table pgwide="0" frame="none" id="sample-pipeline-config">
+	<title>Sample pipeline configuration</title>
+	<tgroup cols="3">
+	  <colspec colname="what"/>
+	  <colspec colname="sensor-0" />
+	  <colspec colname="frontend-0" />
+	  <colspec colname="frontend-1" />
+	  <colspec colname="scaler-0" />
+	  <colspec colname="scaler-1" />
+	  <thead>
+	    <row>
+	      <entry></entry>
+	      <entry>Sensor/0</entry>
+	      <entry>Frontend/0</entry>
+	      <entry>Frontend/1</entry>
+	      <entry>Scaler/0</entry>
+	      <entry>Scaler/1</entry>
+	    </row>
+	  </thead>
+	  <tbody valign="top">
+	    <row>
+	      <entry>Initial state</entry>
+	      <entry>2048x1536</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	    </row>
+	    <row>
+	      <entry>Configure frontend input</entry>
+	      <entry>2048x1536</entry>
+	      <entry><emphasis>2048x1536</emphasis></entry>
+	      <entry><emphasis>2046x1534</emphasis></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	    </row>
+	    <row>
+	      <entry>Configure scaler input</entry>
+	      <entry>2048x1536</entry>
+	      <entry>2048x1536</entry>
+	      <entry>2046x1534</entry>
+	      <entry><emphasis>2046x1534</emphasis></entry>
+	      <entry><emphasis>2046x1534</emphasis></entry>
+	    </row>
+	    <row>
+	      <entry>Configure scaler output</entry>
+	      <entry>2048x1536</entry>
+	      <entry>2048x1536</entry>
+	      <entry>2046x1534</entry>
+	      <entry>2046x1534</entry>
+	      <entry><emphasis>1280x960</emphasis></entry>
+	    </row>
+	  </tbody>
+	</tgroup>
+      </table>
+
+      <para>
+      <orderedlist>
+	<listitem>Initial state. The sensor output is set to its native 3MP
+	resolution. Resolutions on the host frontend and scaler input and output
+	pads are undefined.</listitem>
+	<listitem>The application configures the frontend input pad resolution to
+	2048x1536. The driver propagates the format to the frontend output pad.
+	Note that the propagated output format can be different, as in this case,
+	than the input format, as the hardware might need to crop pixels (for
+	instance when converting a Bayer filter pattern to RGB or YUV).</listitem>
+	<listitem>The application configures the scaler input pad resolution to
+	2046x1534 to match the frontend output resolution. The driver propagates
+	the format to the scaler output pad.</listitem>
+	<listitem>The application configures the scaler output pad resolution to
+	1280x960.</listitem>
+      </orderedlist>
+      </para>
+
+      <para>When satisfied with the probe results, applications can set the
+      active formats by setting the <structfield>which</structfield> argument to
+      <constant>V4L2_SUBDEV_FORMAT_PROBE</constant>. Active formats are mangled
+      exactly as probe formats by drivers. To avoid modifying the hardware
+      state during format negotiation, applications should negotiate probe
+      formats first and then modify the active settings using the probe formats
+      returned during the last negotiation iteration. This guarantees that the
+      active format will be applied as-is by the driver without being modified.
+      </para>
+    </section>
+
+  </section>
+
+  &sub-subdev-formats;
diff --git a/Documentation/DocBook/v4l/pipeline.png b/Documentation/DocBook/v4l/pipeline.png
new file mode 100644
index 0000000000000000000000000000000000000000..f19b86c2c24d07d5ae437820944d25489a447d7a
GIT binary patch
literal 12130
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
B;b8y(

literal 0
HcmV?d00001

diff --git a/Documentation/DocBook/v4l/subdev-formats.xml b/Documentation/DocBook/v4l/subdev-formats.xml
new file mode 100644
index 0000000..fb3c8b1
--- /dev/null
+++ b/Documentation/DocBook/v4l/subdev-formats.xml
@@ -0,0 +1,1282 @@
+<section id="v4l2-mbus-format">
+  <title>Media bus formats</title>
+
+  <table pgwide="1" frame="none" id="v4l2-mbus-framefmt">
+    <title>struct <structname>v4l2_mbus_framefmt</structname></title>
+    <tgroup cols="3">
+      &cs-str;
+      <tbody valign="top">
+	<row>
+	  <entry>__u32</entry>
+	  <entry><structfield>width</structfield></entry>
+	  <entry>Image width, in pixels.</entry>
+	</row>
+	<row>
+	  <entry>__u32</entry>
+	  <entry><structfield>height</structfield></entry>
+	  <entry>Image height, in pixels.</entry>
+	</row>
+	<row>
+	  <entry>__u32</entry>
+	  <entry><structfield>code</structfield></entry>
+	  <entry>Format code, see &v4l2-mbus-pixelcode;. for details.</entry>
+	</row>
+	<row>
+	  <entry>enum v4l2_field</entry>
+	  <entry><structfield>field</structfield></entry>
+	  <entry>Field order, see <xref linkend="field-order" /> for details.
+	  </entry>
+	</row>
+	<row>
+	  <entry>enum v4l2_colorspace</entry>
+	  <entry><structfield>colorspace</structfield></entry>
+	  <entry>Image colorspace, see <xref linkend="field-order" /> for details.
+	  </entry>
+	</row>
+      </tbody>
+    </tgroup>
+  </table>
+
+  <section id="v4l2-mbus-pixelcode">
+    <title>Pixel codes</title>
+    <section>
+      <title>Packet RGB formats</title>
+
+      <para>Those formats transfer pixel data as red, green and blue components.
+      The format code is made of the following information.
+      <itemizedlist>
+	<listitem>The red, green and blue components order code, as encoded in a
+	pixel sample. Possible values are RGB and BGR.</listitem>
+	<listitem>The number of bits per component, for each component. The values
+	can be different for all components. Common values are 555 and 565.
+	</listitem>
+	<listitem>The number of bus samples per pixel. Pixels that are wider than
+	the bus width must be transferred in multiple samples. Common values are
+	1 and 2.</listitem>
+	<listitem>The bus width.</listitem>
+	<listitem>For formats where the total number of bits per pixel is smaller
+	than the number of bus samples per pixel times the bus width, a padding
+	value stating if the bytes are padded in their most high order bits
+	(PADHI) or low order bits (PADLO).</listitem>
+	<listitem>For formats where the number of bus samples per pixel is larger
+	than 1, an endianness value stating if the pixel is transferred MSB first
+	(BE) or LSB first (LE).</listitem>
+      </itemizedlist>
+      </para>
+
+      <para>For instance, a format where pixels are encoded as 5-bits red, 5-bits
+      green and 5-bit blue values padded on the high bit, transferred as 2 8-bit
+      samples per pixel with the most significant bits (padding, red and half of
+      the green value) transferred first will be named
+      <constant>V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE</constant>.
+      </para>
+
+      <para>The following tables list existing packet RGB formats.</para>
+
+      <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-rgb">
+	<title>RGB formats</title>
+	<tgroup cols="11">
+	  <colspec colname="id" align="left" />
+	  <colspec colname="code" align="center"/>
+	  <colspec colname="bit" />
+	  <colspec colnum="4" colname="b07" align="center" />
+	  <colspec colnum="5" colname="b06" align="center" />
+	  <colspec colnum="6" colname="b05" align="center" />
+	  <colspec colnum="7" colname="b04" align="center" />
+	  <colspec colnum="8" colname="b03" align="center" />
+	  <colspec colnum="9" colname="b02" align="center" />
+	  <colspec colnum="10" colname="b01" align="center" />
+	  <colspec colnum="11" colname="b00" align="center" />
+	  <spanspec namest="b07" nameend="b00" spanname="b0" />
+	  <thead>
+	    <row>
+	      <entry>Identifier</entry>
+	      <entry>Code</entry>
+	      <entry></entry>
+	      <entry spanname="b0">Data organization</entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>Bit</entry>
+	      <entry>7</entry>
+	      <entry>6</entry>
+	      <entry>5</entry>
+	      <entry>4</entry>
+	      <entry>3</entry>
+	      <entry>2</entry>
+	      <entry>1</entry>
+	      <entry>0</entry>
+	    </row>
+	  </thead>
+	  <tbody valign="top">
+	    <row id="V4L2-MBUS-FMT-RGB555-2X8-PADHI-BE">
+	      <entry>V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE</entry>
+	      <entry>7</entry>
+	      <entry></entry>
+	      <entry>0</entry>
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-RGB555-2X8-PADHI-LE">
+	      <entry>V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE</entry>
+	      <entry>6</entry>
+	      <entry></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>0</entry>
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-RGB565-2X8-BE">
+	      <entry>V4L2_MBUS_FMT_RGB565_2X8_BE</entry>
+	      <entry>9</entry>
+	      <entry></entry>
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-RGB565-2X8-LE">
+	      <entry>V4L2_MBUS_FMT_RGB565_2X8_LE</entry>
+	      <entry>8</entry>
+	      <entry></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	    </row>
+	  </tbody>
+	</tgroup>
+      </table>
+    </section>
+
+    <section>
+      <title>Bayer formats</title>
+
+      <para>Those formats transfer pixel data as red, green and blue components.
+      The format code is made of the following information.
+      <itemizedlist>
+	<listitem>The red, green and blue components order code, as encoded in a
+	pixel sample. The possible values are shown in <xref
+	linkend="bayer-patterns" />.</listitem>
+	<listitem>The number of bits per pixel component. All components are
+	transferred on the same number of bits. Common values are 8, 10 and 12.
+	</listitem>
+	<listitem>If the pixel components are DPCM-compressed, a mention of the
+	DPCM compression and the number of bits per compressed pixel component.
+	</listitem>
+	<listitem>The number of bus samples per pixel. Pixels that are wider than
+	the bus width must be transferred in multiple samples. Common values are
+	1 and 2.</listitem>
+	<listitem>The bus width.</listitem>
+	<listitem>For formats where the total number of bits per pixel is smaller
+	than the number of bus samples per pixel times the bus width, a padding
+	value stating if the bytes are padded in their most high order bits
+	(PADHI) or low order bits (PADLO).</listitem>
+	<listitem>For formats where the number of bus samples per pixel is larger
+	than 1, an endianness value stating if the pixel is transferred MSB first
+	(BE) or LSB first (LE).</listitem>
+      </itemizedlist>
+      </para>
+
+      <para>For instance, a format with uncompressed 10-bit Bayer components
+      arranged in a red, green, green, blue pattern transferred as 2 8-bit
+      samples per pixel with the least significant bits transferred first will
+      be named <constant>V4L2_MBUS_FMT_SRGGB10_2X8_PADHI_LE</constant>.
+      </para>
+
+      <figure id="bayer-patterns">
+	<title>Bayer patterns</title>
+	<mediaobject>
+	  <imageobject>
+	    <imagedata fileref="bayer.pdf" format="PS" />
+	  </imageobject>
+	  <imageobject>
+	    <imagedata fileref="bayer.png" format="PNG" />
+	  </imageobject>
+	  <textobject>
+	    <phrase>Bayer filter color patterns</phrase>
+	  </textobject>
+	</mediaobject>
+      </figure>
+
+      <para>The following table lists existing packet Bayer formats. The data
+      organization is given as an example for the first pixel only.</para>
+
+      <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-bayer">
+	<title>Bayer formats</title>
+	<tgroup cols="15">
+	  <colspec colname="id" align="left" />
+	  <colspec colname="code" align="center"/>
+	  <colspec colname="bit" />
+	  <colspec colnum="4" colname="b11" align="center" />
+	  <colspec colnum="5" colname="b10" align="center" />
+	  <colspec colnum="6" colname="b09" align="center" />
+	  <colspec colnum="7" colname="b08" align="center" />
+	  <colspec colnum="8" colname="b07" align="center" />
+	  <colspec colnum="9" colname="b06" align="center" />
+	  <colspec colnum="10" colname="b05" align="center" />
+	  <colspec colnum="11" colname="b04" align="center" />
+	  <colspec colnum="12" colname="b03" align="center" />
+	  <colspec colnum="13" colname="b02" align="center" />
+	  <colspec colnum="14" colname="b01" align="center" />
+	  <colspec colnum="15" colname="b00" align="center" />
+	  <spanspec namest="b11" nameend="b00" spanname="b0" />
+	  <thead>
+	    <row>
+	      <entry>Identifier</entry>
+	      <entry>Code</entry>
+	      <entry></entry>
+	      <entry spanname="b0">Data organization</entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>Bit</entry>
+	      <entry>11</entry>
+	      <entry>10</entry>
+	      <entry>9</entry>
+	      <entry>8</entry>
+	      <entry>7</entry>
+	      <entry>6</entry>
+	      <entry>5</entry>
+	      <entry>4</entry>
+	      <entry>3</entry>
+	      <entry>2</entry>
+	      <entry>1</entry>
+	      <entry>0</entry>
+	    </row>
+	  </thead>
+	  <tbody valign="top">
+	    <row id="V4L2-MBUS-FMT-SBGGR8-1X8">
+	      <entry>V4L2_MBUS_FMT_SBGGR8_1X8</entry>
+	      <entry>10</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>b<subscript>7</subscript></entry>
+	      <entry>b<subscript>6</subscript></entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-SBGGR10-DPCM8-1X8">
+	      <entry>V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8</entry>
+	      <entry>30</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>b<subscript>7</subscript></entry>
+	      <entry>b<subscript>6</subscript></entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-SBGGR10-2X8-PADHI-BE">
+	      <entry>V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE</entry>
+	      <entry>16</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>b<subscript>9</subscript></entry>
+	      <entry>b<subscript>8</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>b<subscript>7</subscript></entry>
+	      <entry>b<subscript>6</subscript></entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-SBGGR10-2X8-PADHI-LE">
+	      <entry>V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE</entry>
+	      <entry>14</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>b<subscript>7</subscript></entry>
+	      <entry>b<subscript>6</subscript></entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>b<subscript>9</subscript></entry>
+	      <entry>b<subscript>8</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-SBGGR10-2X8-PADLO-BE">
+	      <entry>V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE</entry>
+	      <entry>17</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>b<subscript>9</subscript></entry>
+	      <entry>b<subscript>8</subscript></entry>
+	      <entry>b<subscript>7</subscript></entry>
+	      <entry>b<subscript>6</subscript></entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-SBGGR10-2X8-PADLO-LE">
+	      <entry>V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE</entry>
+	      <entry>15</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>b<subscript>9</subscript></entry>
+	      <entry>b<subscript>8</subscript></entry>
+	      <entry>b<subscript>7</subscript></entry>
+	      <entry>b<subscript>6</subscript></entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-SBGGR10-1X10">
+	      <entry>V4L2_MBUS_FMT_SBGGR10_1X10</entry>
+	      <entry>11</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>b<subscript>9</subscript></entry>
+	      <entry>b<subscript>8</subscript></entry>
+	      <entry>b<subscript>7</subscript></entry>
+	      <entry>b<subscript>6</subscript></entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-SBGGR12-1X12">
+	      <entry>V4L2_MBUS_FMT_SBGGR12_1X12</entry>
+	      <entry>19</entry>
+	      <entry></entry>
+	      <entry>b<subscript>11</subscript></entry>
+	      <entry>b<subscript>10</subscript></entry>
+	      <entry>b<subscript>9</subscript></entry>
+	      <entry>b<subscript>8</subscript></entry>
+	      <entry>b<subscript>7</subscript></entry>
+	      <entry>b<subscript>6</subscript></entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-SGBRG10-DPCM8-1X8">
+	      <entry>V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8</entry>
+	      <entry>32</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>g<subscript>7</subscript></entry>
+	      <entry>g<subscript>6</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-SGBRG10-1X10">
+	      <entry>V4L2_MBUS_FMT_SGBRG10_1X10</entry>
+	      <entry>31</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>g<subscript>9</subscript></entry>
+	      <entry>g<subscript>8</subscript></entry>
+	      <entry>g<subscript>7</subscript></entry>
+	      <entry>g<subscript>6</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-SGRBG8-1X8">
+	      <entry>V4L2_MBUS_FMT_SGRBG8_1X8</entry>
+	      <entry>18</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>g<subscript>7</subscript></entry>
+	      <entry>g<subscript>6</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-SGRBG10-DPCM8-1X8">
+	      <entry>V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8</entry>
+	      <entry>29</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>g<subscript>7</subscript></entry>
+	      <entry>g<subscript>6</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-SGRBG10-1X10">
+	      <entry>V4L2_MBUS_FMT_SGRBG10_1X10</entry>
+	      <entry>28</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>g<subscript>9</subscript></entry>
+	      <entry>g<subscript>8</subscript></entry>
+	      <entry>g<subscript>7</subscript></entry>
+	      <entry>g<subscript>6</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-SRGGB10-DPCM8-1X8">
+	      <entry>V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8</entry>
+	      <entry>34</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>r<subscript>7</subscript></entry>
+	      <entry>r<subscript>6</subscript></entry>
+	      <entry>r<subscript>5</subscript></entry>
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-SRGGB10-1X10">
+	      <entry>V4L2_MBUS_FMT_SRGGB10_1X10</entry>
+	      <entry>33</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>r<subscript>9</subscript></entry>
+	      <entry>r<subscript>8</subscript></entry>
+	      <entry>r<subscript>7</subscript></entry>
+	      <entry>r<subscript>6</subscript></entry>
+	      <entry>r<subscript>5</subscript></entry>
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	    </row>
+	  </tbody>
+	</tgroup>
+      </table>
+    </section>
+
+    <section>
+      <title>Packed YUV formats</title>
+
+      <para>Those data formats transfer pixel data as (possibly downsampled) Y, U
+      and V components. The format code is made of the following information.
+      <itemizedlist>
+	<listitem>The Y, U and V components order code, as transferred on the
+	bus. Possible values are YUYV, UYVY, YVYU and VYUY.</listitem>
+	<listitem>The number of bits per pixel component. All components are
+	transferred on the same number of bits. Common values are 8, 10 and 12.
+	</listitem>
+	<listitem>The number of bus samples per pixel. Pixels that are wider than
+	the bus width must be transferred in multiple samples. Common values are
+	1, 1.5 (encoded as 1_5) and 2.</listitem>
+	<listitem>The bus width. When the bus width is larger than the number of
+	bits per pixel component, several components are packed in a single bus
+	sample. The components are ordered as specified by the order code, with
+	components on the left of the code transferred in the high order bits.
+	Common values are 8 and 16.
+	</listitem>
+      </itemizedlist>
+      </para>
+
+      <para>For instance, a format where pixels are encoded as 8-bit YUV values
+      downsampled to 4:2:2 and transferred as 2 8-bit bus samples per pixel in the
+      U, Y, V, Y order will be named <constant>V4L2_MBUS_FMT_UYVY8_2X8</constant>.
+      </para>
+
+      <para>The following table lisst existing packet YUV formats.</para>
+
+      <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-yuv8">
+	<title>YUV formats</title>
+	<tgroup cols="19">
+	  <colspec colname="id" align="left" />
+	  <colspec colname="code" align="center"/>
+	  <colspec colname="bit" />
+	  <colspec colnum="4" colname="b15" align="center" />
+	  <colspec colnum="5" colname="b14" align="center" />
+	  <colspec colnum="6" colname="b13" align="center" />
+	  <colspec colnum="7" colname="b12" align="center" />
+	  <colspec colnum="8" colname="b11" align="center" />
+	  <colspec colnum="9" colname="b10" align="center" />
+	  <colspec colnum="10" colname="b09" align="center" />
+	  <colspec colnum="11" colname="b08" align="center" />
+	  <colspec colnum="12" colname="b07" align="center" />
+	  <colspec colnum="13" colname="b06" align="center" />
+	  <colspec colnum="14" colname="b05" align="center" />
+	  <colspec colnum="15" colname="b04" align="center" />
+	  <colspec colnum="16" colname="b03" align="center" />
+	  <colspec colnum="17" colname="b02" align="center" />
+	  <colspec colnum="18" colname="b01" align="center" />
+	  <colspec colnum="19" colname="b00" align="center" />
+	  <spanspec namest="b15" nameend="b00" spanname="b0" />
+	  <thead>
+	    <row>
+	      <entry>Identifier</entry>
+	      <entry>Code</entry>
+	      <entry></entry>
+	      <entry spanname="b0">Data organization</entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>Bit</entry>
+	      <entry>15</entry>
+	      <entry>14</entry>
+	      <entry>13</entry>
+	      <entry>12</entry>
+	      <entry>11</entry>
+	      <entry>10</entry>
+	      <entry>9</entry>
+	      <entry>8</entry>
+	      <entry>7</entry>
+	      <entry>6</entry>
+	      <entry>5</entry>
+	      <entry>4</entry>
+	      <entry>3</entry>
+	      <entry>2</entry>
+	      <entry>1</entry>
+	      <entry>0</entry>
+	    </row>
+	  </thead>
+	  <tbody valign="top">
+	    <row id="V4L2-MBUS-FMT-GREY8-1X8">
+	      <entry>V4L2_MBUS_FMT_GREY8_1X8</entry>
+	      <entry>12</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-YUYV8-2X8">
+	      <entry>V4L2_MBUS_FMT_YUYV8_2X8</entry>
+	      <entry>2</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>u<subscript>7</subscript></entry>
+	      <entry>u<subscript>6</subscript></entry>
+	      <entry>u<subscript>5</subscript></entry>
+	      <entry>u<subscript>4</subscript></entry>
+	      <entry>u<subscript>3</subscript></entry>
+	      <entry>u<subscript>2</subscript></entry>
+	      <entry>u<subscript>1</subscript></entry>
+	      <entry>u<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>v<subscript>7</subscript></entry>
+	      <entry>v<subscript>6</subscript></entry>
+	      <entry>v<subscript>5</subscript></entry>
+	      <entry>v<subscript>4</subscript></entry>
+	      <entry>v<subscript>3</subscript></entry>
+	      <entry>v<subscript>2</subscript></entry>
+	      <entry>v<subscript>1</subscript></entry>
+	      <entry>v<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-UYVY8-2X8">
+	      <entry>V4L2_MBUS_FMT_UYVY8_2X8</entry>
+	      <entry>4</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>u<subscript>7</subscript></entry>
+	      <entry>u<subscript>6</subscript></entry>
+	      <entry>u<subscript>5</subscript></entry>
+	      <entry>u<subscript>4</subscript></entry>
+	      <entry>u<subscript>3</subscript></entry>
+	      <entry>u<subscript>2</subscript></entry>
+	      <entry>u<subscript>1</subscript></entry>
+	      <entry>u<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>v<subscript>7</subscript></entry>
+	      <entry>v<subscript>6</subscript></entry>
+	      <entry>v<subscript>5</subscript></entry>
+	      <entry>v<subscript>4</subscript></entry>
+	      <entry>v<subscript>3</subscript></entry>
+	      <entry>v<subscript>2</subscript></entry>
+	      <entry>v<subscript>1</subscript></entry>
+	      <entry>v<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-YVYU8-2X8">
+	      <entry>V4L2_MBUS_FMT_YVYU8_2X8</entry>
+	      <entry>3</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>v<subscript>7</subscript></entry>
+	      <entry>v<subscript>6</subscript></entry>
+	      <entry>v<subscript>5</subscript></entry>
+	      <entry>v<subscript>4</subscript></entry>
+	      <entry>v<subscript>3</subscript></entry>
+	      <entry>v<subscript>2</subscript></entry>
+	      <entry>v<subscript>1</subscript></entry>
+	      <entry>v<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>u<subscript>7</subscript></entry>
+	      <entry>u<subscript>6</subscript></entry>
+	      <entry>u<subscript>5</subscript></entry>
+	      <entry>u<subscript>4</subscript></entry>
+	      <entry>u<subscript>3</subscript></entry>
+	      <entry>u<subscript>2</subscript></entry>
+	      <entry>u<subscript>1</subscript></entry>
+	      <entry>u<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-VYUY8-2X8">
+	      <entry>V4L2_MBUS_FMT_VYUY8_2X8</entry>
+	      <entry>5</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>v<subscript>7</subscript></entry>
+	      <entry>v<subscript>6</subscript></entry>
+	      <entry>v<subscript>5</subscript></entry>
+	      <entry>v<subscript>4</subscript></entry>
+	      <entry>v<subscript>3</subscript></entry>
+	      <entry>v<subscript>2</subscript></entry>
+	      <entry>v<subscript>1</subscript></entry>
+	      <entry>v<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>u<subscript>7</subscript></entry>
+	      <entry>u<subscript>6</subscript></entry>
+	      <entry>u<subscript>5</subscript></entry>
+	      <entry>u<subscript>4</subscript></entry>
+	      <entry>u<subscript>3</subscript></entry>
+	      <entry>u<subscript>2</subscript></entry>
+	      <entry>u<subscript>1</subscript></entry>
+	      <entry>u<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-Y10-1X10">
+	      <entry>V4L2_MBUS_FMT_Y10_1X10</entry>
+	      <entry>13</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>y<subscript>9</subscript></entry>
+	      <entry>y<subscript>8</subscript></entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-YUYV8-1X16">
+	      <entry>V4L2_MBUS_FMT_YUYV8_1X16</entry>
+	      <entry>24</entry>
+	      <entry></entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	      <entry>u<subscript>7</subscript></entry>
+	      <entry>u<subscript>6</subscript></entry>
+	      <entry>u<subscript>5</subscript></entry>
+	      <entry>u<subscript>4</subscript></entry>
+	      <entry>u<subscript>3</subscript></entry>
+	      <entry>u<subscript>2</subscript></entry>
+	      <entry>u<subscript>1</subscript></entry>
+	      <entry>u<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	      <entry>v<subscript>7</subscript></entry>
+	      <entry>v<subscript>6</subscript></entry>
+	      <entry>v<subscript>5</subscript></entry>
+	      <entry>v<subscript>4</subscript></entry>
+	      <entry>v<subscript>3</subscript></entry>
+	      <entry>v<subscript>2</subscript></entry>
+	      <entry>v<subscript>1</subscript></entry>
+	      <entry>v<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-UYVY8-1X16">
+	      <entry>V4L2_MBUS_FMT_UYVY8_1X16</entry>
+	      <entry>25</entry>
+	      <entry></entry>
+	      <entry>u<subscript>7</subscript></entry>
+	      <entry>u<subscript>6</subscript></entry>
+	      <entry>u<subscript>5</subscript></entry>
+	      <entry>u<subscript>4</subscript></entry>
+	      <entry>u<subscript>3</subscript></entry>
+	      <entry>u<subscript>2</subscript></entry>
+	      <entry>u<subscript>1</subscript></entry>
+	      <entry>u<subscript>0</subscript></entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>v<subscript>7</subscript></entry>
+	      <entry>v<subscript>6</subscript></entry>
+	      <entry>v<subscript>5</subscript></entry>
+	      <entry>v<subscript>4</subscript></entry>
+	      <entry>v<subscript>3</subscript></entry>
+	      <entry>v<subscript>2</subscript></entry>
+	      <entry>v<subscript>1</subscript></entry>
+	      <entry>v<subscript>0</subscript></entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-YVYU8-1X16">
+	      <entry>V4L2_MBUS_FMT_YVYU8_1X16</entry>
+	      <entry>26</entry>
+	      <entry></entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	      <entry>v<subscript>7</subscript></entry>
+	      <entry>v<subscript>6</subscript></entry>
+	      <entry>v<subscript>5</subscript></entry>
+	      <entry>v<subscript>4</subscript></entry>
+	      <entry>v<subscript>3</subscript></entry>
+	      <entry>v<subscript>2</subscript></entry>
+	      <entry>v<subscript>1</subscript></entry>
+	      <entry>v<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	      <entry>u<subscript>7</subscript></entry>
+	      <entry>u<subscript>6</subscript></entry>
+	      <entry>u<subscript>5</subscript></entry>
+	      <entry>u<subscript>4</subscript></entry>
+	      <entry>u<subscript>3</subscript></entry>
+	      <entry>u<subscript>2</subscript></entry>
+	      <entry>u<subscript>1</subscript></entry>
+	      <entry>u<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-VYUY8-1X16">
+	      <entry>V4L2_MBUS_FMT_VYUY8_1X16</entry>
+	      <entry>27</entry>
+	      <entry></entry>
+	      <entry>v<subscript>7</subscript></entry>
+	      <entry>v<subscript>6</subscript></entry>
+	      <entry>v<subscript>5</subscript></entry>
+	      <entry>v<subscript>4</subscript></entry>
+	      <entry>v<subscript>3</subscript></entry>
+	      <entry>v<subscript>2</subscript></entry>
+	      <entry>v<subscript>1</subscript></entry>
+	      <entry>v<subscript>0</subscript></entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>u<subscript>7</subscript></entry>
+	      <entry>u<subscript>6</subscript></entry>
+	      <entry>u<subscript>5</subscript></entry>
+	      <entry>u<subscript>4</subscript></entry>
+	      <entry>u<subscript>3</subscript></entry>
+	      <entry>u<subscript>2</subscript></entry>
+	      <entry>u<subscript>1</subscript></entry>
+	      <entry>u<subscript>0</subscript></entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
+	  </tbody>
+	</tgroup>
+      </table>
+    </section>
+  </section>
+</section>
diff --git a/Documentation/DocBook/v4l/v4l2.xml b/Documentation/DocBook/v4l/v4l2.xml
index 7c3c098..3a59b82 100644
--- a/Documentation/DocBook/v4l/v4l2.xml
+++ b/Documentation/DocBook/v4l/v4l2.xml
@@ -402,6 +402,7 @@ and discussions on the V4L mailing list.</revremark>
     <section id="radio"> &sub-dev-radio; </section>
     <section id="rds"> &sub-dev-rds; </section>
     <section id="event"> &sub-dev-event; </section>
+    <section id="subdev"> &sub-dev-subdev; </section>
   </chapter>
 
   <chapter id="driver">
@@ -469,6 +470,9 @@ and discussions on the V4L mailing list.</revremark>
     &sub-reqbufs;
     &sub-s-hw-freq-seek;
     &sub-streamon;
+    &sub-subdev-enum-frame-size;
+    &sub-subdev-enum-mbus-code;
+    &sub-subdev-g-fmt;
     &sub-subscribe-event;
     <!-- End of ioctls. -->
     &sub-mmap;
diff --git a/Documentation/DocBook/v4l/vidioc-streamon.xml b/Documentation/DocBook/v4l/vidioc-streamon.xml
index e42bff1..75ed39b 100644
--- a/Documentation/DocBook/v4l/vidioc-streamon.xml
+++ b/Documentation/DocBook/v4l/vidioc-streamon.xml
@@ -93,6 +93,15 @@ synchronize with other events.</para>
 been allocated (memory mapping) or enqueued (output) yet.</para>
 	</listitem>
       </varlistentry>
+      <varlistentry>
+	<term><errorcode>EPIPE</errorcode></term>
+	<listitem>
+	  <para>The driver implements <link
+	  linkend="pad-level-formats">pad-level format configuration</link> and
+	  the pipeline configuration is invalid.
+	  </para>
+	</listitem>
+      </varlistentry>
     </variablelist>
   </refsect1>
 </refentry>
diff --git a/Documentation/DocBook/v4l/vidioc-subdev-enum-frame-size.xml b/Documentation/DocBook/v4l/vidioc-subdev-enum-frame-size.xml
new file mode 100644
index 0000000..0fc0d99
--- /dev/null
+++ b/Documentation/DocBook/v4l/vidioc-subdev-enum-frame-size.xml
@@ -0,0 +1,148 @@
+<refentry id="vidioc-subdev-enum-frame-size">
+  <refmeta>
+    <refentrytitle>ioctl VIDIOC_SUBDEV_ENUM_FRAME_SIZE</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>VIDIOC_SUBDEV_ENUM_FRAME_SIZE</refname>
+    <refpurpose>Enumerate media bus frame sizes</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct v4l2_subdev_frame_size_enum *
+	<parameter>argp</parameter></paramdef>
+      </funcprototype>
+    </funcsynopsis>
+  </refsynopsisdiv>
+
+  <refsect1>
+    <title>Arguments</title>
+
+    <variablelist>
+      <varlistentry>
+	<term><parameter>fd</parameter></term>
+	<listitem>
+	  <para>&fd;</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>VIDIOC_SUBDEV_ENUM_FRAME_SIZE</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>argp</parameter></term>
+	<listitem>
+	  <para></para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+    <para>This ioctl allows applications to enumerate all frame sizes
+    supported by a sub-device on the given pad for the given media bus format.
+    Supported formats can be retrieved with the &VIDIOC-SUBDEV-ENUM-MBUS-CODE;
+    ioctl.</para>
+
+    <para>To enumerate frame sizes applications initialize the
+    <structfield>pad</structfield>, <structfield>code</structfield> and
+    <structfield>index</structfield> fields of the
+    &v4l2-subdev-mbus-code-enum; and call the
+    <constant>VIDIOC_SUBDEV_ENUM_FRAME_SIZE</constant> ioctl with a pointer to
+    the structure. Drivers fill the minimum and maximum frame sizes or return
+    an &EINVAL; if one of the input parameters is invalid.</para>
+
+    <para>Sub-devices that only support discrete frame sizes (such as most
+    sensors) will return one or more frame sizes with identical minimum and
+    maximum values.</para>
+
+    <para>Not all possible sizes in given [minimum, maximum] ranges need to be
+    supported. For instance, a scaler that uses a fixed-point scaling ratio
+    might not be able to produce every frame size between the minimum and
+    maximum values. Applications must use the &VIDIOC-SUBDEV-S-FMT; ioctl to
+    probe the sub-device for an exact supported frame size.</para>
+
+    <para>Available frame sizes may depend on the current probe formats at other
+    pads of the sub-device, as well as on the current active links and the
+    current values of V4L2 controls. See &VIDIOC-SUBDEV-G-FMT; for more
+    information about probe formats.</para>
+
+    <table pgwide="1" frame="none" id="v4l2-subdev-frame-size-enum">
+      <title>struct <structname>v4l2_subdev_frame_size_enum</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>index</structfield></entry>
+	    <entry>Number of the format in the enumeration, set by the
+	    application.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>pad</structfield></entry>
+	    <entry>Pad number as reported by the media controller API.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>code</structfield></entry>
+	    <entry>The media bus format code, as defined in
+	    <xref linkend="v4l2-mbus-format" />.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>min_width</structfield></entry>
+	    <entry>Minimum frame width, in pixels.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>max_width</structfield></entry>
+	    <entry>Maximum frame width, in pixels.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>min_height</structfield></entry>
+	    <entry>Minimum frame height, in pixels.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>max_height</structfield></entry>
+	    <entry>Maximum frame height, in pixels.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[9]</entry>
+	    <entry>Reserved for future extensions. Applications and drivers must
+	    set the array to zero.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+  </refsect1>
+
+  <refsect1>
+    &return-value;
+
+    <variablelist>
+      <varlistentry>
+	<term><errorcode>EINVAL</errorcode></term>
+	<listitem>
+	  <para>The &v4l2-subdev-frame-size-enum; <structfield>pad</structfield>
+	  references a non-existing pad, the <structfield>code</structfield> is
+	  invalid for the given pad or the <structfield>index</structfield>
+	  field is out of bounds.</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+</refentry>
diff --git a/Documentation/DocBook/v4l/vidioc-subdev-enum-mbus-code.xml b/Documentation/DocBook/v4l/vidioc-subdev-enum-mbus-code.xml
new file mode 100644
index 0000000..f8bfa5f
--- /dev/null
+++ b/Documentation/DocBook/v4l/vidioc-subdev-enum-mbus-code.xml
@@ -0,0 +1,113 @@
+<refentry id="vidioc-subdev-enum-mbus-code">
+  <refmeta>
+    <refentrytitle>ioctl VIDIOC_SUBDEV_ENUM_MBUS_CODE</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>VIDIOC_SUBDEV_ENUM_MBUS_CODE</refname>
+    <refpurpose>Enumerate media bus formats</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct v4l2_subdev_mbus_code_enum *
+	<parameter>argp</parameter></paramdef>
+      </funcprototype>
+    </funcsynopsis>
+  </refsynopsisdiv>
+
+  <refsect1>
+    <title>Arguments</title>
+
+    <variablelist>
+      <varlistentry>
+	<term><parameter>fd</parameter></term>
+	<listitem>
+	  <para>&fd;</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>VIDIOC_SUBDEV_ENUM_MBUS_CODE</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>argp</parameter></term>
+	<listitem>
+	  <para></para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+    <para>To enumerate media bus formats available at a given sub-device pad
+    applications initialize the <structfield>pad</structfield> and
+    <structfield>index</structfield> fields of &v4l2-subdev-mbus-code-enum; and
+    call the <constant>VIDIOC_SUBDEV_ENUM_MBUS_CODE</constant> ioctl with a
+    pointer to this structure. Drivers fill the rest of the structure or return
+    an &EINVAL; if either the <structfield>pad</structfield> or
+    <structfield>index</structfield> are invalid. All media bus formats are
+    enumerable by beginning at index zero and incrementing by one until
+    <errorcode>EINVAL</errorcode> is returned.</para>
+
+    <para>Available media bus formats may depend on the current probe formats
+    at other pads of the sub-device, as well as on the current active links. See
+    &VIDIOC-SUBDEV-G-FMT; for more information about the probe formats.</para>
+
+    <table pgwide="1" frame="none" id="v4l2-subdev-mbus-code-enum">
+      <title>struct <structname>v4l2_subdev_mbus_code_enum</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>pad</structfield></entry>
+	    <entry>Pad number as reported by the media controller API.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>index</structfield></entry>
+	    <entry>Number of the format in the enumeration, set by the
+	    application.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>code</structfield></entry>
+	    <entry>The media bus format code, as defined in
+	    <xref linkend="v4l2-mbus-format" />.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[5]</entry>
+	    <entry>Reserved for future extensions. Applications and drivers must
+	    set the array to zero.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+  </refsect1>
+
+  <refsect1>
+    &return-value;
+
+    <variablelist>
+      <varlistentry>
+	<term><errorcode>EINVAL</errorcode></term>
+	<listitem>
+	  <para>The &v4l2-subdev-mbus-code-enum; <structfield>pad</structfield>
+	  references a non-existing pad, or the <structfield>index</structfield>
+	  field is out of bounds.</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+</refentry>
diff --git a/Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml b/Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml
new file mode 100644
index 0000000..32efbed
--- /dev/null
+++ b/Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml
@@ -0,0 +1,168 @@
+<refentry id="vidioc-subdev-g-fmt">
+  <refmeta>
+    <refentrytitle>ioctl VIDIOC_SUBDEV_G_FMT, VIDIOC_SUBDEV_S_FMT</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>VIDIOC_SUBDEV_G_FMT</refname>
+    <refname>VIDIOC_SUBDEV_S_FMT</refname>
+    <refpurpose>Get or set the data format on a subdev pad</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct v4l2_subdev_format *<parameter>argp</parameter>
+	</paramdef>
+      </funcprototype>
+    </funcsynopsis>
+  </refsynopsisdiv>
+
+  <refsect1>
+    <title>Arguments</title>
+
+    <variablelist>
+      <varlistentry>
+	<term><parameter>fd</parameter></term>
+	<listitem>
+	  <para>&fd;</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>VIDIOC_SUBDEV_G_FMT, VIDIOC_SUBDEV_S_FMT</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>argp</parameter></term>
+	<listitem>
+	  <para></para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+    <para>These ioctls are used to negotiate the frame format at specific
+    subdev pads in the image pipeline.</para>
+
+    <para>To retrieve the current format applications set the
+    <structfield>pad</structfield> field of a &v4l2-subdev-format; to the
+    desired pad number as reported by the media API and the
+    <structfield>which</structfield> field to
+    <constant>V4L2_SUBDEV_FORMAT_ACTIVE</constant>. When they call the
+    <constant>VIDIOC_SUBDEV_G_FMT</constant> ioctl with a pointer to this
+    structure the driver fills the members of the <structfield>format</structfield>
+    field.</para>
+
+    <para>To change the current format applications set both the
+    <structfield>pad</structfield> and <structfield>which</structfield> fields
+    and all members of the <structfield>format</structfield> field. When they
+    call the <constant>VIDIOC_SUBDEV_S_FMT</constant> ioctl with a pointer to this
+    structure the driver verifies the requested format, adjusts it based on the
+    hardware capabilities and configures the device. Upon return the
+    &v4l2-subdev-format; contains the current format as would be returned by a
+    <constant>VIDIOC_SUBDEV_G_FMT</constant> call.</para>
+
+    <para>Applications can probe the device capabilities by setting the
+    <structfield>which</structfield> to
+    <constant>V4L2_SUBDEV_FORMAT_PROBE</constant>. When set, probe formats are
+    not applied to the device by the driver, but are mangled exactly as active
+    formats and stored in the sub-device file handle. Two applications probing
+    the same sub-device would thus not interact with each other.</para>
+
+    <para>For instance, to try a format at the output pad of a sub-device,
+    applications would first set the probe format at the sub-device input with
+    the <constant>VIDIOC_SUBDEV_S_FMT</constant> ioctl. They would then either
+    retrieve the default format at the output pad with the
+    <constant>VIDIOC_SUBDEV_G_FMT</constant> ioctl, or set the desired output
+    pad format with the <constant>VIDIOC_SUBDEV_S_FMT</constant> ioctl and check
+    the returned value.</para>
+
+    <para>Probe formats do not depend on active formats, but can depend on the
+    current links configuration or sub-device controls value. For instance, a
+    low-pass noise filter might crop pixels at the frame boundaries, modifying
+    its output frame size.</para>
+
+    <para>Drivers must not return an error solely because the requested format
+    doesn't match the device capabilities. They must instead modify the format
+    to match what the hardware can provide. The modified format should be as
+    close as possible to the original request.</para>
+
+    <table pgwide="1" frame="none" id="v4l2-subdev-format">
+      <title>struct <structname>v4l2_subdev_format</structname></title>
+      <tgroup cols="3">
+        &cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>pad</structfield></entry>
+	    <entry>Pad number as reported by the media controller API.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>which</structfield></entry>
+	    <entry>Format to modified, from &v4l2-subdev-format-whence;.</entry>
+	  </row>
+	  <row>
+	    <entry>&v4l2-mbus-framefmt;</entry>
+	    <entry><structfield>format</structfield></entry>
+	    <entry>Definition of an image format, see <xref
+	    linkend="v4l2-mbus-framefmt" /> for details.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="v4l2-subdev-format-whence">
+      <title>enum <structname>v4l2_subdev_format_whence</structname></title>
+      <tgroup cols="3">
+        &cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry>V4L2_SUBDEV_FORMAT_PROBE</entry>
+	    <entry>0</entry>
+	    <entry>Probe formats, used for probing device capabilities.</entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_SUBDEV_FORMAT_ACTIVE</entry>
+	    <entry>1</entry>
+	    <entry>Active formats, applied to the hardware.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+  </refsect1>
+
+  <refsect1>
+    &return-value;
+
+    <variablelist>
+      <varlistentry>
+	<term><errorcode>EBUSY</errorcode></term>
+	<listitem>
+	  <para>The format can't be changed because the pad is currently busy.
+	  This can be caused, for instance, by an active video stream on the
+	  pad. The ioctl must not be retried without performing another action
+	  to fix the problem first. Only returned by
+	  <constant>VIDIOC_SUBDEV_S_FMT</constant></para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><errorcode>EINVAL</errorcode></term>
+	<listitem>
+	  <para>The &v4l2-subdev-format; <structfield>pad</structfield>
+	  references a non-existing pad, or the <structfield>which</structfield>
+	  field references a non-existing format.</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+</refentry>
diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index d2891c1..380d2f2 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -133,6 +133,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	struct video_device *vdev = video_devdata(file);
 	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
 	struct v4l2_fh *vfh = file->private_data;
+	struct v4l2_subdev_fh *subdev_fh = to_v4l2_subdev_fh(vfh);
 
 	switch (cmd) {
 	case VIDIOC_QUERYCTRL:
@@ -168,6 +169,56 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	case VIDIOC_UNSUBSCRIBE_EVENT:
 		return v4l2_subdev_call(sd, core, unsubscribe_event, vfh, arg);
 
+	case VIDIOC_SUBDEV_G_FMT: {
+		struct v4l2_subdev_format *format = arg;
+
+		if (format->which != V4L2_SUBDEV_FORMAT_PROBE &&
+		    format->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+			return -EINVAL;
+
+		if (format->pad >= sd->entity.num_pads)
+			return -EINVAL;
+
+		return v4l2_subdev_call(sd, pad, get_fmt, subdev_fh,
+					format->pad, &format->format,
+					format->which);
+	}
+
+	case VIDIOC_SUBDEV_S_FMT: {
+		struct v4l2_subdev_format *format = arg;
+
+		if (format->which != V4L2_SUBDEV_FORMAT_PROBE &&
+		    format->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+			return -EINVAL;
+
+		if (format->pad >= sd->entity.num_pads)
+			return -EINVAL;
+
+		return v4l2_subdev_call(sd, pad, set_fmt, subdev_fh,
+					format->pad, &format->format,
+					format->which);
+	}
+
+	case VIDIOC_SUBDEV_ENUM_MBUS_CODE: {
+		struct v4l2_subdev_mbus_code_enum *code = arg;
+
+		if (code->pad >= sd->entity.num_pads)
+			return -EINVAL;
+
+		return v4l2_subdev_call(sd, pad, enum_mbus_code, subdev_fh,
+					code);
+	}
+
+	case VIDIOC_SUBDEV_ENUM_FRAME_SIZE: {
+		struct v4l2_subdev_frame_size_enum *fse = arg;
+
+		if (fse->pad >= sd->entity.num_pads)
+			return -EINVAL;
+
+		return v4l2_subdev_call(sd, pad, enum_frame_size, subdev_fh,
+					fse);
+	}
+
 	default:
 		return -ENOIOCTLCMD;
 	}
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 38127c2..c0cc1c3 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -370,6 +370,7 @@ header-y += usbdevice_fs.h
 header-y += utime.h
 header-y += utsname.h
 header-y += v4l2-mediabus.h
+header-y += v4l2-subdev.h
 header-y += veth.h
 header-y += vhost.h
 header-y += videodev.h
diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
new file mode 100644
index 0000000..623d063
--- /dev/null
+++ b/include/linux/v4l2-subdev.h
@@ -0,0 +1,90 @@
+/*
+ * V4L2 subdev userspace API
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef __LINUX_V4L2_SUBDEV_H
+#define __LINUX_V4L2_SUBDEV_H
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+#include <linux/v4l2-mediabus.h>
+
+/**
+ * enum v4l2_subdev_format_whence - Media bus format type
+ * @V4L2_SUBDEV_FORMAT_PROBE: probe format, for negotiation only
+ * @V4L2_SUBDEV_FORMAT_ACTIVE: active format, applied to the device
+ */
+enum v4l2_subdev_format_whence {
+	V4L2_SUBDEV_FORMAT_PROBE = 0,
+	V4L2_SUBDEV_FORMAT_ACTIVE = 1,
+};
+
+/**
+ * struct v4l2_subdev_format - Pad-level media bus format
+ * @which: format type (from enum v4l2_subdev_format_whence)
+ * @pad: pad number, as reported by the media API
+ * @format: media bus format (format code and frame size)
+ */
+struct v4l2_subdev_format {
+	__u32 which;
+	__u32 pad;
+	struct v4l2_mbus_framefmt format;
+	__u32 reserved[9];
+};
+
+/**
+ * struct v4l2_subdev_mbus_code_enum - Media bus format enumeration
+ * @pad: pad number, as reported by the media API
+ * @index: format index during enumeration
+ * @code: format code (from enum v4l2_mbus_pixelcode)
+ */
+struct v4l2_subdev_mbus_code_enum {
+	__u32 pad;
+	__u32 index;
+	__u32 code;
+	__u32 reserved[5];
+};
+
+/**
+ * struct v4l2_subdev_frame_size_enum - Media bus format enumeration
+ * @pad: pad number, as reported by the media API
+ * @index: format index during enumeration
+ * @code: format code (from enum v4l2_mbus_pixelcode)
+ */
+struct v4l2_subdev_frame_size_enum {
+	__u32 index;
+	__u32 pad;
+	__u32 code;
+	__u32 min_width;
+	__u32 max_width;
+	__u32 min_height;
+	__u32 max_height;
+	__u32 reserved[9];
+};
+
+#define VIDIOC_SUBDEV_G_FMT	_IOWR('V',  4, struct v4l2_subdev_format)
+#define VIDIOC_SUBDEV_S_FMT	_IOWR('V',  5, struct v4l2_subdev_format)
+#define VIDIOC_SUBDEV_ENUM_MBUS_CODE \
+			_IOWR('V',  2, struct v4l2_subdev_mbus_code_enum)
+#define VIDIOC_SUBDEV_ENUM_FRAME_SIZE \
+			_IOWR('V', 74, struct v4l2_subdev_frame_size_enum)
+
+#endif
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 8a278c2..bbbe4bf 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -21,6 +21,7 @@
 #ifndef _V4L2_SUBDEV_H
 #define _V4L2_SUBDEV_H
 
+#include <linux/v4l2-subdev.h>
 #include <media/media-entity.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
@@ -419,12 +420,12 @@ struct v4l2_subdev_ir_ops {
 				struct v4l2_subdev_ir_parameters *params);
 };
 
-enum v4l2_subdev_format_whence {
-	V4L2_SUBDEV_FORMAT_PROBE = 0,
-	V4L2_SUBDEV_FORMAT_ACTIVE = 1,
-};
-
 struct v4l2_subdev_pad_ops {
+	int (*enum_mbus_code)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_mbus_code_enum *code);
+	int (*enum_frame_size)(struct v4l2_subdev *sd,
+			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_frame_size_enum *fse);
 	int (*get_fmt)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 		       unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 		       enum v4l2_subdev_format_whence which);
-- 
1.7.2.2

