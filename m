Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:10041 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2HJLVd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 07:21:33 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, Soby Mathew <soby.mathew@st.com>,
	mats.randgaard@cisco.com, manjunath.hadli@ti.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	dri-devel@lists.freedesktop.org
Subject: [RFCv3 PATCH 2/8] V4L2 spec: document the new DV controls and ioctls.
Date: Fri, 10 Aug 2012 13:21:18 +0200
Message-Id: <7c1d81aac1f5e16885c3c06005b5086bfafd5964.1344592468.git.hans.verkuil@cisco.com>
In-Reply-To: <1344597684-8413-1-git-send-email-hans.verkuil@cisco.com>
References: <1344597684-8413-1-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <bf682233fde61ca77ed4512ba77271f6daeedb31.1344592468.git.hans.verkuil@cisco.com>
References: <bf682233fde61ca77ed4512ba77271f6daeedb31.1344592468.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/biblio.xml   |   40 +++++++
 Documentation/DocBook/media/v4l/controls.xml |  161 ++++++++++++++++++++++++++
 Documentation/DocBook/media/v4l/v4l2.xml     |    1 +
 3 files changed, 202 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/biblio.xml b/Documentation/DocBook/media/v4l/biblio.xml
index 1078e45..860626a 100644
--- a/Documentation/DocBook/media/v4l/biblio.xml
+++ b/Documentation/DocBook/media/v4l/biblio.xml
@@ -226,4 +226,44 @@ in the frequency range from 87,5 to 108,0 MHz</title>
       <title>VESA and Industry Standards and Guidelines for Computer Display Monitor Timing (DMT)</title>
     </biblioentry>
 
+    <biblioentry id="vesaedid">
+      <abbrev>EDID</abbrev>
+      <authorgroup>
+	<corpauthor>Video Electronics Standards Association
+(<ulink url="http://www.vesa.org">http://www.vesa.org</ulink>)</corpauthor>
+      </authorgroup>
+      <title>VESA Enhanced Extended Display Identification Data Standard</title>
+      <subtitle>Release A, Revision 2</subtitle>
+    </biblioentry>
+
+    <biblioentry id="hdcp">
+      <abbrev>HDCP</abbrev>
+      <authorgroup>
+	<corpauthor>Digital Content Protection LLC
+(<ulink url="http://www.digital-cp.com">http://www.digital-cp.com</ulink>)</corpauthor>
+      </authorgroup>
+      <title>High-bandwidth Digital Content Protection System</title>
+      <subtitle>Revision 1.3</subtitle>
+    </biblioentry>
+
+    <biblioentry id="hdmi">
+      <abbrev>HDMI</abbrev>
+      <authorgroup>
+	<corpauthor>HDMI Licensing LLC
+(<ulink url="http://www.hdmi.org">http://www.hdmi.org</ulink>)</corpauthor>
+      </authorgroup>
+      <title>High-Definition Multimedia Interface</title>
+      <subtitle>Specification Version 1.4a</subtitle>
+    </biblioentry>
+
+    <biblioentry id="dp">
+      <abbrev>DP</abbrev>
+      <authorgroup>
+	<corpauthor>Video Electronics Standards Association
+(<ulink url="http://www.vesa.org">http://www.vesa.org</ulink>)</corpauthor>
+      </authorgroup>
+      <title>VESA DisplayPort Standard</title>
+      <subtitle>Version 1, Revision 2</subtitle>
+    </biblioentry>
+
   </bibliography>
diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index b0964fb..1b0b95e 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -4274,4 +4274,165 @@ interface and may change in the future.</para>
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
+	and transmitters for <ulink url="http://en.wikipedia.org/wiki/Vga">VGA</ulink>,
+	<ulink url="http://en.wikipedia.org/wiki/Digital_Visual_Interface">DVI</ulink>
+	(Digital Visual Interface), HDMI (<xref linkend="hdmi" />) and DisplayPort (<xref linkend="dp" />).
+	These controls are generally expected to be private to the receiver or transmitter
+	subdevice that implements them, so they are only exposed on the
+	<filename>/dev/v4l-subdev*</filename> device node.
+      </para>
+
+      <para>Note that these devices can have multiple input or output pads which are
+      hooked up to e.g. HDMI connectors. Even though the subdevice will receive or
+      transmit video from/to only one of those pads, the other pads can still be
+      active when it comes to EDID (Extended Display Identification Data,
+      <xref linkend="vesaedid" />) and HDCP (High-bandwidth Digital Content
+      Protection System, <xref linkend="hdcp" />) processing, allowing the device
+      to do the fairly slow EDID/HDCP handling in advance. This allows for quick
+      switching between connectors.</para>
+
+      <para>These pads appear in several of the controls in this section as
+      bitmasks, one bit for each pad. Bit 0 corresponds to pad 0, bit 1 to pad 1,
+      etc. The maximum value of the control is the set of valid pads.</para>
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
+	    <entry spanname="descr">The Digital Video class descriptor.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_DV_TX_HOTPLUG</constant></entry>
+	    <entry>bitmask</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Many connectors have a hotplug pin which is high
+	    if EDID information is available from the source. This control shows the
+	    state of the hotplug pin as seen by the transmitter.
+	    Each bit corresponds to an output pad on the transmitter. If an output pad
+	    does not have an associated hotplug pin, then the bit for that pad will be 0.
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
+	    Each bit corresponds to an output pad on the transmitter. If an output pad
+	    does not have an associated Rx Sense, then the bit for that pad will be 0.
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
+	    Each bit corresponds to an output pad on the transmitter. If an output pad
+	    does not support EDIDs, then the bit for that pad will be 0.
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
+	    (ie. <xref linkend="cea861" /> for HDMI). V4L2_DV_RANGE_LIMITED and V4L2_DV_RANGE_FULL override the standard
+	    to be compatible with sinks that have not implemented the standard correctly
+	    (unfortunately quite common for HDMI and DVI-D). Full range allows all possible values to be
+	    used whereas limited range sets the range to (16 &lt;&lt; (N-8)) - (235 &lt;&lt; (N-8))
+	    where N is the number of bits per component.
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
+	    Each bit corresponds to an input pad on the transmitter. If an input pad
+	    cannot detect whether power is present, then the bit for that pad will be 0.
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
+	    (ie. <xref linkend="cea861" /> for HDMI). V4L2_DV_RANGE_LIMITED and V4L2_DV_RANGE_FULL override the standard
+	    to be compatible with sources that have not implemented the standard correctly
+	    (unfortunately quite common for HDMI and DVI-D). Full range allows all possible values to be
+	    used whereas limited range sets the range to (16 &lt;&lt; (N-8)) - (235 &lt;&lt; (N-8))
+	    where N is the number of bits per component.
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
index eee6908..b251c4b 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -581,6 +581,7 @@ and discussions on the V4L mailing list.</revremark>
     &sub-subdev-enum-frame-size;
     &sub-subdev-enum-mbus-code;
     &sub-subdev-g-crop;
+    &sub-subdev-g-edid;
     &sub-subdev-g-fmt;
     &sub-subdev-g-frame-interval;
     &sub-subdev-g-selection;
-- 
1.7.10.4

