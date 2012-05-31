Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1382 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab2EaJWy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 May 2012 05:22:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, Soby Mathew <soby.mathew@st.com>,
	mats.randgaard@cisco.com, manjunath.hadli@ti.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 2/3] V4L2 spec: document the new DV controls and ioctls.
Date: Thu, 31 May 2012 11:22:43 +0200
Message-Id: <7334405f1da0f87a9e86a90fd48b972059d815ed.1338455197.git.hans.verkuil@cisco.com>
In-Reply-To: <1338456164-25080-1-git-send-email-hverkuil@xs4all.nl>
References: <1338456164-25080-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <87c4b987f7b13776196612029786df388f43ad0a.1338455197.git.hans.verkuil@cisco.com>
References: <87c4b987f7b13776196612029786df388f43ad0a.1338455197.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/controls.xml       |  149 +++++++++++++++++++
 Documentation/DocBook/media/v4l/v4l2.xml           |    1 +
 .../DocBook/media/v4l/vidioc-subdev-g-edid.xml     |  152 ++++++++++++++++++++
 3 files changed, 302 insertions(+)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 8994132..da41504 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4269,4 +4269,153 @@ interface and may change in the future.</para>
       </table>
 
     </section>
+
+    <section id="dv-controls">
+      <title>Digital Video Control Reference</title>
+
+      <note>
+	<title>Experimental</title>
+
+	<para>This is an <link
+	linkend="experimental">experimental</link> interface and may
+	change in the future.</para>
+      </note>
+
+      <para>
+	The Digital Video control class is intended to control receivers
+	and transmitters for VGA, DVI, HDMI and DisplayPort. These controls
+	are generally expected to be private to the receiver or transmitter
+	subdevice that implements them, so they are only exposed on the
+	<filename>/dev/v4l-subdev*</filename> device node.
+      </para>
+
+      <para>Note that these devices can have multiple input or output pads which are
+      hooked up to e.g. HDMI connectors. Even though the subdevice will receive or
+      transmit video from/to only one of those pads, the other pads can still be
+      active when it comes to EDID and HDCP processing, allowing the device
+      to do the fairly slow EDID/HDCP handling in advance. This allows for quick
+      switching between connectors.</para>
+
+      <para>These pads appear in several of the controls in this section as
+      bitmasks, one bit for each pad starting at bit 0. The maximum value of
+      the control is the set of valid pads.</para>
+
+      <table pgwide="1" frame="none" id="dv-control-id">
+      <title>Digital Video Control IDs</title>
+
+      <tgroup cols="4">
+	<colspec colname="c1" colwidth="1*" />
+	<colspec colname="c2" colwidth="6*" />
+	<colspec colname="c3" colwidth="2*" />
+	<colspec colname="c4" colwidth="6*" />
+	<spanspec namest="c1" nameend="c2" spanname="id" />
+	<spanspec namest="c2" nameend="c4" spanname="descr" />
+	<thead>
+	  <row>
+	    <entry spanname="id" align="left">ID</entry>
+	    <entry align="left">Type</entry>
+	  </row><row rowsep="1"><entry spanname="descr" align="left">Description</entry>
+	  </row>
+	</thead>
+	<tbody valign="top">
+	  <row><entry></entry></row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_DV_CLASS</constant></entry>
+	    <entry>class</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">The DV class descriptor.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_DV_TX_HOTPLUG</constant></entry>
+	    <entry>bitmask</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Many connectors have a hotplug pin which is high
+	    if EDID information is available from the source. This control shows the
+	    state of the hotplug pin as seen by the transmitter.
+	    Each bit corresponds to an output pad on the transmitter.
+	    This read-only control is applicable to DVI-D, HDMI and DisplayPort connectors.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_DV_TX_RXSENSE</constant></entry>
+	    <entry>bitmask</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Rx Sense is the detection of pull-ups on the TMDS
+            clock lines. This normally means that the sink has left/entered standby (i.e.
+	    the transmitter can sense that the receiver is ready to receive video).
+	    Each bit corresponds to an output pad on the transmitter.
+	    This read-only control is applicable to DVI-D and HDMI devices.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_DV_TX_EDID_PRESENT</constant></entry>
+	    <entry>bitmask</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">When the transmitter sees the hotplug signal from the
+	    receiver it will attempt to read the EDID. If set, then the transmitter has read
+	    at least the first block (= 128 bytes).
+	    Each bit corresponds to an output pad on the transmitter.
+	    This read-only control is applicable to VGA, DVI-A/D, HDMI and DisplayPort connectors.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_DV_TX_MODE</constant></entry>
+	    <entry id="v4l2-dv-tx-mode">enum v4l2_dv_tx_mode</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">HDMI transmitters can transmit in DVI-D mode (just video)
+	    or in HDMI mode (video + audio + auxiliary data). This control selects which mode
+	    to use: V4L2_DV_TX_MODE_DVI_D or V4L2_DV_TX_MODE_HDMI.
+	    This control is applicable to HDMI connectors.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_DV_TX_RGB_RANGE</constant></entry>
+	    <entry id="v4l2-dv-rgb-range">enum v4l2_dv_rgb_range</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Select the quantization range for RGB output. V4L2_DV_RANGE_AUTO
+	    follows the RGB quantization range specified in the standard for the video interface
+	    (ie. CEA-861 for HDMI). V4L2_DV_RANGE_LIMITED and V4L2_DV_RANGE_FULL override the standard
+	    to be compatible with sinks that have not implemented the standard correctly
+	    (unfortunately quite common for HDMI and DVI-D).
+	    This control is applicable to VGA, DVI-A/D, HDMI and DisplayPort connectors.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_DV_RX_POWER_PRESENT</constant></entry>
+	    <entry>bitmask</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Detects whether the receiver receives power from the source
+	    (e.g. HDMI carries 5V on one of the pins). This is often used to power an eeprom
+	    which contains EDID information, such that the source can read the EDID even if
+	    the sink is in standby/power off.
+	    Each bit corresponds to an input pad on the receiver.
+	    This read-only control is applicable to DVI-D, HDMI and DisplayPort connectors.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_DV_RX_RGB_RANGE</constant></entry>
+	    <entry>enum v4l2_dv_rgb_range</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Select the quantization range for RGB input. V4L2_DV_RANGE_AUTO
+	    follows the RGB quantization range specified in the standard for the video interface
+	    (ie. CEA-861 for HDMI). V4L2_DV_RANGE_LIMITED and V4L2_DV_RANGE_FULL override the standard
+	    to be compatible with sources that have not implemented the standard correctly
+	    (unfortunately quite common for HDMI and DVI-D).
+	    This control is applicable to VGA, DVI-A/D, HDMI and DisplayPort connectors.
+	    </entry>
+	  </row>
+	  <row><entry></entry></row>
+	</tbody>
+      </tgroup>
+      </table>
+
+    </section>
 </section>
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 015c561..6b25035 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -575,6 +575,7 @@ and discussions on the V4L mailing list.</revremark>
     &sub-subdev-enum-frame-size;
     &sub-subdev-enum-mbus-code;
     &sub-subdev-g-crop;
