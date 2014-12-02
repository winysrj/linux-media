Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59933 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933357AbaLBTlh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Dec 2014 14:41:37 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] Add LVDS RGB media bus formats
Date: Tue,  2 Dec 2014 20:41:24 +0100
Message-Id: <1417549284-5097-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds three new RGB media bus formats that describe
18-bit or 24-bit samples transferred over an LVDS bus with three
or four differential data pairs, serialized into 7 time slots,
using standard SPWG/PSWG/VESA or JEIDA data ordering.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml | 189 +++++++++++++++++++++
 include/uapi/linux/media-bus-format.h              |   5 +-
 2 files changed, 193 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 0d6f731..52d7f04 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -89,6 +89,11 @@
       <constant>MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE</constant>.
       </para>
 
+      <para>On LVDS buses, usually each sample is transferred in seven time slots
+      on three (18-bit) or four (24-bit) differential data pairs at the same time.
+      The remaining bits are used for control signals as defined by SPWG/PSWG/VESA
+      or JEIDA standards.</para>
+
       <para>The following tables list existing packed RGB formats.</para>
 
       <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-rgb">
@@ -606,6 +611,190 @@
 	  </tbody>
 	</tgroup>
       </table>
+      <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-rgb-lvds">
+	<title>LVDS RGB formats</title>
+	<tgroup cols="11">
+	  <colspec colname="id" align="left" />
+	  <colspec colname="code" align="center" />
+	  <colspec colname="pair" align="center" />
+	  <colspec colname="slot" />
+	  <colspec colnum="4" colname="s00" align="center" />
+	  <colspec colnum="5" colname="s01" align="center" />
+	  <colspec colnum="6" colname="s02" align="center" />
+	  <colspec colnum="7" colname="s03" align="center" />
+	  <colspec colnum="8" colname="s04" align="center" />
+	  <colspec colnum="9" colname="s05" align="center" />
+	  <colspec colnum="10" colname="s06" align="center" />
+	  <spanspec namest="s00" nameend="s06" spanname="s0" />
+	  <thead>
+	    <row>
+	      <entry>Identifier</entry>
+	      <entry>Code</entry>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry spanname="s0">Data organization</entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>Pair</entry>
+	      <entry>Slot</entry>
+	      <entry>0</entry>
+	      <entry>1</entry>
+	      <entry>2</entry>
+	      <entry>3</entry>
+	      <entry>4</entry>
+	      <entry>5</entry>
+	      <entry>6</entry>
+	    </row>
+	  </thead>
+	  <tbody valign="top">
+	    <row id="MEDIA-BUS-FMT-RGB666-LVDS-SPWG">
+	      <entry>MEDIA_BUS_FMT_RGB666_LVDS_SPWG</entry>
+	      <entry>0x1010</entry>
+	      <entry>data0</entry>
+	      <entry></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	      <entry>r<subscript>5</subscript></entry>
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>data1</entry>
+	      <entry></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>data2</entry>
+	      <entry></entry>
+	      <entry>de</entry>
+	      <entry>vs</entry>
+	      <entry>hs</entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	    </row>
+	    <row id="MEDIA-BUS-FMT-RGB888-LVDS-SPWG">
+	      <entry>MEDIA_BUS_FMT_RGB888_LVDS_SPWG</entry>
+	      <entry>0x1011</entry>
+	      <entry>data0</entry>
+	      <entry></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	      <entry>r<subscript>5</subscript></entry>
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>data1</entry>
+	      <entry></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>data2</entry>
+	      <entry></entry>
+	      <entry>de</entry>
+	      <entry>vs</entry>
+	      <entry>hs</entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>data3</entry>
+	      <entry></entry>
+	      <entry>ctl</entry>
+	      <entry>b<subscript>7</subscript></entry>
+	      <entry>b<subscript>6</subscript></entry>
+	      <entry>g<subscript>7</subscript></entry>
+	      <entry>g<subscript>6</subscript></entry>
+	      <entry>r<subscript>7</subscript></entry>
+	      <entry>r<subscript>6</subscript></entry>
+	    </row>
+	    <row id="MEDIA-BUS-FMT-RGB888-LVDS-JEIDA">
+	      <entry>MEDIA_BUS_FMT_RGB888_LVDS_JEIDA</entry>
+	      <entry>0x1012</entry>
+	      <entry>data0</entry>
+	      <entry></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>r<subscript>7</subscript></entry>
+	      <entry>r<subscript>6</subscript></entry>
+	      <entry>r<subscript>5</subscript></entry>
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>data1</entry>
+	      <entry></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>g<subscript>7</subscript></entry>
+	      <entry>g<subscript>6</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>data2</entry>
+	      <entry></entry>
+	      <entry>de</entry>
+	      <entry>vs</entry>
+	      <entry>hs</entry>
+	      <entry>b<subscript>7</subscript></entry>
+	      <entry>b<subscript>6</subscript></entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry>data3</entry>
+	      <entry></entry>
+	      <entry>ctl</entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	    </row>
+	  </tbody>
+	</tgroup>
+      </table>
     </section>
 
     <section>
diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
index 37091c6..7f8b1e2 100644
--- a/include/uapi/linux/media-bus-format.h
+++ b/include/uapi/linux/media-bus-format.h
@@ -33,7 +33,7 @@
 
 #define MEDIA_BUS_FMT_FIXED			0x0001
 
-/* RGB - next is	0x1010 */
+/* RGB - next is	0x1013 */
 #define MEDIA_BUS_FMT_RGB444_1X12		0x100e
 #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE	0x1001
 #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE	0x1002
@@ -45,9 +45,12 @@
 #define MEDIA_BUS_FMT_RGB565_2X8_BE		0x1007
 #define MEDIA_BUS_FMT_RGB565_2X8_LE		0x1008
 #define MEDIA_BUS_FMT_RGB666_1X18		0x1009
+#define MEDIA_BUS_FMT_RGB666_LVDS_SPWG		0x1010
 #define MEDIA_BUS_FMT_RGB888_1X24		0x100a
 #define MEDIA_BUS_FMT_RGB888_2X12_BE		0x100b
 #define MEDIA_BUS_FMT_RGB888_2X12_LE		0x100c
+#define MEDIA_BUS_FMT_RGB888_LVDS_SPWG		0x1011
+#define MEDIA_BUS_FMT_RGB888_LVDS_JEIDA		0x1012
 #define MEDIA_BUS_FMT_ARGB8888_1X32		0x100d
 
 /* YUV (including grey) - next is	0x2024 */
-- 
2.1.3

