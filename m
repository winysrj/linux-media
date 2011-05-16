Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:50855 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab1EPNAv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2011 09:00:51 -0400
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, nkanchev@mm-sol.com,
	g.liakhovetski@gmx.de, hverkuil@xs4all.nl, dacohen@gmail.com,
	riverful@gmail.com, andrew.b.adams@gmail.com, shpark7@stanford.edu
Subject: [PATCH 2/3] v4l: Add flash control documentation
Date: Mon, 16 May 2011 16:00:38 +0300
Message-Id: <1305550839-16724-2-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4DD11FEC.8050308@maxwell.research.nokia.com>
References: <4DD11FEC.8050308@maxwell.research.nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add documentation for V4L2 flash controls.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 Documentation/DocBook/v4l/controls.xml           |  216 ++++++++++++++++++++++
 Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml |    7 +
 2 files changed, 223 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/v4l/controls.xml
index a920ee8..124d5d8 100644
--- a/Documentation/DocBook/v4l/controls.xml
+++ b/Documentation/DocBook/v4l/controls.xml
@@ -2092,6 +2092,222 @@ manually or automatically if set to zero. Unit, range and step are driver-specif
 <para>For more details about RDS specification, refer to
 <xref linkend="en50067" /> document, from CENELEC.</para>
     </section>
+
+    <section id="flash-controls">
+      <title>Flash Control Reference</title>
+
+      <para>
+	The V4L2 flash controls are intended to provide generic access
+	to flash controller devices. Flash controller devices are
+	typically used in digital cameras.
+      </para>
+
+      <para>
+	The interface can support both LED and xenon flash devices. 
+      </para>
+
+      <table pgwide="1" frame="none" id="flash-control-id">
+      <title>Flash Control IDs</title>
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
+	    <entry spanname="id"><constant>V4L2_CID_FLASH_CLASS</constant></entry>
+	    <entry>class</entry>
+	  </row>
+          <row>
+	    <entry spanname="descr">The FLASH class descriptor.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_FLASH_LED_MODE</constant></entry>
+	    <entry>menu</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Defines the mode of the flash LED,
+	    the high-power white LED attached to the flash
+	    controller.</entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_FLASH_LED_MODE_NONE</constant></entry>
+		  <entry>Off.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_FLASH_LED_MODE_FLASH</constant></entry>
+		  <entry>Flash mode.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_FLASH_LED_MODE_TORCH</constant></entry>
+		  <entry>Torch mode. See V4L2_CID_FLASH_TORCH_INTENSITY.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_FLASH_STROBE_SOURCE</constant></entry>
+	    <entry>menu</entry>
+	  </row>
+	  <row><entry spanname="descr">Defines the mode of the
+	  flash LED strobe.</entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_FLASH_STROBE_SOURCE_SOFTWARE</constant></entry>
+		  <entry>The flash strobe is triggered by using
+		  the V4L2_CID_FLASH_STROBE control.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_FLASH_STROBE_SOURCE_EXTERNAL</constant></entry>
+		  <entry>The flash strobe is triggered by an
+		  external source. Typically this is a sensor,
+		  which makes it possible to synchronises the
+		  flash strobe start to exposure start.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_FLASH_STROBE</constant></entry>
+	    <entry>button</entry>
+	  </row>
+          <row>
+	    <entry spanname="descr">Strobe flash. Valid when
+	    V4L2_CID_FLASH_LED_MODE is set to
+	    V4L2_FLASH_LED_MODE_FLASH and V4L2_CID_FLASH_STROBE_SOURCE
+	    is set to V4L2_FLASH_STROBE_SOURCE_SOFTWARE.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_FLASH_STROBE_STOP</constant></entry>
+	    <entry>button</entry>
+	  </row>
+          <row><entry spanname="descr">Stop flash strobe immediately.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_FLASH_STROBE_STATUS</constant></entry>
+	    <entry>boolean</entry>
+	  </row>
+          <row>
+	    <entry spanname="descr">Strobe status: whether the flash
+	    is strobing at the moment or not. This is a read-only
+	    control.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_FLASH_TIMEOUT</constant></entry>
+	    <entry>integer</entry>
+	  </row>
+          <row>
+	    <entry spanname="descr">Hardware timeout for flash. The
+	    flash strobe is stopped after this period of time has
+	    passed from the start of the strobe.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_FLASH_INTENSITY</constant></entry>
+	    <entry>integer</entry>
+	  </row>
+          <row>
+	    <entry spanname="descr">Intensity of the flash strobe when
+	    the flash LED is in flash mode
+	    (V4L2_FLASH_LED_MODE_FLASH).</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_FLASH_TORCH_INTENSITY</constant></entry>
+	    <entry>integer</entry>
+	  </row>
+          <row>
+	    <entry spanname="descr">Intensity of the flash LED in
+	    torch mode (V4L2_FLASH_LED_MODE_TORCH). Intensity of zero
+	    (0) means off.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_FLASH_INDICATOR_INTENSITY</constant></entry>
+	    <entry>integer</entry>
+	  </row>
+          <row>
+	    <entry spanname="descr">Intensity of the indicator LED.
+	    The indicator LED may be fully independent of the flash
+	    LED. Intensity of zero (0) means off.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_FLASH_FAULT</constant></entry>
+	    <entry>bitmask</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Faults related to the flash. The
+	    faults tell about specific problems in the flash chip
+	    itself or the LEDs attached to it. Reading the control
+	    will clear it.</entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_FLASH_FAULT_OVER_VOLTAGE</constant></entry>
+		  <entry>Flash controller voltage to the flash LED
+		  has exceeded the limit specific to the flash
+		  controller.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_FLASH_FAULT_TIMEOUT</constant></entry>
+		  <entry>The flash strobe was still on when
+		  the timeout set by the user ---
+		  V4L2_CID_FLASH_TIMEOUT control --- has expired.
+		  Not all flash controllers may set this in all
+		  such conditions.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_FLASH_FAULT_OVER_TEMPERATURE</constant></entry>
+		  <entry>The flash controller has overheated.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_FLASH_FAULT_SHORT_CIRCUIT</constant></entry>
+		  <entry>The short circuit protection of the flash
+		  controller has been triggered.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_FLASH_CHARGE</constant></entry>
+	    <entry>boolean</entry>
+	  </row>
+          <row><entry spanname="descr">Enable or disable charging of the xenon
+          flash capacitor.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_FLASH_READY</constant></entry>
+	    <entry>boolean</entry>
+	  </row>
+          <row>
+	    <entry spanname="descr">Is the flash ready to strobe?
+	    Xenon flashes require their capacitors charged before
+	    strobing. LED flashes often require a cooldown period
+	    after strobe during which another strobe will not be
+	    possible. This is a read-only control.</entry>
+	  </row>
+	  <row><entry></entry></row>
+	</tbody>
+      </tgroup>
+      </table>
+
+    </section>
 </section>
 
   <!--
diff --git a/Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml
index 3aa7f8f..c37bd86 100644
--- a/Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/v4l/vidioc-g-ext-ctrls.xml
@@ -250,6 +250,13 @@ These controls are described in <xref
 These controls are described in <xref
 		linkend="fm-tx-controls" />.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_CTRL_CLASS_FLASH</constant></entry>
+	    <entry>0x9c0000</entry>
+	    <entry>The class containing flash device controls.
+These controls are described in <xref
+		linkend="flash-controls" />.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
-- 
1.7.2.5