+    &sub-subdev-g-edid;
     &sub-subdev-g-fmt;
     &sub-subdev-g-frame-interval;
     &sub-subdev-g-selection;
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
new file mode 100644
index 0000000..05371db
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-edid.xml
@@ -0,0 +1,152 @@
+<refentry id="vidioc-subdev-g-edid">
+  <refmeta>
+    <refentrytitle>ioctl VIDIOC_SUBDEV_G_EDID, VIDIOC_SUBDEV_S_EDID</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>VIDIOC_SUBDEV_G_EDID</refname>
+    <refname>VIDIOC_SUBDEV_S_EDID</refname>
+    <refpurpose>Get or set the EDID of a video receiver/transmitter</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct v4l2_subdev_edid *<parameter>argp</parameter></paramdef>
+      </funcprototype>
+    </funcsynopsis>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>const struct v4l2_subdev_edid *<parameter>argp</parameter></paramdef>
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
+	  <para>VIDIOC_SUBDEV_G_EDID, VIDIOC_SUBDEV_S_EDID</para>
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
+    <para>These ioctls can be used to get or set an EDID associated with an input pad
+    from a receiver or an output pad of a transmitter subdevice.</para>
+
+    <para>To get the EDID data the application has to fill in the <structfield>pad</structfield>,
+    <structfield>start_block</structfield>, <structfield>blocks</structfield> and <structfield>edid</structfield>
+    fields and call <constant>VIDIOC_SUBDEV_G_EDID</constant>. The current EDID from block
+    <structfield>start_block</structfield> and of size <structfield>blocks</structfield>
+    will be placed in the memory <structfield>edid</structfield> points to. The <structfield>edid</structfield>
+    pointer must point to memory at least <structfield>blocks</structfield>&nbsp;*&nbsp;128 bytes
+    large (the size of one block is 128 bytes).</para>
+
+    <para>If there are fewer blocks than specified, then the driver will set <structfield>blocks</structfield>
+    to the actual number of blocks. If there are no EDID blocks available at all, then the error code
+    ENODATA is set.</para>
+
+    <para>If blocks have to be retrieved from the sink, then this call will block until they
+    have been read.</para>
+
+    <para>To set the EDID blocks of a receiver the application has to fill in the <structfield>pad</structfield>,
+    <structfield>blocks</structfield> and <structfield>edid</structfield> fields and set
+    <structfield>start_block</structfield> to 0. It is not possible to set part of an EDID,
+    it is always all or nothing. Setting the EDID data is only valid for receivers as it makes
+    no sense for a transmitter.</para>
+
+    <para>The driver assumes that the full EDID is passed in. If there are more EDID blocks than
+    the hardware can handle then the EDID is not written, but instead the error code E2BIG is set
+    and <structfield>blocks</structfield> is set to the maximum that the hardware supports.
+    If <structfield>start_block</structfield> is any
+    value other than 0 then the error code EINVAL is set.</para>
+
+    <para>To disable an EDID you set <structfield>blocks</structfield> to 0. Depending on the
+    hardware this will drive the hotplug pin low and/or block the source from reading the EDID
+    data in some way. In any case, the end result is the same: the EDID is no longer available.
+    </para>
+
+    <table pgwide="1" frame="none" id="v4l2-subdev-edid">
+      <title>struct <structname>v4l2_subdev_edid</structname></title>
+      <tgroup cols="3">
+        &cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>pad</structfield></entry>
+	    <entry>Pad for which to get/set the EDID blocks.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>start_block</structfield></entry>
+	    <entry>Read the EDID from starting with this block. Must be 0 when setting
+	    the EDID.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>blocks</structfield></entry>
+	    <entry>The number of blocks to get or set. Must be less or equal to 255 (the
+	    maximum block number defined by the standard). When you set the EDID and
+	    <structfield>blocks</structfield> is 0, then the EDID is disabled or erased.</entry>
+	  </row>
+	  <row>
+	    <entry>__u8&nbsp;*</entry>
+	    <entry><structfield>edid</structfield></entry>
+	    <entry>Pointer to memory that contains the EDID. The minimum size is
+	    <structfield>blocks</structfield>&nbsp;*&nbsp;128.</entry>
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
+	<term><errorcode>ENODATA</errorcode></term>
+	<listitem>
+	  <para>The EDID data is not available.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><errorcode>E2BIG</errorcode></term>
+	<listitem>
+	  <para>The EDID data you provided is more than the hardware can handle.</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+</refentry>
-- 
1.7.10

