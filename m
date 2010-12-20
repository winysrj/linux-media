Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51308 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab0LTLhm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 06:37:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v5 11/13] v4l: v4l2_subdev userspace format API
Date: Mon, 20 Dec 2010 12:37:23 +0100
Message-Id: <1292845045-7945-12-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1292845045-7945-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1292845045-7945-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Add a userspace API to get, set and enumerate the media format on a
subdev pad.

The format at the output of a subdev usually depends on the format at
its input(s). The try format operation is thus not suitable for probing
format at individual pads, as it can't modify the device state and thus
can't remember the format tried at the input to compute the output
format.

To fix the problem, pass an extra argument to the get/set format
operations to select the 'try' or 'active' format.

The try format is used when probing the subdev. Setting the try format
must not change the device configuration but can store data for later
reuse. Data storage is provided at the file-handle level so applications
probing the subdev concurently won't interfere with each other.

The active format is used when configuring the subdev. It's identical to
the format handled by the usual get/set operations.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 Documentation/DocBook/Makefile                     |    5 +-
 Documentation/DocBook/media-entities.tmpl          |   16 +
 Documentation/DocBook/v4l/dev-subdev.xml           |  274 +++
 Documentation/DocBook/v4l/subdev-formats.xml       | 2410 ++++++++++++++++++++
 Documentation/DocBook/v4l/v4l2.xml                 |    4 +
 Documentation/DocBook/v4l/vidioc-streamon.xml      |    9 +
 .../DocBook/v4l/vidioc-subdev-enum-frame-size.xml  |  148 ++
 .../DocBook/v4l/vidioc-subdev-enum-mbus-code.xml   |  113 +
 Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml  |  168 ++
 drivers/media/video/v4l2-subdev.c                  |   49 +
 include/linux/Kbuild                               |    1 +
 include/linux/v4l2-subdev.h                        |   90 +
 include/media/v4l2-subdev.h                        |   10 +
 13 files changed, 3296 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/DocBook/v4l/dev-subdev.xml
 create mode 100644 Documentation/DocBook/v4l/subdev-formats.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-enum-frame-size.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-enum-mbus-code.xml
 create mode 100644 Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml
 create mode 100644 include/linux/v4l2-subdev.h

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 8b6e00a..2deb069 100644
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
index 679c585..538f8fe 100644
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
@@ -313,6 +325,10 @@
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
diff --git a/Documentation/DocBook/v4l/dev-subdev.xml b/Documentation/DocBook/v4l/dev-subdev.xml
new file mode 100644
index 0000000..12fdca4
--- /dev/null
+++ b/Documentation/DocBook/v4l/dev-subdev.xml
@@ -0,0 +1,274 @@
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
+  <filename>/dev/v4l-subdev*</filename>, use major number 81.</para>
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
+    <para>Depending on the driver, those controls might also be exposed through
+    one (or several) V4L2 device nodes.</para>
+  </section>
+
+  <section>
+    <title>Events</title>
+    <para>V4L2 sub-devices can notify applications of events as described in
+    <xref linkend="event" />. The API behaves identically as when used on V4L2
+    device nodes, with the exception that it only deals with events generated by
+    the sub-device. Depending on the driver, those events might also be reported
+    on one (or several) V4L2 device nodes.</para>
+  </section>
+
+  <section id="pad-level-formats">
+    <title>Pad-level Formats</title>
+
+    <warning>Pad-level formats are only applicable to very complex device that
+    need to expose low-level format configuration to user space. Generic V4L2
+    applications do <emphasis>not</emphasis> need to use the API described in
+    this section.</warning>
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
+      <title>Image Format Negotation on Pipelines</title>
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
+    <para>The sensor scaler is usually of less quality than the host scaler, but
+    scaling on the sensor is required to achieve higher frame rates. Depending
+    on the use case (quality vs. speed), the pipeline must be configured
+    differently. Applications need to configure the formats at every point in
+    the pipeline explicitly.</para>
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
+    <para>Pad-level image format configuration support can be tested by calling
+    the &VIDIOC-SUBDEV-G-FMT; ioctl on pad 0. If the driver returns an &EINVAL;
+    pad-level format configuration is not supported by the sub-device.</para>
+
+    <section>
+      <title>Format Negotiation</title>
+
+      <para>Acceptable formats on pads can (and usually do) depend on a number
+      of external parameters, such as formats on other pads, active links, or
+      even controls. Finding a combination of formats on all pads in a video
+      pipeline, acceptable to both application and driver, can't rely on formats
+      enumeration only. A format negotiation mechanism is required.</para>
+
+      <para>Central to the format negotiation mechanism are the get/set format
+      operations. When called with the <structfield>which</structfield> argument
+      set to <constant>V4L2_SUBDEV_FORMAT_TRY</constant>, the
+      &VIDIOC-SUBDEV-G-FMT; and &VIDIOC-SUBDEV-S-FMT; ioctls operate on a set of
+      formats parameters that are not connected to the hardware configuration.
+      Modifying those 'try' formats leaves the device state untouched (this
+      applies to both the software state stored in the driver and the hardware
+      state stored in the device itself).</para>
+
+      <para>While not kept as part of the device state, try formats are stored
+      in the sub-device file handles. A &VIDIOC-SUBDEV-G-FMT; call will return
+      the last try format set <emphasis>on the same sub-device file
+      handle</emphasis>. Several applications querying the same sub-device at
+      the same time will thus not interact with each other.</para>
+
+      <para>To find out whether a particular format is supported by the device,
+      applications use the &VIDIOC-SUBDEV-S-FMT; ioctl. Drivers verify and, if
+      needed, change the requested <structfield>format</structfield> based on
+      device requirements and return the possibly modified value. Applications
+      can then choose to try a different format or accept the returned value and
+      continue.</para>
+
+      <para>Formats returned by the driver during a negotiation iteration are
+      guaranteed to be supported by the device. In particular, drivers guarantee
+      that a returned format will not be further changed if passed to an
+      &VIDIOC-SUBDEV-S-FMT; call as-is (as long as external parameters, such as
+      formats on other pads or links' configuration are not changed).</para>
+
+      <para>Drivers automatically propagate formats inside sub-devices. When a
+      try or active format is set on a pad, corresponding formats on other pads
+      of the same sub-device can be modified by the driver. Drivers are free to
+      modify formats as required by the device. However, they should comply with
+      the following rules when possible:
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
+	<title>Sample Pipeline Configuration</title>
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
+      <para>When satisfied with the try results, applications can set the active
+      formats by setting the <structfield>which</structfield> argument to
+      <constant>V4L2_SUBDEV_FORMAT_TRY</constant>. Active formats are changed
+      exactly as try formats by drivers. To avoid modifying the hardware state
+      during format negotiation, applications should negotiate try formats first
+      and then modify the active settings using the try formats returned during
+      the last negotiation iteration. This guarantees that the active format
+      will be applied as-is by the driver without being modified.
+      </para>
+    </section>
+
+  </section>
+
+  &sub-subdev-formats;
diff --git a/Documentation/DocBook/v4l/subdev-formats.xml b/Documentation/DocBook/v4l/subdev-formats.xml
new file mode 100644
index 0000000..3688f27
--- /dev/null
+++ b/Documentation/DocBook/v4l/subdev-formats.xml
@@ -0,0 +1,2410 @@
+<section id="v4l2-mbus-format">
+  <title>Media Bus Formats</title>
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
+	  <entry>Format code, from &v4l2-mbus-pixelcode;.</entry>
+	</row>
+	<row>
+	  <entry>__u32</entry>
+	  <entry><structfield>field</structfield></entry>
+	  <entry>Field order, from &v4l2-field;. See
+	  <xref linkend="field-order" /> for details.</entry>
+	</row>
+	<row>
+	  <entry>__u32</entry>
+	  <entry><structfield>colorspace</structfield></entry>
+	  <entry>Image colorspace, from &v4l2-colorspace;. See
+	  <xref linkend="colorspaces" /> for details.</entry>
+	</row>
+      </tbody>
+    </tgroup>
+  </table>
+
+  <section id="v4l2-mbus-pixelcode">
+    <title>Media Bus Pixel Codes</title>
+
+    <para>The media bus pixel codes describe image formats as flowing over
+    physical busses (both between separate physical components and inside SoC
+    devices). This should not be confused with the V4L2 pixel formats that
+    describe, using four character codes, image formats as stored in memory.
+    </para>
+
+    <para>While there is a relationship between image formats on busses and
+    image formats in memory (a raw Bayer image won't be magically converted to
+    JPEG just by storing it to memory), there is no one-to-one correspondance
+    between them.</para>
+
+    <section>
+      <title>Packed RGB Formats</title>
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
+	    <row id="V4L2-MBUS-FMT-RGB444-2X8-PADHI-BE">
+	      <entry>V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE</entry>
+	      <entry>0x1001</entry>
+	      <entry></entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-RGB444-2X8-PADHI-LE">
+	      <entry>V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE</entry>
+	      <entry>0x1002</entry>
+	      <entry></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
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
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-RGB555-2X8-PADHI-BE">
+	      <entry>V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE</entry>
+	      <entry>0x1003</entry>
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
+	      <entry>0x1004</entry>
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
+	    <row id="V4L2-MBUS-FMT-BGR565-2X8-BE">
+	      <entry>V4L2_MBUS_FMT_BGR565_2X8_BE</entry>
+	      <entry>0x1005</entry>
+	      <entry></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
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
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-BGR565-2X8-LE">
+	      <entry>V4L2_MBUS_FMT_BGR565_2X8_LE</entry>
+	      <entry>0x1006</entry>
+	      <entry></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-RGB565-2X8-BE">
+	      <entry>V4L2_MBUS_FMT_RGB565_2X8_BE</entry>
+	      <entry>0x1007</entry>
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
+	      <entry>0x1008</entry>
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
+      <title>Bayer Formats</title>
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
+	<title>Bayer Patterns</title>
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
+	<title>Bayer Formats</title>
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
+	      <entry>0x3001</entry>
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
+	    <row id="V4L2-MBUS-FMT-SGRBG8-1X8">
+	      <entry>V4L2_MBUS_FMT_SGRBG8_1X8</entry>
+	      <entry>0x3002</entry>
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
+	    <row id="V4L2-MBUS-FMT-SBGGR10-DPCM8-1X8">
+	      <entry>V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8</entry>
+	      <entry>0x300b</entry>
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
+	    <row id="V4L2-MBUS-FMT-SGBRG10-DPCM8-1X8">
+	      <entry>V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8</entry>
+	      <entry>0x300c</entry>
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
+	      <entry>0x3009</entry>
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
+	    <row id="V4L2-MBUS-FMT-SRGGB10-DPCM8-1X8">
+	      <entry>V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8</entry>
+	      <entry>0x300d</entry>
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
+	    <row id="V4L2-MBUS-FMT-SBGGR10-2X8-PADHI-BE">
+	      <entry>V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE</entry>
+	      <entry>0x3003</entry>
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
+	      <entry>0x3004</entry>
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
+	      <entry>0x3005</entry>
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
+	      <entry>0x3006</entry>
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
+	      <entry>0x3007</entry>
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
+	    <row id="V4L2-MBUS-FMT-SGBRG10-1X10">
+	      <entry>V4L2_MBUS_FMT_SGBRG10_1X10</entry>
+	      <entry>0x300e</entry>
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
+	    <row id="V4L2-MBUS-FMT-SGRBG10-1X10">
+	      <entry>V4L2_MBUS_FMT_SGRBG10_1X10</entry>
+	      <entry>0x300a</entry>
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
+	    <row id="V4L2-MBUS-FMT-SRGGB10-1X10">
+	      <entry>V4L2_MBUS_FMT_SRGGB10_1X10</entry>
+	      <entry>0x300f</entry>
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
+	    <row id="V4L2-MBUS-FMT-SBGGR12-1X12">
+	      <entry>V4L2_MBUS_FMT_SBGGR12_1X12</entry>
+	      <entry>0x3008</entry>
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
+	  </tbody>
+	</tgroup>
+      </table>
+    </section>
+
+    <section>
+      <title>Packed YUV Formats</title>
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
+	<title>YUV Formats</title>
+	<tgroup cols="23">
+	  <colspec colname="id" align="left" />
+	  <colspec colname="code" align="center"/>
+	  <colspec colname="bit" />
+	  <colspec colnum="4" colname="b19" align="center" />
+	  <colspec colnum="5" colname="b18" align="center" />
+	  <colspec colnum="6" colname="b17" align="center" />
+	  <colspec colnum="7" colname="b16" align="center" />
+	  <colspec colnum="8" colname="b15" align="center" />
+	  <colspec colnum="9" colname="b14" align="center" />
+	  <colspec colnum="10" colname="b13" align="center" />
+	  <colspec colnum="11" colname="b12" align="center" />
+	  <colspec colnum="12" colname="b11" align="center" />
+	  <colspec colnum="13" colname="b10" align="center" />
+	  <colspec colnum="14" colname="b09" align="center" />
+	  <colspec colnum="15" colname="b08" align="center" />
+	  <colspec colnum="16" colname="b07" align="center" />
+	  <colspec colnum="17" colname="b06" align="center" />
+	  <colspec colnum="18" colname="b05" align="center" />
+	  <colspec colnum="19" colname="b04" align="center" />
+	  <colspec colnum="20" colname="b03" align="center" />
+	  <colspec colnum="21" colname="b02" align="center" />
+	  <colspec colnum="22" colname="b01" align="center" />
+	  <colspec colnum="23" colname="b00" align="center" />
+	  <spanspec namest="b19" nameend="b00" spanname="b0" />
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
+	      <entry>19</entry>
+	      <entry>18</entry>
+	      <entry>17</entry>
+	      <entry>16</entry>
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
+	    <row id="V4L2-MBUS-FMT-Y8-1X8">
+	      <entry>V4L2_MBUS_FMT_Y8_1X8</entry>
+	      <entry>0x2001</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
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
+	    <row id="V4L2-MBUS-FMT-UYVY8-1_5X8">
+	      <entry>V4L2_MBUS_FMT_UYVY8_1_5X8</entry>
+	      <entry>0x2002</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
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
+	    <row id="V4L2-MBUS-FMT-VYUY8-1_5X8">
+	      <entry>V4L2_MBUS_FMT_VYUY8_1_5X8</entry>
+	      <entry>0x2003</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
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
+	    <row id="V4L2-MBUS-FMT-YUYV8-1_5X8">
+	      <entry>V4L2_MBUS_FMT_YUYV8_1_5X8</entry>
+	      <entry>0x2004</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
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
+	    <row id="V4L2-MBUS-FMT-YVYU8-1_5X8">
+	      <entry>V4L2_MBUS_FMT_YVYU8_1_5X8</entry>
+	      <entry>0x2005</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
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
+	    <row id="V4L2-MBUS-FMT-UYVY8-2X8">
+	      <entry>V4L2_MBUS_FMT_UYVY8_2X8</entry>
+	      <entry>0x2006</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
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
+	    <row id="V4L2-MBUS-FMT-VYUY8-2X8">
+	      <entry>V4L2_MBUS_FMT_VYUY8_2X8</entry>
+	      <entry>0x2007</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
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
+	      <entry>0x2008</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
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
+	    <row id="V4L2-MBUS-FMT-YVYU8-2X8">
+	      <entry>V4L2_MBUS_FMT_YVYU8_2X8</entry>
+	      <entry>0x2009</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
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
+	    <row id="V4L2-MBUS-FMT-Y10-1X10">
+	      <entry>V4L2_MBUS_FMT_Y10_1X10</entry>
+	      <entry>0x200a</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
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
+	    <row id="V4L2-MBUS-FMT-YUYV10-2X10">
+	      <entry>V4L2_MBUS_FMT_YUYV10_2X10</entry>
+	      <entry>0x200b</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
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
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>u<subscript>9</subscript></entry>
+	      <entry>u<subscript>8</subscript></entry>
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
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>v<subscript>9</subscript></entry>
+	      <entry>v<subscript>8</subscript></entry>
+	      <entry>v<subscript>7</subscript></entry>
+	      <entry>v<subscript>6</subscript></entry>
+	      <entry>v<subscript>5</subscript></entry>
+	      <entry>v<subscript>4</subscript></entry>
+	      <entry>v<subscript>3</subscript></entry>
+	      <entry>v<subscript>2</subscript></entry>
+	      <entry>v<subscript>1</subscript></entry>
+	      <entry>v<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-YVYU10-2X10">
+	      <entry>V4L2_MBUS_FMT_YVYU10_2X10</entry>
+	      <entry>0x200c</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
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
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>v<subscript>9</subscript></entry>
+	      <entry>v<subscript>8</subscript></entry>
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
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>u<subscript>9</subscript></entry>
+	      <entry>u<subscript>8</subscript></entry>
+	      <entry>u<subscript>7</subscript></entry>
+	      <entry>u<subscript>6</subscript></entry>
+	      <entry>u<subscript>5</subscript></entry>
+	      <entry>u<subscript>4</subscript></entry>
+	      <entry>u<subscript>3</subscript></entry>
+	      <entry>u<subscript>2</subscript></entry>
+	      <entry>u<subscript>1</subscript></entry>
+	      <entry>u<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-UYVY8-1X16">
+	      <entry>V4L2_MBUS_FMT_UYVY8_1X16</entry>
+	      <entry>0x200f</entry>
+	      <entry></entry>
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
+	    <row id="V4L2-MBUS-FMT-VYUY8-1X16">
+	      <entry>V4L2_MBUS_FMT_VYUY8_1X16</entry>
+	      <entry>0x2010</entry>
+	      <entry></entry>
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
+	    <row id="V4L2-MBUS-FMT-YUYV8-1X16">
+	      <entry>V4L2_MBUS_FMT_YUYV8_1X16</entry>
+	      <entry>0x2011</entry>
+	      <entry></entry>
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
+	    <row id="V4L2-MBUS-FMT-YVYU8-1X16">
+	      <entry>V4L2_MBUS_FMT_YVYU8_1X16</entry>
+	      <entry>0x2012</entry>
+	      <entry></entry>
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
+	    <row id="V4L2-MBUS-FMT-YUYV10-1X20">
+	      <entry>V4L2_MBUS_FMT_YUYV10_1X20</entry>
+	      <entry>0x200d</entry>
+	      <entry></entry>
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
+	      <entry>u<subscript>9</subscript></entry>
+	      <entry>u<subscript>8</subscript></entry>
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
+	      <entry>v<subscript>9</subscript></entry>
+	      <entry>v<subscript>8</subscript></entry>
+	      <entry>v<subscript>7</subscript></entry>
+	      <entry>v<subscript>6</subscript></entry>
+	      <entry>v<subscript>5</subscript></entry>
+	      <entry>v<subscript>4</subscript></entry>
+	      <entry>v<subscript>3</subscript></entry>
+	      <entry>v<subscript>2</subscript></entry>
+	      <entry>v<subscript>1</subscript></entry>
+	      <entry>v<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-YVYU10-1X20">
+	      <entry>V4L2_MBUS_FMT_YVYU10_1X20</entry>
+	      <entry>0x200e</entry>
+	      <entry></entry>
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
+	      <entry>v<subscript>9</subscript></entry>
+	      <entry>v<subscript>8</subscript></entry>
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
+	      <entry>u<subscript>9</subscript></entry>
+	      <entry>u<subscript>8</subscript></entry>
+	      <entry>u<subscript>7</subscript></entry>
+	      <entry>u<subscript>6</subscript></entry>
+	      <entry>u<subscript>5</subscript></entry>
+	      <entry>u<subscript>4</subscript></entry>
+	      <entry>u<subscript>3</subscript></entry>
+	      <entry>u<subscript>2</subscript></entry>
+	      <entry>u<subscript>1</subscript></entry>
+	      <entry>u<subscript>0</subscript></entry>
+	    </row>
+	  </tbody>
+	</tgroup>
+      </table>
+    </section>
+  </section>
+</section>
diff --git a/Documentation/DocBook/v4l/v4l2.xml b/Documentation/DocBook/v4l/v4l2.xml
index 839e93e..695e3bf 100644
--- a/Documentation/DocBook/v4l/v4l2.xml
+++ b/Documentation/DocBook/v4l/v4l2.xml
@@ -410,6 +410,7 @@ and discussions on the V4L mailing list.</revremark>
     <section id="radio"> &sub-dev-radio; </section>
     <section id="rds"> &sub-dev-rds; </section>
     <section id="event"> &sub-dev-event; </section>
+    <section id="subdev"> &sub-dev-subdev; </section>
   </chapter>
 
   <chapter id="driver">
@@ -477,6 +478,9 @@ and discussions on the V4L mailing list.</revremark>
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
index 0000000..209e983
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
+    try the sub-device for an exact supported frame size.</para>
+
+    <para>Available frame sizes may depend on the current 'try' formats at other
+    pads of the sub-device, as well as on the current active links and the
+    current values of V4L2 controls. See &VIDIOC-SUBDEV-G-FMT; for more
+    information about try formats.</para>
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
index 0000000..d2c4fd2
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
+    <para>Available media bus formats may depend on the current 'try' formats
+    at other pads of the sub-device, as well as on the current active links. See
+    &VIDIOC-SUBDEV-G-FMT; for more information about the try formats.</para>
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
index 0000000..465f8e4
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
+    <para>Applications can query the device capabilities by setting the
+    <structfield>which</structfield> to
+    <constant>V4L2_SUBDEV_FORMAT_TRY</constant>. When set, 'try' formats are not
+    applied to the device by the driver, but are changed exactly as active
+    formats and stored in the sub-device file handle. Two applications querying
+    the same sub-device would thus not interact with each other.</para>
+
+    <para>For instance, to try a format at the output pad of a sub-device,
+    applications would first set the try format at the sub-device input with the
+    <constant>VIDIOC_SUBDEV_S_FMT</constant> ioctl. They would then either
+    retrieve the default format at the output pad with the
+    <constant>VIDIOC_SUBDEV_G_FMT</constant> ioctl, or set the desired output
+    pad format with the <constant>VIDIOC_SUBDEV_S_FMT</constant> ioctl and check
+    the returned value.</para>
+
+    <para>Try formats do not depend on active formats, but can depend on the
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
+	    <entry>V4L2_SUBDEV_FORMAT_TRY</entry>
+	    <entry>0</entry>
+	    <entry>Try formats, used for querying device capabilities.</entry>
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
index de10a1d..679062d 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -151,6 +151,9 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 	struct video_device *vdev = video_devdata(file);
 	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
 	struct v4l2_fh *vfh = file->private_data;
+#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
+	struct v4l2_subdev_fh *subdev_fh = to_v4l2_subdev_fh(vfh);
+#endif
 
 	switch (cmd) {
 	case VIDIOC_QUERYCTRL:
@@ -185,7 +188,53 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	case VIDIOC_UNSUBSCRIBE_EVENT:
 		return v4l2_subdev_call(sd, core, unsubscribe_event, vfh, arg);
+#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
+	case VIDIOC_SUBDEV_G_FMT: {
+		struct v4l2_subdev_format *format = arg;
+
+		if (format->which != V4L2_SUBDEV_FORMAT_TRY &&
+		    format->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+			return -EINVAL;
+
+		if (format->pad >= sd->entity.num_pads)
+			return -EINVAL;
+
+		return v4l2_subdev_call(sd, pad, get_fmt, subdev_fh, format);
+	}
+
+	case VIDIOC_SUBDEV_S_FMT: {
+		struct v4l2_subdev_format *format = arg;
+
+		if (format->which != V4L2_SUBDEV_FORMAT_TRY &&
+		    format->which != V4L2_SUBDEV_FORMAT_ACTIVE)
+			return -EINVAL;
+
+		if (format->pad >= sd->entity.num_pads)
+			return -EINVAL;
 
+		return v4l2_subdev_call(sd, pad, set_fmt, subdev_fh, format);
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
+#endif
 	default:
 		return -ENOIOCTLCMD;
 	}
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 796e1d8..c0db7f4 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -367,6 +367,7 @@ header-y += usbdevice_fs.h
 header-y += utime.h
 header-y += utsname.h
 header-y += v4l2-mediabus.h
+header-y += v4l2-subdev.h
 header-y += veth.h
 header-y += vhost.h
 header-y += videodev.h
diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
new file mode 100644
index 0000000..039c6e4
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
+ * @V4L2_SUBDEV_FORMAT_TRY: try format, for negotiation only
+ * @V4L2_SUBDEV_FORMAT_ACTIVE: active format, applied to the device
+ */
+enum v4l2_subdev_format_whence {
+	V4L2_SUBDEV_FORMAT_TRY = 0,
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
index 4f6ddba..f5611c2 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -21,6 +21,7 @@
 #ifndef _V4L2_SUBDEV_H
 #define _V4L2_SUBDEV_H
 
+#include <linux/v4l2-subdev.h>
 #include <media/media-entity.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
@@ -425,6 +426,15 @@ struct v4l2_subdev_ir_ops {
 };
 
 struct v4l2_subdev_pad_ops {
+	int (*enum_mbus_code)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_mbus_code_enum *code);
+	int (*enum_frame_size)(struct v4l2_subdev *sd,
+			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_frame_size_enum *fse);
+	int (*get_fmt)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		       struct v4l2_subdev_format *format);
+	int (*set_fmt)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+		       struct v4l2_subdev_format *format);
 };
 
 struct v4l2_subdev_ops {
-- 
1.7.2.2

